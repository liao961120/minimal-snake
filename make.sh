WORKFLOW='.'

##################################################
####      For a single connected DAG          ####
#### (Runs the 1st rule and its dependencies) ####
##################################################
snakemake -c -p  # Rule: all

# Generate dependency graphs between workflows
[[ -f $WORKFLOW/dag.png ]] && rm $WORKFLOW/dag.png

if [[ "$OSTYPE" == "msys" ]]; then
    printf "\nBuilding DAG on Windows Git Bash...\n"
    lastwd=$(pwd)
    source ~/.bash_profile
    cd "$lastwd"
    snakemake --dag > dag.txt
    iconv -f big5 -t utf-8 dag.txt > dag2.txt
    cat dag2.txt | dot -Tpng -Gdpi=300 -Grankdir=LR > $WORKFLOW/dag.png
    rm dag.txt dag2.txt
    # snakemake run_bilog run_ezdif item_report --dag | 2utf | dot -Tpng -Gdpi=300 > $DAG_DIR/dag.png
else
    snakemake --dag | dot -Tpng -Gdpi=300 -Grankdir=LR > $WORKFLOW/dag.png
fi
# Generate report
# snakemake --report log.html
