#!/bin/bash

set -e

mkdir /app
if [[ "$PHP_VERSION" =~ ^7.0 ]]; then
    addgroup -S app
    adduser \
        -S \
        -h /app \
        -s /bin/shell \
        app app
else
    addgroup --system app
    adduser \
        --system \
        --home /app \
        --shell /bin/shell \
        app app
fi

chown app:app /app
