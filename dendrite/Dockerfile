# dendrite/Dockerfile
ARG BUILD_FROM
# Stage 1: get compiled Dendrite binary from upstream image
FROM matrixdotorg/dendrite-monolith:latest AS dendrite_src

# Stage 2: Home Assistant add-on base image (bashio, s6, etc)
FROM ${BUILD_FROM}

USER root

# Copy the monolith binary from upstream (path used by upstream image)
# If upstream image changes path, adjust this path accordingly.
COPY --from=dendrite_src /usr/bin/dendrite-monolith-server /usr/local/bin/dendrite-monolith-server
RUN chmod +x /usr/local/bin/dendrite-monolith-server || true

# Provide a place for template & runtime files
RUN mkdir -p /etc/dendrite /data /data/media_store /data/jetstream /data/logs

# Add our run script and template
COPY run.sh /run.sh
COPY dendrite.yaml.template /etc/dendrite/dendrite.yaml.template

RUN chmod a+x /run.sh

WORKDIR /data

# The add-on run script will launch the binary
ENTRYPOINT [ "/run.sh" ]
CMD []
