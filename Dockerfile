FROM n8nio/n8n

USER root

# Install dependencies for Chromium & Puppeteer
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
    corepack \
    && rm -rf /var/cache/apk/*

# Enable pnpm via corepack
RUN corepack enable

# Puppeteer Chromium path env
ENV PUPPETEER_EXECUTABLE_PATH=/usr/lib/chromium/chromium

# Optional: set correct permissions if needed
ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
