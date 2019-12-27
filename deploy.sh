#!/bin/bash
set -e

if [ $# -eq 0 ]
    then
        BRANCH=$(git rev-parse --abbrev-ref HEAD)
    else
        BRANCH=$1
fi

if [ $BRANCH == "master" ]
then
    IMAGE_TAG="latest"
else
    IMAGE_TAG=$BRANCH
fi
echo $BRANCH

deploy() {
    IMAGE_TAG=$1
    IMAGE=nvtienanh/oracle-jdk:$IMAGE_TAG
    docker build \
     -t $IMAGE \
     --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
     --build-arg VCS_REF=`git rev-parse --short HEAD` .
    docker push $IMAGE
}


deploy $IMAGE_TAG 
# Update Microbadger
# curl -X POST https://hooks.microbadger.com/images/nvtienanh/hadoop-base/CA79IP9AVi0mpSaTDfi9k4POrdQ=