# Модуль 3, задание 2: CA и HTTPS

В этой реализации используется совместимая схема RSA-4096 и SHA-256.
Сертификаты действуют `30` дней и содержат оба DNS-имени:

- `web.au-team.irpo`;
- `docker.au-team.irpo`.

Это намеренное отступление от требования отечественных алгоритмов для
совместимости с обычным Yandex Browser и Chromium.

## Параметры

Перед запуском проверьте `.env`:

```bash
CERT_DAYS=30
CA_DAYS=30
RSA_KEY_BITS=4096

ISP_IP=172.16.4.1
HQ_CLI_IP=192.168.2.10
WEB_UPSTREAM=172.16.4.4:8080
DOCKER_UPSTREAM=172.16.5.5:8080
```

## Порядок запуска

На `ISP`:

```bash
bash 00-isp-prepare.sh
```

На `HQ-SRV`:

```bash
bash 01-hq-srv-issue-certificates.sh
```

На `ISP`:

```bash
bash 02-isp-nginx-https.sh
```

На `HQ-CLI`:

```bash
bash 03-hq-cli-trust-ca.sh
```

Скрипт `HQ-SRV` автоматически передаёт сертификат и ключ на `ISP`, а
корневой сертификат на `HQ-CLI`.

## Результат

Центр сертификации на `HQ-SRV`:

```text
/root/au-team-ca
```

Сертификат и закрытый ключ nginx:

```text
/etc/nginx/ssl/web.crt
/etc/nginx/ssl/web.key
```

Корневой сертификат на `HQ-CLI`:

```text
/etc/pki/ca-trust/source/anchors/au-team-ca.crt
```

Nginx перенаправляет HTTP на HTTPS. Basic Auth применяется только к
`web.au-team.irpo`. Для обоих приложений добавляется
`Content-Security-Policy: upgrade-insecure-requests` и передаются заголовки
`X-Forwarded-Proto`, `X-Forwarded-Host` и `X-Forwarded-Port`, чтобы ресурсы
CSS/JS не блокировались как mixed content.

## Проверка

На `HQ-CLI`:

```bash
curl -I https://web.au-team.irpo/
curl -u 'WEB:P@ssw0rd' https://web.au-team.irpo/ | head
curl https://docker.au-team.irpo/ | head
```

Параметр `-k` использовать нельзя.

В обычном Yandex Browser или Chromium:

```text
https://web.au-team.irpo/
https://docker.au-team.irpo/
```

Если браузер был открыт во время установки CA, полностью перезапустите его.

Проверка сертификата на `HQ-SRV`:

```bash
openssl x509 -in /root/au-team-ca/web.crt -noout -subject -issuer -dates
openssl x509 -in /root/au-team-ca/web.crt -noout -text |
    grep -E 'Public Key Algorithm|Signature Algorithm|DNS:'
```
