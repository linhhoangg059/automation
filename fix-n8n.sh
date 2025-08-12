#!/bin/bash
set -e

echo "[1/4] Tạo thư mục dữ liệu và set quyền..."
mkdir -p /root/.n8n
chown -R 1000:1000 /root/.n8n

echo "[2/4] Tạo docker-compose.yml..."
mkdir -p ~/n8n
cat > ~/n8n/docker-compose.yml <<'YAML'
version: "3.9"
services:
  n8n:
    image: n8nio/n8n:1.60.0
    command: n8n
    restart: always
    ports:
      - "5678:5678"
    environment:
      - N8N_HOST=auto.loachuyentien.click
      - N8N_PROTOCOL=https
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=matkhau123
    user: "1000:1000"
    volumes:
      - /root/.n8n:/home/node/.n8n
YAML

echo "[3/4] Kéo image và khởi chạy container..."
cd ~/n8n
docker compose down || true
docker pull n8nio/n8n:1.60.0
docker compose up -d

echo "[4/4] Hoàn tất!"
docker ps
echo "Truy cập: https://auto.loachuyentien.click"
echo "Đăng nhập: admin / matkhau123"
