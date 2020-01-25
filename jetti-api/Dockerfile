FROM node
# Create app directory
RUN mkdir -p /usr/jetti
WORKDIR /usr/jetti

# Install app dependencies
COPY package.json ./package.json
RUN npm i

#COPY ngsw-config.json ./ngsw-config.json
COPY server/ ./server
COPY tsconfig.json ./server/tsconfig.json
RUN node_modules/typescript/bin/tsc -p ./server

ENV PORT 8080
EXPOSE 8080

CMD [ "node", "./server/dist/index.js" ]
#docker build -t eu.gcr.io/jetti-x100/jetti-api:latest .
#docker push eu.gcr.io/jetti-x100/jetti-api:latest
