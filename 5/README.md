# Модуль 3, задание 5

## 1. HQ-SRV

```bash
chmod +x 01-hq-srv-cups.sh
./01-hq-srv-cups.sh
```

## 2. HQ-CLI

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
