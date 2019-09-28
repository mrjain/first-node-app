# Building a simple "Hello World" Node.js app and using AWS Fargate

This is a very simple "Hello World" Node.js app that uses the Express framework, Docker and AWS Fargate.

### What am I going to learn?
- How to create a Node.js application with Express
- Run the Node app locally
- Build the Docker image and run it locally as a Docker container
- Push the docker image to Amazon ECR (Elastic Container Registry)
- Use Amazon Fargate to run the container

### Requirements
- Node.js - https://nodejs.org/en/download/
- npm - comes with Node.js
- Express - we will install below
- Docker - https://hub.docker.com/signup
- AWS CLI - https://aws.amazon.com/cli/
 
## Building the project's folder structure and installing the project's dependencies

Create a directory for the project. In the terminal, we're going to create a folder and navigate to it.
```
mkdir first-node-app
cd first-node-app
```

Now we're going to initiate a new npm project by typing the following command, and leaving blank the inputs by pressing enter:
```
npm init
```

If we take a look at the directory, we can see a new file named `package.json`. This file will be responsible for the management of our project's dependencies.
```
{
  "name": "first-node-app",
  "version": "1.0.0",
  "description": "My First Node.js app",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC",
  "dependencies": {
    "express": "^4.17.1"
  }
}
```
Now we can install Express for our project with the Node Package Manager (npm). We'll need to install the following dependencies by using the following commands:
```
npm install express
```

## Creating the "Hello World" app
Create an empty file called index.js in the directory `first-node-app` by using the following command in terminal:
```
touch index.js
```

Open the file in your favorite text editor and add the following:

```
'use strict';

const express = require('express');

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';

// App
const app = express();
app.get('/', (req, res) => {
  res.send('Hello world, my first Node.js app using Docker.');
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);
```

## Running the application locally
In the directory `first-node-app/` type the following code to run our application:
```
node index.js
```
You should see a message like the following in your terminal window:

`Running on http://0.0.0.0:8080`

If you open a browser and go to localhost:8080 you will see the following: 

`Hello world, my first Node.js app using Docker.`

## Creating a Dockerfile
Create an empty file called Dockerfile in the directory `first-node-app` by using the following command in terminal:
```
touch Dockerfile
```

Open the Dockerfile and add the following:
```
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
```
## Building your Docker image
Go to the directory that has your Dockerfile and run the following command to build the Docker image. The -t flag lets you tag your image so it's easier to find later using the docker images command:

```
docker build -t <your username>/first-node-app .
```
Your image will now be listed by Docker:
```
$ docker images

# Example
REPOSITORY                      TAG        ID              CREATED
node                            10         1934b0b038d1    5 days ago
<your username>/first-node-app    latest     d64d3505b0d2    1 minute ago
```
## Run the Docker image locally
Running your image with -d runs the container in detached mode, leaving the container running in the background. The -p flag redirects a public port to a private port inside the container. Run the image you previously built:

```
docker run -p 80:8080 -d <your username>/first-node-app
```

If you open a browser and go to localhost you will see the following: 

`Hello world, my first Node.js app using Docker.`


## Push the Docker image to AWS ECR


## Run the Docker image using AWS Fargate

## Updating the app
If you make changes to the app locally, then you will have to rebuild the Docker image and then push that to AWS ECR. Then you will have to edit the Services and "Force update" to see the changes appear.