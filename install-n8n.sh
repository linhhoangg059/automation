#!/bin/bash
set -e

DOMAIN="auto.loachuyentien.click"
USERNAME="admin"
PASSWORD="matkhau123"

echo "[1/5] Cập nhật hệ thống và cài Docker..."
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "[2/5] Tạo thư mục và file docker-compose cho n8n..."
mkdir -p ~/n8n && cd ~/n8n
cat > docker-compose.yml <<YAML
version: "3.9"
services:
  n8n:
    image: n8nio/n8n:latest
    restart: always
    ports:
      - "5678:5678"
    environment:
      - N8N_HOST=${DOMAIN}
      - N8N_PROTOCOL=https
      - N8N_PORT=5678
      - N8N_EDITOR_BASE_URL=https://${DOMAIN}/
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=${USERNAME}
      - N8N_BASIC_AUTH_PASSWORD=${PASSWORD}
    volumes:
      - ~/.n8n:/home/node/.n8n
YAML

echo "[3/5] Khởi chạy n8n container..."
docker compose up -d

echo "[4/5] Kiểm tra container..."
docker ps

echo "[5/5] Hoàn tất!"
echo "Truy cập n8n tại: https://${DOMAIN}"
echo "Đăng nhập: ${USERNAME} / ${PASSWORD}"
