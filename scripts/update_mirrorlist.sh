curl -s "https://www.archlinux.org/mirrorlist/?country=DE&country=AT&country=CH&country=FR&protocol=https&use_mirror_status=on" | \
sed -e 's/^#Server/Server/' -e '/^#/d' | \
rankmirrors -t - | \
grep -v 'unreachable$' > \
/etc/pacman.d/mirrorlist
