#!/usr/bin/env bash

#
# PHP Docker Wrapper
#
# This wrapper allows PHP binaries installed globally via Composer to work when PHP
# is only available through Docker. It intercepts PHP calls and rewrites paths from
# the host filesystem to paths inside the container.
#
# When a PHP script with a shebang (#!/usr/bin/env php) is executed, the system
# passes the full host path to the interpreter. This wrapper converts those paths
# before passing them to PHP running inside Docker.
#
# Generated automatically by containers.nu - DO NOT EDIT manually
#

ARGS=()
CWD="$(pwd)"

for arg in "$@"; do
    # Rewrite Composer global binaries paths
    if [[ "$arg" == "{{HOME}}/.composer/"* ]]; then
        ARG=$(echo "$arg" | sed "s|{{HOME}}/.composer|/.composer|")
        ARGS+=("$ARG")
    # Rewrite absolute paths under current working directory to relative paths
    elif [[ "$arg" == "$CWD/"* ]]; then
        ARG=$(echo "$arg" | sed "s|^$CWD/|./|")
        ARGS+=("$ARG")
    else
        ARGS+=("$arg")
    fi
done

docker run --rm -it --network host \
    -v "{{HOME}}/.composer:/.composer" \
    -v "$(pwd):$(pwd)" \
    -v /etc/passwd:/etc/passwd:ro \
    -v /etc/group:/etc/group:ro \
    --user "$(id -u):$(id -g)" \
    -w "$(pwd)" \
    {{IMAGE}}:{{VERSION}} php "${ARGS[@]}"
