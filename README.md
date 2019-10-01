# Building a simple "Hello World" Node.js app and using AWS Fargate

This is a very simple "Hello World" Node.js app that uses the Express framework, Docker and AWS Fargate.

### What You Will learn?
- How to create a simple Node.js application with Express
- Run the Node.js app locally
- Build the Docker image and run the container locally
- Push the docker image to Amazon ECR (EC2 Container Registry)
- Use Amazon Fargate to run the container on AWS

### Pre-Requirements
First you will install Node.js and npm, this tutorial assumes you are using the MacOS:
- Node.js - https://nodejs.org/en/download/
- npm (Node Package Manager) - comes with Node.js

Docker Community Edition (CE) will be installed to build the container and run it locally
- Docker - https://hub.docker.com/signup

AWS CLI to push the Docker image to AWS ECR
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

Now we can install Express for our project with the Node Package Manager (npm). We'll need to install the following dependencies by using the following commands:
```
npm install express
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

## Creating the "Hello World" app
Create an empty file called index.js in the directory `first-node-app` by using the following command in terminal:
```
touch index.js
```

Open the file in your favorite text editor and add the following:

```
var express = require('express');

// Constants
var PORT = 2000;

// App
var app = express();
app.get('/', function (req, res){
  res.send('Hello world, Node.js app running on Docker');
});

app.listen(PORT);
console.log('Running on http://localhost:' + PORT);
```

## Running the application locally
In the directory `first-node-app/` type the following code to run our application:
```
node index.js
```
You should see a message like the following in your terminal window:

`Running on http://localhost:2000`

If you open a browser and go to localhost:2000 you will see the following: 

`Hello world, Node.js app running on Docker`

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
EXPOSE 80
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
The -p flag redirects a public port to a private port inside the container. In this case 80 is the port you use on the browser and it will map to port 2000 which the app is running in the container. Running your image with -d runs the container in detached mode, leaving the container running in the background.

```
docker run -p 80:2000 -d <your username>/first-node-app
```

If you open a browser and go to localhost you will see the following in your browser: 

`Hello world, Node.js app running on Docker`


## Push the Docker image to AWS ECR
Before you can push the Docker image to AWS ECR you need to visit the AWS Management Console and create a new ECR Repository. Once it's created select the repo and click on "View push commands"

In the directory `first-node-app/` type the following:
```
$(aws ecr get-login --no-include-email --region ap-south-1)
```

Build the Docker image:
```
docker build -t first-node-app .
```

After the build completes, tag your image so you can push the image to this repository:
```
docker tag first-node-app:latest 1xxxxxxxxx.dkr.ecr.ap-south-1.amazonaws.com/first-node-app:latest
```
push this image to your newly created AWS repository:
```
docker push 1xxxxxxxxx.dkr.ecr.ap-south-1.amazonaws.com/first-node-app:latest
```
## Run the Docker image using AWS Fargate
Goto the AWS Management Console and select Amazon ECS and create a new Cluster using the "Get Started" wizard.

For Container definition select Custom and configure it. The image name is the URI:
```
1xxxxxxxxx.dkr.ecr.ap-south-1.amazonaws.com/first-node-app
```
In port mappings enter 80

Then click Update, then Next. For define your service select Application Load Balancer. Then select Next, then Next again and then select Create.

When all the AWS resources are created goto EC2 Load Balancers and fine the load balancer that was just created and select the DNS name and enter that into a browser window. It should show the following:

`
Hello world, Node.js app running on Docker
`

## Updating the app
If you make changes to the app locally, then you will have to rebuild the Docker image and then push that to AWS ECR. Then you will have to edit the Services and "Force update" to see the changes appear.