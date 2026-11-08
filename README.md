# infra-monitoring-project

Практическое задание по мониторингу API, анализу логов и контейнеризации.

## Запуск

Из корня проекта:

```bash
docker-compose up -d
docker-compose ps
curl http://localhost:80
./check_api.sh http://localhost:80
./analyze_logs.sh
```

Прокси на порту 80 должен вернуть `Monitoring Service Active`. Скрипт анализа создаёт `access.log` с 300 запросами и выводит общее число запросов, топ-3 IP-адреса и количество ответов 4xx и 5xx.

## Передача на удалённый сервер через SSH и SCP

На локальной машине создайте отдельную пару ключей и скопируйте на сервер только публичный ключ. В командах замените `USER` и `SERVER_IP` на имя пользователя и адрес сервера:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_infra_monitoring
ssh-copy-id -i ~/.ssh/id_ed25519_infra_monitoring.pub USER@SERVER_IP
tar -czf ../infra-monitoring-project.tar.gz --exclude=.git --exclude=access.log -C .. infra-monitoring-project
scp -i ~/.ssh/id_ed25519_infra_monitoring ../infra-monitoring-project.tar.gz USER@SERVER_IP:/tmp/
ssh -i ~/.ssh/id_ed25519_infra_monitoring USER@SERVER_IP 'mkdir -p ~/infra-monitoring && tar -xzf /tmp/infra-monitoring-project.tar.gz -C ~/infra-monitoring && cd ~/infra-monitoring/infra-monitoring-project && docker-compose up -d'
```
