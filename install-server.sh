#!/usr/bin/env bash

DB_USER=root
DB_PASSWORD=pass
VAGRANT="vagrant-ubuntu-trusty-64"

# Install everything
export DEBIAN_FRONTEND=noninteractive
#echo "ubuntu apt get update"
#sudo apt-get update 2>/dev/null 2>&1
echo "mysql"
echo "mysql-server mysql-server/root_password password $DB_PASSWORD" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $DB_PASSWORD" | sudo debconf-set-selections 
sudo apt-get install -y mysql-server 2> /dev/null
sudo apt-get install -y mysql-client 2> /dev/null
echo "installing apache2 php5..."
sudo apt-get install -y apache2 php5 libapache2-mod-php5 php5-mysql php5-curl phpunit subversion nodejs git 2> /dev/null 2>&1

# Configure Apache
WEBROOT="/var/www"
CGIROOT=`dirname "$(which php-cgi)"`
echo "WEBROOT: $WEBROOT"
echo "CGIROOT: $CGIROOT"
sudo echo "<VirtualHost *:80>
        DocumentRoot $WEBROOT
        <Directory />
                Options FollowSymLinks
                AllowOverride All
        </Directory>
        <Directory $WEBROOT >
                Options Indexes FollowSymLinks MultiViews
                AllowOverride All
                Order allow,deny
                allow from all
        </Directory>
		# Configure PHP as CGI
		ScriptAlias /local-bin $CGIROOT
		DirectoryIndex index.php index.html
		AddType application/x-httpd-php5 .php
		Action application/x-httpd-php5 '/local-bin/php-cgi'
</VirtualHost>" > /etc/apache2/sites-available/000-default.conf

sudo a2enmod rewrite
sudo a2enmod actions
sudo service apache2 restart

# Configure custom domain
echo "127.0.0.1 mydomain.local" | sudo tee --append /etc/hosts



#=================================================================

if [ -z "$TRAVIS_PHP_VERSION" ]; then
	echo "non-travis";
else
	echo "travis";
fi

if [ "$HOSTNAME" = "$VAGRANT" ]; then
	echo "phpmyadmin@vagrant"
	echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/app-password-confirm password $DB_PASSWORD" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/mysql/admin-pass password $DB_PASSWORD" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/mysql/app-pass password $DB_PASSWORD" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
	sudo apt-get -y install phpmyadmin 
	echo "phpmyadmin installed"
else
	echo "non-vagrant $HOSTNAME";
fi

