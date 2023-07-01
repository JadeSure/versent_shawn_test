FROM node:18-alpine 

#Next we create a directory to hold the application code inside the image
WORKDIR /app
# Install dependencies based on the preferred package manager
COPY ["package.json", "package-lock.json", "./"]

# RUN yarn install --production=true
RUN npm ci
    #To bundle your app's source code inside the Docker image, use the COPY instruction:
COPY . .

CMD ["npm", "start"]
