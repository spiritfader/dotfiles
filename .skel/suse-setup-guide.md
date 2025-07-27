# confirm wireless regulatory db is correct
WIP


# unofficial and closed source repo setup
WIP


# Enable Sudo and disable root account
- add user to wheel group
```zsh
sudo usermod -aG wheel $YOUR_USERNAME
```
<br>

# configure user to read all systemd-journal logs
- add user to systemd-journal group
```zsh
sudo usermod -aG systemd-journal $YOUR_USERNAME
```
<br>


# Setup/Secure firewalld 
- add loopback device to the trusted zone
```zsh
sudo firewall-cmd --permanent --zone=trusted --add-interface=lo
``` 
- prevent loopback from reaching out of trusted zone
```zsh
sudo firewall-cmd --permanent --zone=trusted --add-rich-rule='rule family=ipv4 source address="127.0.0.1" destination not address="127.0.0.1" drop'
```
```zsh
sudo firewall-cmd --permanent --zone=trusted --add-rich-rule='rule family=ipv6 source address="::1" destination not address="::1" drop'
```
- Reload your firewall-cmd config
```zsh
firewall-cmd --reload
```
- Set currently connected network to home zone in NetworkManager
- Only after you've changed your currently connected and idealized network to the proper config, change default zone to drop
  - Open ``/etc/firewalld/firewalld.conf`` for editing with elevated perms
  change this section on top from this;
```zsh
# default zone
# The default zone used if an empty zone string is used.
# Default: public
DefaultZone=public
```
to this;
```zsh
# default zone
# The default zone used if an empty zone string is used.
# Default: public
DefaultZone=drop
```
- Save and reload your firewall-cmd config with
```zsh
sudo firewall-cmd --reload
```
<br>

# Setup Git/Github

### Generate new ssh keys for user and setup github "authentication/signing"

- Run ``ssh-keygen`` twice (defaults to ed25519 keys, we want this)
  - Save the first key to ``/$HOME/.ssh/id_ed25519`` or name it something,athis is your normal ssh key.
  - Save the second key to ``/$HOME/.ssh/id_ed25519_github`` or something else with github appended to the end, this is your github signing key.

- Add your created ``/$HOME/.ssh/id_ed25519_github.pub`` as a signing/authentication key in your github ssh keys. 

<br>


### Enable commit signing with this new key and adjust git settings 

- tell git where to find your github.pub ssh signing key
```zsh 
git config --global user.signingkey ~/.ssh/id_ed25519_github.pub
```

- tell git to your private github email instead (or your real email if preferred but this is better in the long run)
```zsh
git config --global user.email "<GITHUB_USERNAME>@users.noreply.github.com"
```

- tell git to enable commit signing
```zsh 
git config --global commit.gpgsign true
```
- tell git to use SSH as its signing method 
```zsh
git config --global gpg.format ssh
```
<br>


### Finally create an ssh host alias for github and test your connection

- add this block towards the end of your ``$HOME/.ssh/config`` file (create the file if you do not already have it)
```zsh
Host github.com
    User git
    IdentityFile /home/spiritfader/.ssh/id_ed25519_github
```
This file simplifies the process by aliasing the git@github.com address and explicitly telling it to use the created github.pub key

- run ``ssh -T github.com`` in a terminal to test your authentication and connection to github.  

If you have done everything correctly, you will receive this message response
``Hi <YOUR_USERNAME>! You've successfully authenticated, but GitHub does not provide shell access.``

If so, all is well.



# software setup
WIP 

