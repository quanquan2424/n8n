FROM n8nio/n8n:latest

USER root

# ✅ Cài đặt các gói cần thiết để hỗ trợ Chrome / Puppeteer
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

# ✅ Cài đặt Puppeteer (bản cũ để tương thích với n8n node tùy chỉnh)
RUN npm install -g puppeteer@19.11.1

# ✅ Cài Chrome phiên bản tương thích với Puppeteer
RUN npx puppeteer browsers install chrome@114.0.5735.90

# ✅ Cài pnpm trực tiếp qua npm (không dùng corepack, tránh lỗi)
RUN npm install -g pnpm@10.8.0 --force

# ✅ Kiểm tra phiên bản sau khi cài xong
RUN node -v && npm -v && pnpm -v

# ✅ Copy source vào container
COPY . /data
WORKDIR /data

# ✅ Sửa quyền thư mục để user `node` truy cập được
RUN chown -R node:node /data

# ✅ Cài dependencies bằng pnpm (sau khi đã đổi quyền)
RUN pnpm install --ignore-scripts

# ✅ Chạy với user node để an toàn
USER node
ENV N8N_USER_FOLDER=/data

# ✅ Khởi chạy n8n bằng pnpm
CMD ["pnpm", "start"]
