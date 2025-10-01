# Stage 1: Build Dendrite
FROM golang:1.24-alpine AS builder

# Install dependencies
RUN apk add --no-cache git bash

# Set workdir
WORKDIR /src

# Clone Dendrite source
RUN git clone https://github.com/matrix-org/dendrite.git .

# Build the binaries
RUN go build -o /usr/bin/dendrite-monolith-server ./cmd/dendrite-monolith-server
RUN go build -o /usr/bin/generate-keys ./cmd/generate-keys
RUN go build -o /usr/bin/create-account ./cmd/create-account

# Stage 2: Final image
FROM alpine:3.18

# Install runtime dependencies
RUN apk add --no-cache ca-certificates bash

# Copy binaries
COPY --from=builder /usr/bin/dendrite-monolith-server /usr/bin/dendrite-monolith-server
COPY --from=builder /usr/bin/generate-keys /usr/bin/generate-keys
COPY --from=builder /usr/bin/create-account /usr/bin/create-account

# Create directories
RUN mkdir -p /data /data/jetstream /data/media_store /data/logs

WORKDIR /data

ENTRYPOINT ["/usr/bin/dendrite-monolith-server"]
