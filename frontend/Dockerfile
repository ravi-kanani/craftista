FROM node:lts

WORKDIR /usr/local/app

COPY . .

RUN npm i

EXPOSE 3000

ENTRYPOINT ["npm", "run", "start"]