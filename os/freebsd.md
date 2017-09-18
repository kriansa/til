# FreeBSD

## Post-installing

> freebsd-update fetch
> freebsd-update install
> pkg install sudo
> visudo # `Uncomment %wheel`
> pw usermod myuser -G wheel

## Install Gnome

> pkg install gnome3-lite

## Commands

View memory usage:

> top -n
> vmstat -s
