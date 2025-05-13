# ---- Build React Frontend ----
    FROM node:18 AS frontend
    WORKDIR /app
    COPY webAppFrontend/ ./
    RUN npm install && npm run build
    
    # ---- Build Python Backend ----
    FROM python:3.10-slim AS backend
    WORKDIR /app
    COPY backend/ /app/
    COPY backend/requirements.txt .
    RUN pip install --no-cache-dir -r requirements.txt
    
    # ---- Final Image with Nginx ----
    FROM nginx:alpine
    # Copy React build output
    COPY --from=frontend /app/build /usr/share/nginx/html
    # Copy backend code
    COPY --from=backend /app /backend
    # Copy Nginx config
    COPY nginx/default.conf /etc/nginx/conf.d/default.conf
    
    # Install Python and backend dependencies
    RUN apk add --no-cache python3 py3-pip && \
        pip3 install gunicorn && \
        pip3 install -r /backend/requirements.txt
    
    # Expose port 80 (Nginx)
    EXPOSE 80
    
    # Start Flask backend and Nginx
    CMD sh -c "gunicorn --chdir /backend run:app -b 127.0.0.1:5000 & nginx -g 'daemon off;'"
    