import os
from src.snakes import glob_stem

# Additional setup for running with git-bash on Windows
if os.name == 'nt':
    from snakemake.shell import shell
    shell.executable(r'C:\Users\rd\AppData\Local\Programs\Git\bin\bash.exe')


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
