FROM python:3.7-alpine

USER root

RUN apk add --no-cache ffmpeg bzip2 postgresql-libs\
    && apk add --no-cache --virtual .build-deps jpeg-dev zlib-dev musl-dev gcc libffi-dev postgresql-dev

ARG ZOU_VERSION

RUN pip install --upgrade pip wheel setuptools zou==${ZOU_VERSION}\
    && apk del .build-deps

ENV ZOU_FOLDER /usr/local/lib/python3.7/site-packages/zou
WORKDIR ${ZOU_FOLDER}

ARG PREVIEW_FOLDER
ARG TMP_DIR

RUN mkdir -p ${PREVIEW_FOLDER} ${TMP_DIR}

COPY ./init_zou.sh ./init_zou.sh
COPY ./upgrade_zou.sh ./upgrade_zou.sh