# web: gunicorn -w 4 -b 0.0.0.0:5000 run:app & nginx -g 'daemon off;'

web: nginx -g 'daemon off;'
api: gunicorn -w 4 -b 0.0.0.0:$PORT run:app