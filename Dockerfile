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
    
    # Install Nginx and gettext-base
    RUN apt-get update && \
        apt-get install -y nginx gettext-base && \
        rm -rf /var/lib/apt/lists/*
    
    # Copy React dist output into Nginx's static folder
    COPY --from=frontend /app/dist /usr/share/nginx/html
    
    # Copy backend code and Python dependencies
    COPY --from=backend /app /backend
    COPY --from=backend /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
    COPY --from=backend /usr/local/bin/gunicorn /usr/local/bin/gunicorn
    
    # Create a completely new nginx.conf that doesn't use port 80
    RUN mkdir -p /etc/nginx/conf.d && \
        echo 'worker_processes auto;' > /etc/nginx/nginx.conf && \
        echo 'pid /tmp/nginx.pid;' >> /etc/nginx/nginx.conf && \
        echo 'events {' >> /etc/nginx/nginx.conf && \
        echo '    worker_connections 1024;' >> /etc/nginx/nginx.conf && \
        echo '}' >> /etc/nginx/nginx.conf && \
        echo 'http {' >> /etc/nginx/nginx.conf && \
        echo '    include /etc/nginx/mime.types;' >> /etc/nginx/nginx.conf && \
        echo '    default_type application/octet-stream;' >> /etc/nginx/nginx.conf && \
        echo '    sendfile on;' >> /etc/nginx/nginx.conf && \
        echo '    keepalive_timeout 65;' >> /etc/nginx/nginx.conf && \
        echo '    include /etc/nginx/conf.d/*.conf;' >> /etc/nginx/nginx.conf && \
        echo '}' >> /etc/nginx/nginx.conf && \
        chmod -R 755 /usr/share/nginx/html
    
    # Create a default.template for Nginx config
    RUN echo 'server {' > /etc/nginx/conf.d/default.template && \
        echo '    listen $PORT;' >> /etc/nginx/conf.d/default.template && \
        echo '    server_name _;' >> /etc/nginx/conf.d/default.template && \
        echo '' >> /etc/nginx/conf.d/default.template && \
        echo '    location / {' >> /etc/nginx/conf.d/default.template && \
        echo '        root /usr/share/nginx/html;' >> /etc/nginx/conf.d/default.template && \
        echo '        index index.html;' >> /etc/nginx/conf.d/default.template && \
        echo '        try_files $uri $uri/ /index.html;' >> /etc/nginx/conf.d/default.template && \
        echo '    }' >> /etc/nginx/conf.d/default.template && \
        echo '' >> /etc/nginx/conf.d/default.template && \
        echo '    location /api {' >> /etc/nginx/conf.d/default.template && \
        echo '        proxy_pass http://127.0.0.1:5000;' >> /etc/nginx/conf.d/default.template && \
        echo '        proxy_set_header Host $host;' >> /etc/nginx/conf.d/default.template && \
        echo '        proxy_set_header X-Real-IP $remote_addr;' >> /etc/nginx/conf.d/default.template && \
        echo '        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' >> /etc/nginx/conf.d/default.template && \
        echo '        proxy_set_header X-Forwarded-Proto $scheme;' >> /etc/nginx/conf.d/default.template && \
        echo '    }' >> /etc/nginx/conf.d/default.template && \
        echo '}' >> /etc/nginx/conf.d/default.template
    
    # Create start.sh script
    RUN echo '#!/bin/bash' > /start.sh && \
        echo '' >> /start.sh && \
        echo '# Set default port if not provided' >> /start.sh && \
        echo 'export PORT="${PORT:-8080}"' >> /start.sh && \
        echo 'echo "Using PORT=$PORT"' >> /start.sh && \
        echo '' >> /start.sh && \
        echo '# Start the backend server' >> /start.sh && \
        echo 'echo "Starting Gunicorn on port 5000..."' >> /start.sh && \
        echo 'gunicorn --chdir /backend run:app -b 127.0.0.1:5000 &' >> /start.sh && \
        echo 'GUNICORN_PID=$!' >> /start.sh && \
        echo '' >> /start.sh && \
        echo '# Configure Nginx with correct port' >> /start.sh && \
        echo 'echo "Configuring Nginx to listen on PORT=$PORT..."' >> /start.sh && \
        echo 'envsubst "\$PORT" < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf' >> /start.sh && \
        echo 'cat /etc/nginx/conf.d/default.conf' >> /start.sh && \
        echo '' >> /start.sh && \
        echo '# Start Nginx in the foreground' >> /start.sh && \
        echo 'echo "Starting Nginx..."' >> /start.sh && \
        echo 'exec nginx -g "daemon off;"' >> /start.sh && \
        chmod +x /start.sh
    
    # Set default port as environment variable
    ENV PORT=8080
    
    # Expose the port
    EXPOSE $PORT
    
    # Run the start script
    CMD ["/start.sh"]