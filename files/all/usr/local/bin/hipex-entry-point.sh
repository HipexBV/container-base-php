#!/usr/bin/env bash

set -e

function envreplace() {
    TEMPLATE_FILE=$1
    FILE="${TEMPLATE_FILE%.*}"
    echo "Replacing hipex template ${TEMPLATE_FILE} to ${FILE}"
    envsubst < "${TEMPLATE_FILE}" > "${FILE}"
}

export -f envreplace
find /app -xdev -name \*.hipextemplate -exec bash -c 'envreplace "$0"' {} \; || true

echo "Finished env replace, continue startup."

# first arg is `-f` or `--some-option`
if [ -z "${1#-}" ]; then
    if command -v php-fpm; then
        set -- php-fpm
    else
        set -- php -a
    fi
fi

exec docker-php-entrypoint "$@"
