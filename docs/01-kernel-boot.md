# Stage 1: Kernel boot
- Kernel: 6.6.63, arm64 defconfig + configs/bsp.fragment
- Rootfs: Buildroot 2024.02.9, BusyBox, cpio.gz initramfs
- QEMU: virt, cortex-a72, 1G
## Boot log annotations
(earlycon, DT parse, initramfs unpack, init: fill in from out/boot.log)
## What broke first
(fill in)
