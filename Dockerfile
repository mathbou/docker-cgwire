ARG PY_V=3.13

FROM python:${PY_V}-slim AS builder
USER root

RUN apt update \
    && apt install -y --no-install-recommends make python3-dev gcc g++ \
    && apt autoclean \
    && rm -rf /var/lib/apt/lists/*

ARG PY_V
ARG ZOU_VERSION

RUN pip install --no-cache-dir --upgrade pip wheel setuptools \
    && pip install --no-cache-dir zou==${ZOU_VERSION}   
    

FROM python:${PY_V}-slim

ARG ZOU_VERSION

LABEL org.opencontainers.image.version=${ZOU_VERSION}
LABEL org.opencontainers.image.authors="Mathieu Bouzard <mathieu.bouzard@gmail.com>"
LABEL org.opencontainers.image.source="https://gitlab.com/mathbou/docker-cgwire/-/tree/zou"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.title="Zou"

USER root

RUN apt update \
    && apt install -y --no-install-recommends curl ffmpeg bzip2 postgresql-client \
    && apt autoclean \
    && rm -rf /var/lib/apt/lists/*

ARG PY_V

COPY --from=builder /usr/local/lib/python${PY_V} /usr/local/lib/python${PY_V}
COPY --from=builder /usr/local/bin /usr/local/bin

ENV ZOU_FOLDER /usr/local/lib/python${PY_V}/site-packages/zou
WORKDIR ${ZOU_FOLDER}

COPY init_zou.sh /init_zou.sh
COPY upgrade_zou.sh /upgrade_zou.sh