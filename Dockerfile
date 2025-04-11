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

# ✅ Cài pnpm & fix quyền sử dụng cho user node
RUN corepack enable && corepack prepare pnpm@8.15.4 --activate \
  && ln -sf $(which pnpm) /usr/local/bin/pnpm

COPY . /data
WORKDIR /data

# ✅ Sửa quyền /data để tránh lỗi EACCES
RUN chown -R node:node /data

# ✅ Cài dependencies
RUN pnpm install --ignore-scripts

USER node
ENV N8N_USER_FOLDER=/data

CMD ["pnpm", "start"]
