#!/bin/sh

export LC_ALL=C.UTF-8 
export LANG=C.UTF-8

if [ ${DEBUG:-0} -eq 1 ]; then
  zou upgrade-db --no-telemetry
else
  zou upgrade-db
fi
