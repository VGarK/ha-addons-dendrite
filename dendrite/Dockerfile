# ===== Build image using prebuilt Dendrite binary =====
ARG ARCH=amd64
FROM alpine:3.18

# Install runtime dependencies
RUN apk add --no-cache ca-certificates bash wget

# Set working directory for HA data
WORKDIR /data

# Download Dendrite monolith server for the architecture
RUN if [ "$ARCH" = "arm64" ]; then \
        wget -O /usr/bin/dendrite-monolith-server https://github.com/matrix-org/dendrite/releases/download/v0.11.2/dendrite-monolith-server-linux-arm64; \
    else \
        wget -O /usr/bin/dendrite-monolith-server https://github.com/matrix-org/dendrite/releases/download/v0.11.2/dendrite-monolith-server-linux-amd64; \
    fi \
    && chmod +x /usr/bin/dendrite-monolith-server

# Create required directories
RUN mkdir -p /data/jetstream /data/media_store /data/logs

ENTRYPOINT ["/usr/bin/dendrite-monolith-server"]
