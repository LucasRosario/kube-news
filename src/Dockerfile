FROM node:18.11.0
WORKDIR /app
COPY package*.json ./
RUN npm config set strict-ssl false && npm install
COPY . .
EXPOSE 8080
CMD ["node", "server.js"]
