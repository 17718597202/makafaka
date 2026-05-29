#!/bin/bash

# ==============================================================================
#  MakaFaka 自动发卡平台 - Ubuntu 20.04/22.04 LTS 一键生产部署脚本
# ==============================================================================

# 颜色控制
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}======================================================${NC}"
echo -e "${GREEN}      开始安装 & 部署 MakaFaka 自动发卡平台（Ubuntu）    ${NC}"
echo -e "${GREEN}======================================================${NC}"

# 确保以 root 权限运行
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}错误: 请使用 sudo 运行此脚本！${NC}"
  exit 1
fi

# 1. 基础依赖项安装
echo -e "${YELLOW}1. 正在更新系统软件包并安装基础依赖项...${NC}"
apt-get update -y
apt-get install -y git curl wget build-essential ufw gnupg2 ca-certificates lsb-release

# 2. 安装 JDK 21 (Eclipse Temurin)
echo -e "${YELLOW}2. 正在安装 Eclipse Temurin JDK 21...${NC}"
if ! java -version 2>&1 | grep -q "21."; then
  mkdir -p /etc/apt/keyrings
  wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc > /dev/null
  echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/adoptium.list
  apt-get update -y
  apt-get install -y temurin-21-jdk
else
  echo -e "${GREEN}JDK 21 已经安装${NC}"
fi

# 3. 安装 Maven
echo -e "${YELLOW}3. 正在安装 Maven...${NC}"
apt-get install -y maven

# 4. 安装 Node.js 20.x & PM2
echo -e "${YELLOW}4. 正在安装 Node.js 和 PM2...${NC}"
if ! node -v 2>&1 | grep -q "v20"; then
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  apt-get install -y nodejs
  npm install -g pm2
else
  echo -e "${GREEN}Node.js 已经安装${NC}"
fi

# 5. 安装 PostgreSQL 15 并配置密码
echo -e "${YELLOW}5. 正在安装 PostgreSQL 数据库...${NC}"
if ! command -v psql &> /dev/null; then
  sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
  apt-get update -y
  apt-get install -y postgresql-15 postgresql-contrib-15
  systemctl start postgresql
  systemctl enable postgresql

  echo -e "${YELLOW}正在为 postgres 用户设置默认密码 'postgres'...${NC}"
  sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"
else
  echo -e "${GREEN}PostgreSQL 已经安装${NC}"
fi

# 6. 初始化 PostgreSQL 数据库
echo -e "${YELLOW}6. 正在初始化 MakaFaka 数据库...${NC}"
sudo -u postgres psql -c "SELECT 1 FROM pg_database WHERE datname = 'db'" | grep -q 1
if [ $? -ne 0 ]; then
  sudo -u postgres psql -c "CREATE DATABASE db;"
  echo -e "${GREEN}已成功创建数据库: db${NC}"
else
  echo -e "${YELLOW}数据库 db 已存在，跳过创建。${NC}"
fi

# 7. 安装 Nginx
echo -e "${YELLOW}7. 正在安装并配置 Nginx 接入层...${NC}"
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx

# 8. 编译并打包 Java 后端 (API)
echo -e "${YELLOW}8. 正在编译并打包后端 Spring Boot 应用程序...${NC}"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "${SCRIPT_DIR}/apps/api"
mvn clean package -DskipTests
if [ $? -ne 0 ]; then
  echo -e "${RED}后端打包失败，请检查 Maven 依赖！${NC}"
  exit 1
fi
echo -e "${GREEN}后端打包成功！${NC}"

# 创建上传目录并复制初始精美封面图片
mkdir -p "${SCRIPT_DIR}/apps/api/uploads"
cp -rf "${SCRIPT_DIR}/apps/api/uploads/"* "/var/www/uploads" 2>/dev/null || mkdir -p /var/www/uploads

# 9. 部署后端为 Systemd 系统服务
echo -e "${YELLOW}9. 正在注册并启动后端系统服务 (makafaka-api.service)...${NC}"
JAR_PATH="${SCRIPT_DIR}/apps/api/target/api-0.0.1-SNAPSHOT.jar"
if [ ! -f "$JAR_PATH" ]; then
  JAR_PATH=$(find "${SCRIPT_DIR}/apps/api/target" -name "*.jar" | head -n 1)
fi

cat <<EOF > /etc/systemd/system/makafaka-api.service
[Unit]
Description=MakaFaka API Service
After=syslog.target network.target postgresql.service

[Service]
User=root
Type=simple
WorkingDirectory=${SCRIPT_DIR}/apps/api
ExecStart=/usr/bin/java -jar ${JAR_PATH} --spring.profiles.active=default
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=makafaka-api

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable makafaka-api
systemctl restart makafaka-api
echo -e "${GREEN}后端服务已成功启动并设定开机自启！${NC}"

# 等待 12 秒，让 Spring Boot 容器完全启动并由 Hibernate 自动建表
echo -e "${YELLOW}正在等待 Spring Boot 服务启动并由 Hibernate 自动生成表结构...${NC}"
sleep 12

# 导入精美商品种子数据
SEED_SQL="${SCRIPT_DIR}/apps/api/src/main/resources/seed_makafaka.sql"
if [ -f "$SEED_SQL" ]; then
  echo -e "${YELLOW}正在导入您刚才生成的 VPN、Facebook 和 ChatGPT 精美商品种子数据 (seed_makafaka.sql)...${NC}"
  PGPASSWORD=postgres psql -h localhost -U postgres -d db -f "$SEED_SQL"
  echo -e "${GREEN}商品种子数据导入成功！${NC}"
fi

# 10. 编译并启动 Node.js 前端 (Next.js)
echo -e "${YELLOW}10. 正在编译并启动前端 Next.js 应用程序...${NC}"
cd "${SCRIPT_DIR}/apps/web"
npm install --legacy-peer-deps
npm run build
if [ $? -ne 0 ]; then
  echo -e "${RED}前端构建失败！${NC}"
  exit 1
fi

# 使用 PM2 运行前端应用
pm2 delete makafaka-web 2>/dev/null
PORT=3010 pm2 start .next/standalone/server.js --name "makafaka-web"
pm2 save
pm2 startup
echo -e "${GREEN}前端服务已被 PM2 接管并在 Port 3010 启动成功！${NC}"

# 11. 配置 Nginx 虚拟主机与反向代理
echo -e "${YELLOW}11. 正在编写 Nginx 配置文件...${NC}"
cat <<'EOF' > /etc/nginx/sites-available/makafaka
server {
    listen 80;
    server_name localhost; # 线上请修改为您的实际域名 (如: makafaka.com)

    # 上传文件大小限制
    client_max_body_size 50M;

    # 静态图片/上传文件目录代理
    location /api/uploads/ {
        alias /var/www/uploads/;
        autoindex off;
        expires 30d;
        add_header Cache-Control "public, no-transform";
    }

    # 后端接口代理
    location /api/ {
        proxy_pass http://127.0.0.1:8083/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # 前端代理
    location / {
        proxy_pass http://127.0.0.1:3010;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

# 移动上传封面资源到 Nginx 访问目录
mkdir -p /var/www/uploads
cp -rf ${SCRIPT_DIR}/apps/api/uploads/* /var/www/uploads/ 2>/dev/null
chmod -R 755 /var/www/uploads

# 激活 Nginx 配置并重启
rm -f /etc/nginx/sites-enabled/default
rm -f /etc/nginx/sites-enabled/makafaka
ln -s /etc/nginx/sites-available/makafaka /etc/nginx/sites-enabled/makafaka
nginx -t
if [ $? -eq 0 ]; then
  systemctl restart nginx
  echo -e "${GREEN}Nginx 配置并重启成功！${NC}"
else
  echo -e "${RED}Nginx 配置文件校验失败！请检查配置！${NC}"
fi

# 12. 风控防火墙设置 (UFW)
echo -e "${YELLOW}12. 正在开通服务器防火墙端口...${NC}"
ufw allow ssh
ufw allow http
ufw allow https
echo "y" | ufw enable
ufw status

echo -e "${GREEN}======================================================${NC}"
echo -e "${GREEN}          🎉 MakaFaka 平台已成功部署至本地！🎉        ${NC}"
echo -e "${GREEN}   1. 前端已在后台运行 (PM2): Port 3010                ${NC}"
echo -e "${GREEN}   2. 后端 API 已经在后台运行 (Systemd): Port 8083      ${NC}"
echo -e "${GREEN}   3. Nginx 代理网关已在 Port 80 监听您的访问            ${NC}"
echo -e "${GREEN}   直接在浏览器输入服务器的 IP 或域名即可打开商铺体验！     ${NC}"
echo -e "${GREEN}======================================================${NC}"
