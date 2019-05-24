#!/bin/bash

RELEASE_CANDIDATE=1
VERSION_NUMBER=1.15.0.10
TAG_PREFIX=dockerreg.magenta.dk/
IMAGE_PATH=${TAG_PREFIX}boligadmin/apache_exporter

# If release candidate, build and tag
if [ $RELEASE_CANDIDATE -eq 1 ]; then
    docker build -t ${IMAGE_PATH}:latestrc .

    function tag {
        docker tag ${IMAGE_PATH}:latestrc ${IMAGE_PATH}:$1rc
        docker push ${IMAGE_PATH}:$1rc
    }

    IFS='.' read -ra VER <<< "${VERSION_NUMBER}"
    VER_SO_FAR="${VER[0]}"
    VER=("${VER[@]:1}")
    tag "$VER_SO_FAR"
    for i in "${VER[@]}"; do
        VER_SO_FAR=${VER_SO_FAR}.${i}
        tag "$VER_SO_FAR"
    done
else
    # If release, solely tag old release candidate
    function tag_release {
        docker tag ${IMAGE_PATH}:$1rc ${IMAGE_PATH}:$1
        docker push ${IMAGE_PATH}:$1
    }

    IFS='.' read -ra VER <<< "${VERSION_NUMBER}"
    VER_SO_FAR="${VER[0]}"
    VER=("${VER[@]:1}")
    tag_release "$VER_SO_FAR"
    for i in "${VER[@]}"; do
        VER_SO_FAR=${VER_SO_FAR}.${i}
        tag_release "$VER_SO_FAR"
    done
    docker tag ${IMAGE_PATH}:latestrc ${IMAGE_PATH}:latest
    docker push ${IMAGE_PATH}:latest
fi
