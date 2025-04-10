FROM n8nio/n8n:latest

# 🔐 Sử dụng quyền root để cài puppeteer + dependencies
USER root

# 🧩 Cài thêm thư viện hệ thống để chạy Chromium trong Puppeteer
RUN apk update && apk add --no-cache \
    wget \
    ca-certificates \
    nss \
    chromium \
    font-noto \
    ttf-freefont \
    nodejs \
    npm \
    libstdc++ \
    harfbuzz \
    libxcomposite \
    libxdamage \
    libxrandr \
    libx11 \
    libxext \
    libxfixes \
    libc6-compat

# 🧠 Cài puppeteer phiên bản cụ thể
RUN npm install -g puppeteer@19.11.1

# 📦 Cài thêm Chromium dùng riêng cho Puppeteer
RUN npx puppeteer browsers install chrome@114.0.5735.90

# 📁 Copy source project vào image
COPY . /data
WORKDIR /data

# 📦 Cài đặt dependencies từ repo n8n đã clone
RUN pnpm install --ignore-scripts

# 📂 Set thư mục user cho n8n
ENV N8N_USER_FOLDER=/data

# 👤 Trả quyền lại cho user node để chạy app an toàn
USER node

# 🚀 Lệnh chạy n8n
CMD ["pnpm", "start"]
