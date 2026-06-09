# Отчёт: виртуальный принтер CUPS

На HQ-SRV установлен CUPS и backend `cups-pdf`.

Основные параметры:

- сервер: `hq-srv.au-team.irpo`;
- порт IPP: `631/tcp`;
- серверная очередь: `Cups-PDF`;
- клиентская очередь: `HQ-PDF`;
- URI: `ipp://hq-srv.au-team.irpo:631/printers/Cups-PDF`;
- клиентская очередь `HQ-PDF` назначена принтером по умолчанию;
- результат тестовой печати экспортирован в `/raid/nfs/Print.pdf`.
