# ---- Build React Frontend ----
    FROM node:18 AS frontend
    WORKDIR /app
    COPY webAppFrontend/ ./
    RUN npm install && npm run build
    
    # ---- Build Python Backend ----
    FROM python:3.10-slim AS backend
    WORKDIR /app
    COPY requirements.txt .
    RUN pip install --upgrade pip && \
        pip install -r requirements.txt && \
        pip install gunicorn
    COPY backend .
    
    # ---- Final Image ----
    FROM python:3.10-slim
    
    # Install Nginx
    RUN apt-get update && \
        apt-get install -y nginx && \
        rm -rf /var/lib/apt/lists/*
    
    # Copy React dist output into Nginx's static folder
    COPY --from=frontend /app/dist /usr/share/nginx/html
    
    # Copy backend code
    COPY --from=backend /app /backend
    
    # Copy Nginx config
    COPY nginx/default.template /etc/nginx/conf.d/default.template
    
    # Create start.sh script
    # Create start.sh script
    RUN echo '#!/bin/bash' > /start.sh && \
        echo 'export PORT="${PORT:-80}"' >> /start.sh && \
        echo 'echo "Starting Gunicorn on port 5000..."' >> /start.sh && \
        echo 'gunicorn --chdir /backend run:app -b 127.0.0.1:5000 &' >> /start.sh && \
        echo 'echo "Configuring Nginx to listen on PORT=$PORT..."' >> /start.sh && \
        echo 'envsubst "\$PORT" < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf' >> /start.sh && \
        echo 'echo "Starting Nginx..."' >> /start.sh && \
        echo 'nginx -g "daemon off;"' >> /start.sh && \
        chmod +x /start.sh
    
    # Expose the dynamic port (Heroku will use $PORT)
    EXPOSE $PORT
    
    # Run the start script
    CMD ["/start.sh"]