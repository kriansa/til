# Linux

## Commands

### See listening TCP sockets

> $ ss -tln
> $ netstat -tulpn

### See a list of network devices that have recently interacted with this machine:

> # nmap -sn <cidr>/<subnet-mask>

When executed by an unprivileged user, only SYN packets are sent (using a
connect call) to ports 80 and 443 on the target.

When a privileged user tries to scan targets on a local ethernet network, ARP
requests are used unless --send-ip was specified. The -sn option can be
combined with any of the discovery probe types (the -P* options, excluding -Pn)
for greater flexibility.

If any of those probe type and port number options are used, the default probes
are overridden. When strict firewalls are in place between the source host
running Nmap and the target network, using those advanced techniques is
recommended. Otherwise hosts could be missed when the firewall drops probes or
their responses.

More info: https://askubuntu.com/questions/406792/list-all-mac-addresses-and-their-associated-ip-addresses-in-my-local-network-la
