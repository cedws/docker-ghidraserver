FROM openjdk:11-slim

ARG GHIDRA_ARCHIVE

ENV GHIDRASERVER_PORT 13100
ENV GHIDRASERVER_AUTHENTICATION_MODE 0
ENV GHIDRASERVER_PASSWORD_EXPIRATION 1
ENV GHIDRASERVER_JAVA_XMS 1024
ENV GHIDRASERVER_JAVA_XMX 1024

ENV DEBIAN_FRONTEND noninteractive

RUN apt update
RUN apt install -yq unzip

COPY entrypoint.sh /
COPY start.sh /
RUN chmod +x /entrypoint.sh /start.sh
ENTRYPOINT ["/entrypoint.sh"]

RUN mkdir /srv/repositories
VOLUME /srv/repositories

RUN useradd ghidra
USER ghidra

WORKDIR /home/ghidra

ADD --chown=ghidra:ghidra ${GHIDRA_ARCHIVE} .
RUN unzip ghidra*.zip && \
    rm ghidra*.zip && \
    mv ghidra*/* .

USER root

EXPOSE 13100
EXPOSE 13101
EXPOSE 13102