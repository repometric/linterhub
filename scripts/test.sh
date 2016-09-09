basedir=$1
mkdir -p tests
for dir in "dockers/$basedir"/*; do
    if test -d "$dir"; then
        name="$(basename $dir)"  # Returns just "to"
        mkdir -p tests/$name
        echo "Test: $name"
        sh linter.sh --mode engine:build --name "$name" > tests/"$name"/build.txt
        sh linter.sh --mode engine:save --name "$name" > tests/"$name"/image.tgz
    fi
done