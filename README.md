nrpe-list - prints all configured nrpe commands
========================================================================

parses all nrpe cfg file in common configuration dirs
dirs define by default could be overriden by NAGCFGDIR

there are multiple output formats:

** normal
```
# nrpe-list | head -n 2
check_users          /etc/nagios/nrpe.cfg
check_load           /etc/nagios/nrpe.cfg
```

** short
```
# ./nrpe-list --short | head -n 2
check_users          
check_load
```

** detail
```
# nrpe-list --detail | head -n 2
check_users          /etc/nagios/nrpe.cfg,/usr/lib64/nagios/plugins/check_users,-w 5 -c 10
check_load           /etc/nagios/nrpe.cfg,/usr/lib64/nagios/plugins/check_load,-w 15,10,5 -c 30,25,20


real world example of nrpe-list with nrpe-nagservicedef
========================================================================

output from nrpe-list could be used for feeding nrpe-nagservicedef:
```
# nrpe-list -short | xargs -n 1 nrpe-nagservicedef | head -n 10
define service{
        use                             SYSMON-LA
        host_name                       xxx-xxxx-1.xxx
        service_description             sys:users
        check_command                   check_nrpe!5666!check_users
}
define service{
        use                             SYSMON-LA
        host_name                       xxx-xxxx-1.xxx
        service_description             sys:load
```

using nrpe-checkrun for testing nrpe checks configuation and ouput
========================================================================

running check against remote host (useful for testing from central nagios server)
```
# nrpe-checkrun check_load server.domain.xx
OK - load average: 3.40, 2.51, 2.51|load1=3.400;15.000;30.000;0; load5=2.510;10.000;25.000;0; load15=2.510;5.000;20.000;0; 
```

running on server for checking nrpe config
```
# nrpe-checkrun check_disk_all
DISK OK - free space: / 10911 MB (82% inode=92%); /dev/shm 1003 MB (100% inode=99%); /boot 18 MB (20% inode=99%);| /=2392MB;12614;13315;0;14016 /dev/shm=0MB;902;952;0;1003 /boot=73MB;86;91;0;96
```

using with nrpe-list for checking all localy configured nrpe checks
```
# nrpe-list  | while read ch cfg ; do echo "=== $ch" ; ~/nrpe-checkrun.sh $ch ; done
=== check_users
USERS OK - 1 users currently logged in |users=1;5;10;0
=== check_hda1
DISK CRITICAL - /dev/hda1 is not accessible: No such file or directory
=== check_zombie_procs
PROCS OK: 0 processes with STATE = Z
=== check_total_procs
PROCS WARNING: 173 processes
=== check_crond_procs
PROCS CRITICAL: 2 processes with command name 'crond'
=== check_disk_all
DISK OK - free space: / 1630 MB (42% inode=66%); /dev/shm 1002 MB (99% inode=99%); /boot 64 MB (70% inode=99%); /mnt/lv_varlibone 70056 MB (91% inode=99%);| /=2196MB;3627;3829;0;4031 /dev/shm=0MB;902;952;0;1003 /boot=27MB;86;91;0;96 /mnt/lv_varlibone=6481MB;72570;76602;0;80634
=== check_disk_root
DISK OK - free space: / 1630 MB (42% inode=66%);| /=2196MB;3426;3627;0;4031
=== check_load
OK - load average: 6.89, 4.04, 3.17|load1=6.890;15.000;30.000;0; load5=4.040;10.000;25.000;0; load15=3.170;5.000;20.000;0; 
=== check_mailq
OK: mailq reports queue is empty|unsent=0;50;100;0
=== check_ntp
NTP OK: Offset 0.001530170441 secs|offset=0.001530s;60.000000;120.000000;
=== check_smtp
SMTP OK - 0.645 sec. response time|time=0.645255s;1.000000;2.000000;0.000000
=== check_smtp_localhost
SMTP OK - 0.002 sec. response time|time=0.001986s;1.000000;2.000000;0.000000
=== check_smtp_relayhost
SMTP OK - 0.004 sec. response time|time=0.004267s;;;0.000000
=== check_swap
SWAP OK - 100% free (508 MB out of 511 MB) |swap=508MB;383;204;0;511
=== check_bindmounts
status ok -- all mountbinds mounted
=== check_shorewallrules
STATUS CRITICAL -- shorewall rules NOT present
```
