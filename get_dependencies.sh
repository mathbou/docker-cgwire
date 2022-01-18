#!/usr/bin/env bash

SWD=$(cd $(dirname $0);echo $PWD)


function get_build_dependency() {
    echo "${CYAN}GET $1 build dependencies"
    git clone -b $1 --single-branch --depth 1 https://gitlab.com/mathbou/docker-cgwire.git $SWD/$1 || :

    if $FORCE && $UPDATE; then
        git -C $SWD/$1 reset --hard || :
    fi
    if $UPDATE; then
        git -C $SWD/$1 pull --rebase || :
    fi
}

function get_develop_dependency(){
    echo "${MAGENTA}GET $1 develop dependencies"
    git clone -b master https://github.com/cgwire/$1.git $SWD/$1-dev || :

    if $FORCE && $UPDATE; then
        git -C $SWD/$1-dev reset --hard || :
    fi
    if $UPDATE; then
        git -C $SWD/$1-dev pull --rebase || :
    fi
}

# --------------------------------------------------------------
# ---------------------------- ARGS ----------------------------
# --------------------------------------------------------------

source $SWD/common.sh

DEVELOP=false
case $1 in
  develop)
    DEVELOP=true
    shift
    ;;
esac

UPDATE=false
FORCE=false
for i in "$@"; do
    case $i in
        --update)
            UPDATE=true
            echo "${CYAN}UPDATE DEPENDENCIES"
            shift
            ;;
        --force)
            FORCE=true
            echo "${MAGENTA}/!\\ FORCE UPDATE /!\\ "
            shift
            ;;
        -h | --help)
            echo "
    Usage:

        get_dependencies.sh [subcommand] [options]

    Subcommand:

        develop                Get dependencies for development containers

    Flags:

            --update            Pull dependencies if clone fails
            --force             Combine with `--update`. Hard reset instead of pull.

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

if $FORCE && ! $UPDATE; then
    echo "${ERROR}Force flag works with 'update' flag only"
    exit 1
fi


if $DEVELOP; then
    get_develop_dependency kitsu
    get_develop_dependency zou
else
    get_build_dependency kitsu
    get_build_dependency zou
fi
