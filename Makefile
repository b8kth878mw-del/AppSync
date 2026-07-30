export TARGET = iphone:clang:latest:5.0
export ARCHS = armv7 armv7s arm64 arm64e
export DEBUG = 0

THEOS_PACKAGE_DIR_NAME = debs
PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)

include $(THEOS)/makefiles/common.mk

SUBPROJECTS += AppSyncUnified-installd
SUBPROJECTS += AppSyncUnified-FrontBoard
SUBPROJECTS += pkg-actions
SUBPROJECTS += asu_inject

include $(THEOS_MAKE_PATH)/aggregate.mk

# 在打成 deb 包的最后一刻，修正 Roothide 专属的相对路径问题，并重新进行 ldid 签名
before-package::
	@echo "==> Fixing Roothide paths for DEBIAN scripts to prevent dpkg crash..."
	@-install_name_tool -change @loader_path/.jbroot/usr/lib/libroothide.dylib @loader_path/../../../usr/lib/libroothide.dylib $(THEOS_STAGING_DIR)/DEBIAN/postinst 2>/dev/null || true
	@-install_name_tool -change @loader_path/.jbroot/usr/lib/libroothide.dylib @loader_path/../../../usr/lib/libroothide.dylib $(THEOS_STAGING_DIR)/DEBIAN/prerm 2>/dev/null || true
	@-ldid -S$(THEOS_PROJECT_DIR)/entitlements.plist $(THEOS_STAGING_DIR)/DEBIAN/postinst 2>/dev/null || true
	@-ldid -S$(THEOS_PROJECT_DIR)/entitlements.plist $(THEOS_STAGING_DIR)/DEBIAN/prerm 2>/dev/null || true

package::
ifndef THEOS_PACKAGE_SCHEME
	@$(_THEOS_PLATFORM_DPKG_DEB) -b -Zgzip "transitional/nodelete-net.angelxwind.appsyncunified" "$(THEOS_PACKAGE_DIR_NAME)/nodelete-net.angelxwind.appsyncunified.deb"
	@$(_THEOS_PLATFORM_DPKG_DEB) -b -Zgzip "transitional/nodelete-net.angelxwind.appsync70plus" "$(THEOS_PACKAGE_DIR_NAME)/nodelete-net.angelxwind.appsync70plus.deb"
	@$(_THEOS_PLATFORM_DPKG_DEB) -b -Zgzip "transitional/nodelete-net.angelxwind.appsync60plus" "$(THEOS_PACKAGE_DIR_NAME)/nodelete-net.angelxwind.appsync60plus.deb"
	@$(_THEOS_PLATFORM_DPKG_DEB) -b -Zgzip "transitional/nodelete-net.angelxwind.appsync50plus" "$(THEOS_PACKAGE_DIR_NAME)/nodelete-net.angelxwind.appsync50plus.deb"
endif

after-install::
	install.exec "killall backboardd; exit 0" # backboardd doesn't exist on iOS 5, but that's fine since… FrontBoard also doesn't exist on iOS 5. ;P
