export ARCHS=armv7 arm64
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ProtectiPlusFlipSwitch
ProtectiPlusFlipSwitch_FILES = Switch.x
ProtectiPlusFlipSwitch_FRAMEWORKS = UIKit
ProtectiPlusFlipSwitch_LIBRARIES = flipswitch
ProtectiPlusFlipSwitch_INSTALL_PATH = /Library/Switches
ProtectiPlusFlipSwitch_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/bundle.mk
