#!/bin/bash

set -e

mkdir /app
addgroup -S app -g 5000
adduser \
    -S \
    -h /app \
    -s /bin/shell \
    -u 5000 \
    app app

chown app:app /app
