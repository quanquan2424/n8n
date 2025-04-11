FROM n8nio/n8n:latest

# ✅ Switch sang root để cài gói
USER root

# ✅ Cài dependencies bắt buộc cho Puppeteer, Chrome, n8n
RUN apk update && apk add --no-cache \
    wget \
    ca-certificates \
    nss \
    chromium \
    font-noto \
    ttf-freefont \
    libstdc++ \
    harfbuzz \
    libxcomposite \
    libxdamage \
    libxrandr \
    libx11 \
    libxext \
    libxfixes \
    libc6-compat \
    bash \
    curl \
    nodejs \
    npm \
    corepack # ⬅️ BỔ SUNG DÒNG NÀY ĐỂ FIX LỖI `pnpm not found`

# ✅ Kích hoạt pnpm đúng cách, không bị mất trong môi trường build trên Render
RUN corepack enable && corepack prepare pnpm@10.2.1 --activate

# ✅ Cài Puppeteer đúng bản, không tự download Chromium
ENV PUPPETEER_SKIP_DOWNLOAD=true
RUN npm install -g puppeteer@19.11.1

# ✅ Cài bản Chrome 114 tương thích
RUN npx puppeteer browsers install chrome@114.0.5735.90

# ✅ Copy source code từ repo
COPY . /data
WORKDIR /data

# ✅ Phân quyền để tránh lỗi runtime
RUN chown -R node:node /data

# ✅ Cài dependencies bằng pnpm
RUN pnpm install --ignore-scripts --shamefully-hoist

# ✅ Quay lại user node để khởi động
USER node
ENV N8N_USER_FOLDER=/data

CMD ["pnpm", "start"]
