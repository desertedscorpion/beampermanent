#!/bin/bash

WORK_DIR=$(dirname ${0}) &&
    REPO_DIR=${WORK_DIR}/build/repo &&
    mkdir --parents ${REPO_DIR} &&
    if [[ ! -d ${REPO_DIR}/hollowmoon ]]
    then
	git -C ${REPO_DIR} clone git@github.com:desertedscorpion/hollowmoon &&
	    true
    fi &&
    function build_it(){
	RELEASE_ORGANIZATION=${1} &&
	    RELEASE_REPOSITORY=${2} &&
	    VERSION_ORGANIZATION=${3} &&
	    VERSION_REPOSITORY=${4} &&
	    NAME=${5} &&
	    RELEASE_DIR=${WORK_DIR}/build/release &&
	    mkdir --parents ${RELEASE_DIR} &&
	    VERSION_DIR=${WORK_DIR}/build/version &&
	    mkdir --parents ${VERSION_DIR} &&
	    if [[ ! -d ${RELEASE_DIR}/${RELEASE_REPOSITORY} ]]
	    then
		git -C ${RELEASE_DIR} clone git@github.com:${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}.git &&
		    true
	    fi &&
	    if [[ ! -d ${VERSION_DIR}/${VERSION_REPOSITORY} ]]
	    then
		git -C ${VERSION_DIR} clone git@github.com:${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}.git &&
		    true
	    fi &&
	    git -C ${RELEASE_DIR}/${RELEASE_REPOSITORY} tag | while read RELEASE
	    do
		git -C ${VERSION_DIR}/${VERSION_REPOSITORY} tag | while read VERSION
		do
		    if [[ ! -f ${REPO_DIR}/hollowmoon/${NAME}-${VERSION}-${RELEASE}.x86-64.rpm ]] && [[ ! -f ${RELEASE_DIR}/${RELEASE_REPOSITORY}/${NAME}-${VERSION}-${RELEASE}.failure ]]
		    then
			git -C ${RELEASE_DIR}/${RELEASE_REPOSITORY} checkout tags/${RELEASE} &&
			    (
				(
				    make --directory ${RELEASE_DIR}/${RELEASE_REPOSITORY} rebuild/${NAME}-${VERSION}-${RELEASE}.x86_64.rpm VERSION=${VERSION} &&
					cp ${RELEASE_DIR}/${RELEASE_REPOSITORY}/rebuild/${NAME}-${VERSION}-${RELEASE}.x86_64.rpm ${REPO_DIR}/hollowmoon &&
					git -C ${REPO_DIR}/hollowmoon add ${NAME}-${VERSION}-${RELEASE}.x86_64.rpm &&
					true
				) || (
				    touch ${RELEASE_DIR}/${RELEASE_REPOSITORY}/${NAME}-${VERSION}-${RELEASE}.failure &&
					true
				)
			    ) &&
			    true
		    fi
		done &&
		    true
	    done &&
	    true
    } &&
    build_it desertedscorpion navyavenue desertedscorpion alienmetaphor luckygamma &&
    build_it desertedscorpion silverfoot desertedscorpion scatteredfinger jenkins-client &&
    build_it desertedscorpion lostlocomotive desertedscorpion scatteredfinger bigdrill &&
    build_it desertedscorpion timelessvegetable desertedscorpion helplessmountain shinyalarm &&
    cd ${REPO_DIR}/hollowmoon &&
    createrepo --pretty ${REPO_DIR}/hollowmoon &&
    git -C ${REPO_DIR}/hollowmoon add repodata &&
    git -C ${REPO_DIR}/hollowmoon commit -am "beampermanent" &&
    git -C ${REPO_DIR}/hollowmoon push origin master &&
    true
    
    
