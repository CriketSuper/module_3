# Модуль 3, задание 5

## 1. HQ-SRV

```bash
chmod +x 01-hq-srv-cups.sh
./01-hq-srv-cups.sh
```

## 2. HQ-CLI

Проверьте адрес HQ-SRV в `.env`:

```bash
CUPS_SERVER_HOST=hq-srv.au-team.irpo
CUPS_SERVER_IP=192.168.1.10
```

Если DNS не разрешает имя сервера, скрипт автоматически добавит его в
`/etc/hosts`.

```bash
chmod +x 02-hq-cli-printer.sh
./02-hq-cli-printer.sh
```

Скрипт подключит `HQ-PDF`, назначит его принтером по умолчанию и отправит
тестовое задание.

Проверка:

```bash
lpstat -t
lpoptions -d
```

Печать произвольного файла:

```bash
lp /путь/к/файлу
```

## 3. Экспорт PDF на HQ-SRV

После отправки тестового задания:

```bash
chmod +x 03-hq-srv-export-pdf.sh
./03-hq-srv-export-pdf.sh
```

Проверка:

```bash
ls -l /raid/nfs/Print.pdf
```
