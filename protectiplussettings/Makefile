export ARCHS=armv7 arm64
include theos/makefiles/common.mk

BUNDLE_NAME = ProtectiPlusSettings
ProtectiPlusSettings_FILES = ProtectiPlusSettings.mm NSData+Base64.m NSString+Base64.m RSA.m PICheck.m
ProtectiPlusSettings_INSTALL_PATH = /Library/PreferenceBundles
#ProtectiPlusSettings_LIBRARIES = applist
ProtectiPlusSettings_FRAMEWORKS = UIKit Security
ProtectiPlusSettings_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ProtectiPlusSettings.plist$(ECHO_END)
