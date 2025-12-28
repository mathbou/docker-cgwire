#!/bin/sh

export LC_ALL=C.UTF-8
export LANG=C.UTF-8

mkdir -p ${PREVIEW_FOLDER} ${TMP_DIR}

if [ ${DEBUG:-0} -eq 1 ]; then
  zou upgrade-db --no-telemetry
else
  zou upgrade-db
fi

zou init-data
zou create-admin admin@example.com --password mysecretpassword
