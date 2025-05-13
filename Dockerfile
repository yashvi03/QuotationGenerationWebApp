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
    COPY nginx/default.conf /etc/nginx/conf.d/default.conf
    
    # Expose the dynamic port (Heroku will use $PORT)
    EXPOSE $PORT
    
    # Create a start script to run Gunicorn and Nginx
    RUN echo '#!/bin/bash\n\
    gunicorn --chdir /backend run:app -b 127.0.0.1:5000 &\n\
    sed -i "s/listen 80/listen \$PORT/" /etc/nginx/conf.d/default.conf\n\
    nginx -g "daemon off;"' > /start.sh && \
    chmod +x /start.sh
    
    # Run the start script
    CMD ["/start.sh"]