#!/bin/bash


THIS_FILE_FOLDER="$(dirname $(readlink -f ${BASH_SOURCE}))"

##############    read static env vars ###############

if [ ! -f ".env" ]
then
    ln -s env .env
fi

source "${THIS_FILE_FOLDER}/.env"

################ make version ########################

BOX_VERSION="$(date -u +%Y%m%d.%H.%M)"

############### check if box is defined ##############

vagrant status --machine-readable "${BOX_NAME}" &> /dev/null
box_exists="$?"

############## check if already created ###############
if ((!${box_exists}))
then
    VM_STATE="$(vagrant status --machine-readable ${BOX_NAME} | grep ',state,' | sed 's/.*,state,\(.*\)$/\1/g')"
    
    echo "Box state : ${VM_STATE}"
    
    if [ "${VM_STATE}" != "not_created" ]
    then
	echo "vm is ${VM_STATE}, will destroy before rebuilding from scratch..."
	vagrant destroy -f
    fi
else
    echo "Box is undefined, is the Vagrantfile missing ? aborting."
    exit 1
fi

#############   Prepare build folder   ###############

BUILD_FOLDER="${THIS_FILE_FOLDER}/build/${BOX_VERSION}" \
    && mkdir -p "${BUILD_FOLDER}"

############# BUILD AND PROVISION ###############

BOX_VERSION=${BOX_VERSION} vagrant up

### post processing info : build the description file :

DESTINATION_DESC_FILE="${BUILD_FOLDER}/description.txt"

cat "${THIS_FILE_FOLDER}/description.header" > "${DESTINATION_DESC_FILE}"

ssh -i ${HOME}/.vagrant.d/insecure_private_key \
    -o IdentitiesOnly=yes \
    -o StrictHostKeyChecking=no \
    -o GlobalKnownHostsFile=/dev/null \
    -o UserKnownHostsFile=/dev/null \
    -p 2200 vagrant@127.0.0.1 'dpkg-query -W' > "${BUILD_FOLDER}/installed_apt_pkgs.txt"

cat <<EOF >> "${DESTINATION_DESC_FILE}"

Box version : ${BOX_VERSION}
Commit : $(git rev-parse --short HEAD)
ubuntu/bionic64 base box version : ${UBUNTU_BASE_BOX_VERSION}

installed pacakges :

EOF

cat ${BUILD_FOLDER}/installed_apt_pkgs.txt >> "${DESTINATION_DESC_FILE}"

################# PACKAGE #######################

vagrant package --output "${BUILD_FOLDER}/virtualbox.box" --base "${BOX_NAME}"

### stop and destroy the vm ###

#vagrant destroy

#### all done. ####


