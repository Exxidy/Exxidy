# Terraform AWS Configuration for CI/CD Infrastructure

Цей репозиторій містить конфігурацію Terraform для створення інфраструктури CI/CD в AWS.

## Локальні змінні

- `vpc_id`: ID вашого VPC.
- `subnet_id`: ID вашої підмережі.
- `ssh_user`: Ім'я користувача для SSH.
- `key_name`: Назва ключа для EC2.
- `private_key_path`: Шлях до приватного ключа.

## Провайдер

AWS регіон: `Вибрати по смаку`.

## Ресурси

### Security Group

- **Jenkins Security Group**: Security Group для Jenkins з правилами для вхідного та вихідного трафіку.

### EC2 Instances

- **ec2-apache-jenkins**: EC2 інстанс для Apache та Jenkins.
- **ec2-apache-wildfly**: EC2 інстанс для Apache та WildFly.
- **ec2-jdk**: EC2 інстанс для JDK-11.

## Процедури

- `000_setup.yaml`: Встановлення Apache та Jenkins, JDK-11.
- `010_setup.yaml`: Встановлення Apache та WildFly, JDK-11.
- `020_setup.yaml`: Встановлення JDK-11.

## Вивід

Публічні IP адреси створених інстансів.

---

**Примітка**: Перед використанням цього коду переконайтеся, що у вас є відповідні права доступу та ключі.
