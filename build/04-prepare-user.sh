#!/bin/bash

set -e

mkdir /app
addgroup --system app
adduser \
    --system \
    --home /app \
    --shell /bin/shell \
    app app

chown app:app /app
