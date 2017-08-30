PREFIX = /usr/local

.PHONY: all install uninstall

all:
	@echo "Nothing to make. Use make install or make uninstall."

install:
	sudo cp ./docker-swarm-listener $(DESTDIR)$(PREFIX)/bin/docker-swarm-listener
	sudo cp ./docker-swarm-enable-usb $(DESTDIR)$(PREFIX)/bin/docker-swarm-enable-usb
	sudo cp ./redhawk-usb.rules $(DESTDIR)/etc/udev/rules.d/redhawk-usb.rules
	sudo udevadm control --reload-rules
	sudo udevadm trigger
	@echo "You may now execute one of the the following commands as root:"
	@echo "  $(DESTDIR)$(PREFIX)/bin/docker-swarm-listener /dev/usb_gps    geontech/redhawk-bu353s4  &"
	@echo "  $(DESTDIR)$(PREFIX)/bin/docker-swarm-listener /dev/usb_usrp   geontech/redhawk-usrp     &"
	@echo "  $(DESTDIR)$(PREFIX)/bin/docker-swarm-listener /dev/usb_rtlsdr geontech/redhawk-rtl2832u &"

uninstall:
	sudo rm $(DESTDIR)$(PREFIX)/bin/docker-swarm-listener
	sudo rm $(DESTDIR)$(PREFIX)/bin/docker-swarm-enable-usb
	sudo rm $(DESTDIR)/etc/udev/rules.d/redhawk-usb.rules
	sudo udevadm control --reload-rules
	sudo udevadm trigger
