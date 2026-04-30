#!/usr/bin/env bash

#
# Node Docker Wrapper
#
# This wrapper allows Node binaries installed globally via npm to work when Node
# is only available through Docker. It intelligently falls back to system Node
# for files that wouldn't work in the container (like Mason LSP servers).
#
# Generated automatically by containers/node.nu - DO NOT EDIT manually
#

ARGS=()
CWD="$(pwd)"
USE_DOCKER=true

for arg in "$@"; do
    # Check if we're trying to run a file outside of mounted directories
    # (Mason files, other local files that wouldn't exist in container)
    if [[ "$arg" == /* ]] && [[ -f "$arg" ]]; then
        # This is an absolute path to an existing file
        # Check if it's in a directory that would be mounted in the container
        if [[ "$arg" != "{{HOME}}/.npm/"* ]] && [[ "$arg" != "$CWD"/* ]]; then
            # File exists but won't be accessible in container -> use system node
            USE_DOCKER=false
        fi
    fi

    # Rewrite npm global binaries paths
    if [[ "$arg" == "{{HOME}}/.npm/"* ]]; then
        ARG=$(echo "$arg" | sed "s|{{HOME}}/.npm|/npm|")
        ARGS+=("$ARG")
    # Rewrite absolute paths under CWD to relative paths
    elif [[ "$arg" == "$CWD/"* ]]; then
        ARG=$(echo "$arg" | sed "s|^$CWD/|./|")
        ARGS+=("$ARG")
    else
        ARGS+=("$arg")
    fi
done

if [ "$USE_DOCKER" = true ]; then
    # Detect if we have a TTY
    if [ -t 0 ]; then
        TTY_FLAG="-it"
    else
        TTY_FLAG="-i"
    fi

    docker run --rm $TTY_FLAG --network host \
        -v "{{HOME}}/.npm:/npm" \
        -e NPM_CONFIG_PREFIX=/npm \
        -e PATH=/npm/bin:/usr/local/bin:/usr/bin:/bin \
        -v "$(pwd):$(pwd)" \
        -v /etc/passwd:/etc/passwd:ro \
        -v /etc/group:/etc/group:ro \
        --user "$(id -u):$(id -g)" \
        -w "$(pwd)" \
        {{IMAGE}}:{{VERSION}} node "${ARGS[@]}"
else
    # Fall back to system Node.js
    exec /usr/bin/node "$@"
fi
