FROM python:3.7-alpine

LABEL maintainer="Mathieu Bouzard <mathieu.bouzard@gmail.com>"

USER root

RUN apk add --no-cache ffmpeg bzip2 postgresql-libs postgresql-client\
    && apk add --no-cache --virtual .build-deps jpeg-dev zlib-dev musl-dev gcc libffi-dev postgresql-dev

ARG ZOU_VERSION

RUN pip install --upgrade pip wheel setuptools zou==${ZOU_VERSION}\
    && apk del .build-deps

ENV ZOU_FOLDER /usr/local/lib/python3.7/site-packages/zou
WORKDIR ${ZOU_FOLDER}

COPY init_zou.sh ./init_zou.sh
COPY upgrade_zou.sh ./upgrade_zou.sh