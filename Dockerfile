FROM nginx:alpine AS buildStage

USER root

WORKDIR /opt

RUN apk add --no-cache --virtual .build-deps git

ARG KITSU_VERSION

RUN git clone -b "${KITSU_VERSION}-build" --single-branch --depth 1 https://github.com/cgwire/kitsu\
    && apk --purge del .build-deps


FROM nginx:alpine AS squashStage

ARG KITSU_VERSION

LABEL org.opencontainers.image.version=${KITSU_VERSION}
LABEL org.opencontainers.image.authors="Mathieu Bouzard <mathieu.bouzard@gmail.com>"
LABEL org.opencontainers.image.source="https://gitlab.com/mathbou/docker-cgwire/-/tree/kitsu"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.title="Kitsu"

COPY --from=buildStage / /

COPY ./nginx.conf /etc/nginx/nginx.conf
