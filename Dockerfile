# ---- Build React Frontend ----
    FROM node:18 AS frontend
    WORKDIR /app
    COPY webAppFrontend/ ./
    RUN npm install && npm run build   # Ensure the dist folder is created
    
    # ---- Build Python Backend ----
    FROM python:3.10-slim AS backend
    WORKDIR /app
    COPY backend/ /app/
    COPY backend/requirements.txt .
    
    # Install pip and required packages (only in the backend container)
    RUN pip install --upgrade pip && \
        pip install gunicorn && \
        pip install -r requirements.txt
    
    # ---- Final Image with Nginx ----
    FROM nginx:alpine
    
    # Copy React dist output instead of build
    COPY --from=frontend /app/dist /usr/share/nginx/html
    
    # Copy backend code into Nginx container (backend container already has the Python environment)
    COPY --from=backend /app /backend
    
    # Copy Nginx config
    COPY nginx/default.conf /etc/nginx/conf.d/default.conf
    
    # Expose port 80 (Nginx)
    EXPOSE 80
    
    # Start Flask backend and Nginx
    CMD sh -c "gunicorn --chdir /backend run:app -b 127.0.0.1:5000 & nginx -g 'daemon off;'"
    