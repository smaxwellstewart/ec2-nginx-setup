#!/bin/bash

# Change the host name, replace ip and host name with correct information
sudo chmod 777 /etc/hosts
sudo echo "ipaddress hostnameholder" >> /etc/hosts
sudo chmod 644 /etc/hosts

sudo chmod 777 /etc/hostname
sudo echo "hostnameholder" > /etc/hostname
sudo chmod 644 /etc/hostname
sudo hostname -F /etc/hostname

# Update and upgrade packages using apt-get
sudo apt-get update -y
sudo apt-get upgrade -y --show-upgraded

# Install git and curl 
sudo apt-get install -y git-core
sudo apt-get install -y git
sudo apt-get install -y curl

# Install nginx and php
sudo apt-get install -y nginx php5-fpm php5-cli php5-mcrypt

# Move the laravel.conf file to the nginx sites-enabled directory 
sudo mv ~/laravel.conf /etc/nginx/sites-available/sitename.com

# Remove the default www.conf file and move in the replacement file included
sudo rm /etc/php5/fpm/pool.d/www.conf
sudo mv www.conf /etc/php5/fpm/pool.d

# Install mysql and php-mysql
sudo apt-get install -y mysql-server php5-mysql
sudo mysql_secure_installation
sudo service php5-fpm restart

# Make the main site directory and logs subdirectory
sudo git clone githolder sitename
sudo mkdir sitename/logs

# Symbollically link the site directory to enable the site
sudo ln -s /etc/nginx/sites-available/sitename.com /etc/nginx/sites-enabled

# Remove the default site config from sites-available and sites-enabled and then restart the server
sudo rm /etc/nginx/sites-available/default
sudo rm /etc/nginx/sites-enabled/default
sudo /etc/init.d/nginx restart

# Install emacs
sudo add-apt-repository -y ppa:cassou/emacs
sudo apt-get update
sudo apt-get install -y emacs-snapshot

# Change permissions on the main site directory
sudo chmod -R 755 sitename

# Install composer and then use composer to install all dependencies
sudo curl -s http://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

cd sitename
sudo composer install --dev

# Set up database
sudo mysqladmin -u root -p create sitename

# Set encryption key
sudo php artisan key:generate

# Build assets using bassett
sudo php artisan basset:build

# Change permissions on the app/storage directory
sudo chmod -R 777 app/storage

cd ~
sudo /etc/init.d/nginx restart

