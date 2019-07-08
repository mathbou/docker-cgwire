#!/usr/bin/env bash

CYAN="\e[1;36m"
BLUE="\e[1;34m"
LYELLOW="\e[1;93m"
LGREEN="\e[1;92m"
ERROR="\e[1;48;5;1m"
DEFAULT="\e[0;0;0m"

INIT=0
BUILD=0
DOWN=0
export ENV_FILE=./env

echo -e "${LGREEN}GET ARGS${DEFAULT}"
for i in "$@"
do
case $i in
    -i | --init)
    INIT=1
    echo -e "${CYAN}INIT MODE ACTIVATED${DEFAULT}"
    shift
    ;;
    -b | --build)
    BUILD=1
    echo -e "${CYAN}USE LOCAL BUILD${DEFAULT}"
    shift
    ;;
    -e=* | --env=*)
    export ENV_FILE="${i#*=}"
    echo -e "${CYAN}USE CUSTOM ENV FILE${DEFAULT}"
    shift
    ;;
    -d | --down)
    DOWN=1
    echo -e "${CYAN}STOP INSTANCE${DEFAULT}"
    shift
    ;;
    -h | --help)
    echo "
    Usage:

        build.sh [options]

    Flags:

        -i, --init              Init Zou and the database (Required for the first launch)
        -b, --build             Use local images
        -e, --env=ENV_FILE      Set custom env file
        -d, --down              Compose down the stack
        -h, --help              Show this help
    "
    exit 0
    ;;
    *)
    echo -e "${ERROR}Invalid flag ${i} // Use -h or --help to print help${DEFAULT}"
    exit 1
    ;;
esac
done

echo -e "${LGREEN}SOURCE ENV${DEFAULT}"
export $(grep -v '^#' ${ENV_FILE} | xargs -L 1)

echo -e "${LYELLOW}STOP OLD CONTAINER${DEFAULT}"
docker-compose down

if [ $DOWN == 0 ]; then
    if [ $BUILD == 1 ]; then
        echo -e "${BLUE}BUILD CONTAINER${DEFAULT}"
        docker-compose build --force-rm --pull --compress

        echo -e "${LYELLOW}START NEW CONTAINER${DEFAULT}"
        docker-compose -f docker-compose-build.yml up -d
    else
        echo -e "${LYELLOW}START NEW CONTAINER${DEFAULT}"
        docker-compose up -d
    fi


    if [ $INIT == 1 ]; then
        echo -e "${LGREEN}INIT ZOU${DEFAULT}"
        docker-compose exec db su - postgres -c "createuser root"
        docker-compose exec db su - postgres -c "createdb -T template0 -E UTF8 --owner root root"
        docker-compose exec db  su - postgres -c "createdb -T template0 -E UTF8 --owner root zoudb"
        docker-compose exec zou-app sh init_zou.sh
    else
        echo -e "${LGREEN}UPGRADE ZOU${DEFAULT}"
        docker-compose exec zou-app sh upgrade_zou.sh
    fi
fi