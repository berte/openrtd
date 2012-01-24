#############################################################
#
# transmission
#
#############################################################
TRANSMISSION_VERSION = 2.33
TRANSMISSION_SITE = http://download.transmissionbt.com/files/
TRANSMISSION_SOURCE = transmission-$(TRANSMISSION_VERSION).tar.bz2
TRANSMISSION_DEPENDENCIES = \
	host-pkg-config \
	libcurl \
	libevent \
	openssl \
	zlib

TRANSMISSION_CONF_OPT = \
	--disable-libnotify \
	--enable-lightweight
TRANSMISSION_CONF_ENV = \
	CFLAGS+="-I$(TARGET_DIR)/usr/include" \
	LDFLAGS+="-L$(TARGET_DIR)/usr/lib"	

define TRANSMISSION_INIT_SCRIPT_INSTALL_ORIGINAL
	[ -f $(TARGET_DIR)/etc/init.d/S92transmission ] || \
		$(INSTALL) -m 0755 -D package/transmission/S92transmission \
			$(TARGET_DIR)/etc/init.d/S92transmission
endef

define TRANSMISSION_INIT_SCRIPT_INSTALL_OPENRTD
	[ -f $(TARGET_DIR)/etc/init.d/S90transmission ] || \
		$(INSTALL) -m 0755 -D package/transmission/S90transmission \
			$(TARGET_DIR)/etc/init.d/S90transmission
endef


ifeq ($(BR2_PACKAGE_TRANSMISSION_UTP),y)
	TRANSMISSION_CONF_OPT += --enable-utp
else
	TRANSMISSION_CONF_OPT += --disable-utp
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_CLI),y)
	TRANSMISSION_CONF_OPT += --enable-cli
else
	TRANSMISSION_CONF_OPT += --disable-cli
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_DAEMON),y)
	TRANSMISSION_CONF_OPT += --enable-daemon
ifeq ($(BR2_PACKAGE_TRANSMISSION_DAEMON_ORIGINAL_STARTUP_SCRIPT),y)
	TRANSMISSION_POST_INSTALL_TARGET_HOOKS += TRANSMISSION_INIT_SCRIPT_INSTALL_ORIGINAL
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_DAEMON_OPENRTD_STARTUP_SCRIPT),y)
	TRANSMISSION_POST_INSTALL_TARGET_HOOKS += TRANSMISSION_INIT_SCRIPT_INSTALL_OPENRTD
endif

else
	TRANSMISSION_CONF_OPT += --disable-daemon
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_REMOTE),y)
	TRANSMISSION_CONF_OPT += --enable-remote
else
	TRANSMISSION_CONF_OPT += --disable-remote
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_GTK),y)
	TRANSMISSION_CONF_OPT += --enable-gtk
	TRANSMISSION_DEPENDENCIES += libgtk2
else
	TRANSMISSION_CONF_OPT += --disable-gtk
endif

$(eval $(call AUTOTARGETS))
