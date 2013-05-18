nrpe-grep - prints all configured nrpe commands
========================================================================

parses all nrpe cfg file in common configuration dirs
dirs define by default could be overriden by NAGCFGDIR

there are multiple output formats:

** normal
```
# nrpe-grep | head -n 2
check_users          /etc/nagios/nrpe.cfg
check_load           /etc/nagios/nrpe.cfg
```

** short
```
# ./nrpe-grep --short | head -n 2
check_users          
check_load
```

** detail
```
# nrpe-grep --detail | head -n 2
check_users          /etc/nagios/nrpe.cfg,/usr/lib64/nagios/plugins/check_users,-w 5 -c 10
check_load           /etc/nagios/nrpe.cfg,/usr/lib64/nagios/plugins/check_load,-w 15,10,5 -c 30,25,20


real world example
========================================================================

output from nrpe-grep could be used for feeding nrpe-nagservicedef:
```
# nrpe-grep -short | xargs -n 1 nrpe-nagservicedef | head -n 10
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
