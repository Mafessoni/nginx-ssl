FROM node:18

WORKDIR /app

COPY package.json ./
COPY tsconfig.json ./
COPY index.ts ./

RUN yarn install
RUN yarn build

RUN cd ./dist

WORKDIR /app/dist

CMD ["node","index.js"]

# EXPOSE 3000