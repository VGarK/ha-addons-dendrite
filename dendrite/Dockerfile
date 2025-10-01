ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.17
FROM $BUILD_FROM

# Install dependencies
RUN apk add --no-cache go git bash

# Build dendrite
WORKDIR /dendrite
RUN git clone https://github.com/matrix-org/dendrite.git . && \
    go build -o /usr/bin/dendrite-monolith-server ./cmd/dendrite-monolith-server && \
    go build -o /usr/bin/generate-keys ./cmd/generate-keys && \
    go build -o /usr/bin/create-account ./cmd/create-account

# Copy runtime files
COPY run.sh /run.sh
COPY dendrite.yaml.template /etc/dendrite/dendrite.yaml.template

RUN chmod +x /run.sh

CMD [ "/run.sh" ]
