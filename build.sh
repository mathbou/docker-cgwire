#!/usr/bin/env bash

echo "GET ARGS"

INIT=0
BUILD=0

for i in "$@"
do
case $i in
    -i | --init)
    INIT=1
    echo "INIT MODE ACTIVATED"
    shift
    ;;
    -b | --build)
    BUILD=1
    echo "MAKE LOCAL BUILD"
    shift
    ;;
    *)
          # unknown option
    ;;
esac
done

echo "STOP OLD CONTAINER"

docker-compose down

if [ $BUILD == 1 ]; then
    echo "BUILD CONTAINER"
    docker-compose build --force-rm --pull --compress

    echo "START NEW CONTAINER"
    docker-compose up -d -f docker-compose-build.yml
else
    echo "START NEW CONTAINER"
    docker-compose up -d
fi


if [ $INIT == 1 ]; then
    echo "INIT ZOU"
    docker-compose exec db su - postgres -c "createuser root"
    docker-compose exec db su - postgres -c "createdb -T template0 -E UTF8 --owner root root"
    docker-compose exec db  su - postgres -c "createdb -T template0 -E UTF8 --owner root zoudb"
    docker-compose exec zou-app sh init_zou.sh
else
    echo "UPGRADE ZOU"
    docker-compose exec zou-app sh upgrade_zou.sh
fi