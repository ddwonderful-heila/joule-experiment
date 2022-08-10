#!/bin/bash
set -x

# TODO(DW) - check if image exists locally before doing this
JOULE_COMMIT=17e27d900df5c760c05c3cd1e3fc701668bbb4cd

git clone git@github.com:wattsworth/joule.git
git reset --hard ${JOULE_COMMIT}

docker build -t heilaiq/joule/test .

rm -rf joule
