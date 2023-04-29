# update & upgrade
sudo apt-get update
sudo apt-get upgrade

# set up Linux, Git & Apache
apt-get install -y git
apt-get install -y apache2

# enable Apache mods
sudo a2emod rewrite

# set up PHP & Postgres versions
PHPVER=8.1
PGV=15

# install stuff
sudo apt-get install -y php$PHPVER
apt-get install -y libapache2-mod-php$PHPVER

# restart to take effect
service apache2 restart

# PHP stuff
sudo apt-get install -y php$PHPVER-common
sudo apt-get install -y php$PHPVER-mcrypt
sudo apt-get install -y php$PHPVER-zip
sudo apt-get install -y php-mbstring
sudo apt-get install -y php-xml
sudo apt-get install -y php$PHPVER-curl

# restart to take effect
sudo service apache2 restart

# set up curl
 sudo apt-get install php-curl
 sudo service apache2 restart

# postgres & postgis setup
sudo apt install curl ca-certificates gnupg
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo add-apt-repository ppa:ubuntugis/ppa -y
sudo apt-get update -y
sudo apt-get install postgis postgresql-$PGV-postgis-3 -y
sudo apt install php-pgsql -y

# set postgres superuser password - Make sure passwords change before deployment
sudo -u postgres -i psql -U postgres -c "ALTER USER postgres PASSWORD 'e1k5FSYa4u1p';"

# create new user and DB
sudo -u postgres -i psql -U postgres -c "CREATE USER root WITH PASSWORD 'e1k5FSYa4u1p'"
sudo -u postgres -i psql -U postgres -c "CREATE DATABASE sandbox OWNER 'root'"
sudo -u postgres -i psql -U postgres -d sandbox -c "GRANT ALL PRIVILEGES ON DATABASE sandbox TO root"
sudo -u postgres -i psql -U postgres -d sandbox -c "CREATE EXTENSION postgis";
sudo -u postgres -i psql -U postgres -d sandbox -c "CREATE EXTENSION postgis_topology";

# allow remote access & restart
echo "listen_addresses = '*'" | sudo tee -a /etc/postgresql/$PGV/main/postgresql.conf
echo "host    all             all             0.0.0.0/0            scram-sha-256" | sudo tee -a /etc/postgresql/$PGV/main/pg_hba.conf
sudo ufw allow 5432/tcp
sudo systemctl restart postgresql
sudo service apache2 restart

# set up composer stuff for php
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php
sudo mv composer.phar /usr/local/bin/composer

# PERMISSIONS
sudo chmod 777 /var/www/html -R

# change site root (VM ONLY)
sudo cp /var/www/html/000-default.conf /etc/apache2/sites-available/000-default.conf
sudo systemctl restart apache2

# composer & laravel stuff
# remove the vm index
cd /var/www/html
sudo rm index.html

sudo composer require doctrine/dbal
sudo composer install
php artisan config:clear
cp .env.example .env
php artisan key:generate
php artisan migrate
php artisan db:seed

sudo ufw enable
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https


