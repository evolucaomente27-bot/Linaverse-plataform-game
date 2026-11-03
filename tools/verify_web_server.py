"""
Verify that serve_web.py serves all critical Linaverse Web assets properly.
"""
import urllib.request
import threading
import time
import sys
import os

from serve_web import Handler, socketserver, PORT

def run_test():
    test_urls = [
        ("http://localhost:8000/index.html", 200, "text/html"),
        ("http://localhost:8000/index.js", 200, "text/javascript"),
        ("http://localhost:8000/index.wasm", 200, "application/wasm"),
        ("http://localhost:8000/index.pck", 200, "application/octet-stream"),
        ("http://localhost:8000/index.icon.png", 200, "image/png"),
    ]

    all_passed = True
    for url, expected_status, expected_mime in test_urls:
        req = urllib.request.Request(url)
        try:
            with urllib.request.urlopen(req) as resp:
                status = resp.status
                content_type = resp.headers.get("Content-Type", "")
                length = resp.headers.get("Content-Length", 0)
                print(f"[{status}] {url} -> {content_type} ({length} bytes)")
                if status != expected_status:
                    print(f"  FAILED: expected status {expected_status}, got {status}")
                    all_passed = False
                if expected_mime not in content_type:
                    print(f"  WARNING: expected mime {expected_mime}, got {content_type}")
        except Exception as e:
            print(f"FAILED to fetch {url}: {e}")
            all_passed = False

    return all_passed

if __name__ == "__main__":
    socketserver.TCPServer.allow_reuse_address = True
    httpd = socketserver.TCPServer(("", PORT), Handler)
    server_thread = threading.Thread(target=httpd.serve_forever, daemon=True)
    server_thread.start()
    print("Test server started in background...")
    time.sleep(0.5)

    try:
        success = run_test()
        if success:
            print("\nALL ASSET CHECKS PASSED SUCCESSFULLY!")
        else:
            print("\nSOME CHECKS FAILED.")
            sys.exit(1)
    finally:
        httpd.shutdown()
        server_thread.join()
        print("Test server stopped.")
