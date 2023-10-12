import os
from pathlib import Path
from shlex import join  # for quoting file paths
from src.snakes import glob_stem


# Additional setup for running with git-bash on Windows
if os.name == 'nt':
    from snakemake.shell import shell
    shell.executable(r'C:\Users\rd\AppData\Local\Programs\Git\bin\bash.exe')
    shell.prefix("""
    # Load bash predefined functions
    lastwd=$(pwd)
    source ~/.bash_profile
    cd "$lastwd"
""")

# Protect Raw data (read-only permissions for all files in `raw/`)
from stat import S_IREAD, S_IRGRP, S_IROTH
for fp in Path("raw").rglob("*"):
    if fp.is_file():
        os.chmod(fp, S_IREAD|S_IRGRP|S_IROTH)


# Global variables
HTML = glob_stem("raw/html/*.html")


# Rules
rule all:
    input: 
        "made/wordfreq.png"

rule plot_word_freq:
    input: 
        data = "made/merged.csv",
        stopwords = "made/stopwords.txt",
        script = "src/viz.R"
    output: 
        "made/wordfreq.png"
    shell:
        """
        Rscript {input.script} {input.data} {input.stopwords} {output}
        """

rule extract_word_freq:
    input:
        expand("raw/html/{FILE}.html", FILE=HTML),
        script = "src/extract_word_freq.R"
    output:
        temp(expand("made/{FILE}.csv", FILE=HTML)),
        merged = "made/merged.csv"
    run:
        shell('echo "token,freq,file" > {output.merged}')
        for i in range(len(HTML)):
            fin, fout = input[i], output[i]
            shell('''
                Rscript {input.script} "{fin}" "{fout}"
                cat "{fout}" >> {output.merged}
                ''')

rule get_stopwords:
    input: 
        script = "src/stopwords.R"
    output:
        "made/stopwords.txt"
    shell: "Rscript {input.script} {output}"


rule get_stopwords_nonStdFilePaths:
    """
    This rule demonstrates the use of `shlex.join()` along with the `params` 
    directive to handle cmd arguments with nonstandard file paths (e.g., paths
    with spaces and parentheses).
    """
    input: 
        script = "src/stopwords-multi-output.R"
    output:
        multi = [
            "made/stopwords-1.txt",
            "made/stopwords-2.txt",
            "made/stopwords-3.txt",
        ]
    params:
        # See https://snakemake.readthedocs.io/en/stable/snakefiles/rules.html#non-file-parameters-for-rules
        outfiles = lambda wildcards, output: join(output.multi)
    shell: 
        """
        Rscript {input.script} {params.outfiles}
        """


########################################
"""
[Tips]
    DO NOT use Snakmake built-in wildcards
    lots of limitations & changes the default behaviour in for loops
    of run: blocks

[How relative paths work in Snakefile]

`input:`, `output:`, and `shell:` have the project root as the working dir.
All other directives (e.g. `script:`, `include:`, and `notebook:`) have 
the directory where `Snakefile` is located as the working dir.
"""
