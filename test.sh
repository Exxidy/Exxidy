#!/bin/sh

# Визначення операційної системи
OS=$(grep -o '^NAME=' /etc/os-release)
echo "$OS"
. /etc/os-release
echo "$NAME"
