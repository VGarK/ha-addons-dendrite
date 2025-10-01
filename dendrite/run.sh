#!/usr/bin/with-contenv bashio
set -euo pipefail

DATA_DIR=/data
CONFIG_FILE=${DATA_DIR}/dendrite.yaml
KEY_FILE=${DATA_DIR}/matrix_key.pem

mkdir -p "${DATA_DIR}"

SERVER_NAME=$(bashio::config 'server_name')
ENABLE_REG=$(bashio::config 'enable_registration')
REGSECRET=$(bashio::config 'registration_shared_secret')

bashio::log.info "Configuring Dendrite for server_name=${SERVER_NAME}"

if [ ! -f "${KEY_FILE}" ]; then
  bashio::log.info "Generating signing key..."
  /usr/bin/generate-keys -private-key "${KEY_FILE}"
fi

if [ ! -f "${CONFIG_FILE}" ]; then
  bashio::log.info "Creating config file..."
  sed -e "s|__SERVER_NAME__|${SERVER_NAME}|g" \
      -e "s|__PRIVATE_KEY_PATH__|${KEY_FILE}|g" \
      /etc/dendrite/dendrite.yaml.template > "${CONFIG_FILE}"

  if [ -n "${REGSECRET}" ]; then
    echo "  registration_shared_secret: \"${REGSECRET}\"" >> "${CONFIG_FILE}"
  fi
fi

exec /usr/bin/dendrite-monolith-server -config "${CONFIG_FILE}"
