#!/usr/bin/env bash

#
# Node Docker Wrapper
#
# This wrapper allows Node binaries installed globally via npm to work when Node
# is only available through Docker. It intercepts Node calls and rewrites paths.
#
# Generated automatically by containers/node.nu - DO NOT EDIT manually
#

ARGS=()
CWD="$(pwd)"

for arg in "$@"; do
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

docker run --rm -it --network host \
    -v "{{HOME}}/.npm:/npm" \
    -e NPM_CONFIG_PREFIX=/npm \
    -e PATH=/npm/bin:/usr/local/bin:/usr/bin:/bin \
    -v "$(pwd):$(pwd)" \
    -v /etc/passwd:/etc/passwd:ro \
    -v /etc/group:/etc/group:ro \
    --user "$(id -u):$(id -g)" \
    -w "$(pwd)" \
    {{IMAGE}}:{{VERSION}} node "${ARGS[@]}"
