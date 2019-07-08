#!/usr/bin/env bash

CYAN="\e[1;36m"
BLUE="\e[1;94m"
LYELLOW="\e[1;93m"
LGREEN="\e[1;92m"
ERROR="\e[1;48;5;1m"
DEFAULT="\e[0;0;0m"


function echo() {
    builtin echo -e "$*${DEFAULT}"
}


function source_env() {
    echo "${LGREEN}SOURCE ENV${DEFAULT}"
    export $(grep -v '^#' $1 | xargs -L 1)
}