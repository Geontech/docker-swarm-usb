# Docker Swarm USB

This repository contains scripts to enable USB permissions on a [Redhawk](https://redhawksdr.github.io/Documentation/) Docker Swarm container. It is intended to be a complement to the [docker-redhawk-swarm](https://github.com/Geontech/docker-redhawk-swarm) repository.

## Background

This package is a necessary workaround (*ahem* hack) because USB devices are not officially supported by a Docker Service. It is heavily based on user @brubbel's comment on this [issue](https://github.com/docker/swarmkit/issues/1244). This approach uses a system listener to wait for a specific Docker Container to be launched on the host. When the Container is detected based on the Docker Image name, a symlink to a USB device (created by UDEV rules) is read and the permissions for the device are forced into the Container's configuration file.

## Prerequisites

### Docker

For this guide, it is assumed that you are installing this package on an existing Unix-based Docker Swarm Node. If you haven't set up your Docker Swarm Node yet, see our guide [here](http://geontech.com/docker-redhawk-swarm/).

### Supported Hardware

The following devices have been tested with this package and [docker-redhawk-swarm](https://github.com/Geontech/docker-redhawk-swarm):
* USRP: Ettus b200 mini
* GPS: bu353s4
* RTLSDR: NooElec R820T

There are many other devices that are theoretically supported, including the Ettus USRP1, Ettus B100, and almost every variant of RTL SDR. Since these devices are untested, additional development could be required to get them working. Currently only one device per category (USRP, GPS, or RTLSDR) is supported for a single machine due to how the symlinks are created in the UDEV rules.

## Installing

Use the following command to install the package:

> Note: You will need administrative privileges to complete the install.

    $ make install

The following warning messages will appear after the installation is complete:

    A reboot is REQUIRED if you are planning on using the RTL SDR!!!

    Note: After a reboot, the RTL SDR will ONLY work with Docker!
          Uninstall this application and reboot to re-enable the local kernel modules.

These warning messages appear because the installation blacklists the kernel modules for the RTL SDR, meaning that your local installation of the RTL SDR libraries will no longer work. The RTL SDR will only work within the Docker container. The reboot is required to load in the `.conf` blacklist file, so if you don't have the RTL SDR kernel modules to begin with, then you don't need to reboot! You can check if you have these modules with the command `lsmod | grep rtl`.

## Running

Run the following command to get a list of steps to perform depending on the device you are enabling on this Docker Swarm Node:

    $ make info

The following message appears:

    Post Installation Steps:
     * To use the bu353s4 USB GPS with Docker Swarm, execute the following as root:
          /usr/local/bin/docker-swarm-listener /dev/usb_gps geontech/redhawk-bu353s4 &

     * To use the b200 USB USRP with Docker Swarm, execute the following as root:
          /usr/local/bin/docker-swarm-listener /dev/usb_usrp geontech/redhawk-usrp &

     * To use the rtl2832u USB SDR with Docker Swarm, execute the following as root:
          /usr/local/bin/docker-swarm-listener /dev/usb_rtlsdr geontech/redhawk-rtl2832u &

Follow these instructions and remember to `sudo su` before the command to run it as root! The `&` at the end of the command forces the process to the background. The `docker-swarm-listener` script is easily extended to be given any device symlink path with any image name. The format of the command is below:

    $ sudo su
    $ /usr/local/bin/docker-swarm-listener <device_symlink_path> <image_name> &

## Uninstalling

Use the following command to uninstall the package:

> Note: You will need administrative privileges to uninstall the package.

    $ make uninstall

Reminder: A reboot may be required to re-enable the RTL SDR kernel modules.

As always, [let us know](https://geontech.com/contact-us/) how we can help you with all your Redhawk and SDR needs!
