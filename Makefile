include versions.mk

SRC := src

.PHONY: doctor fetch clean-src

doctor:
	@./scripts/doctor.sh

fetch: $(SRC)/linux-$(LINUX_VER) $(SRC)/buildroot-$(BUILDROOT_VER)

$(SRC)/linux-$(LINUX_VER):
	mkdir -p $(SRC)
	wget -c -O $(SRC)/linux.tar.xz $(LINUX_URL)
	tar -C $(SRC) -xf $(SRC)/linux.tar.xz
	rm $(SRC)/linux.tar.xz

$(SRC)/buildroot-$(BUILDROOT_VER):
	mkdir -p $(SRC)
	wget -c -O $(SRC)/buildroot.tar.gz $(BUILDROOT_URL)
	tar -C $(SRC) -xf $(SRC)/buildroot.tar.gz
	rm $(SRC)/buildroot.tar.gz

clean-src:
	rm -rf $(SRC)

KSRC := $(SRC)/linux-$(LINUX_VER)
BSRC := $(SRC)/buildroot-$(BUILDROOT_VER)
KOUT := out/linux
BOUT := out/buildroot
KMAKE := $(MAKE) -C $(KSRC) O=$(abspath $(KOUT)) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
CLEAN_PATH := $(shell echo "$$PATH" | tr ':' '\n' | grep -vxE '\.|' | paste -sd:)
BMAKE := env PATH="$(CLEAN_PATH)" $(MAKE) -C $(BSRC) O=$(abspath $(BOUT)) BR2_DL_DIR=$(abspath out/dl)

QEMU := qemu-system-aarch64 -M virt -cpu cortex-a72 -smp 2 -m 1G -nographic \
	-kernel $(KOUT)/arch/arm64/boot/Image \
	-initrd $(BOUT)/images/rootfs.cpio.gz \
	-append "console=ttyAMA0 earlycon"

.PHONY: kernel kernel-check rootfs run menuconfig

$(KOUT)/.config: configs/bsp.fragment
	mkdir -p $(KOUT)
	$(KMAKE) defconfig
	ARCH=arm64 $(KSRC)/scripts/kconfig/merge_config.sh -m -O $(abspath $(KOUT)) \
		$(abspath $(KOUT)/.config) $(abspath configs/bsp.fragment)
	$(KMAKE) olddefconfig

kernel: $(KOUT)/.config
	$(KMAKE) -j$$(nproc) Image modules dtbs
	@$(MAKE) --no-print-directory kernel-check

kernel-check:
	@grep -v '^#' configs/bsp.fragment | grep . | while read l; do \
		grep -qx "$$l" $(KOUT)/.config || echo "NOT APPLIED: $$l"; done; \
		echo "kernel-check done"

menuconfig: $(KOUT)/.config
	$(KMAKE) menuconfig

$(BOUT)/.config: configs/buildroot_defconfig
	mkdir -p $(BOUT)
	$(BMAKE) BR2_DEFCONFIG=$(abspath configs/buildroot_defconfig) defconfig

rootfs: $(BOUT)/.config
	$(BMAKE)

run:
	$(QEMU)
