#!/bin/bash

WORK_DIR=$(mktemp -d) &&
    REPO_DIR=$(mktemp -d) &&
    git -C ${REPO_DIR} clone git@github.com:desertedscorpion/hollowmoon &&
    git -C ${WORK_DIR} clone git@github.com:desertedscorpion/navyavenue.git &&
    git -C ${WORK_DIR}/navyavenue checkout tags/0.0.1 &&
    make --directory ${WORK_DIR}/navyavenue rebuild/emory-0.0.0-0.0.1 VERSION=0.0.0 &&
    cp ${WORK_DIR}/silverfoot/rebuild/emory-0.0.0-0.0.1.x86_64.rpm ${REPO_DIR} &&
#    git -C ${WORK_DIR} clone git@github.com:desertedscorpion/silverfoot.git &&
#    git -C ${WORK_DIR}/silverfoot checkout tags/0.0.0 &&
#    make --directory ${WORK_DIR}/silverfoot rebuild/jenkins-client-0.0.0-0.0.0 VERSION=0.0.0 &&
#    cp ${WORK_DIR}/silverfoot/rebuild/jenkins-client-0.0.0-0.0.0.x86_64.rpm ${REPO_DIR} &&
    cd ${REPO_DIR}/hollowmoon &&
    createrepo --pretty ${REPO_DIR} &&
#    git -C ${REPO_DIR}/hollowmoon add jenkins-client-0.0.0-0.0.0.x86_64.rpm &&
    git -C ${REPO_DIR}/hollowmoon add repodata.xml &&
    git -C ${REPO_DIR}/hollowmoon commit -m "Added Files" &&
    git -C ${REPO_DIR}/hollowmoon push origin master &&
    true
    
    
