FROM n8nio/n8n:latest

# ✅ Switch sang root để cài gói
USER root

# ✅ Cài các dependency bắt buộc cho Puppeteer, Chrome, n8n
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

# ✅ Cài đúng bản Puppeteer, ngăn nó tự nâng cấp Chrome
ENV PUPPETEER_SKIP_DOWNLOAD=true
RUN npm install -g puppeteer@19.11.1

# ✅ Cài đúng bản Chrome 114
RUN npx puppeteer browsers install chrome@114.0.5735.90

# ✅ Cài pnpm bản tương thích, đảm bảo PATH đúng
RUN corepack enable && corepack prepare pnpm@10.2.1 --activate

# ✅ Copy source code
COPY . /data
WORKDIR /data

# ✅ Phân quyền chính xác để tránh lỗi permission
RUN chown -R node:node /data

# ✅ Cài dependencies dưới quyền root để tránh lỗi quyền
RUN pnpm install --ignore-scripts --shamefully-hoist

# ✅ Dùng đúng user n8n yêu cầu
USER node
ENV N8N_USER_FOLDER=/data

# ✅ Khởi chạy n8n custom
CMD ["pnpm", "start"]
