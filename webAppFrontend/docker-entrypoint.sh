#!/bin/sh

# Replace environment variables in the Nginx configuration
envsubst '$PORT $API_URL' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Start Nginx
exec nginx -g 'daemon off;'