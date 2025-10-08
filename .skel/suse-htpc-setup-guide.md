# Enable Sudo for your user, disable root account, and reboot
- add user to wheel group
```bash
sudo usermod -aG wheel $YOUR_USERNAME
```
- run visudo with your favorite editor to edit the sudoers file
```bash
EDITOR=nvim visudo
```
- Make sure these lines are commented out as followed

```bash
#Defaults targetpw   # ask for the password of the target user i.e. root
#ALL   ALL=(ALL) ALL   # WARNING! Only use this together with 'Defaults targetpw'!
```
- Uncomment the following line to appear as follow, this allows wheel group sudo perms, then save and exit.
```bash
## Uncomment to allow members of group wheel to execute any command
%wheel ALL=(ALL:ALL) ALL
```
<br>

### Disable the root account (Note: This will break Yast2)
- run passwd -d to disable root account
```bash
sudo passwd -d root
```
<br>

# Configure user to read all systemd-journal logs
- add user to systemd-journal group
```bash
sudo usermod -aG systemd-journal $YOUR_USERNAME
```
<br>

# Setup & secure Firewalld for CIS benchmark compliance
- add loopback device to the trusted zone
```bash
sudo firewall-cmd --permanent --zone=trusted --add-interface=lo
``` 
<br>

- prevent loopback from reaching out of trusted zone
```bash
sudo firewall-cmd --permanent --zone=trusted --add-rich-rule='rule family=ipv4 source address="127.0.0.1" destination not address="127.0.0.1" drop'
```
```bash
sudo firewall-cmd --permanent --zone=trusted --add-rich-rule='rule family=ipv6 source address="::1" destination not address="::1" drop'
```
<br>

- Reload your firewall-cmd config
```bash
firewall-cmd --reload
```
- Set currently connected network to home zone in NetworkManager
- Only after you've changed your currently connected and idealized network to the proper config, change default zone to drop
  - Open ``/etc/firewalld/firewalld.conf`` for editing with elevated perms
  change this section on top from this;
```bash
# default zone
# The default zone used if an empty zone string is used.
# Default: public
DefaultZone=public
```
to this;
```bash
# default zone
# The default zone used if an empty zone string is used.
# Default: public
DefaultZone=drop
```
- Save and reload your firewall-cmd config with
```bash
sudo firewall-cmd --reload
```
<br>

# Lock & Remove Yast2 package family
```bash
sudo zypper rm yast2 yast2-* && sudo zypper al yast2 yast2-*
```
<br>

# Remove additional redundant online source repo added by installer
- get name from `sudo zypper lr`
```bash
sudo zypper rr openSUSE-20250905-1
```
<br>

# Install software
```bash
sudo zypper in fastfetch python313-hyfetch git ranger neovim alacritty
```
<br>

# Git clone dotfiles
```bash
git clone https://www.github.com/spiritfader/dotfiles
```
<br>

# Setup neovim
```bash
git clone https://github.com/spiritfader/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim && nvim
```
<br>

# Set hostname
```bash
nvim /etc/hostname
```
<br>

# Add unofficial repos
```bash
### repo contains 'sunshine', 'xone', and more
sudo zypper addrepo https://download.opensuse.org/repositories/home:MaxxedSUSE/openSUSE_Tumbleweed/home:MaxxedSUSE.repo

### repo contains the 'xone-dongle-firmware' package for wireless xbox one controller functionality 
sudo zypper addrepo https://download.opensuse.org/repositories/home:Tobi_Peter:repo/openSUSE_Tumbleweed/home:Tobi_Peter:repo.repo
```
<br>

# Install more software
```bash
sudo zypper in sunshine xone xone-dongle-firmware
```
<br>



