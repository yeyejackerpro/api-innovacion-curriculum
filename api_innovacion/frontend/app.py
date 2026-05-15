from flask import Flask, send_from_directory, request, jsonify
from flask_cors import CORS
import requests
import os

app = Flask(__name__)
CORS(app)

# Configurar la URL del backend según el entorno
# En desarrollo: http://localhost:8000
# En producción (Render): https://api-innovacion-curriculum-in0c.onrender.com
if os.getenv('FLASK_ENV') == 'production' or os.getenv('RENDER'):
    BACKEND_URL = 'https://api-innovacion-curriculum-in0c.onrender.com'
else:
    BACKEND_URL = os.getenv('BACKEND_URL', 'http://localhost:8000')

@app.route('/')
def index():
    return send_from_directory('.', 'index.html')

@app.route('/<path:filename>')
def serve_file(filename):
    # Solo servir archivos HTML y estáticos
    if filename.startswith('api/'):
        return proxy_api(filename)
    return send_from_directory('.', filename)

@app.route('/api/<path:endpoint>', methods=['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'])
def proxy_api(endpoint=None):
    """Proxy todas las peticiones /api/* hacia el backend FastAPI"""
    try:
        # Construir la URL del endpoint en el backend
        full_endpoint = endpoint if endpoint else request.path.replace('/api/', '')
        backend_url = f"{BACKEND_URL}/api/{full_endpoint}"
        
        # Pasar parámetros query
        if request.query_string:
            backend_url += f"?{request.query_string.decode()}"
        
        # Determinar método HTTP
        method = request.method
        
        # Preparar headers (excluir host y content-length para evitar conflictos)
        headers = {key: value for key, value in request.headers if key.lower() not in ['host', 'content-length']}
        
        # Hacer la petición al backend
        if method == 'GET':
            response = requests.get(backend_url, headers=headers, timeout=30)
        elif method == 'POST':
            response = requests.post(backend_url, json=request.get_json(), headers=headers, timeout=30)
        elif method == 'PUT':
            response = requests.put(backend_url, json=request.get_json(), headers=headers, timeout=30)
        elif method == 'DELETE':
            response = requests.delete(backend_url, headers=headers, timeout=30)
        else:
            return jsonify({"error": "Método no permitido"}), 405
        
        # Retornar la respuesta del backend
        return response.content, response.status_code, {'Content-Type': response.headers.get('Content-Type', 'application/json')}
    
    except requests.exceptions.Timeout:
        return jsonify({"error": "Timeout conectando al backend"}), 504
    except requests.exceptions.ConnectionError:
        return jsonify({"error": "No se pudo conectar al backend", "backend_url": BACKEND_URL}), 503
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=os.getenv('FLASK_ENV') == 'development', host='0.0.0.0')