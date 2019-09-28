# Base image
FROM node

# Create app directory
WORKDIR /usr/src/app

# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./

# Installing the project dependencies
RUN npm install

# Bundle app source
COPY . .

# Port mapped to the docker daemon, this is the port that your app is running on:
EXPOSE 80
CMD ["node", "index.js"]