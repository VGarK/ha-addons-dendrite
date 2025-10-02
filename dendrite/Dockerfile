# Use the official Dendrite image as base (wrapper)
FROM matrixdotorg/dendrite:v0.15.2

# Create data directories (for persistence)
RUN mkdir -p /data /data/jetstream /data/media_store /data/logs

# Copy run script
COPY run.sh /run.sh
RUN chmod +x /run.sh

WORKDIR /data

# Use run.sh as entrypoint
ENTRYPOINT ["/run.sh"]
