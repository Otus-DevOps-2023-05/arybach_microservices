#!/bin/bash

echo `git show --format="%h" HEAD | head -1` > build_info.txt
echo `git rev-parse --abbrev-ref HEAD` >> build_info.txt

VERSION_TAG=$1
docker build -t $USER_NAME/ui:$VERSION_TAG .
