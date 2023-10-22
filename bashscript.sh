#!/bin/bash

# Check if Homebrew is installed, and if not, install it.
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Update Homebrew
brew update

# Install required software
brew install openjdk@11   # Install OpenJDK 11
brew install apache2     # Install Apache HTTP server
brew install mysql       # Install MySQL server
brew install php         # Install PHP
brew install composer    # Install Composer

# Start Apache and MySQL services
sudo apachectl start
brew services start mysql

# Set up PHP configurations
sudo cp /usr/local/etc/php/8.0/php.ini.default /usr/local/etc/php/8.0/php.ini
sudo apachectl restart

# Clone Laravel repository
mkdir -p /var/www/html/laravel
cd /var/www/html/laravel
git clone https://github.com/laravel/laravel.git .

# Install Composer packages
composer install

# Copy the .env file and set permissions
cp .env.example .env
sudo chown -R $(whoami) /var/www/html/laravel
sudo chmod -R 775 /var/www/html/laravel/storage
sudo chmod -R 775 /var/www/html/laravel/bootstrap/cache

# Configure Apache for Laravel
cat <<EOL | sudo tee /etc/apache2/sites-available/laravel.conf
<VirtualHost *:80>
 ServerAdmin sijuadeabai@gmail.com
 ServerName 192.168.60.11
 DocumentRoot /var/www/html/laravel/public

 <Directory /var/www/html/laravel>
  Options Indexes FollowSymLinks
  AllowOverride All
  Require all granted
 </Directory>

 ErrorLog \${APACHE_LOG_DIR}/error.log
 CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL

# Enable Apache modules and site, then restart Apache
sudo a2enmod rewrite
sudo a2ensite laravel.conf
sudo apachectl restart

# Create a MySQL user and database
DB_NAME="your_database_name"
DB_USER="your_database_user"
DB_PASS="your_database_password"

mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@localhost;
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "MySQL user and database created."
echo "Database: $DB_NAME"
echo "Username: $DB_USER"
echo "Password: $DB_PASS"

# Generate Laravel application key and run migrations
cd /var/www/html/laravel
php artisan key:generate
php artisan config:cache
php artisan migrate