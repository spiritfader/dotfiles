# Arch Linux Installation Guide

## Table of contents

- [Pre-Installation](#pre-installation)
  - [Set Console Keyboard & Font](#set-the-console-keyboard-layout-and-font-if-necessary)
  - [Verify Boot Mode](#verify-boot-mode)
  - [Connect to Network](#connect-to-network)
  - [Check system time](#check-the-system-clock)
- [Main Installation](#main-installation)
  - [Partition the disks](#partition-the-disks)
  - [Format the partitions](#format-the-partitions)
  - [Mount the filesystem](#mount-the-file-system)
  - [Bootstrap Packages](#package-bootstrap)
  - [Generate Fstab](#generate-fstab)
  - [Chroot into our Install](#chroot-into-our-new-install)
  - [Set time zone](#set-time-zone)
  - [Set language and TTY keyboard map](#set-language-and-tty-keymap)
  - [Set hostname and edit hosts file](#set-hostname-and-hosts-file)
  - [Create Users](#create-users)
  - [Bootloader configuration](#bootloader-configuration)
  - [Configure services](#enabledisable-services)
  - [Setup swap](#setup-swap)
  - [Unmount and reboot](#unmount-and-reboot)
- [Post-Installation](#post-installation)
  - [Install an Aur Helper](#aur-helper)

# Pre-Installation
## Set the console keyboard layout and font (if necessary)

If you do not wish to use the default US keymap, set the keymap for your environment accordingly 


- List available keymaps
```Zsh
localectl list-keymaps
```

- Set available keymaps, example 'de-latin1' keymap
```Zsh

loadkeys de-latin1
```

<br>

If you need to set a particular console font, for example a HiDPI font


- Show available fonts
```Zsh
ls /usr/share/kbd/consolefonts/
```
- Set the font omitting path and file extension
```Zsh
setfont ter-132b
```
<br>

## Verify boot mode
- If output is 64, system booted in UEFI mode with a 64-bit x64 UEFI.
- If output is 32, system booted in UEFI mode with a 32-bit IA32 UEFI.
- If the file doesn't exist, the system may be booted in BIOS (or CSM) mode.
```Zsh
cat /sys/firmware/efi/fw_platform_size
```
<br>


## Connect to network
<br>

###  *Ethernet*
```Zsh
Plug in your ethernet cable
```
<br>

### *Wi-Fi*

- Get name of wireless nic
```Zsh
ip link
```
<br> 

- Connect to unprotected Wi-Fi network (replace ``$INTERFACE`` with nic name, and ``$SSID`` with your wireless network name)
```Zsh
iwctl station $INTERFACE connect $SSID
```
<br>

- Connect to password protected Wi-Fi network (replace ``$INTERFACE`` with nic name, ``$PASSPHRASE`` with your ``$SSID`` password, and ``$SSID`` with your wireless network name)
```Zsh
iwctl --passphrase $PASSPHRASE station $INTERFACE connect $SSID
```
<br>

### *Modem*

- Use mmcli to list available modems 
- Take note of ``/org/freedesktop/ModemManager1/Modem/$MODEM_INDEX``
```Zsh
mmcli -L
```
<br>

- Connect to the unprotected modem network, replacing ``$MODEM_INDEX`` from above
- Replace ``internet.myisp.example`` with your ISP's provided APN
```Zsh
mmcli -m $MODEM_INDEX --simple-connect="apn=internet.myisp.example"
```
<br>

- Connect to the protected modem network, replacing ``$MODEM_INDEX`` from above
- Replace ``internet.myisp.example`` with your ISP's provided APN
```Zsh
mmcli -m $MODEM_INDEX --simple-connect="apn=internet.myisp.example,user=user_name,password=password"
```
<br>

- Verify connection using Ping

```Zsh
ping -c 5 archlinux.org 
```

<br>

## Check the system clock

<br>

- Check if ntp is active and if the time is right
```Zsh
timedatectl
```

<br>

# Main installation

## Partition the disks

- List and check drives names to determine the drive you wish to use.
```Zsh
fdisk -l
```
<br>

- Run ``cfdisk`` to partition your disk while starting with a zeroed partition table.
```Zsh
cfdisk -z /dev/nvme0n1
```
<br>

- Select ``GPT`` when prompted. 


- We will be making two partitions that look as follows.  

| Number | Type | Size | Mount |
| --- | --- | --- | --- |
| 1 | EFI | 1024 MB | /boot |
| 2 | Linux Filesystem | Remaining Space | / |  

<br>

- Once finished, select ``write`` with your arrow keys, hit enter, and type ``yes``. Then highlight ``quit`` and hit enter.

## Format the partitions

- Find the EFI partition you created with ``fdisk -l`` or ``lsblk``, then format it as a FAT32 filesystem.
```Zsh
mkfs.fat -F 32 /dev/nvme0n1p1
```
<br>

- Find the root partition you created with ``fdisk -l`` or ``lsblk``, then format it as a BTRFS filesystem.
```Zsh
mkfs.btrfs /dev/nvme0n1p2
```
<br>


## Mount the file system


- Mount the root partition to prepare the btrfs subvolumes
```Zsh
mount /dev/nvme0n1p2 /mnt
```

<br>

- Use a **flat** subvolume layout in the creation of your subvolumes. More info from [sysadmin guide](https://archive.kernel.org/oldwiki/btrfs.wiki.kernel.org/index.php/SysadminGuide.html#Layout)


```Zsh
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
```
<br>

- Unmount the root partition so you can remount with btrfs mount options
```Zsh
umount /mnt
```

<br>

- Remount the root and home subvolume while setting mount options to compress and define subvol location
```Zsh
mount -o compress=zstd,subvol=@ /dev/nvme0n1p2 /mnt
mkdir -p /mnt/home
mount -o compress=zstd,subvol=@home /dev/nvme0n1p2 /mnt/home
```

<br>

- Create the ``/boot`` directory and mount your EFI partition there 

```Zsh
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

<br>

## Package bootstrap  

- Install packages to the root mountpoint thus, bootstrapping the new install and using -K switch to initialize a new pacman keyring. 
- Append any additional packages to the end of the list or install in post-installation. Install ``intel-ucode`` or ``amd-ucode`` to install the respective microcode for your cpu. 
```Zsh
pacstrap -K /mnt base base-devel linux linux-firmware git btrfs-progs nano networkmanager zram-generator openssh man sudo amd-ucode
```

<br>

## Generate fstab  


- Generate the ``/etc/fstab``
```Zsh
genfstab -U /mnt >> /mnt/etc/fstab
```
<br>

- Verify fstab
```Zsh
cat /mnt/etc/fstab
```

<br>

## Chroot into our new install  

- To access our new system we chroot into it
```Zsh
arch-chroot /mnt
```

<br>

## Set Time Zone


- Find your timezone in ``/usr/share/zoneinfo/*/*`` and create a symbolic link to ``/etc/localtime``
```Zsh
ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime
```
<br>

- Sync the system time to the hardware clock
```Zsh
hwclock --systohc
```

<br>

## Set Language and TTY keymap


Edit `/etc/locale.gen` and uncomment the entries for your locales. ie: remove the `#` preceeding `en_US.UTF-8 UTF-8`

<br>

- Edit ``/etc/locale.gen``
```Zsh
nano /etc/locale.gen
```
<br>

- Generate locales
```Zsh
locale-gen
```
<br>

- Set ``LANG=`` variable to reflect your above choice in ``/etc/locale.conf``
```Zsh
nano /etc/locale.conf
```

<br>

If not using the default US keymap, edit `/etc/vconsole.conf`

<br>

- Edit ``/etc/vconsole.conf``
```Zsh
nano /etc/vconsole.conf
```
<br>

- Update the following line to reflect your current keymap
```Zsh
KEYMAP=us
```

<br>

## Set Hostname and Hosts file


- Edit the ``/etc/hostname`` file to reflect the name of your system (hostname) 
```Zsh
nano /etc/hostname
```
<br>

- Create/Edit the ``/etc/hosts`` file to reflect your localhost replacing 
```Zsh
nano /etc/hosts
```
<br>

- add the following three lines replacing arch with your hostname from above
```Zsh
127.0.0.1 localhost
::1 localhost
127.0.1.1 Arch
```

<br>

## Create Users  

- Create your user and give them sudo permissions. 
- We want to leave root disabled so we do not set the root password
```Zsh
useradd -mG wheel spiritfader
passwd spiritfader
```
<br>

- Edit sudoers file with visudo
```Zsh
EDITOR=nano visudo
```
<br>

- Uncomment (remove the #) Allow sudo access to all members of the wheel group 
- Change the line from: 
```Zsh
#%wheel      ALL=(ALL:ALL) ALL
```
to
```Zsh
%wheel      ALL=(ALL:ALL) ALL
```
and save.
<br>

## Bootloader configuration

- Install the systemd-boot loader 

```Zsh
bootctl install
```
<br>

### *Setup unified kernel image*

- open ``/etc/mkinitcpio.d/linux.preset`` for editing 
```Zsh
nano /etc/mkinitcpio.d/linux.preset
```
<br>

- replace the contents of ``linux.preset`` from this;
```Zsh
ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-linux"

PRESETS=('default' 'fallback')

default_config="/etc/mkinitcpio.conf"
default_image="/boot/initramfs-linux.img"
#default_uki="/esp/EFI/Linux/arch-linux.efi"
#default_options="--splash=/usr/share/systemd/bootctl/splash-arch.bmp"

fallback_config="/etc/mkinitcpio.conf"
fallback_image="/boot/initramfs-linux-fallback.img"
#fallback_uki="/esp/EFI/Linux/arch-linux-fallback.efi"
#fallback_options="-S autodetect"
```

<br>

- To this. 
- Replace ``esp`` with the mount point of your esp created earlier. For us this is ``/boot``
```Zsh
#ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-linux"

PRESETS=('default' 'fallback')

#default_config="/etc/mkinitcpio.conf"
#default_image="/boot/initramfs-linux.img"
default_uki="/boot/EFI/Linux/arch-linux.efi"
default_options="--splash=/usr/share/systemd/bootctl/splash-arch.bmp"

#fallback_config="/etc/mkinitcpio.conf"
#fallback_image="/boot/initramfs-linux-fallback.img"
fallback_uki="/boot/EFI/Linux/arch-linux-fallback.efi"
fallback_options="-S autodetect"
```
<br>


- Generate uki with mkinictpio
```Zsh
wip
```
<br>

## Enable/Disable services


- Enable NetworkManager before rebooting otherwise for connectivity upon next boot
```Zsh
systemctl enable NetworkManager
```
<br>

- Enable chronyd and disable systemd-timesyncd because we use chronyd
```Zsh
systemctl disable systemd-timesyncd
systemctl enable chronyd.service
```

<br>

## Setup swap


- Create and open``/etc/systemd/zram-generator.conf`` for editing
```Zsh
nano /etc/systemd/zram-generator.conf
```
<br>

- Add the following lines, save and exit when finished.

```Zsh
[zram0]
zram-size = min(ram / 2, 4096)
compression-algorithm = zstd
```
<br>

## Unmount and reboot 


- Exit from chroot
```Zsh
exit
```
<br>

- Unmount everything
```Zsh
umount -R /mnt
```
<br>

- Reboot the system and unplug the installation media
```Zsh
reboot
```

<br>

# Post-Installation
## Aur Helper
- Install paru as AUR helper

```Zsh
git clone https://aur.archlinux.org/paru.git 
cd paru && makepkg -si
```

<br>

## Hardening your new install (Optional)

```Zsh
wip
```

<br>

## Improving Performance (Optional)

```Zsh
wip
```

<br>

## Optimizing Battery Life for Laptops (Optional)

```Zsh
wip
```

<br>
