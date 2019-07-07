FROM nginx:alpine

USER root

WORKDIR /opt
ARG KITSU_VERSION

RUN apk add --no-cache --virtual .build-deps git\
    && git clone -b ${KITSU_VERSION} --single-branch --depth 1 https://github.com/cgwire/kitsu\
    && apk --purge del .build-deps

COPY ./nginx.conf /etc/nginx/nginx.conf
