# Stage 1: Build Dendrite
FROM golang:1.24-bullseye AS builder

# Install dependencies
RUN apt-get update && apt-get install -y git bash ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /src

# Clone Dendrite
RUN git clone https://github.com/matrix-org/dendrite.git .

# Build binaries
RUN go build -o /usr/bin/dendrite-monolith-server ./cmd/dendrite-monolith-server
RUN go build -o /usr/bin/generate-keys ./cmd/generate-keys
RUN go build -o /usr/bin/create-account ./cmd/create-account

# Stage 2: Runtime image
FROM debian:bullseye-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y ca-certificates bash && rm -rf /var/lib/apt/lists/*

# Copy binaries
COPY --from=builder /usr/bin/dendrite-monolith-server /usr/bin/dendrite-monolith-server
COPY --from=builder /usr/bin/generate-keys /usr/bin/generate-keys
COPY --from=builder /usr/bin/create-account /usr/bin/create-account

# Create necessary directories
RUN mkdir -p /data /data/jetstream /data/media_store /data/logs

WORKDIR /data

ENTRYPOINT ["/usr/bin/dendrite-monolith-server"]
