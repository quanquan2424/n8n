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

# ✅ Cài puppeteer và browser
RUN npm install -g puppeteer@19.11.1
RUN npx puppeteer browsers install chrome@114.0.5735.90

# ✅ Cài pnpm đúng cách (không symlink)
RUN corepack enable && corepack prepare pnpm@8.15.4 --activate

COPY . /data
WORKDIR /data

# ✅ Sửa quyền thư mục để user node dùng được
RUN chown -R node:node /data

# ✅ Cài dependencies bằng pnpm
RUN pnpm install --ignore-scripts

# ✅ Đảm bảo dùng đúng user
USER node
ENV N8N_USER_FOLDER=/data

CMD ["pnpm", "start"]
