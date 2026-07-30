ARCHS = armv7 armv7s arm64

include $(THEOS)/makefiles/common.mk

TOOL_NAME = postinst prerm

postinst_FILES = pkg-actions.m
postinst_CFLAGS += -fobjc-arc -fvisibility=hidden -DPOSTINST
postinst_FRAMEWORKS = CoreFoundation
postinst_INSTALL_PATH = /DEBIAN
postinst_CODESIGN_FLAGS = -S../entitlements.plist

prerm_FILES = pkg-actions.m
prerm_CFLAGS += -fobjc-arc -fvisibility=hidden
prerm_FRAMEWORKS = CoreFoundation
prerm_INSTALL_PATH = /DEBIAN
prerm_CODESIGN_FLAGS = -S../entitlements.plist

include $(THEOS_MAKE_PATH)/tool.mk

# 修复 Roothide 架构下 DEBIAN 安装脚本被 dpkg 移动后，导致相对链接库失效的致命问题
after-stage::
	@-install_name_tool -change @loader_path/.jbroot/usr/lib/libroothide.dylib @loader_path/../../../usr/lib/libroothide.dylib $(THEOS_STAGING_DIR)/DEBIAN/postinst 2>/dev/null || true
	@-install_name_tool -change @loader_path/.jbroot/usr/lib/libroothide.dylib @loader_path/../../../usr/lib/libroothide.dylib $(THEOS_STAGING_DIR)/DEBIAN/prerm 2>/dev/null || true
