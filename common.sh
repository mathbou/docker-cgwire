#!/usr/bin/env bash

CYAN="\e[1;96m"
BLUE="\e[1;94m"
MAGENTA="\e[1;95m"
YELLOW="\e[1;93m"
GREEN="\e[1;92m"
ERROR="\e[1;97;48;5;1m"
DEFAULT="\e[0;0;0m"


function echo() {
    builtin echo -e "$*${DEFAULT}"
}


function source_env() {
    echo "${GREEN}SOURCE ENV${DEFAULT}"
    export $(grep -v '^#' $1 | xargs -L 1)
}


function dc() {
    if command -v docker-compose &> /dev/null; then
        docker-compose "$@"
    else
        docker compose "$@"
    fi
}
