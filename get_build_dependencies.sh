#!/usr/bin/env bash

source ./common.sh

echo "${BLUE}GET KITSU"
git clone -b kitsu --single-branch --depth 1 https://gitlab.com/mathbou/docker-cgwire.git ./kitsu || git -C ./kitsu pull

echo "${BLUE}GET ZOU"
git clone -b zou --single-branch --depth 1 https://gitlab.com/mathbou/docker-cgwire.git ./zou || git -C ./zou pull