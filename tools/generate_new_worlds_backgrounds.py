import os
import math
import random
from PIL import Image, ImageDraw, ImageFilter

WIDTH = 1280
SKY_H = 720
FAR_H = 400
MID_H = 360
NEAR_H = 240

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BG_ROOT = os.path.join(BASE_DIR, "assets", "sprites", "background")

def lerp_color(c1, c2, t):
    t = max(0.0, min(1.0, t))
    return tuple(int(a + (b - a) * t) for a, b in zip(c1, c2))

def create_gradient_img(w, h, stops):
    img = Image.new("RGBA", (w, h))
    pixels = img.load()
    stops = sorted(stops, key=lambda s: s[0])
    
    col_cache = []
    for y in range(h):
        t = y / float(h - 1)
        col = stops[-1][1]
        for i in range(len(stops) - 1):
            if stops[i][0] <= t <= stops[i+1][0]:
                segment_t = (t - stops[i][0]) / (stops[i+1][0] - stops[i][0])
                col = lerp_color(stops[i][1], stops[i+1][1], segment_t)
                break
        col_cache.append(col)
        
    for y in range(h):
        c = col_cache[y]
        for x in range(w):
            pixels[x, y] = c
    return img

def add_stars(draw, count, w, h, colors=[(255, 255, 255, 220), (220, 240, 255, 200)], seed=42):
    rng = random.Random(seed)
    for _ in range(count):
        x = rng.randint(0, w - 1)
        y = rng.randint(0, int(h * 0.75))
        c = rng.choice(colors)
        sz = rng.choices([1, 2, 3], weights=[0.8, 0.16, 0.04])[0]
        if sz == 1:
            draw.point((x, y), fill=c)
        elif sz == 2:
            draw.rectangle([x, y, x + 1, y + 1], fill=c)
        else:
            draw.rectangle([x, y, x + 1, y + 1], fill=(255, 255, 255, 255))
            draw.point((x - 1, y), fill=c)
            draw.point((x + 2, y), fill=c)
            draw.point((x, y - 1), fill=c)
            draw.point((x, y + 2), fill=c)

# ==============================================================================
# 1. AGNES: Laboratório Quântico (Quantum Laboratory)
# ==============================================================================
def generate_agnes():
    out_dir = os.path.join(BG_ROOT, "agnes")
    os.makedirs(out_dir, exist_ok=True)
    
    # 1. SKY (1280x720)
    sky = create_gradient_img(WIDTH, SKY_H, [
        (0.0, (18, 12, 34, 255)),
        (0.5, (38, 20, 56, 255)),
        (1.0, (65, 30, 80, 255))
    ])
    sdraw = ImageDraw.Draw(sky)
    add_stars(sdraw, 80, WIDTH, SKY_H, [(200, 255, 230, 220), (255, 180, 230, 200)], seed=101)
    
    # Quantum grid lines in sky
    for x in range(0, WIDTH, 80):
        sdraw.line([(x, 0), (x, SKY_H)], fill=(90, 220, 160, 25), width=1)
    for y in range(0, SKY_H, 60):
        sdraw.line([(0, y), (WIDTH, y)], fill=(220, 90, 180, 20), width=1)
    sky.save(os.path.join(out_dir, "sky.png"))
    
    # 2. FAR (1280x400)
    far = Image.new("RGBA", (WIDTH, FAR_H), (0, 0, 0, 0))
    fdraw = ImageDraw.Draw(far)
    # Futuristic lab domes and towers
    rng = random.Random(202)
    for i in range(16):
        cx = (i * 80 + 40) % WIDTH
        bh = rng.randint(180, 320)
        bw = rng.randint(50, 75)
        # Lab tower
        fdraw.rectangle([cx - bw//2, FAR_H - bh, cx + bw//2, FAR_H], fill=(42, 28, 58, 230))
        # Dome on top
        fdraw.ellipse([cx - bw//2, FAR_H - bh - 20, cx + bw//2, FAR_H - bh + 20], fill=(70, 45, 90, 240))
        # Glowing green antenna
        fdraw.line([(cx, FAR_H - bh - 20), (cx, FAR_H - bh - 45)], fill=(80, 240, 160, 200), width=2)
        fdraw.ellipse([cx - 3, FAR_H - bh - 48, cx + 3, FAR_H - bh - 42], fill=(120, 255, 190, 255))
    far.save(os.path.join(out_dir, "far.png"))
    
    # 3. MID (1280x360)
    mid = Image.new("RGBA", (WIDTH, MID_H), (0, 0, 0, 0))
    mdraw = ImageDraw.Draw(mid)
    # Quantum consoles and glowing fluid vats
    for i in range(10):
        cx = (i * 128 + 64) % WIDTH
        # Fluid cylinder vat
        fdraw_y = MID_H - 190
        mdraw.rectangle([cx - 28, fdraw_y, cx + 28, MID_H], fill=(25, 20, 38, 240))
        mdraw.rectangle([cx - 20, fdraw_y + 15, cx + 20, MID_H - 20], fill=(45, 220, 140, 140))
        # Level bubbles
        mdraw.ellipse([cx - 10, fdraw_y + 50, cx - 2, fdraw_y + 58], fill=(160, 255, 210, 220))
        mdraw.ellipse([cx + 2, fdraw_y + 90, cx + 12, fdraw_y + 100], fill=(160, 255, 210, 220))
        # Glowing conduits
        mdraw.line([(cx - 64, MID_H - 80), (cx + 64, MID_H - 80)], fill=(240, 100, 190, 150), width=3)
    mid.save(os.path.join(out_dir, "mid.png"))
    
    # 4. TREES/NEAR (1280x240)
    near = Image.new("RGBA", (WIDTH, NEAR_H), (0, 0, 0, 0))
    ndraw = ImageDraw.Draw(near)
    # Lab workbenches and holographic formula displays
    for i in range(16):
        cx = (i * 80 + 35) % WIDTH
        # Work table
        ndraw.rectangle([cx - 32, NEAR_H - 110, cx + 32, NEAR_H], fill=(20, 16, 30, 250))
        ndraw.rectangle([cx - 36, NEAR_H - 115, cx + 36, NEAR_H - 105], fill=(75, 45, 95, 255))
        # Erlenmeyer flask
        ndraw.polygon([(cx - 10, NEAR_H - 115), (cx + 10, NEAR_H - 115), (cx + 3, NEAR_H - 135), (cx - 3, NEAR_H - 135)], fill=(60, 240, 170, 220))
        # Hologram screen
        ndraw.rectangle([cx - 18, NEAR_H - 170, cx + 18, NEAR_H - 138], outline=(100, 220, 255, 200), width=2, fill=(30, 80, 140, 90))
    near.save(os.path.join(out_dir, "trees.png"))
    print("  [OK] Background gerado para: agnes")

# ==============================================================================
# 2. FRIEREN: Floresta Arcana dos Elfos (Ancient Elf Forest)
# ==============================================================================
def generate_frieren():
    out_dir = os.path.join(BG_ROOT, "frieren")
    os.makedirs(out_dir, exist_ok=True)
    
    # 1. SKY (1280x720)
    sky = create_gradient_img(WIDTH, SKY_H, [
        (0.0, (12, 14, 28, 255)),
        (0.4, (26, 30, 56, 255)),
        (0.7, (50, 48, 82, 255)),
        (1.0, (95, 88, 125, 255))
    ])
    sdraw = ImageDraw.Draw(sky)
    add_stars(sdraw, 140, WIDTH, SKY_H, [(240, 245, 255, 220), (180, 210, 255, 200)], seed=303)
    # Giant Crescent Moon
    sdraw.ellipse([WIDTH - 240, 80, WIDTH - 120, 200], fill=(250, 252, 255, 230))
    sdraw.ellipse([WIDTH - 225, 75, WIDTH - 105, 195], fill=(26, 30, 56, 255))
    sky.save(os.path.join(out_dir, "sky.png"))
    
    # 2. FAR (1280x400)
    far = Image.new("RGBA", (WIDTH, FAR_H), (0, 0, 0, 0))
    fdraw = ImageDraw.Draw(far)
    # Ancient elven spires and ruined fantasy fortresses
    for i in range(12):
        cx = (i * 110 + 50) % WIDTH
        sh = 220 + (i % 4) * 35
        # Tall gothic elven spire
        fdraw.polygon([(cx - 24, FAR_H), (cx + 24, FAR_H), (cx, FAR_H - sh)], fill=(32, 36, 60, 240))
        # Archway
        fdraw.ellipse([cx - 10, FAR_H - sh//2, cx + 10, FAR_H - sh//2 + 30], fill=(18, 20, 36, 255))
    far.save(os.path.join(out_dir, "far.png"))
    
    # 3. MID (1280x360)
    mid = Image.new("RGBA", (WIDTH, MID_H), (0, 0, 0, 0))
    mdraw = ImageDraw.Draw(mid)
    # Ancient enchanted elf trees with twisting silver branches and blue leaves
    for i in range(8):
        cx = (i * 160 + 80) % WIDTH
        # Trunk
        mdraw.polygon([(cx - 16, MID_H), (cx + 16, MID_H), (cx + 6, MID_H - 180), (cx - 6, MID_H - 180)], fill=(28, 30, 48, 255))
        # Luminous foliage (Mirrored Lotus blue)
        for foliage_off in [(-45, -200), (0, -225), (45, -200), (-20, -170), (20, -170)]:
            fx, fy = cx + foliage_off[0], MID_H + foliage_off[1]
            mdraw.ellipse([fx - 36, fy - 26, fx + 36, fy + 26], fill=(70, 110, 185, 190))
            mdraw.ellipse([fx - 24, fy - 18, fx + 24, fy + 18], fill=(110, 160, 235, 160))
    mid.save(os.path.join(out_dir, "mid.png"))
    
    # 4. TREES/NEAR (1280x240)
    near = Image.new("RGBA", (WIDTH, NEAR_H), (0, 0, 0, 0))
    ndraw = ImageDraw.Draw(near)
    # Ancient stone arches covered in Semm Blue flowers (Mirrored Lotus)
    for i in range(10):
        cx = (i * 128 + 64) % WIDTH
        # Ruined stone arch
        ndraw.rectangle([cx - 24, NEAR_H - 140, cx - 14, NEAR_H], fill=(22, 24, 38, 255))
        ndraw.rectangle([cx + 14, NEAR_H - 140, cx + 24, NEAR_H], fill=(22, 24, 38, 255))
        ndraw.rectangle([cx - 28, NEAR_H - 150, cx + 28, NEAR_H - 135], fill=(35, 38, 55, 255))
        # Blue enchanted flowers cluster
        for flo in range(5):
            flx = cx - 20 + flo * 10
            fly = NEAR_H - 15 - (flo % 2) * 8
            ndraw.ellipse([flx - 4, fly - 4, flx + 4, fly + 4], fill=(120, 185, 255, 240))
            ndraw.ellipse([flx - 2, fly - 2, flx + 2, fly + 2], fill=(255, 255, 255, 255))
    near.save(os.path.join(out_dir, "trees.png"))
    print("  [OK] Background gerado para: frieren")

# ==============================================================================
# 3. MAID: Mansão Vitoriana dos Salões Clássicos (Victorian Manor)
# ==============================================================================
def generate_maid():
    out_dir = os.path.join(BG_ROOT, "maid")
    os.makedirs(out_dir, exist_ok=True)
    
    # 1. SKY (1280x720) - Warm royal salon sunset
    sky = create_gradient_img(WIDTH, SKY_H, [
        (0.0, (28, 14, 28, 255)),
        (0.4, (58, 28, 50, 255)),
        (0.8, (110, 55, 80, 255)),
        (1.0, (160, 95, 115, 255))
    ])
    sky.save(os.path.join(out_dir, "sky.png"))
    
    # 2. FAR (1280x400)
    far = Image.new("RGBA", (WIDTH, FAR_H), (0, 0, 0, 0))
    fdraw = ImageDraw.Draw(far)
    # Grand Victorian mansion skyline with mansard roofs and clock towers
    for i in range(10):
        cx = (i * 128 + 64) % WIDTH
        bh = 200 + (i % 3) * 50
        # Manor body
        fdraw.rectangle([cx - 48, FAR_H - bh, cx + 48, FAR_H], fill=(42, 24, 38, 240))
        # Mansard roof
        fdraw.polygon([(cx - 56, FAR_H - bh), (cx + 56, FAR_H - bh), (cx + 36, FAR_H - bh - 40), (cx - 36, FAR_H - bh - 40)], fill=(30, 16, 28, 250))
        # Chimneys
        fdraw.rectangle([cx - 24, FAR_H - bh - 55, cx - 18, FAR_H - bh - 40], fill=(22, 12, 20, 255))
    far.save(os.path.join(out_dir, "far.png"))
    
    # 3. MID (1280x360)
    mid = Image.new("RGBA", (WIDTH, MID_H), (0, 0, 0, 0))
    mdraw = ImageDraw.Draw(mid)
    # Victorian grand arched windows and golden glowing chandeliers
    for i in range(8):
        cx = (i * 160 + 80) % WIDTH
        # Grand arched French window
        mdraw.rectangle([cx - 36, MID_H - 220, cx + 36, MID_H], fill=(32, 18, 30, 255))
        mdraw.ellipse([cx - 36, MID_H - 250, cx + 36, MID_H - 190], fill=(32, 18, 30, 255))
        # Golden interior warm light
        mdraw.rectangle([cx - 28, MID_H - 210, cx + 28, MID_H - 20], fill=(255, 215, 130, 140))
        # Golden chandelier
        mdraw.line([(cx, MID_H - 260), (cx, MID_H - 220)], fill=(220, 185, 90, 240), width=2)
        mdraw.ellipse([cx - 16, MID_H - 225, cx + 16, MID_H - 215], fill=(255, 225, 110, 230))
    mid.save(os.path.join(out_dir, "mid.png"))
    
    # 4. TREES/NEAR (1280x240)
    near = Image.new("RGBA", (WIDTH, NEAR_H), (0, 0, 0, 0))
    ndraw = ImageDraw.Draw(near)
    # Ballroom marble balustrade with rose topiaries and tea tables
    for i in range(16):
        cx = (i * 80 + 40) % WIDTH
        # Balustrade pillars
        ndraw.rectangle([cx - 8, NEAR_H - 80, cx + 8, NEAR_H], fill=(24, 14, 22, 255))
        ndraw.ellipse([cx - 10, NEAR_H - 90, cx + 10, NEAR_H - 75], fill=(36, 20, 32, 255))
        # Rose bush in porcelain urn
        if i % 2 == 0:
            ndraw.ellipse([cx - 24, NEAR_H - 150, cx + 24, NEAR_H - 95], fill=(35, 55, 38, 250))
            # Pink rosebuds
            for ro in [(-12, -135), (8, -140), (0, -115)]:
                ndraw.ellipse([cx + ro[0] - 4, NEAR_H + ro[1] - 4, cx + ro[0] + 4, NEAR_H + ro[1] + 4], fill=(245, 130, 175, 240))
    near.save(os.path.join(out_dir, "trees.png"))
    print("  [OK] Background gerado para: maid")

# ==============================================================================
# 4. MAOMAO: Palácio Imperial das Ervas (Imperial Apothecary)
# ==============================================================================
def generate_maomao():
    out_dir = os.path.join(BG_ROOT, "maomao")
    os.makedirs(out_dir, exist_ok=True)
    
    # 1. SKY (1280x720) - Jade midnight sky with floating lanterns
    sky = create_gradient_img(WIDTH, SKY_H, [
        (0.0, (10, 22, 20, 255)),
        (0.45, (20, 48, 40, 255)),
        (0.8, (35, 78, 62, 255)),
        (1.0, (55, 105, 82, 255))
    ])
    sdraw = ImageDraw.Draw(sky)
    add_stars(sdraw, 100, WIDTH, SKY_H, [(220, 255, 235, 220), (255, 230, 180, 200)], seed=404)
    # Crimson floating paper lanterns in the sky
    rng = random.Random(505)
    for _ in range(14):
        lx = rng.randint(0, WIDTH - 1)
        ly = rng.randint(40, 340)
        sdraw.ellipse([lx - 7, ly - 10, lx + 7, ly + 10], fill=(235, 60, 50, 220))
        sdraw.ellipse([lx - 4, ly - 6, lx + 4, ly + 6], fill=(255, 210, 110, 240))
        sdraw.line([(lx, ly + 10), (lx, ly + 16)], fill=(180, 40, 40, 200), width=1)
    sky.save(os.path.join(out_dir, "sky.png"))
    
    # 2. FAR (1280x400)
    far = Image.new("RGBA", (WIDTH, FAR_H), (0, 0, 0, 0))
    fdraw = ImageDraw.Draw(far)
    # Imperial palace pagodas with curved upturned roofs
    for i in range(8):
        cx = (i * 160 + 80) % WIDTH
        # Multi-tiered pagoda roof
        for tier in range(3):
            ty = FAR_H - 120 - tier * 45
            rw = 60 - tier * 10
            # Upturned roof eave
            fdraw.polygon([(cx - rw - 15, ty), (cx + rw + 15, ty), (cx + rw, ty - 18), (cx - rw, ty - 18)], fill=(32, 18, 22, 240))
            fdraw.rectangle([cx - rw + 10, ty, cx + rw - 10, ty + 25], fill=(22, 40, 32, 250))
    far.save(os.path.join(out_dir, "far.png"))
    
    # 3. MID (1280x360)
    mid = Image.new("RGBA", (WIDTH, MID_H), (0, 0, 0, 0))
    mdraw = ImageDraw.Draw(mid)
    # Bamboo forest grove and red lacquer pavilions
    for i in range(16):
        cx = (i * 80 + 35) % WIDTH
        # Bamboo stalk
        for seg in range(6):
            sy = MID_H - seg * 45
            mdraw.rectangle([cx - 4, sy - 40, cx + 4, sy], fill=(25, 65, 42, 240))
            # Bamboo joint ring
            mdraw.ellipse([cx - 6, sy - 42, cx + 6, sy - 38], fill=(45, 95, 60, 255))
            # Bamboo leaves
            mdraw.line([(cx, sy - 30), (cx + 25, sy - 40)], fill=(35, 85, 50, 220), width=2)
            mdraw.line([(cx, sy - 30), (cx - 25, sy - 40)], fill=(35, 85, 50, 220), width=2)
    mid.save(os.path.join(out_dir, "mid.png"))
    
    # 4. TREES/NEAR (1280x240)
    near = Image.new("RGBA", (WIDTH, NEAR_H), (0, 0, 0, 0))
    ndraw = ImageDraw.Draw(near)
    # Herbal drying racks, ceramic medicine jars, and red carved railings
    for i in range(12):
        cx = (i * 106 + 50) % WIDTH
        # Wooden drying rack
        ndraw.rectangle([cx - 30, NEAR_H - 120, cx - 24, NEAR_H], fill=(30, 22, 18, 255))
        ndraw.rectangle([cx + 24, NEAR_H - 120, cx + 30, NEAR_H], fill=(30, 22, 18, 255))
        ndraw.rectangle([cx - 35, NEAR_H - 100, cx + 35, NEAR_H - 94], fill=(45, 32, 25, 255))
        # Hanging bundles of medicinal herbs
        for hb in [-18, 0, 18]:
            ndraw.polygon([(cx + hb - 5, NEAR_H - 94), (cx + hb + 5, NEAR_H - 94), (cx + hb, NEAR_H - 65)], fill=(65, 140, 75, 240))
        # Ceramic apothecary jar
        ndraw.ellipse([cx + 36, NEAR_H - 35, cx + 56, NEAR_H - 10], fill=(25, 45, 55, 255))
        ndraw.rectangle([cx + 42, NEAR_H - 42, cx + 50, NEAR_H - 35], fill=(160, 50, 45, 255)) # Red wax seal
    near.save(os.path.join(out_dir, "trees.png"))
    print("  [OK] Background gerado para: maomao")

# ==============================================================================
# 5. MIKU: Metrópole Cyberpunk Neon (Cyber Synth City)
# ==============================================================================
def generate_miku():
    out_dir = os.path.join(BG_ROOT, "miku")
    os.makedirs(out_dir, exist_ok=True)
    
    # 1. SKY (1280x720) - Electric cyan/magenta cyber gradient with visualizer bars
    sky = create_gradient_img(WIDTH, SKY_H, [
        (0.0, (10, 8, 28, 255)),
        (0.5, (22, 14, 52, 255)),
        (0.8, (25, 45, 80, 255)),
        (1.0, (15, 75, 95, 255))
    ])
    sdraw = ImageDraw.Draw(sky)
    # Giant Holographic Audio Visualizer in the sky!
    for i in range(32):
        bx = i * 40 + 10
        # Waveform height
        bh = int(120 + 80 * math.sin(i * 0.4) + 40 * math.cos(i * 0.9))
        col = (40, 240, 215, 110) if i % 2 == 0 else (245, 60, 180, 110)
        sdraw.rectangle([bx, SKY_H - 320 - bh, bx + 22, SKY_H - 320], fill=col)
    sky.save(os.path.join(out_dir, "sky.png"))
    
    # 2. FAR (1280x400)
    far = Image.new("RGBA", (WIDTH, FAR_H), (0, 0, 0, 0))
    fdraw = ImageDraw.Draw(far)
    # Cyberpunk mega-skyscrapers with glowing cyan & magenta windows
    rng = random.Random(606)
    for i in range(16):
        cx = (i * 80 + 40) % WIDTH
        bh = rng.randint(220, 360)
        bw = rng.randint(55, 75)
        # Tower
        fdraw.rectangle([cx - bw//2, FAR_H - bh, cx + bw//2, FAR_H], fill=(16, 18, 38, 240))
        # Windows grid
        for wy in range(FAR_H - bh + 15, FAR_H - 20, 18):
            for wx in range(cx - bw//2 + 8, cx + bw//2 - 8, 14):
                if rng.random() < 0.6:
                    wcol = (50, 245, 220, 200) if rng.random() < 0.5 else (255, 65, 175, 200)
                    fdraw.rectangle([wx, wy, wx + 6, wy + 8], fill=wcol)
        # Rooftop antenna
        fdraw.line([(cx, FAR_H - bh), (cx, FAR_H - bh - 30)], fill=(50, 245, 220, 255), width=2)
    far.save(os.path.join(out_dir, "far.png"))
    
    # 3. MID (1280x360)
    mid = Image.new("RGBA", (WIDTH, MID_H), (0, 0, 0, 0))
    mdraw = ImageDraw.Draw(mid)
    # Holographic musical notes and neon elevated highways
    for i in range(10):
        cx = (i * 128 + 64) % WIDTH
        # Highway pillar
        mdraw.rectangle([cx - 16, MID_H - 180, cx + 16, MID_H], fill=(18, 20, 32, 255))
        # Glowing elevated road
        mdraw.rectangle([cx - 64, MID_H - 185, cx + 64, MID_H - 170], fill=(30, 34, 52, 255))
        mdraw.line([(cx - 64, MID_H - 170), (cx + 64, MID_H - 170)], fill=(50, 245, 220, 240), width=3)
        # Floating neon musical eighth note ♪
        mdraw.ellipse([cx + 20, MID_H - 240, cx + 34, MID_H - 228], fill=(255, 80, 190, 230))
        mdraw.line([(cx + 34, MID_H - 234), (cx + 34, MID_H - 265)], fill=(255, 80, 190, 230), width=3)
        mdraw.line([(cx + 34, MID_H - 265), (cx + 46, MID_H - 260)], fill=(255, 80, 190, 230), width=3)
    mid.save(os.path.join(out_dir, "mid.png"))
    
    # 4. TREES/NEAR (1280x240)
    near = Image.new("RGBA", (WIDTH, NEAR_H), (0, 0, 0, 0))
    ndraw = ImageDraw.Draw(near)
    # Stage sound amplifiers, neon synthesizers, and cyber laser projectors
    for i in range(12):
        cx = (i * 106 + 50) % WIDTH
        # Sound amp stack
        ndraw.rectangle([cx - 26, NEAR_H - 120, cx + 26, NEAR_H], fill=(12, 14, 22, 255))
        # Speaker cones
        for cone_y in [NEAR_H - 95, NEAR_H - 50]:
            ndraw.ellipse([cx - 18, cone_y - 18, cx + 18, cone_y + 18], fill=(24, 28, 40, 255))
            ndraw.ellipse([cx - 8, cone_y - 8, cx + 8, cone_y + 8], fill=(50, 245, 220, 240))
        # Neon laser beam cutting upward
        ndraw.line([(cx, NEAR_H - 120), (cx + 35, 0)], fill=(255, 60, 190, 160), width=2)
    near.save(os.path.join(out_dir, "trees.png"))
    print("  [OK] Background gerado para: miku")

# ==============================================================================
# 6. SONSERINA: Masmorras de Esmeralda (Slytherin Emerald Dungeons)
# ==============================================================================
def generate_sonserina():
    out_dir = os.path.join(BG_ROOT, "sonserina")
    os.makedirs(out_dir, exist_ok=True)
    
    # 1. SKY (1280x720) - Deep black lake depths with eerie emerald rays
    sky = create_gradient_img(WIDTH, SKY_H, [
        (0.0, (6, 14, 10, 255)),
        (0.4, (12, 32, 22, 255)),
        (0.8, (18, 55, 36, 255)),
        (1.0, (26, 75, 48, 255))
    ])
    sdraw = ImageDraw.Draw(sky)
    # Caustic emerald light rays penetrating the dark lake waters
    for i in range(16):
        rx0 = i * 90 - 40
        sdraw.polygon([(rx0, 0), (rx0 + 50, 0), (rx0 + 130, SKY_H), (rx0 + 60, SKY_H)], fill=(60, 200, 120, 25))
    sky.save(os.path.join(out_dir, "sky.png"))
    
    # 2. FAR (1280x400)
    far = Image.new("RGBA", (WIDTH, FAR_H), (0, 0, 0, 0))
    fdraw = ImageDraw.Draw(far)
    # Submerged gothic castle vaults and serpent stone arches
    for i in range(8):
        cx = (i * 160 + 80) % WIDTH
        # Stone arch column
        fdraw.rectangle([cx - 40, FAR_H - 240, cx - 24, FAR_H], fill=(16, 26, 20, 250))
        fdraw.rectangle([cx + 24, FAR_H - 240, cx + 40, FAR_H], fill=(16, 26, 20, 250))
        # Pointed gothic arch
        fdraw.polygon([(cx - 48, FAR_H - 240), (cx + 48, FAR_H - 240), (cx, FAR_H - 310)], fill=(12, 22, 16, 255))
        # Emerald stained glass
        fdraw.polygon([(cx - 24, FAR_H - 230), (cx + 24, FAR_H - 230), (cx, FAR_H - 280)], fill=(40, 150, 85, 140))
    far.save(os.path.join(out_dir, "far.png"))
    
    # 3. MID (1280x360)
    mid = Image.new("RGBA", (WIDTH, MID_H), (0, 0, 0, 0))
    mdraw = ImageDraw.Draw(mid)
    # Carved serpent columns and floating silver water wisps
    for i in range(10):
        cx = (i * 128 + 64) % WIDTH
        # Carved stone pillar
        mdraw.rectangle([cx - 22, MID_H - 200, cx + 22, MID_H], fill=(18, 28, 22, 255))
        # Coiled serpent carving along the pillar (silver-emerald)
        for coil in range(5):
            cy = MID_H - 180 + coil * 35
            side = 1 if coil % 2 == 0 else -1
            mdraw.arc([cx - 18, cy - 12, cx + 18, cy + 12], start=0, end=180, fill=(90, 190, 130, 220), width=4)
        # Brazier of green fire
        mdraw.rectangle([cx - 14, MID_H - 215, cx + 14, MID_H - 200], fill=(35, 45, 38, 255))
        mdraw.ellipse([cx - 10, MID_H - 235, cx + 10, MID_H - 210], fill=(60, 240, 120, 220))
        mdraw.ellipse([cx - 5, MID_H - 230, cx + 5, MID_H - 215], fill=(200, 255, 210, 240))
    mid.save(os.path.join(out_dir, "mid.png"))
    
    # 4. TREES/NEAR (1280x240)
    near = Image.new("RGBA", (WIDTH, NEAR_H), (0, 0, 0, 0))
    ndraw = ImageDraw.Draw(near)
    # Dungeon potion cauldrons emitting green mist, stone gargoyles
    for i in range(12):
        cx = (i * 106 + 50) % WIDTH
        # Dark iron cauldron
        ndraw.ellipse([cx - 25, NEAR_H - 80, cx + 25, NEAR_H - 30], fill=(14, 18, 16, 255))
        ndraw.ellipse([cx - 22, NEAR_H - 85, cx + 22, NEAR_H - 70], fill=(45, 180, 95, 240))
        # Green mist bubbling up
        ndraw.ellipse([cx - 12, NEAR_H - 110, cx + 4, NEAR_H - 88], fill=(80, 220, 140, 110))
        ndraw.ellipse([cx - 2, NEAR_H - 130, cx + 16, NEAR_H - 105], fill=(80, 220, 140, 90))
    near.save(os.path.join(out_dir, "trees.png"))
    print("  [OK] Background gerado para: sonserina")

# ==============================================================================
# 7. TRACEN: Academia Tracen - Pista de Velocidade (Tracen Racetrack)
# ==============================================================================
def generate_tracen():
    out_dir = os.path.join(BG_ROOT, "tracen")
    os.makedirs(out_dir, exist_ok=True)
    
    # 1. SKY (1280x720) - Golden hour race twilight
    sky = create_gradient_img(WIDTH, SKY_H, [
        (0.0, (25, 20, 48, 255)),
        (0.4, (75, 40, 75, 255)),
        (0.75, (160, 75, 80, 255)),
        (1.0, (235, 140, 90, 255))
    ])
    sdraw = ImageDraw.Draw(sky)
    # Sunset sun glow on horizon
    sdraw.ellipse([WIDTH//2 - 120, SKY_H - 260, WIDTH//2 + 120, SKY_H - 20], fill=(255, 215, 120, 150))
    sky.save(os.path.join(out_dir, "sky.png"))
    
    # 2. FAR (1280x400)
    far = Image.new("RGBA", (WIDTH, FAR_H), (0, 0, 0, 0))
    fdraw = ImageDraw.Draw(far)
    # Stadium grandstands and stadium light towers
    for i in range(12):
        cx = (i * 110 + 50) % WIDTH
        # Grandstand tier
        fdraw.rectangle([cx - 48, FAR_H - 160, cx + 48, FAR_H], fill=(55, 30, 50, 240))
        # Stadium light mast
        if i % 3 == 0:
            fdraw.line([(cx, FAR_H - 160), (cx, FAR_H - 280)], fill=(40, 25, 40, 255), width=3)
            # Light bank
            fdraw.rectangle([cx - 24, FAR_H - 295, cx + 24, FAR_H - 280], fill=(255, 245, 200, 230))
    far.save(os.path.join(out_dir, "far.png"))
    
    # 3. MID (1280x360)
    mid = Image.new("RGBA", (WIDTH, MID_H), (0, 0, 0, 0))
    mdraw = ImageDraw.Draw(mid)
    # Lush green rolling turf hills and fluttering championship banners
    for i in range(10):
        cx = (i * 128 + 64) % WIDTH
        # Turf hill crest
        mdraw.ellipse([cx - 90, MID_H - 140, cx + 90, MID_H + 40], fill=(45, 95, 48, 255))
        # Flagpole
        mdraw.line([(cx, MID_H - 130), (cx, MID_H - 200)], fill=(180, 180, 190, 255), width=2)
        flag_col = (235, 60, 60, 240) if i % 2 == 0 else (60, 120, 235, 240)
        mdraw.polygon([(cx, MID_H - 200), (cx + 30, MID_H - 185), (cx, MID_H - 170)], fill=flag_col)
    mid.save(os.path.join(out_dir, "mid.png"))
    
    # 4. TREES/NEAR (1280x240)
    near = Image.new("RGBA", (WIDTH, NEAR_H), (0, 0, 0, 0))
    ndraw = ImageDraw.Draw(near)
    # White racetrack rail fences, distance markers, and pruned green hedges
    for i in range(16):
        cx = (i * 80 + 40) % WIDTH
        # White rail fence posts
        ndraw.rectangle([cx - 4, NEAR_H - 95, cx + 4, NEAR_H], fill=(240, 245, 250, 255))
        # Horizontal white rails
        ndraw.line([(cx - 40, NEAR_H - 85), (cx + 40, NEAR_H - 85)], fill=(240, 245, 250, 255), width=3)
        ndraw.line([(cx - 40, NEAR_H - 55), (cx + 40, NEAR_H - 55)], fill=(240, 245, 250, 255), width=3)
        # Distance marker (e.g. 200m, 400m)
        if i % 4 == 0:
            ndraw.rectangle([cx + 15, NEAR_H - 125, cx + 38, NEAR_H - 95], fill=(230, 45, 45, 255))
            ndraw.ellipse([cx + 20, NEAR_H - 120, cx + 33, NEAR_H - 100], fill=(255, 255, 255, 255))
    near.save(os.path.join(out_dir, "trees.png"))
    print("  [OK] Background gerado para: tracen")

if __name__ == "__main__":
    print("\n=== Gerando Backgrounds Parallax para os Novos Mundos ===")
    generate_agnes()
    generate_frieren()
    generate_maid()
    generate_maomao()
    generate_miku()
    generate_sonserina()
    generate_tracen()
    print("\n[SUCESSO] Todos os 7 novos mundos têm backgrounds Parallax completos e seamless!")
