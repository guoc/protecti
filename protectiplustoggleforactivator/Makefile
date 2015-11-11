ARCHS=armv7 arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = protectiplustoggleforactivator
protectiplustoggleforactivator_FILES = Tweak.xm
protectiplustoggleforactivator_LIBRARIES = activator
protectiplustoggleforactivator_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk
