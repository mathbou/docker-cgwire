source common.sh

DRY=0
export ENV_FILE=./env

echo "${BLUE}PARSE ARGS"
for i in "$@"; do
    case $i in
        -e=* | --env=*)
            export ENV_FILE="${i#*=}"
            echo "${CYAN}USE CUSTOM ENV FILE"
            shift
            ;;
        -d | --dry-run)
            DRY=1
            shift
            ;;
        -h | --help)
            echo "
    Usage:

        $0 [options] OldIdxVersion NewIdxVersion

    Flags:
        -e, --env=ENV_FILE      Set custom env file. If not set ./env is used
        -d, --dry               Dry-run
        -h, --help              Show this help
            "
            exit 0
        ;;
    esac
done

version_ge() {
    printf '%s\n%s\n' "$2" "$1" | sort --check=quiet --version-sort
}

if [[ $1 =~ ^[+-]?[0-9]+(\.[0-9]+)+$ ]]; then
    if ! version_ge "$2" "1.11"; then
      echo "${ERROR}Need OldIdxVersion > 1.11"
      exit 1
    fi
    export OLD_VERSION="v${1}"
else
    echo "${ERROR}$0 [options] OldIdxVersion NewIdxVersion"
    exit 1
fi
if [[ $2 =~ ^[+-]?[0-9]+(\.[0-9]+)+$ ]]; then
    if ! version_ge "$2" "1.12"; then
      echo "${ERROR}Need NewIdxVersion > 1.12"
      exit 1
    fi
    export NEW_VERSION="v${2}"
else
    echo "${ERROR}$0 [options] OldIdxVersion NewIdxVersion"
    exit 1
fi

# --------------------------------------------------------------
# ---------------------------- MAIN ----------------------------
# --------------------------------------------------------------


function db-compose() {
    dc -f docker-compose.idxUpgrade.yml "$@"
}

source_env ${ENV_FILE}

bash ./build.sh down -e=${ENV_FILE}
db-compose up -d --wait copier

sleep 1


if [ $DRY == 1 ]; then
    echo "${MAGENTA}Dry migration from $OLD_VERSION to $NEW_VERSION"
else
    echo "${GREEN}Copy data from $OLD_VERSION to $NEW_VERSION"
    db-compose exec -T copier cp -avT '/old_meili_data/' '/meili_data/'
    db-compose down

    echo "${GREEN}Upgrade data from $OLD_VERSION to $NEW_VERSION"
    db-compose up -d new-indexer

    until db-compose exec -T new-indexer curl -s -f 'http://localhost:${INDEXER_PORT:-7700}/tasks?types=UpgradeDatabase&statuses=processing' | grep -q '"total":0' ; do
      sleep 3
      echo "${YELLOW}Upgrade in progress..."
    done
fi

db-compose down