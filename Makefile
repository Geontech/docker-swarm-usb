PREFIX = /usr/local

.PHONY: info install uninstall

info:
	@echo
	@echo "Usage: make [install | uninstall]"
	@echo
	@echo "Post Installation Steps:"
	@echo " * To use the bu353s4 USB GPS with Docker Swarm, execute the following as root:"
	@echo "      $(DESTDIR)$(PREFIX)/bin/docker-swarm-listener /dev/usb_gps geontech/redhawk-bu353s4 &"
	@echo
	@echo " * To use the b200 USB USRP with Docker Swarm, execute the following as root:"
	@echo "      $(DESTDIR)$(PREFIX)/bin/docker-swarm-listener /dev/usb_usrp geontech/redhawk-usrp &"
	@echo
	@echo " * To use the rtl2832u USB SDR with Docker Swarm, execute the following as root:"
	@echo "      $(DESTDIR)$(PREFIX)/bin/docker-swarm-listener /dev/usb_rtlsdr geontech/redhawk-rtl2832u &"
	@echo

install:
	sudo cp ./blacklist-rtlsdr.conf $(DESTDIR)/etc/modprobe.d/blacklist-rtlsdr.conf
	sudo cp ./docker-swarm-listener $(DESTDIR)$(PREFIX)/bin/docker-swarm-listener
	sudo cp ./docker-swarm-enable-usb $(DESTDIR)$(PREFIX)/bin/docker-swarm-enable-usb
	sudo cp ./redhawk-usb.rules $(DESTDIR)/etc/udev/rules.d/redhawk-usb.rules
	sudo udevadm control --reload-rules
	sudo udevadm trigger
	@echo
	@echo "A reboot is REQUIRED if you are planning on using the RTL SDR!!!"
	@echo
	@echo "Note: After a reboot, the RTL SDR will ONLY work with Docker!"
	@echo "      Uninstall this application and reboot to re-enable the local kernel modules."
	@echo 

uninstall:
	sudo rm $(DESTDIR)/etc/modprobe.d/blacklist-rtlsdr.conf
	sudo rm $(DESTDIR)$(PREFIX)/bin/docker-swarm-listener
	sudo rm $(DESTDIR)$(PREFIX)/bin/docker-swarm-enable-usb
	sudo rm $(DESTDIR)/etc/udev/rules.d/redhawk-usb.rules
	sudo udevadm control --reload-rules
	sudo udevadm trigger
