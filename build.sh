#!/bin/bash

mkdir --parents build/{release,repo} &&
    REBUILD=false &&
    if [[ ! -d build ]]
    then
	mkdir build &&
	    true
    fi &&
    if [[ ! -d build/repo ]]
    then
	mkdir build/repo &&
	    true
    fi &&
    if [[ ! -d build/repo/hollowmoon ]]
    then
	git -C build/repo clone git@github.com:desertedscorpion/hollowmoon.git &&
	    true
    fi &&
    git -C build/repo/hollowmoon pull --tags origin master &&
    function artifacts(){
	RELEASE_ORGANIZATION=${1} &&
	    RELEASE_REPOSITORY=${2} &&
	    VERSION_ORGANIZATION=${3} &&
	    VERSION_REPOSITORY=${4} &&
	    NAME=${5} &&
	    RELEASE=${6} &&
	    VERSION=${7} &&
	    if [[ -f build/repo/hollowmoon/${NAME}-${VERSION}-${RELEASE}.x86_64.rpm ]]
	    then
		echo WE HAVE ALREADY SUCCEEDED IN BUILDING RELEASE_ORGANIZATION=${RELEASE_ORGANIZATION} RELEASE_REPOSITORY=${RELEASE_REPOSITORY} VERSION_ORGANIZATION=${VERSION_ORGANIZATION} VERSION_REPOSITORY=${VERSION_REPOSITORY} NAME=${NAME} RELEASE=${RELEASE} VERSION=${VERSION} &&
		    touch build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}/${VERSION}/oldsuccess &&
		    true
	    elif [[ -f build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}/${VERSION}/failure ]]
	    then
		echo WE HAVE ALREADY FAILED IN BUILDING RELEASE_ORGANIZATION=${RELEASE_ORGANIZATION} RELEASE_REPOSITORY=${RELEASE_REPOSITORY} VERSION_ORGANIZATION=${VERSION_ORGANIZATION} VERSION_REPOSITORY=${VERSION_REPOSITORY} NAME=${NAME} RELEASE=${RELEASE} VERSION=${VERSION} &&
		    touch build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}/${VERSION}/oldfailure &&
		    true
	    else
		echo LET US BUILD RELEASE_ORGANIZATION=${RELEASE_ORGANIZATION} RELEASE_REPOSITORY=${RELEASE_REPOSITORY} VERSION_ORGANIZATION=${VERSION_ORGANIZATION} VERSION_REPOSITORY=${VERSION_REPOSITORY} NAME=${NAME} RELEASE=${RELEASE} VERSION=${VERSION} &&
		    sed --quiet -e "s#VERSION#${VERSION}#" -e "s#RELEASE#${RELEASE}#" -e "wbuild/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}/${VERSION}/${NAME}-${VERSION}.spec" build/release/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${NAME}.spec &&
		    git -C build/version/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY} archive --prefix ${NAME}-${VERSION}/ tags/${VERSION} > build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}/${VERSION}/${NAME}-${VERSION}.tar &&
		    gzip --to-stdout build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}/${VERSION}/${NAME}-${VERSION}.tar > build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}/${VERSION}/${NAME}-${VERSION}.tar.gz &&
		    mkdir build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}/${VERSION}/buildsrpm &&
		    mock --buildsrpm --spec build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}/${VERSION}/${NAME}-${VERSION}.spec --sources build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}/${VERSION}/${NAME}-${VERSION}.tar.gz --resultdir build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}/${VERSION}/buildsrpm --quiet &&
		    mkdir build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}/${VERSION}/rebuild &&
		    mock --rebuild build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}/${VERSION}/buildsrpm/${NAME}-${VERSION}-${RELEASE}.src.rpm --resultdir build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}/${VERSION}/rebuild --quiet &&
		    cp build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}/${VERSION}/rebuild/${NAME}-${VERSION}-${RELEASE}.x86_64.rpm build/repo/hollowmoon &&
		    git -C build/repo/hollowmoon add ${NAME}-${VERSION}-${RELEASE}.x86_64.rpm &&
		    touch build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}/${VERSION}/success &&
		    REBUILD=true &&
		    true
	    fi &&
	    true
    } &&
    function version(){
	RELEASE_ORGANIZATION=${1} &&
	    RELEASE_REPOSITORY=${2} &&
	    VERSION_ORGANIZATION=${3} &&
	    VERSION_REPOSITORY=${4} &&
	    NAME=${5} &&
	    RELEASE=${6} &&
	    VERSION=${7} &&
	    git -C build/version/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY} checkout tags/${VERSION} &&
	    if [[ ! -d build/artifacts/${RELEASE_ORGANIZATION} ]]
	    then
		mkdir --parents build/artifacts/${RELEASE_ORGANIZATION} &&
		    true
	    fi &&
	    if [[ ! -d build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY} ]]
	    then
		mkdir --parents build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY} &&
		    true
	    fi &&
	    if [[ ! -d build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE} ]]
	    then
		mkdir --parents build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE} &&
		    true
	    fi &&
	    if [[ ! -d build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION} ]]
	    then
		mkdir --parents build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION} &&
		    true
	    fi &&
	    if [[ ! -d build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY} ]]
	    then
		mkdir --parents build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY} &&
		    true
	    fi &&
	    if [[ ! -d build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}/${VERSION} ]]
	    then
		mkdir --parents build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}/${VERSION} &&
		    true
	    fi &&
	    (
		artifacts ${RELEASE_ORGANIZATION} ${RELEASE_REPOSITORY} ${VERSION_ORGANIZATION} ${VERSION_REPOSITORY} ${NAME} ${RELEASE} ${VERSION} ||
		    touch build/artifacts/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}/${RELEASE}/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}/${VERSION}/failure
	    ) &&
	    true
    } &&
    function versions(){
	RELEASE_ORGANIZATION=${1} &&
	    RELEASE_REPOSITORY=${2} &&
	    VERSION_ORGANIZATION=${3} &&
	    VERSION_REPOSITORY=${4} &&
	    NAME=${5} &&
	    RELEASE=${6} &&
	    if [[ ! -d build/version/${VERSION_ORGANIZATION} ]]
	    then
		mkdir --parents build/version/${VERSION_ORGANIZATION} &&
		    true
	    fi &&
	    if [[ ! -d build/version/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY} ]]
	    then
		git -C build/version/${VERSION_ORGANIZATION} clone git@github.com:${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}.git &&
		    true
	    fi &&
	    git -C build/version/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY} pull --tags origin master &&
	    git -C build/version/${VERSION_ORGANIZATION}/${VERSION_REPOSITORY} tag | while read VERSION
	    do
		version ${RELEASE_ORGANIZATION} ${RELEASE_REPOSITORY} ${VERSION_ORGANIZATION} ${VERSION_REPOSITORY} ${NAME} ${RELEASE} ${VERSION} &&
		    true
	    done &&
	    true
    } &&
    function release(){
	RELEASE_ORGANIZATION=${1} &&
	    RELEASE_REPOSITORY=${2} &&
	    VERSION_ORGANIZATION=${3} &&
	    VERSION_REPOSITORY=${4} &&
	    NAME=${5} &&
	    RELEASE=${6} &&
	    git -C build/release/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY} checkout tags/${RELEASE} &&
	    versions ${RELEASE_ORGANIZATION} ${RELEASE_REPOSITORY} ${VERSION_ORGANIZATION} ${VERSION_REPOSITORY} ${NAME} ${RELEASE} &&
	    true
    } &&
    function releases(){
	RELEASE_ORGANIZATION=${1} &&
	    RELEASE_REPOSITORY=${2} &&
	    VERSION_ORGANIZATION=${3} &&
	    VERSION_REPOSITORY=${4} &&
	    NAME=${5} &&
	    echo BUILDING RELEASES ${RELEASE_ORGANIZATION} ${RELEASE_REPOSITORY} &&
	    if [[ ! -d build/release/${RELEASE_ORGANIZATION} ]]
	    then
		mkdir --parents build/release/${RELEASE_ORGANIZATION} &&
		    true
	    fi &&
	    if [[ ! -d build/release/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY} ]]
	    then
		git -C build/release/${RELEASE_ORGANIZATION} clone git@github.com:${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY}.git &&
		    true
	    fi &&
	    git -C build/release/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY} pull --tags origin master &&
	    git -C build/release/${RELEASE_ORGANIZATION}/${RELEASE_REPOSITORY} tag | while read RELEASE
	    do
		release ${RELEASE_ORGANIZATION} ${RELEASE_REPOSITORY} ${VERSION_ORGANIZATION} ${VERSION_REPOSITORY} ${NAME} ${RELEASE} &&
		    true
	    done &&
	    true
    } &&
    (
	flock --exclusive 9
	releases desertedscorpion navyavenue desertedscorpion alienmetaphor luckygamma &&
	    releases desertedscorpion silverfoot desertedscorpion scatteredfinger jenkins-client &&
	    releases desertedscorpion bigdrill desertedscorpion lostlocomotive jenkins-client-service &&
	    releases desertedscorpion timelyvegetable desertedscorpion helplessmountain shinyalarm &&
	    rm ~/beampermanent.lock &&
	    true
    ) 9> ~/beampermanent.lock &&
    if [[ ${REBUILD} ]]
    then
	createrepo --pretty build/repo/hollowmoon &&
	    git -C build/repo/hollowmoon add repodata &&
	    git -C build/repo/hollowmoon commit -am "beampermanent" &&
	    git -C build/repo/hollowmoon push origin master &&
	    true
    fi &&
    true


