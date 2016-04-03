#!/bin/bash

WORK_DIR=$(mktemp -d) &&
    REPO_DIR=$(mktemp -d) &&
    git -C ${REPO_DIR} clone git@github.com:desertedscorpion/hollowmoon &&
    function build_it(){
	ORGANIZATION=${1} &&
	    REPOSITORY=${2} &&
	    VERSION=${3} &&
	    RELEASE=${4} &&
	    NAME=${5} &&
	    git -C ${WORK_DIR} clone git@github.com:${ORGANIZATION}/${REPOSITORY}.git &&
	    git -C ${WORK_DIR}/${REPOSITORY} checkout tags/${RELEASE} &&
	    echo make --directory ${WORK_DIR}/${REPOSITORY} rebuild/${NAME}-${VERSION}-${RELEASE}.x86_64.rpm VERSION=${VERSION} &&
	    make --directory ${WORK_DIR}/${REPOSITORY} rebuild/${NAME}-${VERSION}-${RELEASE}.x86_64.rpm VERSION=${VERSION} &&
	    cp ${WORK_DIR}/${REPOSITORY}/rebuild/${NAME}-${VERSION}-${RELEASE}.x86_64.rpm ${REPO_DIR}/hollowmoon &&
	    git -C ${REPO_DIR}/hollowmoon add ${NAME}-${VERSION}-${RELEASE}.x86_64.rpm &&
	    git -C ${REPO_DIR}/hollowmoon commit -m "Added ${NAME}-${VERSION}-${RELEASE}" &&
	    true
    } &&
    build_it desertedscorpion navyavenue 0.0.1 0.0.4 luckygamma &&
    cd ${REPO_DIR}/hollowmoon &&
    createrepo --pretty ${REPO_DIR}/hollowmoon &&
    git -C ${REPO_DIR}/hollowmoon add repodata &&
    git -C ${REPO_DIR}/hollowmoon push origin master &&
    true
    
    
