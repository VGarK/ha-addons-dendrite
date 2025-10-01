FROM alpine:3.18

RUN apk add --no-cache ca-certificates bash wget

WORKDIR /data

# Download prebuilt Dendrite binary
RUN wget -O /usr/bin/dendrite-monolith-server https://github.com/matrix-org/dendrite/releases/download/v0.11.2/dendrite-monolith-server-linux-arm64 \
    && chmod +x /usr/bin/dendrite-monolith-server

# Also add dummy scripts for create-account & generate-keys if needed
COPY generate-keys /usr/bin/generate-keys
COPY create-account /usr/bin/create-account

RUN mkdir -p /data/jetstream /data/media_store /data/logs

ENTRYPOINT ["/usr/bin/dendrite-monolith-server"]
