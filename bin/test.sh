source bin/colors.sh

basedir=$1
mkdir -p tests

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