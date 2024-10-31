FROM node:latest AS build

WORKDIR /app

COPY package*.json ./ 

RUN npm ci 

COPY . .  

RUN npm run build  

FROM nginx:latest

COPY --from=build /app/build /var/www/html

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["/usr/sbin/nginx", "-g", "daemon off;"] 
