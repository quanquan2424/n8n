FROM n8nio/n8n:latest

RUN npm install -g puppeteer@19.11.1
RUN npx puppeteer browsers install chrome@114.0.5735.90

ENV PUPPETEER_EXECUTABLE_PATH=/root/.cache/puppeteer/chrome/linux-114.0.5735.90/chrome-linux/chrome
