FROM n8nio/n8n:latest

# ✅ Sử dụng user root để cài thư viện hệ thống
USER root

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

# ✅ Cài Puppeteer & Browser
RUN npm install -g puppeteer@19.11.1
RUN npx puppeteer browsers install chrome@114.0.5735.90

# ✅ Copy mã nguồn
COPY . /data
WORKDIR /data

# ✅ Sửa quyền cho user node
RUN chown -R node:node /data

# ✅ Cài đặt các gói bằng pnpm
RUN pnpm install --ignore-scripts

# ✅ Chạy n8n bằng user node
USER node
ENV N8N_USER_FOLDER=/data

CMD ["pnpm", "start"]
