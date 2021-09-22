#!/bin/sh

export LC_ALL=C.UTF-8
export LANG=C.UTF-8

mkdir -p ${PREVIEW_FOLDER} ${TMP_DIR}

zou upgrade-db
zou init-data
zou create-admin admin@example.com --password mysecretpassword
