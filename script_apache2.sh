#!/bin/sh

# Визначення операційної системи, хоча мені здається якось по простому може все бути
OS=$(grep -o '^NAME="[^"]*' /etc/os-release | cut -d'"' -f2)
#теж працює)
#. /etc/os-release
#echo "$NAME"

if echo "$OS" | grep -q "Ubuntu\|Debian"; then
    echo "Виявлено Debian-based ОС"
    if dpkg -s apache2 >/dev/null 2>&1; then
        echo "Apache2 вже встановлено"
    else
        echo "Оновлення списку пакетів..."
        sudo apt-get update
        echo "Встановлення Apache2..."
        sudo apt-get install apache2 -y
    fi
elif echo "$OS" | grep -q "CentOS\|RHEL"; then
    echo "Виявлено RHEL-based ОС"
    if rpm -q httpd >/dev/null 2>&1; then
        echo "Apache2 вже встановлено"
    else
        echo "Оновлення списку пакетів..."
        sudo yum -y update
        echo "Встановлення Apache2..."
        sudo yum -y install httpd
    fi
else
    echo "Операційна система не підтримується"
    exit 1
fi

echo "Apache2 успішно встановлено, або ні)"
