#!/bin/bash

REPO_DIR=$(mktemp -d) &&
    git -C ${REPO_DIR} clone git@github.com:desertedscorpion/hollowmoon &&
    function build_it(){
	RELEASE_ORGANIZATION=${1} &&
	    RELEASE_REPOSITORY=${2} &&
	    VERSION_ORGANIZATION=${3} &&
	    VERSION_REPOSITORY=${4} &&
	    NAME=${5} &&
	    RELEASE_DIR=$(mktemp -d) &&
	    VERSION_DIR=$(mktemp -d) &&
	    git -C ${RELEASE_DIR} clone git@github.com:${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}.git &&
	    git -C ${VERSION_DIR} clone git@github.com:${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}.git &&
	    git -C ${RELEASE_DIR}/${RELEASE_REPOSITORY} tag | while read RELEASE
	    do
		git -C ${VERSION_DIR}/${VERSION_REPOSITORY} tag | while read VERSION
		do
		    if [ ! -f ${REPO_DIR}/hollowmoon/${NAME}-${VERSION}-${RELEASE}.x86-64.rpm ]
		    then
			git -C ${RELEASE_DIR}/${RELEASE_REPOSITORY} checkout tags/${RELEASE} &&
			    (
				(
				    make --directory ${RELEASE_DIR}/${RELEASE_REPOSITORY} rebuild/${NAME}-${VERSION}-${RELEASE}.x86_64.rpm VERSION=${VERSION} &&
					cp ${RELEASE_DIR}/${RELEASE_REPOSITORY}/rebuild/${NAME}-${VERSION}-${RELEASE}.x86_64.rpm ${REPO_DIR}/hollowmoon &&
					git -C ${REPO_DIR}/hollowmoon add ${NAME}-${VERSION}-${RELEASE}.x86_64.rpm &&
					true
				) || true
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
    build_it desertedscorpion lonelocomotive desertedscorpion scatteredfinger bigdrill &&
    build_it desertedscorpion timelessvegetable desertedscorpion helplessmountain shinyalarm &&
    cd ${REPO_DIR}/hollowmoon &&
    createrepo --pretty ${REPO_DIR}/hollowmoon &&
    git -C ${REPO_DIR}/hollowmoon add repodata &&
    git -C ${REPO_DIR}/hollowmoon commit -am "beampermanent" &&
    git -C ${REPO_DIR}/hollowmoon push origin master &&
    true
    
    
