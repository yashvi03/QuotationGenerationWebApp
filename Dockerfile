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
    
    # Install pip and required packages in the backend container
    RUN pip install --upgrade pip && \
        pip install -r /backend/requirements.txt && \
        pip install gunicorn
    
    # ---- Final Image with Nginx ----
    FROM nginx:alpine
    
    # Copy React dist output into Nginx's static folder
    COPY --from=frontend /app/dist /usr/share/nginx/html
    
    # Copy backend code into Nginx container (backend container already has the Python environment)
    COPY --from=backend /app /backend
    
    # Copy Nginx config into the container
    COPY nginx/default.conf /etc/nginx/conf.d/default.conf
    
    # Expose the dynamic port (Heroku's PORT)
    EXPOSE $PORT
    
    # Start Flask app using Gunicorn from backend and Nginx
    CMD gunicorn --chdir /backend run:app -b 127.0.0.1:5000 & nginx -g 'daemon off;'
    