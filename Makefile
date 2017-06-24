#export THEOS_DEVICE_IP=localhost
#export THEOS_DEVICE_PORT=2222
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = traffic
traffic_FILES = Tweak.xm RAFFAppServer.m RAFFMultiView.m RAFFCardView.m
traffic_FRAMEWORKS = UIKit CoreGraphics
traffic_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
