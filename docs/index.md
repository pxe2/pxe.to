# pxe.to 
[![Build Status](https://travis-ci.org/pxe2/pxe.to.svg?branch=master)](https://travis-ci.org/pxe2/pxe.to)

![pxe.to menu](img/pxe.to.gif)

### Bootloader Downloads

These iPXE disks will automatically load into [boot.pxe.to](https://boot.pxe.to):

| Type | Bootloader | Description |
|------|------------|-------------|
|ISO (Legacy)| [pxe.to.iso](https://boot.pxe.to/ipxe/pxe.to.iso)| Used for CD/DVD, Virtual CDs like DRAC/iLO, VMware, Virtual Box (Legacy) |
|ISO (EFI)|[pxe.to-efi.iso](https://boot.pxe.to/ipxe/pxe.to-efi.iso)| Same as ISO (Legacy) but used for EFI BIOS, works in Virtual Box EFI mode |
|Floppy| [pxe.to.dsk](https://boot.pxe.to/ipxe/pxe.to.dsk)| Used for 1.44 MB floppies, Virtual floppies like DRAC/iLO, VMware, Virtual Box|
|USB| [pxe.to.usb](https://boot.pxe.to/ipxe/pxe.to.usb)| Used for creation of USB Keys|
|Kernel| [pxe.to.lkrn](https://boot.pxe.to/ipxe/pxe.to.lkrn)| Used for booting from GRUB/EXTLINUX|
|DHCP| [pxe.to.kpxe](https://boot.pxe.to/ipxe/pxe.to.kpxe)| DHCP boot image file, uses built-in iPXE NIC drivers|
|DHCP-undionly| [pxe.to-undionly.kpxe](https://boot.pxe.to/ipxe/pxe.to-undionly.kpxe)| DHCP boot image file, use if you have NIC issues|
|EFI| [pxe.to.efi](https://boot.pxe.to/ipxe/pxe.to.efi)| EFI boot image file|

SHA256 checksums are generated during each build of iPXE and are located [here](https://boot.pxe.to/ipxe/pxe.to-sha256-checksums.txt).  You can also view the scripts that are embedded into the images [here](https://github.com/pxe2/pxe.to/tree/master/ipxe/disks).

### What is pxe.to?

[pxe.to](http://pxe.to) is a way to select various operating system installers or utilities from one place within the BIOS without the need of having to go retrieve the media to run the tool.  [iPXE](http://ipxe.org/) is used to provide a user friendly menu from within the BIOS that lets you easily choose the operating system you want along with any specific types of versions or bootable flags.

You can remote attach the ISO to servers, set it up as a rescue option in Grub, or even set up your home network to boot to it by default so that it's always available.

### Getting started

Download the bootloader of your choice from the links above and add it to your favorite virtualization tool to start testing out pxe.to.  These are precompiled versions of the latest version of [iPXE](https://github.com/ipxe/ipxe) that will chainload you to [https://boot.pxe.to](https://boot.pxe.to).  If you have DHCP it'll automatically attempt to boot from DHCP.  If you need to set a static IP address, hit the 'm' key during boot up for the failsafe menu and choose manual network configuration.

If you already have iPXE up and running on the network, you can hit pxe.to at anytime by typing:

    chain --autofree https://boot.pxe.to

You'll need to make sure to have [DOWNLOAD_PROTO_HTTPS](https://github.com/ipxe/ipxe/blob/master/src/config/general.h#L57) enabled when compiling iPXE.

### Operating Systems

#### What Operating Systems are currently available on pxe.to?

* [Alpine Linux](https://alpinelinux.org)
* [Antergos](https://antergos.com)
* [Arch Linux](https://www.archlinux.org)
* [CentOS](https://centos.org)
* [CoreOS Container Linux](https://coreos.com/)
* [Debian](https://debian.org)
* [Devuan](https://devuan.org)
* [Fedora](https://fedoraproject.org)
* [FreeBSD](https://freebsd.org)
* [FreeDOS](http://www.freedos.org)
* [Gentoo](https://gentoo.org)
* [IPFire](https://www.ipfire.org)
* [Mageia](http://www.mageia.org)
* [Manjaro Linux](https://manjaro.github.io)
* [Microsoft Windows](https://www.microsoft.com)
* [MirOS](https://www.mirbsd.org)
* [OpenBSD](http://openbsd.org)
* [OpenSUSE](http://opensuse.org)
* [RancherOS](http://rancher.com/rancher-os/)
* [Red Hat Enterprise Linux](https://www.redhat.com/)
* [Scientific Linux](http://scientificlinux.org)
* [Tiny Core Linux](http://tinycorelinux.net)
* [Ubuntu](http://www.ubuntu.com/)

#### Hypervisors

* [Citrix XenServer](http://xenserver.org)

#### Security Related

* [BlackArch Linux](https://blackarch.org)
* [Kali Linux](https://www.kali.org)
* [Parrot Security](https://www.parrotsec.org)

#### Utilities

* [ALT Linux Rescue](https://en.altlinux.org/Rescue)
* [AVG Rescue CD](http://www.avg.com/us-en/avg-rescue-cd)
* [Breakin](http://www.advancedclustering.com/products/software/breakin/)
* [Clonezilla](http://www.clonezilla.org/)
* [DBAN](http://www.dban.org/)
* [GParted](http://gparted.org)
* [Grml](http://grml.org)
* [Memtest](http://www.memtest.org/)
* [Partition Wizard](http://www.partitionwizard.com)
* [Pogostick - Offline Windows Password and Registry Editor](http://pogostick.net/~pnh/ntpasswd)
* [Super Grub2 Disk](http://www.supergrubdisk.org)
* [SystemRescueCD](https://www.system-rescue-cd.org)
* [Ultimate Boot CD](http://www.ultimatebootcd.com)

### Source Code

The source code for pxe.to is located [here](https://github.com/pxe2/pxe.to).

### Contributing

New version of an operating system out?  Found one that network boots well with iPXE?  Pull requests are welcomed and encouraged and helps me out a ton!  Feel free to issue a pull request for new versions or tools that you might find useful.  Once merged into master, [Travis CI](https://travis-ci.org/pxe2/pxe.to) will regenerate new versions of [iPXE from upstream](https://github.com/ipxe/ipxe) and deploy the latest changes to pxe.to.  See more on contributing [here](https://pxe.to/contributing).

### Testing New Branches

Under the **Utilities** menu on pxe.to, there's an option for ["Test pxe.to branch"](https://github.com/pxe2/pxe.to/blob/master/src/utils.ipxe#L157).  If you've forked the code and have developed a new feature branch, you can use this option to chainload into that branch to test and validate the code.  All you need to do is specify your Github user name and the name of your branch or abbreviated hash of the commit. Also, disable the signature verification for *pxe.to* under **Signatures Checks**.

### Feedback

Feel free to open up an [issue](https://github.com/pxe2/pxe.to/issues) on Github, swing by [Freenode IRC](http://freenode.net/) in the [#pxe2](http://webchat.freenode.net/?channels=#pxe2) channel, or ping us on [Gitter](https://gitter.im/pxe2/pxe.to?utm_source=share-link&utm_medium=link&utm_campaign=share-link).  Follow us on [Twitter](https://twitter.com/pxe2) or like us on [Facebook](https://www.facebook.com/pxe2)!
