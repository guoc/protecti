export ARCHS=armv7 arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = protectiplustoggleforquickdo
protectiplustoggleforquickdo_FILES = Action.m
protectiplustoggleforquickdo_LIBRARIES = quickdo
protectiplustoggleforquickdo_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk
