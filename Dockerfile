# Base image: node + debian slim (ổn định, dễ cài puppeteer/chromium)
FROM node:20-slim

# 1. Tạo thư mục làm việc
WORKDIR /data

# 2. Cài các dependency cần thiết cho Puppeteer, Chrome, Font, Corepack, Bash
RUN apt-get update && apt-get install -y \
  wget \
  curl \
  gnupg \
  ca-certificates \
  fonts-noto \
  fonts-freefont-ttf \
  chromium \
  bash \
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
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# 3. Bật corepack và cài pnpm (theo kim chỉ nam)
RUN corepack enable && corepack prepare pnpm@latest --activate

# 4. Cài puppeteer (nếu bạn cần sẵn global)
RUN npm install -g puppeteer

# 5. Copy toàn bộ mã nguồn n8n từ repo vào image
COPY . .

# 6. Build n8n
RUN pnpm install && pnpm build

# 7. Cấu hình môi trường
ENV N8N_DISABLE_PRODUCTION_MAIN_PROCESS=true
ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

# 8. Mở port
EXPOSE 5678

# 9. Chạy n8n
CMD ["pnpm", "start"]
