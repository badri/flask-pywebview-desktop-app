#!/usr/bin/env python3
import os
import sys
import threading
import time
import platform
from flask import Flask, render_template, jsonify
import webview

# Force Qt on Windows and Linux
current_platform = platform.system().lower()
if current_platform in ['windows', 'linux']:
    os.environ['PYWEBVIEW_GUI'] = 'qt'

# Create Flask app
app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/hello')
def hello():
    return jsonify({'message': 'Hello from Flask!'})

def start_flask():
    """Start Flask server in a separate thread"""
    app.run(host='127.0.0.1', port=5000, debug=False, use_reloader=False)

def main():
    # Start Flask in a separate thread
    flask_thread = threading.Thread(target=start_flask, daemon=True)
    flask_thread.start()
    
    # Give Flask a moment to start
    time.sleep(2)
    
    # Create and start the webview window
    webview.create_window(
        'My Desktop App',
        'http://127.0.0.1:5000',
        width=1200,
        height=800,
        min_size=(800, 600),
        resizable=True
    )
    
    # Start the webview with Qt forced on Windows/Linux
    gui = 'qt' if current_platform in ['windows', 'linux'] else None
    webview.start(debug=False, gui=gui)

if __name__ == '__main__':
    main()
