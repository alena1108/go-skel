#!/bin/bash

if [ "$#" != 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo Usage: $0 NEW-APP-NAME
    exit 1
fi

APP=$1
FILES="
./main.go
./.gitignore
./README.md.in
./Makefile
./.dockerignore
./Dockerfile.dapper
./trash.yml
./LICENSE
./package/Dockerfile
./scripts/release
./scripts/build
./scripts/ci
./scripts/version
./scripts/entry
./scripts/package
"


mkdir -p $APP

for i in $FILES; do
    mkdir -p $APP/$(dirname $i)
    echo Creating $APP/$i
    sed -e "s/%APP%/$APP/g" $i > $APP/$i
    if echo $i | grep -q scripts; then
        echo chmod +x $APP/$i
        chmod +x $APP/$i
    fi
done

cd ./$APP
mv README.md.in README.md
make trash

git init
git add -A
git commit -m "Initial Commit"

echo Created $APP in ./$APP
