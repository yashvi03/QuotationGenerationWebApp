#!/bin/sh

# Make sure API_URL doesn't end with a slash
API_URL_CLEAN=$(echo $API_URL | sed 's/\/$//')
export API_URL=$API_URL_CLEAN

# Replace environment variables in the Nginx configuration
envsubst '$PORT $API_URL' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Start Nginx
exec nginx -g 'daemon off;'