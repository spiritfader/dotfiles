#!/bin/sh
# Blackarch sysclean script
#pacman -Rscn "$(yay -Qtdq)" # Remove all packages marked as orphans, their dependencies and all the packages that depend on the target packages, quietly (no titles)
updatedb                    # update the locate/plocate database
pkgfile -u                  # update the pkgfile database
pacman -Fyy                 # update the pacman file database
pacman-db-upgrade           # upgrade the local pacman db to a newer format
yes | pacman -Scc           # Remove all files and unused repositories from pacman cache without prompt
sync                        # syncronize cached writes to persistent storage