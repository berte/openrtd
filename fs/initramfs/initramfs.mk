#############################################################
#
# Make a initramfs_list file to be used by gen_init_cpio
# gen_init_cpio is part of the 2.6 linux kernels to build an
# initial ramdisk filesystem based on cpio
#
#############################################################

define ROOTFS_INITRAMFS_INIT_SYMLINK
	rm -f $(TARGET_DIR)/init
	ln -s sbin/init $(TARGET_DIR)/init
endef

define ROOTFS_INITRAMFS_CMD
	$(SHELL) fs/initramfs/gen_initramfs_list.sh -u 0 -g 0 $(TARGET_DIR) > $$@
endef

$(eval $(call ROOTFS_TARGET,initramfs))