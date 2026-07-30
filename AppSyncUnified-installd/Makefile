include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AppSyncUnified-installd

AppSyncUnified-installd_FILES = AppSyncUnified-installd.x dump.cpp cdhash.m
AppSyncUnified-installd_CFLAGS += -fvisibility=hidden -Wno-unused-private-field
# 添加 C++ 编译参数
AppSyncUnified-installd_CCFLAGS += -std=c++11 -stdlib=libc++
# 强制链接 libc++ 标准库
AppSyncUnified-installd_LDFLAGS += -lc++

AppSyncUnified-installd_LIBRARIES = substrate

include $(THEOS_MAKE_PATH)/tweak.mk
