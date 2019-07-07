FROM abiosoft/caddy:no-stats

LABEL maintainer="Mathieu Bouzard <mathieu.bouzard@gmail.com>"

ARG  KITSU_VERSION

WORKDIR /opt

RUN git clone -b ${KITSU_VERSION} --single-branch --depth 1 https://github.com/cgwire/kitsu

ENV ACME_AGREE="true"
COPY Caddyfile /etc/Caddyfile