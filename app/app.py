# app/app.py
from flask import Flask, jsonify, Response
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
import time
import random

app = Flask(__name__)

REQUEST_COUNT = Counter('app_request_count', 'Total HTTP requests', ['method', 'endpoint', 'http_status'])
REQUEST_LATENCY = Histogram('app_request_latency_seconds', 'Request latency', ['endpoint'])

@app.route('/')
def hello():
    start = time.time()
    # simulate variable work
    time.sleep(random.uniform(0.01, 0.2))
    duration = time.time() - start
    REQUEST_COUNT.labels(method='GET', endpoint='/', http_status='200').inc()
    REQUEST_LATENCY.labels(endpoint='/').observe(duration)
    return jsonify(message='Hello from Multi-Cloud App')

@app.route('/health')
def health():
    return jsonify(status='ok')

@app.route('/metrics')
def metrics():
    data = generate_latest()
    return Response(data, mimetype=CONTENT_TYPE_LATEST)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
