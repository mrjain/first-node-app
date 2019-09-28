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

# Port mapped to the docker daemon:
EXPOSE 8080
CMD ["node", "index.js"]