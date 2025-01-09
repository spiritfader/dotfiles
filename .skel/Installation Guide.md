# Arch Linux Installation Guide

## Table of contents

- [Pre-Installation](#pre-installation)
  - [Set Console Keyboard & Font](#set-the-console-keyboard-layout-and-font-if-necessary)
  - [Verify Boot Mode](#verify-boot-mode)
  - [Connect to Network](#connect-to-network)
  - [Check system time](#check-the-system-clock)
- [Main Installation](#main-installation)
  - [Disk partitioning](#disk-partitioning)
  - [Disk formatting](#disk-formatting)
  - [Disk mounting](#disk-mounting)
  - [Packages Installation Bootstrap](#package-bootstrap)
  - [Generate Fstab](#generate-fstab)
  - [Chroot into our Install](#chroot-into-our-new-install)
  - [Set time zone](#set-time-zone)
  - [Set language and TTY keyboard map](#set-language-and-tty-keymap)
  - [Set hostname and edit hosts file](#set-hostname-and-hosts-file)
  - [Create Users](#create-users)
  - [Bootloader configuration](#bootloader-configuration)
  - [Configure services](#enabledisable-services)
  - [Unmount and reboot](#unmount-and-reboot)
- [Post-Installation](#post-installation)

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

#####  *Ethernet*
```Zsh
Plug in your ethernet cable
```
<br>

##### *Wi-Fi*

- Get name of wireless nic
```Zsh
ip link
```
<br> 

- Connect to unprotected Wi-Fi network (replace interface with nic name)
```Zsh
iwctl station interface connect SSID
```
<br>

- Connect to password protected Wi-Fi network (replace interface with nic name)
```Zsh
iwctl --passphrase passphrase station interface connect SSID
```
<br>

##### *Modem*

- Use mmcli to list available modems 
- Take note of ``/org/freedesktop/ModemManager1/Modem/MODEM_INDEX``
```Zsh
mmcli -L
```
<br>

- Connect to the unprotected modem network, replacing ``MODEM_INDEX`` from above
- Replace ``internet.myisp.example`` with your ISP's provided APN
```Zsh
mmcli -m MODEM_INDEX --simple-connect="apn=internet.myisp.example"
```
<br>

- Connect to the protected modem network, replacing ``MODEM_INDEX`` from above
- Replace ``internet.myisp.example`` with your ISP's provided APN
```Zsh
mmcli -m MODEM_INDEX --simple-connect="apn=internet.myisp.example,user=user_name,password=password"
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

## Disk partitioning

- I recommend making 2 partitions:  

| Number | Type | Size | Mount |
| --- | --- | --- | --- |
| 1 | EFI | 1024 Mb | /boot |
| 2 | Linux Filesystem | Remaining Space | / |  

<br>

- List and check drives names
```Zsh
fdisk -l
```
<br>

- Run cfdisk to parition disk and start with zero'd partition table
```Zsh
cfdisk -z /dev/nvme0n1
```
<br>

## Disk formatting  


- Find the efi partition with ``fdisk -l`` or ``lsblk``. For me it's ``/dev/nvme0n1p1`` and format it.
```Zsh
mkfs.fat -F 32 /dev/nvme0n1p1
```
<br>

- Find the root partition. For me it's ``/dev/nvme0n1p2`` and format it. I will use BTRFS.
```Zsh
mkfs.btrfs /dev/nvme0n1p2
```
<br>

- Mount the root fs to make it accessible
```Zsh
mount /dev/nvme0n1p2 /mnt
```

<br>

## Disk mounting
<br>

- Lay down the subvolumes on a **flat** layout
[explanation from sysadmin guide](https://archive.kernel.org/oldwiki/btrfs.wiki.kernel.org/index.php/SysadminGuide.html#Layout)


- Create the subvolumes, in my case I choose to make a subvolume for / and one for /home. Subvolumes are identified by prepending @
```Zsh
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
```
<br>

- Unmount the root fs
```Zsh
umount /mnt
```

<br>

- Mount the root and home subvolume. compress option.
```Zsh
mount -o compress=zstd,subvol=@ /dev/nvme0n1p2 /mnt
mkdir -p /mnt/home
mount -o compress=zstd,subvol=@home /dev/nvme0n1p2 /mnt/home
```

<br>

```Zsh
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

<br>

## Package bootstrap  

- Install packages to the root mountpoint thus, bootstrapping the new install and using -K switch to initialize a new pacman keyring. 
- Append any additional packages to the end of the list or install in post-installation
```Zsh
pacstrap -K /mnt base base-devel linux linux-firmware git btrfs-progs vim networkmanager openssh man sudo
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
vim /etc/locale.gen
```
<br>

- Generate locales
```Zsh
locale-gen
```
<br>

- Set ``LANG=`` variable to reflect your above choice in ``/etc/locale.conf``
```Zsh
vim /etc/locale.conf
```

<br>

If not using the default US keymap, edit `/etc/vconsole.conf`

<br>

- Edit ``/etc/vconsole.conf``
```Zsh
vim /etc/vconsole.conf
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
vim /etc/hostname
```
<br>

- Create/Edit the ``/etc/hosts`` file to reflect your localhost replacing 
```Zsh
vim /etc/hosts
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
EDITOR=vim visudo
```
<br>

- Uncomment Allow sudo access to all within wheel group
```Zsh
(wip)
```

<br>

## Bootloader configuration  

- Setup systemd-boot 

```Zsh
bootctl install
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

## Post-Installation


- Install paru as AUR helper

```Zsh
git clone https://aur.archlinux.org/paru.git 
cd paru && makepkg -si
```

<br>

