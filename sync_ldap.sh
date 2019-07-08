#!/usr/bin/env bash

# --------------------------------------------------------------
# ---------------------------- ARGS ----------------------------
# --------------------------------------------------------------

source ./common.sh
export ENV_FILE=./env

echo "${LGREEN}PARSE ARGS"
for i in "$@"; do
    case $i in
        -e=* | --env=*)
            export ENV_FILE="${i#*=}"
            echo "${CYAN}USE CUSTOM ENV FILE"
            shift
            ;;
        -h | --help)
            echo "
    Usage:

        sync_ldap.sh [options]

    Flags:

        -e, --env=ENV_FILE      Set custom env file, must be the same as the env used with build.sh
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

echo "${CYAN}SYNC LDAP"
docker-compose exec zou-app zou sync_with_ldap_server