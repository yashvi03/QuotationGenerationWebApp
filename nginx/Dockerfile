FROM nginx:alpine
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE $PORT
CMD ["nginx", "-g", "daemon off;"]