FROM n8nio/n8n:latest

# ✅ Switch sang root để cài gói
USER root

# ✅ Cài các dependency cho Puppeteer + Chrome + n8n
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
    npm

# ✅ Ngăn Puppeteer tự tải Chrome mới + chỉ định bản cần thiết
ENV PUPPETEER_SKIP_DOWNLOAD=true
RUN npm install -g puppeteer@19.11.1

# ✅ Cài đúng Chrome v114 tương thích với Puppeteer 19
RUN npx puppeteer browsers install chrome@114.0.5735.90

# ✅ Cài pnpm tương thích
RUN corepack enable && corepack prepare pnpm@10.2.1 --activate

# ✅ Copy source code
COPY . /data
WORKDIR /data

# ✅ Phân quyền thư mục
RUN chown -R node:node /data

# ✅ Cài dependencies với root để tránh lỗi
RUN pnpm install --ignore-scripts --shamefully-hoist

# ✅ Switch về user node cho n8n
USER node
ENV N8N_USER_FOLDER=/data

# ✅ Khởi chạy n8n custom
CMD ["pnpm", "start"]
