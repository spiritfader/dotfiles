#!/bin/bash
# Usage:
#     extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz|.zlib|.cso>
#
# Example:
# $ extract file_name.zip

extract2() {
 SAVEIFS=$IFS
 IFS="$(printf '\n\t')"
 if [ $# -eq 0 ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz|.zlib|.cso>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 fi
    for n in "$@"; do
        if [ ! -f "$n" ]; then
            echo "'$n' - file doesn't exist"
            return 1
        fi

        case "${n##*.}" in
          *.cbt)       tar xvf -p "$n"    ;;
          *.tar.bz2)   tar xvf -p "$n"    ;;
          *.tar.gz)    tar xvf -p "$n"    ;;
          *.tar.xz)    tar xvf -p "$n"    ;;
          *.tbz2)      tar xvf -p "$n"    ;;
          *.tgz)       tar xvf -p "$n"    ;;
          *.txz)       tar xvf -p "$n"    ;;
          *.tar)       tar xvf -p "$n"    ;;
          *.lzma)      unlzma ./"$n"      ;;
          *.bz2)       bunzip2 ./"$n"     ;;
          *.cbr)       unrar x -ad ./"$n" ;;
          *.rar)       unrar x -ad ./"$n" ;; 
          *.gz)        gunzip ./"$n"      ;;
          *.cbz)           unzip ./"$n"   ;;
          *.epub)          unzip ./"$n"   ;;
          *.zip)           unzip ./"$n"   ;;
          *.z)         uncompress ./"$n"  ;;
          *.7z)        7z x ./"$n"        ;;
          *.apk)       7z x ./"$n"        ;;
          *.arj)       7z x ./"$n"        ;;
          *.cab)       7z x ./"$n"        ;;
          *.cb7)       7z x ./"$n"        ;;
          *.chm)       7z x ./"$n"        ;;
          *.deb)       7z x ./"$n"        ;;
          *.iso)       7z x ./"$n"        ;;
          *.lzh)       7z x ./"$n"        ;;
          *.msi)       7z x ./"$n"        ;;
          *.pkg)       7z x ./"$n"        ;;
          *.rpm)       7z x ./"$n"        ;;
          *.udf)       7z x ./"$n"        ;;
          *.wim)       7z x ./"$n"        ;;
          *.xar)       7z x ./"$n"        ;;
          *.vhd)       7z x ./"$n"        ;;
          *.xz)        unxz ./"$n"        ;;
          *.exe)       cabextract ./"$n"  ;;
          *.cpio)      cpio -id < ./"$n"  ;;
          *.cba)       unace x ./"$n"     ;;
          *.ace)       unace x ./"$n"     ;;
          *.zpaq)      zpaq x ./"$n"      ;;
          *.arc)       arc e ./"$n"       ;;
          *.cso)       ciso 0 ./"$n" ./"$n.iso" && extract "$n.iso" && rm -f "$n" ;;
          *.zlib)      zlib-flate -uncompress < ./"$n" > ./"$n.tmp" && mv ./"$n.tmp" ./"${n%.*zlib}" && rm -f "$n";;
          *.dmg)       hdiutil mount ./"$n" -mountpoint "./$n.mounted" ;;
          *)           echo "extract: '$n' - unknown archive method"
          return 1;;
        esac
    done
 IFS=$SAVEIFSll
}