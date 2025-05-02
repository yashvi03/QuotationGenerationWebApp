FROM python:3.9-slim
WORKDIR /app
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE $PORT
ENV PORT=5000
CMD ["gunicorn", "--bind", "0.0.0.0:$PORT", "-w", "4", "run:app"]