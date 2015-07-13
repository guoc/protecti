export ARCHS=armv7 arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ProtectiPlus
ProtectiPlus_FILES = Tweak.xmi WelcomeAlertDelegate.m PIPreferences.m PasswordAlertDelegate.xm PIStatusBarIcon.m
#ProtectiPlus_CFLAGS = -Qunused-arguments
ProtectiPlus_FRAMEWORKS = UIKit AudioToolBox Security
ProtectiPlus_LIBRARIES = MobileGestalt cephei

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += protectiplussettings
SUBPROJECTS += protectiplustoggleforactivator
SUBPROJECTS += protectiplustoggleforquickdo
SUBPROJECTS += protectiplusflipswitch
SUBPROJECTS += protectidap
include $(THEOS_MAKE_PATH)/aggregate.mk
