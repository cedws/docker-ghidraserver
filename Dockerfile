FROM alpine:latest AS extract

ARG GHIDRA_ARCHIVE=https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.1_build/ghidra_11.1_PUBLIC_20240607.zip
ADD $GHIDRA_ARCHIVE /

WORKDIR /home/ghidra

RUN mkdir -p Ghidra/Features
RUN mkdir -p Ghidra

# Extract the ZIP and throw away the extras we don't need
# Ideally they would distribute the server component as a separate artifact but anyway
RUN apk add unzip
RUN unzip -d / /ghidra*.zip && \
    rm /ghidra*.zip && \
    mv /ghidra*/Ghidra/Features/GhidraServer  Ghidra/Features && \
    mv /ghidra*/Ghidra/Framework              Ghidra && \
    mv /ghidra*/Ghidra/application.properties Ghidra && \
    mv /ghidra*/server                        . && \
    mv /ghidra*/support                       .

RUN /bin/sh -c "ln -s $(realpath $(find -name wrapper.jar)) wrapper.jar"

FROM openjdk:17-slim

ENV GHIDRASERVER_PORT 13100
ENV GHIDRASERVER_AUTHENTICATION_MODE 0
ENV GHIDRASERVER_PASSWORD_EXPIRATION 1
ENV GHIDRASERVER_ENABLE_USERID_PROMPT 1

ENV DEBIAN_FRONTEND noninteractive

COPY entrypoint.sh /
COPY start.sh /
RUN chmod +x /entrypoint.sh /start.sh
ENTRYPOINT ["/entrypoint.sh"]

RUN mkdir /srv/repositories
VOLUME /srv/repositories

# Create user and switch to it, makes permissions kosher
RUN useradd ghidra
USER ghidra

WORKDIR /home/ghidra
COPY --from=extract --chown=ghidra:ghidra /home/ghidra /home/ghidra

# Switch back to root since the entrypoint needs to chown the repositories mount
USER root

EXPOSE 13100
EXPOSE 13101
EXPOSE 13102