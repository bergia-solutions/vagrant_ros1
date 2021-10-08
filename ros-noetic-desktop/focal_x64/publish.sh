#!/bin/bash

set -o errexit

BUILD_FOLDER=${1:-"/UNDEFINED"}

if [ "${BUILD_FOLDER}" == "/UNDEFINED" ]
then
    echo "error: you need to provide the build folder as the first argument."
    exit 1
fi

THIS_FILE_FOLDER=$(dirname $(readlink -f "${BASH_SOURCE}"))

source "${THIS_FILE_FOLDER}/.env"

############ fetch current build version ###################

BOX_VERSION=$(basename "${BUILD_FOLDER}")
BOX_FILE="${BUILD_FOLDER}/virtualbox.box"

echo "Box version : ${BOX_VERSION}"

############## compute sha256 checksum #####################

BOX_SHA256=$(sha256sum -b "${BUILD_FOLDER}/virtualbox.box" | cut -d ' ' -f 1)

################    PUBLISH    #############################

vagrant cloud publish \
	-c "${BOX_SHA256}" -C sha256 \
	-d "$(<${BUILD_FOLDER}/description.txt)" \
	-s "$(<${THIS_FILE_FOLDER}/short_description.txt)" \
	--no-private --release \
	"bergiasolutions/${BOX_NAME}" "${BOX_VERSION}" virtualbox "${BOX_FILE}"

### tag and commit so we have traceability

#git tag "${BOX_VERION}" && git commit -a -m "Box release ${BOX_VERSION}"


