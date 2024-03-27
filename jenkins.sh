#!/bin/bash

# Оновлення встановлених пакетів
sudo apt update && sudo apt upgrade -y

# Встановлення Java
sudo apt install openjdk-17-jdk -y

# Встановлення Apache HTTP
sudo apt install apache2 -y

# Додавання ключа для пакета Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
/usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Додавання репозиторію для встановлення
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null

# Оновлення індексу пакетів
sudo apt-get update

# Встановлення jenkins
sudo apt-get install jenkins

# Налаштування ssl
sudo mkdir /etc/apache2/ssl

# Генерація самопідписаного сертифіката ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt

# Налаштування Apache
sudo bash -c 'cat > /etc/apache2/sites-available/000-default.conf << EOF
<VirtualHost *:80>
   ServerName localhost
   Redirect / https://localhost/
</VirtualHost>

<VirtualHost *:443>
   SSLEngine on
   SSLCertificateFile /etc/apache2/ssl/apache.crt
   SSLCertificateKeyFile /etc/apache2/ssl/apache.key

   ProxyRequests Off
   ProxyPreserveHost On
   ProxyPass / http://localhost:8080/
   ProxyPassReverse / http://localhost:8080/
</VirtualHost>
EOF'

# Налаштування проксі
sudo bash -c 'cat > /etc/apache2/mods-available/proxy.conf << EOF
<IfModule mod_proxy.c>
ProxyPass         /  http://localhost:8080/ nocanon
ProxyPassReverse  /  http://localhost:8080/
ProxyRequests     Off
AllowEncodedSlashes NoDecode

<Proxy http://localhost:8080/*>
  Order deny,allow
  Allow from all
</Proxy>
</IfModule>
EOF'

# Встановлення модулів Apache
sudo a2enmod ssl
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod rewrite
sudo a2enmod headers

# Запуск оболонки з Jenkins за допомогою sudo
echo "jenkins ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo

# Зміна HTTP_HOST
sudo sed -i '/JENKINS_ARGS/i HTTP_HOST=127.0.0.1' /etc/default/jenkins

# Запуск оболонки з Jenkins за допомогою sudo
#sudo vim /etc/sudoers
# додати рядок:
# jenkins ALL=(ALL) NOPASSWD: ALL

# Перезапуск обох служб
sudo systemctl restart apache2
sudo systemctl restart jenkins
