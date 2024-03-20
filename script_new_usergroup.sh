#!/bin/bash

# Масиви з іменами групами
users=("devuser1" "opuser1" "Tester1")
groups=("Dev" "Ops" "Test")

# Створення груп
for group in "${groups[@]}"; do
    if getent group $group > /dev/null 2>&1; then
    # if getent group $group > /tmp/exd 2>&1; then
        echo "Помилка: група $group вже існує"
    else
        sudo groupadd $group
        echo "Групу $group успішно створено"
    fi
done

# Створення користувачів та додавання їх до відповідних груп
for i in ${!users[@]}; do
    user=${users[$i]}
    group=${groups[$i]}
    if id -u $user > /dev/null 2>&1; then
    # if id -u $user > /tmp/exd 2>&1; then
        echo "Помилка: користувач $user вже існує"
    else
        sudo useradd -m -G $group $user
        # sudo mkdir /home/$user
        echo "Користувач $user успішно створений та доданий до групи $group"
    fi
done
