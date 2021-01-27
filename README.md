## QEMU Binaries for testing the Linux kernel

This repository hosts copies of [QEMU](https://www.qemu.org/) that are used for [continuously testing](https://github.com/ClangBuiltLinux/continuous-integration2) Clang built Linux kernels.

Currently, this only hosts a copy of `qemu-system-s390x` (zstd compressed) that includes [the patchset to fix booting Clang built kernels](https://lore.kernel.org/qemu-devel/20210111163845.18148-1-david@redhat.com/). It was built in an Ubuntu 20.04 Docker image using `build.sh` and can be updated/rebuilt by just running that script. It is statically linked so it *should* work with any distribution but do not report any bugs if it does not. Just run the `build-qemu.sh` in your environment to generate a copy that you can use.

Generally, using this repo should not be necessary. The copies of QEMU available through your distribution are more than sufficient to test Clang built kernels (or you can [build QEMU from source](https://www.qemu.org/download/#source)). If you run into an issue, feel free to [open an issue](https://github.com/ClangBuiltLinux/linux/issues/new) so that it can be investigated.
