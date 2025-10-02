# dendrite/Dockerfile
ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:latest
FROM matrixdotorg/dendrite-monolith:latest AS dendrite_src

FROM ${BUILD_FROM} AS final

USER root

# Copy whole upstream FS to staging so we can pick binaries regardless of exact path
COPY --from=dendrite_src / /staging

# Pick the binary from likely locations and install to /usr/local/bin/dendrite
RUN set -eux; \
    mkdir -p /usr/local/bin /data /data/media_store /data/jetstream /data/logs; \
    if [ -f /staging/usr/bin/dendrite-monolith-server ]; then \
      cp /staging/usr/bin/dendrite-monolith-server /usr/local/bin/dendrite; \
    elif [ -f /staging/usr/bin/dendrite ]; then \
      cp /staging/usr/bin/dendrite /usr/local/bin/dendrite; \
    elif [ -f /staging/usr/local/bin/dendrite-monolith-server ]; then \
      cp /staging/usr/local/bin/dendrite-monolith-server /usr/local/bin/dendrite; \
    elif [ -f /staging/out/dendrite-monolith-server ]; then \
      cp /staging/out/dendrite-monolith-server /usr/local/bin/dendrite; \
    else \
      echo "ERROR: dendrite binary not found in upstream image (checked several paths)" >&2; \
      echo "Staging contents (top-level):" >&2; ls -la /staging | sed -n '1,200p' >&2; \
      exit 1; \
    fi; \
    chmod +x /usr/local/bin/dendrite

# Copy run script and template (will be used by HA add-on)
COPY run.sh /run.sh
COPY dendrite.yaml.template /etc/dendrite/dendrite.yaml.template

RUN chmod +x /run.sh || true

WORKDIR /data

ENTRYPOINT [ "/run.sh" ]
CMD []

