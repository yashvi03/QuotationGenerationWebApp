FROM node:18 AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html


# EXPOSE $PORT
# CMD ["nginx", "-g", "daemon off;"]

RUN echo 'server { \
  listen $PORT; \
  location / { \
    root /usr/share/nginx/html; \
    index index.html index.htm; \
    try_files $uri $uri/ /index.html =404; \
  } \
}' > /etc/nginx/conf.d/default.conf.template

# Create startup script
RUN echo '#!/bin/sh \
envsubst "\$PORT" < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf \
nginx -g "daemon off;"' > /start.sh && chmod +x /start.sh

CMD ["/start.sh"]