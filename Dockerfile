FROM n8nio/n8n:latest

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

# ✅ Cài Puppeteer và Chrome
RUN npm install -g puppeteer@19.11.1
RUN npx puppeteer browsers install chrome@114.0.5735.90

# ✅ Copy code vào image
COPY . /data
WORKDIR /data

# ✅ Bật corepack và chuẩn bị pnpm
RUN corepack enable && corepack prepare pnpm@8.15.4 --activate

# ✅ Sửa quyền cho user node
RUN chown -R node:node /data

# ✅ Cài các dependencies
RUN pnpm install --ignore-scripts

# ✅ Chạy bằng user node
USER node
ENV N8N_USER_FOLDER=/data

CMD ["pnpm", "start"]
