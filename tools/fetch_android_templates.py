import os
import io
import urllib.request
import zipfile

URL = "https://github.com/godotengine/godot/releases/download/4.7.2-stable/Godot_v4.7.2-stable_export_templates.tpz"
TARGET_DIR = r"C:\Users\user\AppData\Roaming\Godot\export_templates\4.7.2.stable"
os.makedirs(TARGET_DIR, exist_ok=True)

class RemoteZipFile(io.RawIOBase):
    def __init__(self, url):
        req = urllib.request.Request(url, method='HEAD')
        with urllib.request.urlopen(req) as resp:
            self.url = resp.geturl()
            self.size = int(resp.headers['Content-Length'])
        self.pos = 0
        print(f"Remote file size: {self.size / (1024*1024):.2f} MB")

    def seekable(self):
        return True

    def readable(self):
        return True

    def seek(self, offset, whence=io.SEEK_SET):
        if whence == io.SEEK_SET:
            self.pos = offset
        elif whence == io.SEEK_CUR:
            self.pos += offset
        elif whence == io.SEEK_END:
            self.pos = self.size + offset
        return self.pos

    def tell(self):
        return self.pos

    def readinto(self, b):
        l = len(b)
        if self.pos >= self.size or l == 0:
            return 0
        end_pos = min(self.size - 1, self.pos + l - 1)
        req = urllib.request.Request(self.url, headers={'Range': f'bytes={self.pos}-{end_pos}'})
        with urllib.request.urlopen(req) as resp:
            data = resp.read()
        b[:len(data)] = data
        self.pos += len(data)
        return len(data)

print("Connecting to remote export templates...")
remote_io = RemoteZipFile(URL)
# Wrap in BufferedReader so zipfile can buffer reads
buffered_io = io.BufferedReader(remote_io, buffer_size=1024*1024)

print("Opening remote zip...")
with zipfile.ZipFile(buffered_io) as z:
    names = z.namelist()
    print(f"Found {len(names)} files in zip.")
    
    android_files = [n for n in names if "android" in n.lower() or "version" in n.lower()]
    print("Extracting Android template files:", android_files)
    
    for f in android_files:
        basename = os.path.basename(f)
        if not basename:
            continue
        dest_path = os.path.join(TARGET_DIR, basename)
        print(f"Downloading {basename}...")
        with z.open(f) as src, open(dest_path, "wb") as dst:
            while True:
                chunk = src.read(1024 * 1024) # 1 MB chunks
                if not chunk:
                    break
                dst.write(chunk)
        print(f"Saved: {dest_path} ({os.path.getsize(dest_path)/(1024*1024):.2f} MB)")

print("\n=== SUCCESS: ANDROID EXPORT TEMPLATES INSTALLED! ===")
