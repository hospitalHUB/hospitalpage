#!/bin/bash
DIR=/var/www
cd $DIR/vendor/amarcinkowski/hospitalplugin/
chmod +x /var/www/vendor/doctrine/orm/bin/doctrine
../../bin/doctrine orm:schema-tool:create
echo "insert into hospital_user values (1,'1','admin');" | sudo -u vagrant wp db cli
echo "INSERT INTO hospital_ward VALUES (1, 'Oddział Specjalny', 'OS', 'OS', 'Ataman Młoda Foka', 'ZZ', 0, '', '', '', '');" | sudo -u vagrant wp db cli
