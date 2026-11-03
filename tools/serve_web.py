"""
Local HTTP Server for testing Linaverse Web build.
Serves build/web/ on http://localhost:8000 with appropriate headers and mime types.
"""
import http.server
import socketserver
import os
import sys

PORT = 8000
DIRECTORY = os.path.join(os.path.dirname(os.path.dirname(__file__)), "build", "web")

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def end_headers(self):
        # Add CORS and Cross-Origin Isolation headers for maximum compatibility
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        super().end_headers()

    def guess_type(self, path):
        if path.endswith(".wasm"):
            return "application/wasm"
        if path.endswith(".pck"):
            return "application/octet-stream"
        if path.endswith(".js") or path.endswith(".worklet.js"):
            return "text/javascript"
        return super().guess_type(path)

if __name__ == "__main__":
    if not os.path.isdir(DIRECTORY):
        print(f"Error: Directory not found: {DIRECTORY}")
        sys.exit(1)

    print(f"Serving Linaverse Web from: {DIRECTORY}")
    print(f"URL: http://localhost:{PORT}")
    print("Press Ctrl+C to stop.")

    socketserver.TCPServer.allow_reuse_address = True
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nServer stopped.")
