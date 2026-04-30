#!/usr/bin/env bash

#
# npm Docker Wrapper
#
# This wrapper allows npm to work through Docker, supporting global package
# installation and management.
#
# Generated automatically by containers/node.nu - DO NOT EDIT manually
#

# Detect if we have a TTY
if [ -t 0 ]; then
    TTY_FLAG="-it"
else
    TTY_FLAG="-i"
fi

# Get npm directories
NPM_HOME="{{HOME}}/.npm"
NPM_LIB="$NPM_HOME/lib"
NPM_BIN="$NPM_HOME/bin"

# Create directories if they don't exist
mkdir -p "$NPM_LIB" "$NPM_BIN" 2>/dev/null || true

# Run npm in Docker with proper configuration for global packages
docker run --rm $TTY_FLAG --network host \
    -v "$NPM_LIB:/npm/lib" \
    -v "$NPM_BIN:/npm/bin" \
    -e NPM_CONFIG_PREFIX=/npm \
    -e HOME=/tmp \
    -e PATH=/npm/bin:/usr/local/bin:/usr/bin:/bin \
    -v "$(pwd):$(pwd)" \
    -v /etc/passwd:/etc/passwd:ro \
    -v /etc/group:/etc/group:ro \
    --user "$(id -u):$(id -g)" \
    -w "$(pwd)" \
    {{IMAGE}}:{{VERSION}} npm "$@"
