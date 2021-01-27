#!/usr/bin/env bash

BASE=$(dirname "$(readlink -f "${0}")")

set -x

QEMU_TARGETS=( s390x-softmmu )

function upd_qemu() {
    QEMU_SRC=${BASE}/src
    [[ -d ${QEMU_SRC} ]] || git clone https://gitlab.com/qemu-project/qemu.git "${QEMU_SRC}"
    cd "${QEMU_SRC}" || exit ${?}
    git pull --rebase
    git submodule update --init --recursive
}

function bld_qemu() {
    QEMU_BLD=${BASE}/build

    rm -rf "${QEMU_BLD}" &&
        mkdir -p "${QEMU_BLD}" &&
        cd "${QEMU_BLD}" || exit ${?}

    "${QEMU_SRC}"/configure \
        --disable-curl \
        --static \
        --target-list="${QEMU_TARGETS[*]}" || exit ${?}

    ninja || exit ${?}
}

function gather_files() {
    BIN=${BASE}/bin
    SHARE_QEMU=${BASE}/share/qemu
    mkdir -p "${BIN}" "${SHARE_QEMU}"

    for QEMU_TARGET in "${QEMU_TARGETS[@]}"; do
        QEMU_BINARY=${BIN}/qemu-system-${QEMU_TARGET%%-*}

        # Move the binary from the build folder to the bin folder
        cp -v "${QEMU_BLD}/${QEMU_BINARY##*/}" "${QEMU_BINARY}"

        # Strip and compress the binary so that it is not so large in git
        strip --strip-unneeded "${QEMU_BINARY}"
        zstd -19 -f -o "${QEMU_BINARY}".zst --rm "${QEMU_BINARY}"

        # Move any necessary firmware
        case ${QEMU_TARGET} in
            s390x-softmmu) cp -v "${QEMU_BLD}"/pc-bios/s390-ccw.img "${SHARE_QEMU}" ;;
        esac
    done
}

upd_qemu
bld_qemu
gather_files
