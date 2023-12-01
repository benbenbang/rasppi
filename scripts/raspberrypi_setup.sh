#! /bin/bash

function confirm() {
    read -p ">> " CONFIRM

    case ${CONFIRM} in
        Yes | yes )
            echo "going to proceed with ${VOLUME_PATH}"
            ;;
        * )
            echo "abort!"
            exit 1
            ;;
    esac
}

set -e

diskutil list

VOLUME_PATH="${1}"
IMAGE_PATH="${2}"

if [[ -z ${VOLUME_PATH} ]]; then
    read -p "ℹ️ enter the volume path >> " VOLUME_PATH
fi

echo "⚠️ Path: ${VOLUME_PATH} will be used to format the SD card and install the OS. Are you sure this is the correct path"
confirm "${VOLUME_PATH}"

sudo diskutil eraseDisk FAT32 BOOT MBRFormat "${VOLUME_PATH}"

if [[ -z ${IMAGE_PATH} ]]; then
    read -p "ℹ️ enter the image path >> " IMAGE_PATH
fi

echo "⚠️ Path: ${IMAGE_PATH} is the image for installing the OS. Is that correct?"
confirm "${IMAGE_PATH}"

sudo dd if="${IMAGE_PATH}" of="${VOLUME_PATH}" bs=2m
