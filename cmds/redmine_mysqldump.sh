#!/bin/sh

# Add this line in server crontab to backup the database:
# 00 23    * * *   root     /usr/local/sbin/redmine_mysqldump.sh

# Note that the /root/.redmine.my.cnf file must contain the database password:
#
# [client]
# password=mysecretpasswd
#
# Don't forget to chmod 400 this file!

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:$PATH

OUTFILE=$1$(date +%Y%m%d).sql
USER=redmine
DB=redmine
DESTDIR=/var/mysqldump/$DB
docker run --rm --link redmine_db_1:db -v $DESTDIR:/tmp \
         -v /root/.$DB.my.cnf:/etc/auth.cnf -e DUMPFILE=$OUTFILE -e USER=$USER -e BASE=$DB mysql \
         sh -c 'exec mysqldump --defaults-file=/etc/auth.cnf -h db -u $USER $BASE > /tmp/$DUMPFILE'
