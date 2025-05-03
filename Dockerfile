# Stage 1: Build React frontend
FROM node:18 AS build
WORKDIR /app
COPY webAppFrontend/package.json webAppFrontend/package-lock.json ./
RUN npm install
COPY webAppFrontend/ .
RUN npm run build

# Stage 2: Build backend and serve with Nginx
FROM python:3.9-slim
RUN apt-get update && apt-get install -y nginx
WORKDIR /app
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY backend/ .
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
ENV PORT=8080
EXPOSE $PORT
CMD gunicorn -w 4 -b 0.0.0.0:5000 run:app & nginx -g 'daemon off;'