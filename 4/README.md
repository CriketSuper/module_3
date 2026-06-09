# Модуль 3, задание 4

## 1. Установка пакетов на HQ-CLI

```bash
apt-get update
apt-get install -y expect openssh-clients sshpass
```

## 2. Настройка

Проверьте сети, адреса и учётные данные в `.env`.

```bash
chmod +x 00-generate-router-configs.sh
chmod +x 01-apply-router-config.exp

./00-generate-router-configs.sh
./01-apply-router-config.exp all
```

Настройка одного маршрутизатора:

```bash
./01-apply-router-config.exp hq
./01-apply-router-config.exp br
```

## 3. Проверка

На маршрутизаторах:

```text
show running-config
show crypto-ipsec ike security-associations
show ip ospf neighbor
```

На ISP:

```bash
apt-get install -y nmap

nmap -Pn -p 22,80,443,8080,2026,5555 172.16.4.4
nmap -Pn -p 22,80,443,8080,2026,5555 172.16.5.5
nmap -Pn -sU -p 53,123,9999 172.16.4.4
nmap -Pn -sU -p 53,123,9999 172.16.5.5
```

Проверка сайтов и SSH-пробросов:

```bash
curl -I http://172.16.4.4:8080
curl -I http://172.16.5.5:8080
nmap -Pn -p 2026 172.16.4.4
nmap -Pn -p 2026 172.16.5.5
```

Порты разрешённых сервисов должны отвечать как `open` или `closed`.
Контрольный порт `5555` и UDP-порт `9999` должны быть `filtered`.
