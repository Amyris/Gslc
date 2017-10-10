#!/usr/bin/env bash
# Builds the minimal docker image with the GSL binaries installed

set -e

REPO_NAME="gslc"

##################################################################
# Get the version
##################################################################

GIT_TAG=`git rev-parse HEAD`
if [ ! -z "$TRAVIS_COMMIT" ]; then
	GIT_TAG=$TRAVIS_COMMIT
fi
GIT_TAG=${GIT_TAG:0:8}
PACKAGE_VERSION=$GIT_TAG

##################################################################
# Build the binaries
##################################################################

docker run -w /app -v $PWD:/app mono:4.8.0.495 ./build.sh

##################################################################
# Build the docker image that has all the final libraries and binaries
##################################################################

OUTPUT_DIR=$PWD/tmpDockerBuild
rm -rf $OUTPUT_DIR
mkdir -p $OUTPUT_DIR/bin
mkdir -p $OUTPUT_DIR/docs

##################################################################
# Now create the final docker image that
# Only contains the binaries and the libraries
##################################################################

cp -r ./src/Gslc/bin/Release/* $OUTPUT_DIR/bin

cat > $OUTPUT_DIR/Dockerfile << EOF
FROM mono:4.8.0.495
ENV PATH="/gslc/bin:${PATH}"
ADD ./bin/* /gslc/bin/
ADD ./docs /gslc/docs
ADD ./gslc_lib /gslc/gslc_lib
ENTRYPOINT [ "mono", "/gslc/bin/Gslc.exe", "--lib", "/gslc/gslc_lib" ]
EOF

cat > $OUTPUT_DIR/.dockerignore << EOF
# =========================
# Windows detritus
# =========================

# Windows image file caches
Thumbs.db
ehthumbs.db

# Folder config file
Desktop.ini

# Recycle Bin used on file shares
$RECYCLE.BIN/

# Mac desktop service store files
.DS_Store
EOF

cp -r ./gslc_lib $OUTPUT_DIR/
cd $OUTPUT_DIR/
docker build -t "$REPO_NAME:$PACKAGE_VERSION" .
echo "$REPO_NAME:$PACKAGE_VERSION"

##################################################################
#If DOCKER_REGISTRY, DOCKER_USER, and DOCKER_PASSWORD are given
#then login to the DOCKER_REGISTRY, and upload the image
##################################################################

echo "DOCKER_USER=$DOCKER_USER"
echo "DOCKER_REGISTRY=$DOCKER_REGISTRY"

if [ ! -z  $DOCKER_USER ] && [ ! -z  $DOCKER_PASSWORD ] && [ ! -z  $DOCKER_REGISTRY ]; then
	docker login --username $DOCKER_USER --password $DOCKER_PASSWORD $DOCKER_REGISTRY
	docker tag $REPO_NAME:$PACKAGE_VERSION $DOCKER_REGISTRY/$DOCKER_USER/$REPO_NAME:$PACKAGE_VERSION
	echo "Pushing $DOCKER_REGISTRY/$DOCKER_USER/$REPO_NAME:$PACKAGE_VERSION"
	docker push $DOCKER_REGISTRY/$DOCKER_USER/$REPO_NAME:$PACKAGE_VERSION
fi
