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
    
    # Install Nginx and gettext-base (for envsubst)
    RUN apt-get update && \
        apt-get install -y nginx gettext-base && \
        rm -rf /var/lib/apt/lists/*
    
    # Copy React dist output into Nginx's static folder
    COPY --from=frontend /app/dist /usr/share/nginx/html
    
    # Copy backend code and Python dependencies
    COPY --from=backend /app /backend
    COPY --from=backend /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
    COPY --from=backend /usr/local/bin/gunicorn /usr/local/bin/gunicorn
    
    # Copy Nginx config template
    COPY nginx/default.template /etc/nginx/conf.d/default.template
    
    # Create improved start.sh script
    RUN echo '#!/bin/bash' > /start.sh && \
        echo 'export PORT="${PORT:-8080}"' >> /start.sh && \
        echo 'echo "Starting Gunicorn on port 5000..."' >> /start.sh && \
        echo 'gunicorn --chdir /backend run:app -b 127.0.0.1:5000 &' >> /start.sh && \
        echo 'echo "Configuring Nginx to listen on PORT=$PORT..."' >> /start.sh && \
        echo 'envsubst "\$PORT" < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf' >> /start.sh && \
        echo 'echo "Starting Nginx..."' >> /start.sh && \
        echo 'nginx -g "daemon off;"' >> /start.sh && \
        chmod +x /start.sh
    
    # Set non-privileged default port (Heroku will override with its own $PORT)
    ENV PORT=8080
    
    # Expose the port
    EXPOSE $PORT
    
    # Run the start script
    CMD ["/start.sh"]