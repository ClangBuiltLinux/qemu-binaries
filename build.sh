#!/usr/bin/env bash

BASE=$(dirname "$(readlink -f "${0}")")

# Make sure we have the required binaries
for NAME in podman docker; do
    command -v "${NAME}" &>/dev/null && BINARY=${NAME}
done
if [[ -z ${BINARY} ]]; then
    echo "Neither podman nor docker could be found on your system! Please install one to use this script."
    exit 1
fi

set -x

# Build the image that hosts all of the tools
"${BINARY}" build \
    --file Dockerfile \
    --tag qemu-binaries-builder

# Build QEMU in the container
"${BINARY}" run \
    --rm \
    --init \
    --volume="${BASE}:${BASE}" \
    --workdir="${BASE}" \
    qemu-binaries-builder \
    "${BASE}"/build-qemu.sh
