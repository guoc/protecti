include theos/makefiles/common.mk

TWEAK_NAME = protectiplustoggleforactivator
protectiplustoggleforactivator_FILES = Listener.xm
protectiplustoggleforactivator_LIBRARIES = activator

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	#PreferenceLoader plist
	$(ECHO_NOTHING)if [ -f Preferences.plist ]; then mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/protectiplustoggleforactivator; cp Preferences.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/protectiplustoggleforactivator/; fi$(ECHO_END)

after-install::
	install.exec "killall -9 SpringBoard"
