FROM --platform=linux/amd64 node:16
WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .
EXPOSE 11111
CMD ["node", "app.js"]