#!/bin/bash

# Стабильный SSH туннель к Data Infrastructure на gorky
# PostgreSQL: localhost:15432
# Kafka: localhost:19092
# MinIO API: localhost:19000
# MinIO Console: localhost:19001
# Ollama LLM: localhost:11134

set -e

SSH_HOST="gorky@zhendorenko.ru"
SSH_PORT="8205"
SSH_PASS="1q2w3e4rDFYZ"

echo "🚀 Запускаю SSH туннель к Data Infrastructure..."
echo ""
echo "📦 Сервисы доступны локально:"
echo "  🐘 PostgreSQL:     localhost:15432"
echo "  📨 Kafka:          localhost:19092"
echo "  📦 MinIO API:      localhost:19000"
echo "  🌐 MinIO Console:  localhost:19001"
echo "  🤖 Ollama LLM:     localhost:11134"
echo ""
echo "Нажмите Ctrl+C для остановки"
echo ""

# Убиваем старые SSH туннели к gorky
pkill -f "ssh.*gorky@zhendorenko.ru.*-L 15432" 2>/dev/null || true
sleep 1

# Запускаем SSH с автоматическим переподключением
while true; do
  sshpass -p "$SSH_PASS" ssh -N \
    -o StrictHostKeyChecking=no \
    -o ServerAliveInterval=30 \
    -o ServerAliveCountMax=2 \
    -o TCPKeepAlive=yes \
    -o ExitOnForwardFailure=yes \
    -p $SSH_PORT \
    -L 15432:10.43.160.145:5432 \
    -L 9092:10.43.94.232:9092 \
    -L 19092:10.43.94.232:9092 \
    -L 19000:10.43.52.146:9000 \
    -L 19001:10.43.52.146:9001 \
    -L 11134:10.43.126.193:11434 \
    $SSH_HOST
  
  exit_code=$?
  
  # Если Ctrl+C (exit code 130) - выходим
  if [ $exit_code -eq 130 ]; then
    echo ""
    echo "✅ Остановлено пользователем"
    exit 0
  fi
  
  # Иначе переподключаемся
  echo "⚠️  Соединение прервано (exit $exit_code), переподключение через 3 сек..."
  sleep 3
done
