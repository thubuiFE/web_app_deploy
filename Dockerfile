FROM node:lts-alpine as build  # Use Node.js LTS Alpine image as build environment

WORKDIR /app  # Set working directory inside the container to /app

COPY package*.json ./  # Copy package.json and package-lock.json files to /app directory

RUN npm ci  # Install dependencies using npm CI mode for faster and consistent builds

COPY . .  # Copy the rest of the application files to /app directory

RUN npm run build  # Build the application using npm script

FROM nginx:latest as prod  # Use the latest Nginx image as production environment

COPY --from=build /app/build /usr/share/nginx/html  # Copy built files from the previous stage to Nginx HTML directory

COPY nginx.conf /etc/nginx/nginx.conf  # Copy custom Nginx configuration file to override default configuration

EXPOSE 80/tcp  # Expose port 80 for incoming HTTP traffic

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]  # Start Nginx server with daemon off for foreground execution
