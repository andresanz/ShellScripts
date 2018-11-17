echo Running...
sudo chown -R www-data:www-data /var/www/html/ ;
sudo find /var/www/html/ -type d -exec chmod 750 {} \;
sudo find /var/www/html/ -type f -exec chmod 640 {} \;

