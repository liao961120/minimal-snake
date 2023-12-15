A Minimalist Workflow for Snakemake
===================================

This workflow structure is modified from Snakemake's [recommended workflow][snk-flow] with two enhancements.

1. **Simplified directory names**
   
    `resources/` is renamed as `raw/`, and `results/` is renamed as `made/`. The
    `workflow/` directory is broken down into `src/` (holding scripts) and the
    `Snakefile`.

2. **Consistent relative paths**
   
    Since `Snakefile` is now placed in the project root, the problem of
    different relative paths for different directives is resolved, as long as
    the user always invokes the command `snakemake -c` in the project root.

```tree
├── README.md
├── Snakefile
├── made
├── raw
└── src
```

Refer to [this post][post] for context and details.


## Usage

```bash
bash make.sh    # reproduce everything (e.g., dag.png)
# snakemake -c  # directly invoke snakemake command
```

![](dag.png)


[snk-flow]: https://snakemake.readthedocs.io/en/stable/snakefiles/deployment.html#distribution-and-reproducibility
[post]: https://yongfu.name/2023/02/15/snakemake/


---

To Do
-----

A simple command line program to take a snakemake's `--detailed-summary` table and generate a dot file of file dependency DAG. This may look like something as:

```bash
snakemake --detailed-summary -c | fileDag | dot -Tpng -Gdpi=300 -Grankdir=LR > dag.png
```

```bash
# snakemake -c
snakemake --detatiled-summary -c  # --detailed-summary outputs a TSV file
```

| output_file              | date                     | rule              | version | log-file(s) | input-file(s)                                                                                              | shellcmd                                                               | status            | plan      |
| ------------------------ | ------------------------ | ----------------- | ------- | ----------- | ---------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- | ----------------- | --------- |
| made/wordfreq.png        | Fri Dec 15 16:26:19 2023 | plot_word_freq    | -       |             | made/merged.csv,made/stopwords.txt,src/viz.R                                                               | Rscript src/viz.R made/merged.csv made/stopwords.txt made/wordfreq.png | ok                | no update |
| made/CausalModel.csv     | -                        | extract_word_freq | -       |             | raw/html/CausalModel.html,raw/html/DeepLearning.html,raw/html/MultilevelModel.html,src/extract_word_freq.R | -                                                                      | removed temp file | no update |
| made/DeepLearning.csv    | -                        | extract_word_freq | -       |             | raw/html/CausalModel.html,raw/html/DeepLearning.html,raw/html/MultilevelModel.html,src/extract_word_freq.R | -                                                                      | removed temp file | no update |
| made/MultilevelModel.csv | -                        | extract_word_freq | -       |             | raw/html/CausalModel.html,raw/html/DeepLearning.html,raw/html/MultilevelModel.html,src/extract_word_freq.R | -                                                                      | removed temp file | no update |
| made/merged.csv          | Fri Dec 15 16:26:15 2023 | extract_word_freq | -       |             | raw/html/CausalModel.html,raw/html/DeepLearning.html,raw/html/MultilevelModel.html,src/extract_word_freq.R | -                                                                      | ok                | no update |
| made/stopwords.txt       | Fri Dec 15 16:26:12 2023 | get_stopwords     | -       |             | src/stopwords.R                                                                                            | Rscript src/stopwords.R made/stopwords.txt                             | ok                | no update |


### Some Potential Libraries

- [pydot](https://github.com/pydot/pydot)

