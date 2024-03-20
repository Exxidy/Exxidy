#!/bin/sh

# Визначення операційної системи
OS=$(grep -o '^NAME="[^"]*' /etc/os-release | cut -d'"' -f2)
#теж працює)
#. /etc/os-release
#echo "$NAME"

if echo "$OS" | grep -q "Ubuntu\|Debian"; then
    echo "Виявлено Debian-based ОС"
    echo "Оновлення списку пакетів..."
    sudo apt-get update
    echo "Встановлення Apache2..."
    sudo apt-get install apache2 -y
    echo "Встановлення MySQL..."
    sudo apt-get install mysql-server -y
    echo "Встановлення PHP..."
    sudo apt-get install php libapache2-mod-php php-mysql -y
    echo "Перезапуск Apache2..."
    sudo systemctl restart apache2
elif echo "$OS" | grep -q "CentOS\|RHEL"; then
    echo "Виявлено RHEL-based ОС"
    echo "Оновлення списку пакетів..."
    sudo yum -y update
    echo "Встановлення Apache2..."
    sudo yum -y install httpd
    echo "Встановлення MySQL..."
    sudo yum -y install mariadb-server mariadb
    echo "Встановлення PHP..."
    sudo yum -y install php php-mysql
    echo "Перезапуск Apache2..."
    sudo systemctl restart httpd
else
    echo "Операційна система не підтримується"
    exit 1
fi

echo "LAMP стек успішно встановлено!"
