#
# Regular cron jobs for the qmlremis package
#
0 4	* * *	root	[ -x /usr/bin/qmlremis_maintenance ] && /usr/bin/qmlremis_maintenance
