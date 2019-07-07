#!/usr/bin/env bash

echo "GET DEPENDENCIES"
git clone -b kitsu --single-branch --depth 1 https://gitlab.com/mathbou/docker-cgwire.git ./kitsu || git -C ./kitsu pull
git clone -b zou --single-branch --depth 1 https://gitlab.com/mathbou/docker-cgwire.git ./zou || git -C ./zou pull