FROM n8nio/n8n:latest

# ✅ Switch sang root để cài gói hệ thống
USER root

# ✅ Cập nhật hệ thống + cài Chrome dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg \
    ca-certificates \
    fonts-noto \
    fonts-freefont-ttf \
    chromium \
    bash \
    nodejs \
    npm \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libgbm-dev \
    libnss3 \
    libxss1 \
    libasound2 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libxext6 \
    libxfixes3 \
    libglib2.0-0 \
    libdrm2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ✅ Kích hoạt pnpm đúng cách (Debian dùng corepack cũng được)
RUN npm install -g corepack && corepack enable && corepack prepare pnpm@10.2.1 --activate

# ✅ Cài Puppeteer & Chrome
ENV PUPPETEER_SKIP_DOWNLOAD=true
RUN npm install -g puppeteer@19.11.1 && npx puppeteer browsers install chrome@114.0.5735.90

# ✅ Copy code từ repo vào container
COPY . /data
WORKDIR /data

# ✅ Phân quyền cho user node
RUN chown -R node:node /data

# ✅ Cài dependencies của n8n custom
RUN pnpm install --ignore-scripts --shamefully-hoist

# ✅ Quay lại user node để run
USER node
ENV N8N_USER_FOLDER=/data

CMD ["pnpm", "start"]
