export ARCHS=armv7 arm64
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ProtectiPlusSettings
ProtectiPlusSettings_FILES = ProtectiPlusSettings.mm ../PIPreferences.m
ProtectiPlusSettings_INSTALL_PATH = /Library/PreferenceBundles
ProtectiPlusSettings_LIBRARIES = applist MobileGestalt cephei
ProtectiPlusSettings_FRAMEWORKS = UIKit Security
ProtectiPlusSettings_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ProtectiPlusSettings.plist$(ECHO_END)
