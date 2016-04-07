build/release/${RELEASE_REPOSITORY}/${NAME}-${VERSION}.spec : ${NAME}.spec
	sed -e "s#VERSION#${VERSION}#" -e "s#RELEASE#${RELEASE}#" -e "w${@}" ${<}

build/release/${RELEASE_REPOSITORY}/${NAME}-${VERSION} :
	mkdir ${@}
	git -C ${@} init
	git -C ${@} remote add origin git@github.com:${VERSION_ORGANIZATION}/${VERSION_REPOSITORY}.git
	git -C ${@} fetch origin

build/release/${RELEASE_REPOSITORY}/${NAME}-${VERSION}.tar : build/release/${RELEASE_REPOSITORY}/${NAME}-${VERSION}
	git -C ${<} archive --prefix ${NAME}-${VERSION}/ tags/${VERSION} > ${@}

build/release/${RELEASE_REPOSITORY}/${NAME}-${VERSION}.tar.gz : ${NAME}-${VERSION}.tar
	gzip --to-stdout ${<} > ${@}

build/release/${RELEASE_REPOSITORY}/buildsrpm/${NAME}-${VERSION}-${RELEASE}.src.rpm : build/release/${RELEASE_REPOSITORY}/${NAME}-${VERSION}.spec ${NAME}-${VERSION}.tar.gz
	mkdir --parents buildsrpm
	mock --buildsrpm --spec ${NAME}-${VERSION}.spec --sources ${NAME}-${VERSION}.tar.gz --resultdir buildsrpm

build/release/${RELEASE_REPOSITORY}/rebuild/${NAME}-${VERSION}-${RELEASE}.x86_64.rpm : build/release/${RELEASE_REPOSITORY}/buildsrpm/${NAME}-${VERSION}-${RELEASE}.src.rpm
	mkdir --parents rebuild
	mock --rebuild build/release/${RELEASE_REPOSITORY}/buildsrpm/${NAME}-${VERSION}-${RELEASE}.src.rpm --resultdir rebuild
