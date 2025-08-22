#FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntujammy
FROM node:22.18

# Using Root to enable SYS_ADMIN capabilities (for running the browser in sandbox mode )
USER root 

# Update package lists and upgrade packages
#RUN apt-get update && apt-get upgrade -y

# Install latest chrome dev package
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
RUN apt-get update \
    && apt-get install -y nano wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

ENV TZ "Asia/Ho_Chi_Minh"

# Install Puppeteer under /node_modules so it's available system-wide
#COPY package.json /app/
#COPY . /app/
#RUN cd /app/ && npm install

ADD code.zip /app/code.zip

RUN mkdir -p /app && cd /app && unzip -qo code.zip && npm install && rm -rf code.zip || true

WORKDIR /app

#CMD ["npm", "start"]
ENTRYPOINT node server.js
