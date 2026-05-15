/**
 * config.js - Configuración centralizada de la API
 * Define la URL base según el entorno (desarrollo o producción)
 */

const API_CONFIG = {
    // Detecta automáticamente si está en localhost o en producción
    getApiBase: function() {
        if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
            // Desarrollo local
            return 'http://localhost:8000';
        } else {
            // Producción (Render u otro servidor)
            return 'https://api-innovacion-curriculum-in0c.onrender.com';
        }
    },
    
    // Construye la URL completa para un endpoint
    getUrl: function(endpoint) {
        return this.getApiBase() + endpoint;
    }
};

// Exportar para uso global
const API_BASE = API_CONFIG.getApiBase();
