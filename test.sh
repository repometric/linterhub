basedir=$1
mkdir -p tests
for dir in "dockers/$basedir"/*; do
    if test -d "$dir"; then
        dir="$(basename $dir)"  # Returns just "to"
        sh linter.sh engine:build "$dir" > tests/$dir.txt
    fi
done