FROM n8nio/n8n:latest

# ✅ Switch to root to install dependencies
USER root

# ✅ Cài hệ thống cần thiết cho puppeteer
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

# ✅ Cài puppeteer & browser
RUN npm install -g puppeteer@19.11.1
RUN npx puppeteer browsers install chrome@114.0.5735.90

# ✅ Cài pnpm bằng corepack (an toàn hơn)
RUN corepack enable && corepack prepare pnpm@8.15.4 --activate

# ✅ Set thư mục làm việc, sao chép source code
COPY . /data
WORKDIR /data

# ✅ Phân quyền cho user node (tránh lỗi EACCES)
RUN chown -R node:node /data

# ✅ Cài gói bằng pnpm, dưới quyền root (safe)
RUN pnpm install --ignore-scripts

# ✅ Switch lại user node (đúng chuẩn n8n)
USER node
ENV N8N_USER_FOLDER=/data

CMD ["pnpm", "start"]
