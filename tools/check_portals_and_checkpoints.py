import glob

def parse_tscn(path):
    with open(path, "r", encoding="utf-8") as f:
        lines = f.readlines()
        
    nodes = []
    curr = None
    for line in lines:
        line_s = line.strip()
        if line_s.startswith("[node "):
            if curr:
                nodes.append(curr)
            curr = {"header": line_s, "props": {}}
        elif curr:
            if "=" in line_s and not line_s.startswith("["):
                k, v = line_s.split("=", 1)
                curr["props"][k.strip()] = v.strip()
    if curr:
        nodes.append(curr)
    return nodes

files = sorted(glob.glob("scenes/levels/level_*.tscn")) + sorted(glob.glob("scenes/levels/*/level_*.tscn"))

for path in files:
    nodes = parse_tscn(path)
    
    platforms = []
    checkpoints = []
    portals = []
    
    for n in nodes:
        header = n["header"]
        props = n["props"]
        name = header.split('name="')[1].split('"')[0] if 'name="' in header else ""
        parent = header.split('parent="')[1].split('"')[0] if 'parent="' in header else ""
        
        pos_str = props.get("position", "Vector2(0, 0)")
        pos_str = pos_str.replace("Vector2(", "").replace(")", "")
        parts = [float(x.strip()) for x in pos_str.split(",")]
        x, y = parts[0], parts[1]
        
        if "Platforms" in parent or "Mechanics" in parent:
            size_str = props.get("platform_size", "Vector2(140, 32)")
            size_str = size_str.replace("Vector2(", "").replace(")", "")
            sparts = [float(s.strip()) for s in size_str.split(",")]
            w, h = sparts[0], sparts[1]
            platforms.append((name, x, y, w, h))
            
        if "Checkpoint" in name:
            checkpoints.append((name, x, y))
        elif name == "Portal":
            portals.append((name, x, y))
            
    for cp_name, cx, cy in checkpoints:
        # Platform directly under: x within width/2, and y >= cy and y <= cy + 100
        under = [p for p in platforms if abs(p[1] - cx) <= p[3]/2 + 40 and p[2] >= cy and p[2] <= cy + 120]
        if not under:
            print(f"[MISSING PLATFORM] {path} -> {cp_name} at ({cx}, {cy})")
        else:
            unstable = [p for p in under if "Crumble" in p[0] or "Moving" in p[0] or "Ice" in p[0]]
            if unstable and not [p for p in under if "Ground" in p[0]]:
                print(f"[UNSTABLE PLATFORM] {path} -> {cp_name} at ({cx}, {cy}) on {unstable[0][0]}")

    for pt_name, px, py in portals:
        under = [p for p in platforms if abs(p[1] - px) <= p[3]/2 + 40 and p[2] >= py and p[2] <= py + 120]
        if not under:
            print(f"[MISSING PLATFORM] {path} -> {pt_name} at ({px}, {py})")

print("Check finished!")
