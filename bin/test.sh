basedir=$1
mkdir -p tests

ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"

for dir in "dockers/$basedir"/*; do
    if test -d "$dir"; then
        name="$(basename $dir)"  # Returns just "to"
        mkdir -p tests/$name
        echo "${COL_YELLOW}Test: $name.${COL_RESET}"
        echo "1. Build: \c"
        sh linter.sh --mode engine:build --name "$name" > tests/"$name"/build.txt
        if [ $? -eq 0 ]
        then
            echo "${COL_GREEN}OK${COL_RESET}"
        else
            echo "${COL_RED}FAIL${COL_RESET}"
        fi
        echo "2. Save : \c"
        sh linter.sh --mode engine:save --name "$name" > tests/"$name"/image.tgz
        if [ $? -eq 0 ]
        then
            echo "${COL_GREEN}OK${COL_RESET}"
        else
            echo "${COL_RED}FAIL${COL_RESET}"
        fi
    fi
done