#!/bin/sh
# Syscleanup script 
#printf "Remove unnecessary pkg dependencies...\n" && paru -scc         # Remove unneeded dependencies & ignore make/check dependencies for foreign packages                                           # Remove all packages marked as orphans, their dependencies and all the packages that depend on the target packages, quietly (no titles)
sudo updatedb && printf "Updating locate/plocate database...\n"         # update the locate/plocate database
printf "\nUpdating pkgfile database" && sudo pkgfile -u                 # update the pkgfile database
printf "\nUpdating Pacman file database" && sudo pacman -Fyy            # update the pacman file database
printf "\nUpgrading local Pacman database..." && sudo pacman-db-upgrade # upgrade the local pacman db to a newer format
printf "\n\nCleaning Pacman cache..." && yes | sudo pacman -Scc         # Remove all files and unused repositories from pacman cache without prompt
printf "\nCleaning AUR cache...\n" && yes | paru -Scc                   # Remove all files and unused repositories from pacman cache without prompt
sync                                                                    # syncronize cached writes to persistent storage
