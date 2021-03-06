export ARCHS=armv7 arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ProtectiPlus
ProtectiPlus_FILES = Tweak.xmi helpers.mm WelcomeAlertDelegate.m PIPreferences.m PasswordAlertDelegate.xm PIStatusBarIcon.m compatibility/ccquick.mm
#ProtectiPlus_CFLAGS = -Qunused-arguments
ProtectiPlus_FRAMEWORKS = UIKit AudioToolBox Security
ProtectiPlus_LIBRARIES = MobileGestalt cephei
ProtectiPlus_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += protectiplussettings
SUBPROJECTS += protectiplustoggleforactivator
SUBPROJECTS += protectiplustoggleforquickdo
SUBPROJECTS += protectiplusflipswitch
SUBPROJECTS += protectidap
include $(THEOS_MAKE_PATH)/aggregate.mk
