#!/usr/bin/with-contenv bashio
set -euo pipefail

CONFIG_FILE=/data/dendrite.yaml
KEY_FILE=/data/matrix_key.pem
MEDIA_PATH=/data/media_store
LOGS_PATH=/data/logs

SERVER_NAME=$(bashio::config 'server_name')
ENABLE_REG=$(bashio::config 'enable_registration')
REGSECRET=$(bashio::config 'registration_shared_secret')

bashio::log.info "Initializing Dendrite config"

# Create signing key if missing
if [ ! -f "${KEY_FILE}" ]; then
  bashio::log.info "Generating signing key..."
  /usr/local/bin/generate-keys -private-key "${KEY_FILE}"
fi

# If config file not present, create from template
if [ ! -f "${CONFIG_FILE}" ]; then
  bashio::log.info "Writing template config to ${CONFIG_FILE}"
  cp /etc/dendrite/dendrite.yaml.template "${CONFIG_FILE}"
  sed -i "s|__SERVER_NAME__|${SERVER_NAME}|g" "${CONFIG_FILE}"
  sed -i "s|__PRIVATE_KEY_PATH__|${KEY_FILE}|g" "${CONFIG_FILE}"
  sed -i "s|__MEDIA_PATH__|${MEDIA_PATH}|g" "${CONFIG_FILE}"

  # registration toggle
  if [ "${ENABLE_REG}" = "true" ]; then
    sed -i "s/__REGISTRATION_DISABLED__/false/" "${CONFIG_FILE}"
  else
    sed -i "s/__REGISTRATION_DISABLED__/true/" "${CONFIG_FILE}"
  fi

  # registration_shared_secret if set
  if [ -n "${REGSECRET}" ]; then
    awk -v secret="${REGSECRET}" '1; /client_api:/ && c==0 {print "  registration_shared_secret: \"" secret "\""; c=1}' \
      "${CONFIG_FILE}" > "${CONFIG_FILE}.new"
    mv "${CONFIG_FILE}.new" "${CONFIG_FILE}"
  fi
else
  bashio::log.info "Config already exists at ${CONFIG_FILE}"
fi

bashio::log.info "Starting Dendrite server"
exec /usr/local/bin/dendrite-monolith-server -config "${CONFIG_FILE}"
