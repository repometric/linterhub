basedir=$1
mkdir -p tests
for dir in "dockers/$basedir"/*; do
    if test -d "$dir"; then
        dir="$(basename $dir)"  # Returns just "to"
        mkdir -p tests/$dir
        sh linter.sh engine:build "$dir" > tests/"$dir"/build.txt
        sh linter.sh engine:save "$dir" > tests/"$dir"/image.tgz
    fi
done