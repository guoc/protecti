export ARCHS=armv7 arm64

include theos/makefiles/common.mk

TWEAK_NAME = ProtectiPlus
ProtectiPlus_FILES = Tweak.xm WelcomeAlertDelegate.m
#ProtectiPlus_CFLAGS = -Qunused-arguments
ProtectiPlus_FRAMEWORKS = UIKit AudioToolBox

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += protectiplussettings
SUBPROJECTS += protectiplustoggleforactivator
SUBPROJECTS += protectiplusflipswitch
SUBPROJECTS += protectidap
include $(THEOS_MAKE_PATH)/aggregate.mk
