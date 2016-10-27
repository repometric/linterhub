#!/bin/bash

source bin/lh_utils.sh

basedir=$1
mkdir -p tests

for dir in "dockers/$basedir"/*; do
    if test -d "$dir"; then
        name="$(basename $dir)"  # Returns just "to"
        mkdir -p tests/$name
        log WARN "Test: $name."
        echo "1. Build: \c"
        sh linterhub.sh --mode engine:build --name "$name" > tests/"$name"/build.txt
        if [ $? -eq 0 ]
        then
            log INFO "OK"
        else
            log ERROR "FAIL"
        fi
        echo "2. Save : \c"
        sh linterhub.sh --mode engine:export --name "$name" > tests/"$name"/image.tgz
        if [ $? -eq 0 ]
        then
            log INFO "OK"
        else
            log ERROR "FAIL"
        fi
    fi
done