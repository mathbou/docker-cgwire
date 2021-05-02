#!/usr/bin/env bash


function build_images() {
    echo "${MAGENTA}BUILD CONTAINERS"

    command -v curl 1>/dev/null || { echo "${ERROR}curl required" && exit 1; }
    command -v jq 1>/dev/null || { echo "${ERROR}jq required" && exit 1; }

    if [[ $KITSU_VERSION == "latest" ]]; then
        export KITSU_VERSION=`curl https://api.github.com/repos/cgwire/kitsu/commits | jq -r '.[].commit.message | select(. | test("[0-9]+(\\\\.[0-9]+)+"))?' | grep -m1 ""`
        echo "${GREEN}Set KITSU_VERSION to $KITSU_VERSION"
    fi
    if [[ $ZOU_VERSION == "latest" ]]; then
        export ZOU_VERSION=`curl https://api.github.com/repos/cgwire/zou/commits | jq -r '.[].commit.message | select(. | test("[0-9]+(\\\\.[0-9]+)+"))?' | grep -m1 ""`
        echo "${GREEN}Set ZOU_VERSION to $ZOU_VERSION"
    fi

    if [ ! -e "./kitsu/Dockerfile" ] || [ ! -e "./zou/Dockerfile" ]; then
        echo "${ERROR}Kitsu and Zou Dockerfiles required"
        exit 1
    fi
    docker-compose -f docker-compose.yml -f docker-compose.build.yml build --force-rm --pull --compress
}


function compose_up() {
    echo "${YELLOW}START CONTAINERS"
    if [ ${BUILD} == 1 ]; then
        docker-compose -f docker-compose.yml -f docker-compose.build.yml up -d
    else
        docker-compose pull --include-deps
        docker-compose up -d
    fi
    if [[ "${ENABLE_JOB_QUEUE}" != "True" ]]; then
        echo "${YELLOW}DISABLE ZOU ASYNC JOBS"
        docker-compose stop zou-jobs
    fi
    
    until docker-compose exec -T db pg_isready ; do
        sleep 3
        echo "${YELLOW}Waiting for db..."
    done
}


function compose_down() {
    echo "${YELLOW}STOP CONTAINERS"
    docker-compose down
}


function init_zou() {
    dbowner=postgres
    dbname=zoudb
    
    if docker-compose exec db psql -U ${dbowner} ${dbname} -c '' 2>&1; then
        echo "${GREEN}UPGRADE ZOU"
        docker-compose exec zou-app sh upgrade_zou.sh
    else
        echo "${GREEN}INIT ZOU"
        docker-compose exec db  su - postgres -c "createdb -T template0 -E UTF8 --owner ${dbowner} ${dbname}"
        docker-compose exec zou-app sh init_zou.sh
    fi
}

# --------------------------------------------------------------
# ---------------------------- ARGS ----------------------------
# --------------------------------------------------------------

source common.sh

BUILD=0
DOWN=0
export ENV_FILE=./env

echo "${BLUE}PARSE ARGS"
for i in "$@"; do
    case $i in
        -l | --local)
            BUILD=1
            echo "${CYAN}USE LOCAL BUILD"
            shift
            ;;
        -e=* | --env=*)
            export ENV_FILE="${i#*=}"
            echo "${CYAN}USE CUSTOM ENV FILE"
            shift
            ;;
        -d | --down)
            DOWN=1
            echo "${CYAN}STOP INSTANCE"
            shift
            ;;
        -h | --help)
            echo "
    Usage:

        build.sh [options]

    Flags:

        -l, --local             Use local images
        -e, --env=ENV_FILE      Set custom env file. If not set ./env is used
        -d, --down              Compose down the stack
        -h, --help              Show this help
            "
            exit 0
        ;;
        *)
            echo "${ERROR}Invalid flag ${i} // Use -h or --help to print help"
            exit 1
        ;;
    esac
done

# --------------------------------------------------------------
# ---------------------------- MAIN ----------------------------
# --------------------------------------------------------------

source_env ${ENV_FILE}
compose_down

if [ $DOWN == 0 ]; then
    if [ $BUILD == 1 ]; then
        build_images
    fi

    compose_up
    init_zou
fi
