export ARCHS=armv7 arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ProtectiDAP
ProtectiDAP_FILES = Tweak.xm
ProtectiDAP_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
