#!/usr/bin/with-contenv bashio
set -euo pipefail

DATA_DIR=/data
CONFIG_FILE=${DATA_DIR}/dendrite.yaml
KEY_FILE=${DATA_DIR}/matrix_key.pem
MEDIA_DIR=${DATA_DIR}/media_store
LOGS_DIR=${DATA_DIR}/logs

SERVER_NAME=$(bashio::config 'server_name')
ENABLE_REG=$(bashio::config 'enable_registration')
REGSECRET=$(bashio::config 'registration_shared_secret')

bashio::log.info "Dendrite add-on: initializing"

mkdir -p "${DATA_DIR}" "${MEDIA_DIR}" "${LOGS_DIR}"

# Generate signing key if missing (try bundled tool if present)
if [ ! -f "${KEY_FILE}" ]; then
  if command -v /usr/local/bin/generate-keys >/dev/null 2>&1; then
    bashio::log.info "Generating matrix signing key"
    /usr/local/bin/generate-keys -private-key "${KEY_FILE}"
  else
    bashio::log.warning "generate-keys tool not in image; you must supply matrix_key.pem in /config/dendrite or use create-account externally"
  fi
fi

# Create config from template if not present
if [ ! -f "${CONFIG_FILE}" ]; then
  bashio::log.info "Writing initial dendrite config to ${CONFIG_FILE}"
  mkdir -p "$(dirname "${CONFIG_FILE}")"
  cp /etc/dendrite/dendrite.yaml.template "${CONFIG_FILE}" || true
  sed -i "s|__SERVER_NAME__|${SERVER_NAME}|g" "${CONFIG_FILE}" || true
  sed -i "s|__PRIVATE_KEY_PATH__|${KEY_FILE}|g" "${CONFIG_FILE}" || true
  sed -i "s|__MEDIA_PATH__|${MEDIA_DIR}|g" "${CONFIG_FILE}" || true

  if [ "${ENABLE_REG}" = "true" ]; then
    sed -i "s/__REGISTRATION_DISABLED__/false/" "${CONFIG_FILE}" || true
  else
    sed -i "s/__REGISTRATION_DISABLED__/true/" "${CONFIG_FILE}" || true
  fi

  if [ -n "${REGSECRET}" ]; then
    awk -v secret="${REGSECRET}" '1; /client_api:/ && c==0 {print "  registration_shared_secret: \"" secret "\""; c=1}' "${CONFIG_FILE}" > "${CONFIG_FILE}.new" && mv "${CONFIG_FILE}.new" "${CONFIG_FILE}" || true
  fi
else
  bashio::log.info "Using existing config at ${CONFIG_FILE}"
fi

bashio::log.info "Starting Dendrite"
exec /usr/local/bin/dendrite -config "${CONFIG_FILE}" || exec /usr/local/bin/dendrite-monolith-server -config "${CONFIG_FILE}"
