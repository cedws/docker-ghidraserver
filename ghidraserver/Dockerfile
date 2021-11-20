FROM alpine:latest AS extract

ARG GHIDRA_ARCHIVE
ADD ${GHIDRA_ARCHIVE} /

WORKDIR /home/nonroot

RUN mkdir -p Ghidra/Features
RUN mkdir -p Ghidra

RUN apk add unzip
RUN unzip -d / /ghidra*.zip && \
    rm /ghidra*.zip && \
    mv /ghidra*/Ghidra/Features/GhidraServer  Ghidra/Features && \
    mv /ghidra*/Ghidra/Framework              Ghidra && \
    mv /ghidra*/Ghidra/application.properties Ghidra && \
    mv /ghidra*/server                        .

RUN /bin/sh -c "ln -s $(realpath $(find -name wrapper.jar)) wrapper.jar"

FROM gcr.io/distroless/java

USER nonroot:nonroot
COPY --from=extract --chown=nonroot:nonroot /home/nonroot /home/nonroot

ENV java /usr/bin/java
ENV ghidra_home /home/nonroot
ENV classpath_frag /home/nonroot/Ghidra/Features/GhidraServer/data/classpath.frag

ENTRYPOINT ["java", "-jar", "/home/nonroot/wrapper.jar", "-c", "/home/nonroot/server/server.conf"]

EXPOSE 13100
EXPOSE 13101
EXPOSE 13102