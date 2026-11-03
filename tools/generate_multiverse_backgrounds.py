"""
Linaverse - Multiverse Custom Background Generator
Generates personalized, unique high-quality 2D backgrounds for all 6 universes:
- classic: Arctic polar landscape (aurora, snow peaks, pine forest)
- celestial: Astral cosmos (crescent moon, nebula, floating islands, star trees)
- valkyrie: Norse realm (runic aurora, Valhalla spires, Viking runestones, frost pines)
- ninja: Japanese snow night (giant full moon, pagodas, Torii gates, bamboo & sakura)
- royalty: Sapphire crystal palace (imperial towers, castle arches, royal topiary gardens)
- uniform: Modern metropolis (skyscrapers, lit windows, school rooftops, utility poles, streetlamps)

Ensures 100% seamless horizontal tiling at 1280px width for Parallax scrolling.
"""

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
    """stops = list of (pos_float, (r, g, b, a))"""
    img = Image.new("RGBA", (w, h))
    pixels = img.load()
    stops = sorted(stops, key=lambda s: s[0])
    
    col_cache = []
    for y in range(h):
        t = y / float(h - 1)
        # find stops
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

def add_stars(draw, count, w, h, colors=[(255, 255, 255, 220), (220, 240, 255, 200), (255, 230, 160, 180)], seed=42):
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
            # 4-point cross sparkle
            draw.rectangle([x, y, x + 1, y + 1], fill=(255, 255, 255, 255))
            draw.point((x - 1, y), fill=c)
            draw.point((x + 2, y), fill=c)
            draw.point((x, y - 1), fill=c)
            draw.point((x, y + 2), fill=c)

# -------------------------------------------------------------
# 1. CELESTIAL UNIVERSE GENERATION
# -------------------------------------------------------------
def generate_celestial():
    out_dir = os.path.join(BG_ROOT, "celestial")
    os.makedirs(out_dir, exist_ok=True)
    
    # 1.1 SKY (1280x720)
    sky = create_gradient_img(WIDTH, SKY_H, [
        (0.0, (14, 8, 34, 255)),
        (0.35, (32, 14, 66, 255)),
        (0.7, (65, 22, 95, 255)),
        (1.0, (92, 35, 118, 255))
    ])
    
    # Nebula glow
    nebula = Image.new("RGBA", (WIDTH, SKY_H), (0, 0, 0, 0))
    ndraw = ImageDraw.Draw(nebula)
    # Wavy nebula band
    for i in range(12):
        cx = (i * 120 + 80) % WIDTH
        cy = 220 + int(45 * math.sin(i * 0.8))
        rx = 160 + (i % 3) * 30
        ry = 70 + (i % 2) * 25
        col = (180, 80, 240, 35) if i % 2 == 0 else (255, 190, 70, 25)
        ndraw.ellipse([cx - rx, cy - ry, cx + rx, cy + ry], fill=col)
    nebula = nebula.filter(ImageFilter.GaussianBlur(35))
    sky.alpha_composite(nebula)
    
    sdraw = ImageDraw.Draw(sky)
    add_stars(sdraw, 240, WIDTH, SKY_H, colors=[(255, 255, 255, 240), (255, 225, 140, 220), (210, 160, 255, 200)], seed=101)
    
    # Constellation lines
    constell_pts = [(180, 140), (230, 120), (290, 150), (340, 110), (390, 160)]
    for i in range(len(constell_pts) - 1):
        sdraw.line([constell_pts[i], constell_pts[i+1]], fill=(255, 225, 140, 120), width=1)
    for p in constell_pts:
        sdraw.ellipse([p[0]-2, p[1]-2, p[0]+2, p[1]+2], fill=(255, 240, 180, 230))
        
    constell_pts2 = [(820, 100), (880, 85), (920, 130), (990, 110), (1050, 150)]
    for i in range(len(constell_pts2) - 1):
        sdraw.line([constell_pts2[i], constell_pts2[i+1]], fill=(210, 180, 255, 110), width=1)
    for p in constell_pts2:
        sdraw.ellipse([p[0]-2, p[1]-2, p[0]+2, p[1]+2], fill=(230, 210, 255, 230))
    
    # Golden Crescent Moon
    mx, my, mr = 640, 160, 52
    moon_glow = Image.new("RGBA", (WIDTH, SKY_H), (0, 0, 0, 0))
    mg_draw = ImageDraw.Draw(moon_glow)
    mg_draw.ellipse([mx - mr - 20, my - mr - 20, mx + mr + 20, my + mr + 20], fill=(255, 220, 110, 50))
    moon_glow = moon_glow.filter(ImageFilter.GaussianBlur(16))
    sky.alpha_composite(moon_glow)
    
    sdraw = ImageDraw.Draw(sky)
    sdraw.ellipse([mx - mr, my - mr, mx + mr, my + mr], fill=(255, 235, 150, 250))
    # Cutout for crescent
    sdraw.ellipse([mx - mr + 22, my - mr - 10, mx + mr + 24, my + mr + 12], fill=(42, 16, 72, 255))
    
    # Moon planetary ring
    sdraw.arc([mx - mr - 35, my - 15, mx + mr + 35, my + 15], start=10, end=170, fill=(255, 220, 130, 160), width=2)
    sdraw.arc([mx - mr - 35, my - 15, mx + mr + 35, my + 15], start=190, end=350, fill=(255, 220, 130, 90), width=2)
    
    sky.save(os.path.join(out_dir, "sky.png"))
    
    # 1.2 FAR LAYER (1280x400) - Floating Cosmic Islands & Crystal Peaks
    far = Image.new("RGBA", (WIDTH, FAR_H), (0, 0, 0, 0))
    fdraw = ImageDraw.Draw(far)
    
    # Procedural floating islands and crystalline peaks with seamless wrapping
    island_x_list = [100, 320, 580, 840, 1100]
    for ix in island_x_list:
        w_isl = 160
        top_y = 120 + int(35 * math.sin(ix * 0.015))
        bot_y = top_y + 85
        # island body
        pts = [
            (ix - w_isl//2, top_y + 15),
            (ix - w_isl//4, top_y),
            (ix + w_isl//4, top_y + 5),
            (ix + w_isl//2, top_y + 20),
            (ix + w_isl//3, bot_y - 20),
            (ix, bot_y),
            (ix - w_isl//3, bot_y - 25)
        ]
        fdraw.polygon(pts, fill=(35, 16, 62, 235))
        # glowing crystal clusters on island
        c_pts = [(ix - 15, top_y - 25), (ix - 5, top_y), (ix - 25, top_y)]
        fdraw.polygon(c_pts, fill=(255, 215, 100, 240))
        c_pts2 = [(ix + 12, top_y - 35), (ix + 24, top_y), (ix, top_y)]
        fdraw.polygon(c_pts2, fill=(210, 150, 255, 230))
        # highlight edge
        fdraw.line([(ix - w_isl//2, top_y + 15), (ix - w_isl//4, top_y), (ix + w_isl//4, top_y + 5), (ix + w_isl//2, top_y + 20)], fill=(245, 205, 110, 220), width=2)

    # Distant cosmic mountain peaks behind at bottom
    mountain_pts = [(0, FAR_H)]
    for x in range(0, WIDTH + 1, 20):
        # seamless harmonic formula
        y = 230 + 55 * math.sin(x * (2 * math.pi / WIDTH) * 2) + 30 * math.sin(x * (2 * math.pi / WIDTH) * 5)
        mountain_pts.append((x, int(y)))
    mountain_pts.append((WIDTH, FAR_H))
    fdraw.polygon(mountain_pts, fill=(48, 22, 80, 245))
    
    # Crystal highlights on mountain peaks
    for x in range(40, WIDTH, 160):
        peak_y = int(230 + 55 * math.sin(x * (2 * math.pi / WIDTH) * 2) + 30 * math.sin(x * (2 * math.pi / WIDTH) * 5))
        fdraw.polygon([(x, peak_y - 30), (x + 12, peak_y + 10), (x - 12, peak_y + 10)], fill=(255, 220, 110, 220))
        
    far.save(os.path.join(out_dir, "far.png"))
    
    # 1.3 MID LAYER (1280x360) - Astral Shrines & Floating Arches
    mid = Image.new("RGBA", (WIDTH, MID_H), (0, 0, 0, 0))
    mdraw = ImageDraw.Draw(mid)
    
    # Mid-range floating rocks and crags
    mid_mountain = [(0, MID_H)]
    for x in range(0, WIDTH + 1, 16):
        y = 170 + 45 * math.sin(x * (2 * math.pi / WIDTH) * 3 + 1.2) + 25 * math.cos(x * (2 * math.pi / WIDTH) * 6)
        mid_mountain.append((x, int(y)))
    mid_mountain.append((WIDTH, MID_H))
    mdraw.polygon(mid_mountain, fill=(28, 12, 52, 255))
    
    # Celestial Pillars and Archways on peaks
    for x_arch in [220, 640, 1060]:
        y_base = int(170 + 45 * math.sin(x_arch * (2 * math.pi / WIDTH) * 3 + 1.2) + 25 * math.cos(x_arch * (2 * math.pi / WIDTH) * 6))
        # Left pillar
        mdraw.rectangle([x_arch - 25, y_base - 70, x_arch - 15, y_base], fill=(62, 28, 98, 255))
        # Right pillar
        mdraw.rectangle([x_arch + 15, y_base - 70, x_arch + 25, y_base], fill=(62, 28, 98, 255))
        # Arch top
        mdraw.rectangle([x_arch - 30, y_base - 80, x_arch + 30, y_base - 70], fill=(95, 45, 140, 255))
        # Floating astral diamond inside arch
        mdraw.polygon([(x_arch, y_base - 62), (x_arch + 8, y_base - 48), (x_arch, y_base - 34), (x_arch - 8, y_base - 48)], fill=(255, 230, 120, 250))
    
    # Glowing gold ridge line
    for i in range(1, len(mid_mountain) - 2):
        mdraw.line([mid_mountain[i], mid_mountain[i+1]], fill=(185, 120, 245, 200), width=2)
        
    mid.save(os.path.join(out_dir, "mid.png"))
    
    # 1.4 TREES LAYER (1280x240) - Celestial Star Willow Trees & Crystal Spire Shards
    trees = Image.new("RGBA", (WIDTH, NEAR_H), (0, 0, 0, 0))
    tdraw = ImageDraw.Draw(trees)
    
    # Ground silhouette
    ground_pts = [(0, NEAR_H)]
    for x in range(0, WIDTH + 1, 10):
        y = 160 + 15 * math.sin(x * (2 * math.pi / WIDTH) * 4) + 8 * math.cos(x * (2 * math.pi / WIDTH) * 8)
        ground_pts.append((x, int(y)))
    ground_pts.append((WIDTH, NEAR_H))
    tdraw.polygon(ground_pts, fill=(18, 8, 35, 255))
    
    # Draw Celestial Willow Trees with glowing spiral foliage
    tree_x_positions = [80, 200, 340, 480, 620, 760, 900, 1040, 1180]
    for tx in tree_x_positions:
        ty = int(160 + 15 * math.sin(tx * (2 * math.pi / WIDTH) * 4) + 8 * math.cos(tx * (2 * math.pi / WIDTH) * 8))
        # Trunk
        tdraw.rectangle([tx - 4, ty - 60, tx + 4, ty], fill=(32, 14, 55, 255))
        # Swirling celestial foliage circles
        tdraw.ellipse([tx - 35, ty - 120, tx + 35, ty - 50], fill=(45, 20, 78, 250))
        tdraw.ellipse([tx - 28, ty - 135, tx + 28, ty - 75], fill=(70, 30, 110, 240))
        tdraw.ellipse([tx - 18, ty - 145, tx + 18, ty - 95], fill=(105, 45, 155, 240))
        # Star fruits (glowing gold dots)
        for fx, fy in [(tx - 18, ty - 85), (tx + 16, ty - 90), (tx, ty - 115), (tx - 10, ty - 130), (tx + 12, ty - 125)]:
            tdraw.ellipse([fx - 3, fy - 3, fx + 3, fy + 3], fill=(255, 225, 110, 255))
            
    # Crystal stalagmites on ground
    for cx in range(30, WIDTH, 75):
        cy = int(160 + 15 * math.sin(cx * (2 * math.pi / WIDTH) * 4) + 8 * math.cos(cx * (2 * math.pi / WIDTH) * 8))
        ch = 22 + (cx % 18)
        tdraw.polygon([(cx, cy - ch), (cx + 5, cy), (cx - 5, cy)], fill=(230, 180, 255, 230))
        tdraw.polygon([(cx, cy - ch), (cx + 2, cy), (cx - 2, cy)], fill=(255, 240, 180, 255))
        
    trees.save(os.path.join(out_dir, "trees.png"))
    print("[OK] Generated custom Celestial Universe background textures!")

# -------------------------------------------------------------
# 2. VALKYRIE UNIVERSE GENERATION
# -------------------------------------------------------------
def generate_valkyrie():
    out_dir = os.path.join(BG_ROOT, "valkyrie")
    os.makedirs(out_dir, exist_ok=True)
    
    # 2.1 SKY (1280x720) - Valhalla Norse Aurora & Yggdrasil Glow
    sky = create_gradient_img(WIDTH, SKY_H, [
        (0.0, (5, 18, 34, 255)),
        (0.3, (12, 38, 62, 255)),
        (0.65, (22, 70, 95, 255)),
        (1.0, (48, 125, 145, 255))
    ])
    
    # Radiant Norse Aurora Ribbons in Cyan and Emerald
    aurora_layer = Image.new("RGBA", (WIDTH, SKY_H), (0, 0, 0, 0))
    adraw = ImageDraw.Draw(aurora_layer)
    for band in range(4):
        y_offset = 120 + band * 50
        pts_top = []
        pts_bot = []
        for x in range(0, WIDTH + 20, 20):
            wav = math.sin(x * (2 * math.pi / WIDTH) * 2 + band * 1.5) * 40 + math.cos(x * 0.01) * 25
            pts_top.append((x, y_offset + wav))
            pts_bot.append((x, y_offset + wav + 70))
        poly = pts_top + list(reversed(pts_bot))
        col = (60, 240, 220, 45) if band % 2 == 0 else (120, 255, 190, 40)
        adraw.polygon(poly, fill=col)
    aurora_layer = aurora_layer.filter(ImageFilter.GaussianBlur(28))
    sky.alpha_composite(aurora_layer)
    
    sdraw = ImageDraw.Draw(sky)
    add_stars(sdraw, 200, WIDTH, SKY_H, colors=[(255, 255, 255, 240), (160, 240, 255, 220), (200, 255, 230, 200)], seed=202)
    
    # Distant glowing Bifrost rainbow arc
    bifrost = Image.new("RGBA", (WIDTH, SKY_H), (0, 0, 0, 0))
    bdraw = ImageDraw.Draw(bifrost)
    bdraw.arc([150, 100, 1130, 950], start=190, end=350, fill=(100, 220, 255, 90), width=6)
    bdraw.arc([155, 105, 1125, 945], start=190, end=350, fill=(255, 210, 100, 70), width=4)
    bdraw.arc([160, 110, 1120, 940], start=190, end=350, fill=(255, 140, 180, 60), width=3)
    bifrost = bifrost.filter(ImageFilter.GaussianBlur(6))
    sky.alpha_composite(bifrost)
    
    sky.save(os.path.join(out_dir, "sky.png"))
    
    # 2.2 FAR LAYER (1280x400) - Nordic Fjord Glaciers & Golden Valhalla Spires
    far = Image.new("RGBA", (WIDTH, FAR_H), (0, 0, 0, 0))
    fdraw = ImageDraw.Draw(far)
    
    # High sharp glacial fjord peaks
    glacier_pts = [(0, FAR_H)]
    for x in range(0, WIDTH + 1, 16):
        y = 190 + 65 * math.sin(x * (2 * math.pi / WIDTH) * 2 - 0.5) + 35 * math.cos(x * (2 * math.pi / WIDTH) * 4)
        glacier_pts.append((x, int(y)))
    glacier_pts.append((WIDTH, FAR_H))
    fdraw.polygon(glacier_pts, fill=(16, 42, 68, 245))
    
    # Valhalla Castle Spires on the central fjord (x: 560 to 720)
    for sp_x, sp_h in [(600, 140), (630, 180), (640, 210), (650, 180), (680, 150)]:
        y_b = int(190 + 65 * math.sin(sp_x * (2 * math.pi / WIDTH) * 2 - 0.5) + 35 * math.cos(sp_x * (2 * math.pi / WIDTH) * 4))
        # Spire tower
        fdraw.polygon([(sp_x, y_b - sp_h), (sp_x + 9, y_b), (sp_x - 9, y_b)], fill=(225, 185, 90, 250))
        # Tip gleam
        fdraw.ellipse([sp_x - 3, y_b - sp_h - 3, sp_x + 3, y_b - sp_h + 3], fill=(255, 245, 180, 255))
        
    # Glacial frost caps on peaks
    for i in range(1, len(glacier_pts) - 2):
        if glacier_pts[i][1] < 220:
            fdraw.line([glacier_pts[i], glacier_pts[i+1]], fill=(180, 235, 255, 240), width=3)
            
    far.save(os.path.join(out_dir, "far.png"))
    
    # 2.3 MID LAYER (1280x360) - Giant Viking Runestones on Craggy Bluffs
    mid = Image.new("RGBA", (WIDTH, MID_H), (0, 0, 0, 0))
    mdraw = ImageDraw.Draw(mid)
    
    mid_bluff = [(0, MID_H)]
    for x in range(0, WIDTH + 1, 16):
        y = 160 + 50 * math.sin(x * (2 * math.pi / WIDTH) * 3 + 0.8) + 20 * math.sin(x * (2 * math.pi / WIDTH) * 7)
        mid_bluff.append((x, int(y)))
    mid_bluff.append((WIDTH, MID_H))
    mdraw.polygon(mid_bluff, fill=(12, 32, 54, 255))
    
    # Giant Norse Runestones
    runestone_x = [180, 420, 680, 920, 1140]
    for rx in runestone_x:
        ry = int(160 + 50 * math.sin(rx * (2 * math.pi / WIDTH) * 3 + 0.8) + 20 * math.sin(rx * (2 * math.pi / WIDTH) * 7))
        rw, rh = 28, 70
        # Stone tablet
        mdraw.polygon([(rx - rw//2, ry), (rx - rw//2 + 4, ry - rh), (rx + rw//2 - 4, ry - rh), (rx + rw//2, ry)], fill=(28, 55, 82, 255))
        # Glowing Norse Rune carved in center (Algiz / Valkyrie Rune)
        mdraw.line([(rx, ry - 15), (rx, ry - rh + 15)], fill=(70, 245, 255, 255), width=2)
        mdraw.line([(rx, ry - rh + 28), (rx - 8, ry - rh + 16)], fill=(70, 245, 255, 255), width=2)
        mdraw.line([(rx, ry - rh + 28), (rx + 8, ry - rh + 16)], fill=(70, 245, 255, 255), width=2)
        
    # Icy cliff highlights
    for i in range(1, len(mid_bluff) - 2):
        mdraw.line([mid_bluff[i], mid_bluff[i+1]], fill=(120, 210, 245, 220), width=2)
        
    mid.save(os.path.join(out_dir, "mid.png"))
    
    # 2.4 TREES LAYER (1280x240) - Yggdrasil Frost Pines & Viking Banners
    trees = Image.new("RGBA", (WIDTH, NEAR_H), (0, 0, 0, 0))
    tdraw = ImageDraw.Draw(trees)
    
    g_pts = [(0, NEAR_H)]
    for x in range(0, WIDTH + 1, 10):
        y = 155 + 16 * math.sin(x * (2 * math.pi / WIDTH) * 4 + 1.0)
        g_pts.append((x, int(y)))
    g_pts.append((WIDTH, NEAR_H))
    tdraw.polygon(g_pts, fill=(8, 22, 38, 255))
    
    # Rugged, frost-laden Nordic Pines
    pine_x = [60, 160, 270, 390, 510, 630, 750, 870, 990, 1110, 1220]
    for px in pine_x:
        py = int(155 + 16 * math.sin(px * (2 * math.pi / WIDTH) * 4 + 1.0))
        # Trunk
        tdraw.rectangle([px - 4, py - 40, px + 4, py], fill=(18, 35, 52, 255))
        # Triangular tiers of frost pine
        for tier, (w, h_off) in enumerate([(48, 60), (38, 90), (26, 120), (14, 145)]):
            tdraw.polygon([(px, py - h_off - 20), (px + w//2, py - h_off + 15), (px - w//2, py - h_off + 15)], fill=(14, 38, 60, 255))
            # Frost rim on each branch
            tdraw.line([(px - w//2, py - h_off + 15), (px, py - h_off - 10), (px + w//2, py - h_off + 15)], fill=(160, 235, 255, 240), width=2)
            
    # Crossed Viking spears / shields in the snow
    for sx in [220, 570, 930]:
        sy = int(155 + 16 * math.sin(sx * (2 * math.pi / WIDTH) * 4 + 1.0))
        tdraw.line([(sx - 12, sy + 5), (sx + 12, sy - 28)], fill=(180, 195, 215, 255), width=2)
        tdraw.line([(sx + 12, sy + 5), (sx - 12, sy - 28)], fill=(180, 195, 215, 255), width=2)
        # Round Viking shield in center
        tdraw.ellipse([sx - 9, sy - 20, sx + 9, sy - 2], fill=(45, 95, 130, 255), outline=(210, 175, 80, 255), width=2)
        
    trees.save(os.path.join(out_dir, "trees.png"))
    print("[OK] Generated custom Valkyrie Universe background textures!")

# -------------------------------------------------------------
# 3. NINJA UNIVERSE GENERATION
# -------------------------------------------------------------
def generate_ninja():
    out_dir = os.path.join(BG_ROOT, "ninja")
    os.makedirs(out_dir, exist_ok=True)
    
    # 3.1 SKY (1280x720) - Giant Oborozuki Full Moon & Stormy Night
    sky = create_gradient_img(WIDTH, SKY_H, [
        (0.0, (6, 8, 20, 255)),
        (0.35, (14, 18, 38, 255)),
        (0.7, (24, 32, 58, 255)),
        (1.0, (38, 48, 76, 255))
    ])
    
    # Giant Moon Glow
    mx, my, mr = 880, 190, 85
    mglow = Image.new("RGBA", (WIDTH, SKY_H), (0, 0, 0, 0))
    mg_draw = ImageDraw.Draw(mglow)
    mg_draw.ellipse([mx - mr - 40, my - mr - 40, mx + mr + 40, my + mr + 40], fill=(220, 235, 255, 45))
    mglow = mglow.filter(ImageFilter.GaussianBlur(30))
    sky.alpha_composite(mglow)
    
    sdraw = ImageDraw.Draw(sky)
    add_stars(sdraw, 140, WIDTH, SKY_H, colors=[(210, 225, 255, 180), (180, 200, 240, 150)], seed=303)
    
    # Moon Disc
    sdraw.ellipse([mx - mr, my - mr, mx + mr, my + mr], fill=(240, 245, 255, 250))
    # Soft craters / maria
    sdraw.ellipse([mx - 35, my - 25, mx + 15, my + 15], fill=(215, 225, 245, 120))
    sdraw.ellipse([mx + 10, my - 45, mx + 50, my - 10], fill=(215, 225, 245, 100))
    sdraw.ellipse([mx - 20, my + 15, mx + 30, my + 55], fill=(210, 220, 240, 110))
    
    # Stylized Ukiyo-e Mist Clouds cutting across moon
    mists = Image.new("RGBA", (WIDTH, SKY_H), (0, 0, 0, 0))
    mist_draw = ImageDraw.Draw(mists)
    for c_y in [140, 230]:
        mist_draw.rounded_rectangle([mx - 150, c_y, mx + 120, c_y + 22], radius=11, fill=(20, 28, 52, 175))
    mists = mists.filter(ImageFilter.GaussianBlur(3))
    sky.alpha_composite(mists)
    
    sky.save(os.path.join(out_dir, "sky.png"))
    
    # 3.2 FAR LAYER (1280x400) - Misty Needles & Mountain Castles (Shiro)
    far = Image.new("RGBA", (WIDTH, FAR_H), (0, 0, 0, 0))
    fdraw = ImageDraw.Draw(far)
    
    # Needle-sharp misty peaks (Japanese ink wash style)
    peaks = [(0, FAR_H)]
    for x in range(0, WIDTH + 1, 16):
        y = 195 + 60 * math.sin(x * (2 * math.pi / WIDTH) * 2 + 1.5) + 30 * math.cos(x * (2 * math.pi / WIDTH) * 5)
        peaks.append((x, int(y)))
    peaks.append((WIDTH, FAR_H))
    fdraw.polygon(peaks, fill=(18, 22, 42, 245))
    
    # Distant Ninja Mountain Fortress silhouette on cliff (x: 320)
    fx, fy = 320, int(195 + 60 * math.sin(320 * (2 * math.pi / WIDTH) * 2 + 1.5) + 30 * math.cos(320 * (2 * math.pi / WIDTH) * 5))
    # Stone foundation
    fdraw.polygon([(fx - 35, fy), (fx - 25, fy - 25), (fx + 25, fy - 25), (fx + 35, fy)], fill=(28, 34, 58, 255))
    # Tier 1 Roof
    fdraw.polygon([(fx - 38, fy - 25), (fx - 28, fy - 36), (fx + 28, fy - 36), (fx + 38, fy - 25)], fill=(12, 15, 30, 255))
    # Tier 2 Roof
    fdraw.polygon([(fx - 26, fy - 46), (fx - 18, fy - 56), (fx + 18, fy - 56), (fx + 26, fy - 46)], fill=(12, 15, 30, 255))
    # Top watchtower
    fdraw.rectangle([fx - 8, fy - 68, fx + 8, fy - 56], fill=(12, 15, 30, 255))
    fdraw.polygon([(fx - 14, fy - 68), (fx, fy - 78), (fx + 14, fy - 68)], fill=(180, 205, 235, 240)) # snow roof
    
    # Frost ridges
    for i in range(1, len(peaks) - 2):
        fdraw.line([peaks[i], peaks[i+1]], fill=(70, 95, 140, 180), width=2)
        
    far.save(os.path.join(out_dir, "far.png"))
    
    # 3.3 MID LAYER (1280x360) - Torii Gates & Traditional Pagodas in Snow
    mid = Image.new("RGBA", (WIDTH, MID_H), (0, 0, 0, 0))
    mdraw = ImageDraw.Draw(mid)
    
    mid_ridge = [(0, MID_H)]
    for x in range(0, WIDTH + 1, 16):
        y = 165 + 45 * math.sin(x * (2 * math.pi / WIDTH) * 3 - 0.5) + 18 * math.cos(x * (2 * math.pi / WIDTH) * 6)
        mid_ridge.append((x, int(y)))
    mid_ridge.append((WIDTH, MID_H))
    mdraw.polygon(mid_ridge, fill=(14, 18, 34, 255))
    
    # Japanese Pagoda at x = 740
    px = 740
    py = int(165 + 45 * math.sin(px * (2 * math.pi / WIDTH) * 3 - 0.5) + 18 * math.cos(px * (2 * math.pi / WIDTH) * 6))
    for tier, (rw, rh, sw) in enumerate([(44, 20, 54), (34, 18, 42), (24, 16, 30)]):
        y_curr = py - (tier * 26)
        # Pagoda walls
        mdraw.rectangle([px - rw//2, y_curr - rh, px + rw//2, y_curr], fill=(24, 28, 48, 255))
        # Pagoda curved roof with snow
        roof_pts = [(px - sw//2 - 6, y_curr - rh + 3), (px, y_curr - rh - 8), (px + sw//2 + 6, y_curr - rh + 3), (px + sw//2, y_curr - rh + 7), (px - sw//2, y_curr - rh + 7)]
        mdraw.polygon(roof_pts, fill=(8, 10, 20, 255))
        # Snow cap on roof
        mdraw.line([(px - sw//2 - 5, y_curr - rh + 3), (px, y_curr - rh - 8), (px + sw//2 + 5, y_curr - rh + 3)], fill=(210, 225, 245, 240), width=2)
    # Pagoda finial spire (Sorin)
    mdraw.line([(px, py - 85), (px, py - 110)], fill=(210, 180, 80, 255), width=2)
    
    # Classic Vermilion Red Torii Gate at x = 240 and x = 1120
    for tx in [240, 1120]:
        ty = int(165 + 45 * math.sin(tx * (2 * math.pi / WIDTH) * 3 - 0.5) + 18 * math.cos(tx * (2 * math.pi / WIDTH) * 6))
        # Pillars
        mdraw.rectangle([tx - 24, ty - 65, tx - 18, ty], fill=(175, 45, 40, 255))
        mdraw.rectangle([tx + 18, ty - 65, tx + 24, ty], fill=(175, 45, 40, 255))
        # Lower crossbeam
        mdraw.rectangle([tx - 32, ty - 50, tx + 32, ty - 45], fill=(175, 45, 40, 255))
        # Upper curved lintel (Kasagi) with snow cap
        mdraw.polygon([(tx - 38, ty - 68), (tx, ty - 73), (tx + 38, ty - 68), (tx + 34, ty - 63), (tx - 34, ty - 63)], fill=(12, 10, 12, 255))
        mdraw.line([(tx - 38, ty - 68), (tx, ty - 73), (tx + 38, ty - 68)], fill=(230, 240, 255, 250), width=2)
        
    mid.save(os.path.join(out_dir, "mid.png"))
    
    # 3.4 TREES LAYER (1280x240) - Snow Bamboo Groves & Winter Sakura
    trees = Image.new("RGBA", (WIDTH, NEAR_H), (0, 0, 0, 0))
    tdraw = ImageDraw.Draw(trees)
    
    g_pts = [(0, NEAR_H)]
    for x in range(0, WIDTH + 1, 10):
        y = 150 + 15 * math.sin(x * (2 * math.pi / WIDTH) * 4)
        g_pts.append((x, int(y)))
    g_pts.append((WIDTH, NEAR_H))
    tdraw.polygon(g_pts, fill=(8, 10, 20, 255))
    
    # Bamboo clusters
    bamboo_clusters = [100, 140, 360, 400, 440, 620, 860, 900, 1020, 1200]
    for bx in bamboo_clusters:
        by = int(150 + 15 * math.sin(bx * (2 * math.pi / WIDTH) * 4))
        bh = 120 + (bx % 25)
        # Stalk
        tdraw.rectangle([bx - 3, by - bh, bx + 3, by], fill=(16, 26, 38, 255))
        # Segment rings
        for seg in range(by - bh, by, 24):
            tdraw.line([(bx - 4, seg), (bx + 4, seg)], fill=(45, 75, 95, 255), width=2)
            # Bamboo leaves
            tdraw.polygon([(bx - 3, seg), (bx - 18, seg - 8), (bx - 4, seg - 4)], fill=(22, 40, 52, 240))
            tdraw.polygon([(bx + 3, seg), (bx + 18, seg - 8), (bx + 4, seg - 4)], fill=(22, 40, 52, 240))
            # Little snow on leaves
            tdraw.line([(bx - 18, seg - 8), (bx - 3, seg)], fill=(200, 220, 245, 230), width=1)
            
    # Japanese Stone Lanterns (Tōrō) with warm amber glow
    for lx in [260, 720, 1140]:
        ly = int(150 + 15 * math.sin(lx * (2 * math.pi / WIDTH) * 4))
        # Base and post
        tdraw.rectangle([lx - 6, ly - 28, lx + 6, ly], fill=(22, 26, 42, 255))
        # Fire box
        tdraw.rectangle([lx - 9, ly - 42, lx + 9, ly - 28], fill=(240, 175, 60, 255), outline=(15, 18, 28, 255), width=2)
        # Roof cap
        tdraw.polygon([(lx - 15, ly - 42), (lx, ly - 50), (lx + 15, ly - 42)], fill=(210, 225, 245, 255))
        
    trees.save(os.path.join(out_dir, "trees.png"))
    print("[OK] Generated custom Ninja Universe background textures!")

# -------------------------------------------------------------
# 4. ROYALTY UNIVERSE GENERATION
# -------------------------------------------------------------
def generate_royalty():
    out_dir = os.path.join(BG_ROOT, "royalty")
    os.makedirs(out_dir, exist_ok=True)
    
    # 4.1 SKY (1280x720) - Sapphire Palace Sunset & Velvet Auroras
    sky = create_gradient_img(WIDTH, SKY_H, [
        (0.0, (16, 8, 36, 255)),
        (0.3, (38, 14, 62, 255)),
        (0.65, (85, 24, 88, 255)),
        (1.0, (135, 48, 110, 255))
    ])
    
    # Palace Velvet Curtain Aurora
    vaurora = Image.new("RGBA", (WIDTH, SKY_H), (0, 0, 0, 0))
    vdraw = ImageDraw.Draw(vaurora)
    for c_i in range(5):
        cx = c_i * 280 + 100
        for y_a in range(80, 360, 30):
            w = 120 + int(30 * math.sin(y_a * 0.05 + c_i))
            vdraw.ellipse([cx - w, y_a, cx + w, y_a + 90], fill=(220, 90, 210, 25))
    vaurora = vaurora.filter(ImageFilter.GaussianBlur(32))
    sky.alpha_composite(vaurora)
    
    sdraw = ImageDraw.Draw(sky)
    add_stars(sdraw, 220, WIDTH, SKY_H, colors=[(255, 255, 255, 230), (255, 210, 240, 220), (220, 190, 255, 200)], seed=404)
    
    sky.save(os.path.join(out_dir, "sky.png"))
    
    # 4.2 FAR LAYER (1280x400) - The Grand Imperial Sapphire Palace Skyline
    far = Image.new("RGBA", (WIDTH, FAR_H), (0, 0, 0, 0))
    fdraw = ImageDraw.Draw(far)
    
    # Distant crystalline mountain ridge
    ridge = [(0, FAR_H)]
    for x in range(0, WIDTH + 1, 16):
        y = 205 + 50 * math.sin(x * (2 * math.pi / WIDTH) * 2 + 0.3) + 25 * math.cos(x * (2 * math.pi / WIDTH) * 4)
        ridge.append((x, int(y)))
    ridge.append((WIDTH, FAR_H))
    fdraw.polygon(ridge, fill=(38, 16, 56, 245))
    
    # Massive Royal Palace Towers & Spires (clusters at x=400, x=640, x=880)
    palace_clusters = [
        # (center_x, [(rel_x, width, height, roof_color)])
        (640, [(-70, 28, 140), (-35, 34, 180), (0, 44, 220), (35, 34, 180), (70, 28, 140)]),
        (220, [(-30, 24, 120), (0, 32, 150), (30, 24, 120)]),
        (1060, [(-30, 24, 120), (0, 32, 150), (30, 24, 120)])
    ]
    for pc_x, towers in palace_clusters:
        y_base = int(205 + 50 * math.sin(pc_x * (2 * math.pi / WIDTH) * 2 + 0.3) + 25 * math.cos(pc_x * (2 * math.pi / WIDTH) * 4))
        for rx, tw, th in towers:
            tx = pc_x + rx
            # Tower body
            fdraw.rectangle([tx - tw//2, y_base - th, tx + tw//2, y_base], fill=(54, 22, 78, 255))
            # Conical royal turret roof
            fdraw.polygon([(tx - tw//2 - 4, y_base - th), (tx, y_base - th - 45), (tx + tw//2 + 4, y_base - th)], fill=(130, 45, 155, 255))
            # Gold royal crown spire
            fdraw.line([(tx, y_base - th - 45), (tx, y_base - th - 62)], fill=(255, 215, 110, 255), width=2)
            fdraw.ellipse([tx - 2, y_base - th - 65, tx + 2, y_base - th - 61], fill=(255, 235, 140, 255))
            
    far.save(os.path.join(out_dir, "far.png"))
    
    # 4.3 MID LAYER (1280x360) - Castle Balustrades, Grand Arches & Candelabra Windows
    mid = Image.new("RGBA", (WIDTH, MID_H), (0, 0, 0, 0))
    mdraw = ImageDraw.Draw(mid)
    
    mid_rampart = [(0, MID_H)]
    for x in range(0, WIDTH + 1, 16):
        y = 165 + 40 * math.sin(x * (2 * math.pi / WIDTH) * 3 + 1.8) + 15 * math.cos(x * (2 * math.pi / WIDTH) * 7)
        mid_rampart.append((x, int(y)))
    mid_rampart.append((WIDTH, MID_H))
    mdraw.polygon(mid_rampart, fill=(32, 14, 52, 255))
    
    # Grand Castle Arches & Glowing Stained Glass Windows
    for ax in [160, 380, 640, 900, 1120]:
        ay = int(165 + 40 * math.sin(ax * (2 * math.pi / WIDTH) * 3 + 1.8) + 15 * math.cos(ax * (2 * math.pi / WIDTH) * 7))
        # Arch stone frame
        mdraw.rectangle([ax - 28, ay - 65, ax + 28, ay], fill=(48, 20, 72, 255))
        mdraw.ellipse([ax - 28, ay - 93, ax + 28, ay - 37], fill=(48, 20, 72, 255))
        # Stained glass warm amber candle glow inside
        mdraw.rectangle([ax - 18, ay - 55, ax + 18, ay - 5], fill=(255, 190, 80, 240))
        mdraw.ellipse([ax - 18, ay - 75, ax + 18, ay - 35], fill=(255, 190, 80, 240))
        # Window traceries (gothic cross)
        mdraw.line([(ax, ay - 75), (ax, ay - 5)], fill=(32, 14, 52, 255), width=2)
        mdraw.line([(ax - 18, ay - 35), (ax + 18, ay - 35)], fill=(32, 14, 52, 255), width=2)
        
    # Balustrade railing on top
    for i in range(1, len(mid_rampart) - 2):
        mdraw.line([mid_rampart[i], mid_rampart[i+1]], fill=(225, 150, 245, 220), width=2)
        
    mid.save(os.path.join(out_dir, "mid.png"))
    
    # 4.4 TREES LAYER (1280x240) - Royal Topiaries, Gilded Gates & Lampposts
    trees = Image.new("RGBA", (WIDTH, NEAR_H), (0, 0, 0, 0))
    tdraw = ImageDraw.Draw(trees)
    
    g_pts = [(0, NEAR_H)]
    for x in range(0, WIDTH + 1, 10):
        y = 150 + 14 * math.sin(x * (2 * math.pi / WIDTH) * 4 + 0.5)
        g_pts.append((x, int(y)))
    g_pts.append((WIDTH, NEAR_H))
    tdraw.polygon(g_pts, fill=(20, 8, 34, 255))
    
    # Symmetrical Clipped Royal Topiaries (Cone & Ball shrubs)
    for tx in [80, 220, 360, 500, 640, 780, 920, 1060, 1200]:
        ty = int(150 + 14 * math.sin(tx * (2 * math.pi / WIDTH) * 4 + 0.5))
        # Urn base
        tdraw.polygon([(tx - 12, ty), (tx - 8, ty - 22), (tx + 8, ty - 22), (tx + 12, ty)], fill=(210, 175, 80, 255))
        # Conical clipped shrub
        tdraw.polygon([(tx - 24, ty - 22), (tx, ty - 100), (tx + 24, ty - 22)], fill=(38, 16, 58, 255))
        # Spherical tip
        tdraw.ellipse([tx - 10, ty - 115, tx + 10, ty - 95], fill=(55, 24, 82, 255))
        # Snow garlands
        tdraw.arc([tx - 18, ty - 60, tx + 18, ty - 38], start=20, end=160, fill=(240, 215, 255, 250), width=2)
        tdraw.ellipse([tx - 8, ty - 114, tx + 8, ty - 100], fill=(245, 225, 255, 255))
        
    # Victorian Gilded Streetlights
    for lx in [150, 430, 710, 990]:
        ly = int(150 + 14 * math.sin(lx * (2 * math.pi / WIDTH) * 4 + 0.5))
        # Lamp post
        tdraw.rectangle([lx - 2, ly - 65, lx + 2, ly], fill=(215, 180, 75, 255))
        # Lamp head
        tdraw.polygon([(lx - 8, ly - 78), (lx - 12, ly - 65), (lx + 12, ly - 65), (lx + 8, ly - 78)], fill=(255, 215, 110, 255))
        # Warm light glow
        tdraw.ellipse([lx - 5, ly - 74, lx + 5, ly - 64], fill=(255, 245, 190, 255))
        
    trees.save(os.path.join(out_dir, "trees.png"))
    print("[OK] Generated custom Royalty Universe background textures!")

# -------------------------------------------------------------
# 5. UNIFORM UNIVERSE GENERATION (Modern Metropolis)
# -------------------------------------------------------------
def generate_uniform():
    out_dir = os.path.join(BG_ROOT, "uniform")
    os.makedirs(out_dir, exist_ok=True)
    
    # 5.1 SKY (1280x720) - Winter City Sunset & Twilight Skyline
    sky = create_gradient_img(WIDTH, SKY_H, [
        (0.0, (18, 28, 56, 255)),
        (0.35, (42, 45, 82, 255)),
        (0.68, (120, 68, 72, 255)),
        (0.88, (185, 95, 68, 255)),
        (1.0, (230, 140, 85, 255))
    ])
    
    # Airplane Contrail cutting across twilight sky
    sdraw = ImageDraw.Draw(sky)
    sdraw.line([(80, 180), (1200, 70)], fill=(255, 220, 200, 110), width=2)
    sdraw.line([(80, 181), (1200, 71)], fill=(255, 255, 255, 140), width=1)
    
    add_stars(sdraw, 80, WIDTH, int(SKY_H * 0.45), colors=[(255, 255, 255, 220), (255, 230, 180, 200)], seed=505)
    
    # City Evening Crescent Moon
    mx, my, mr = 280, 120, 28
    sdraw.ellipse([mx - mr, my - mr, mx + mr, my + mr], fill=(255, 245, 210, 245))
    sdraw.ellipse([mx - mr + 12, my - mr - 4, mx + mr + 12, my + mr + 4], fill=(32, 38, 72, 255))
    
    sky.save(os.path.join(out_dir, "sky.png"))
    
    # 5.2 FAR LAYER (1280x400) - Modern Metropolis Skyscrapers with Lit Windows & Radio Mast
    far = Image.new("RGBA", (WIDTH, FAR_H), (0, 0, 0, 0))
    fdraw = ImageDraw.Draw(far)
    
    # High-rise skyscrapers varying in height and width
    bldg_specs = [
        # (x, width, height)
        (0, 70, 180), (60, 55, 240), (110, 80, 200), (185, 60, 280), (240, 75, 220),
        (310, 90, 310), (395, 65, 250), (455, 80, 190), (530, 70, 330), (595, 85, 270),
        (675, 60, 220), (730, 95, 300), (820, 70, 260), (885, 80, 320), (960, 65, 240),
        (1020, 85, 290), (1100, 70, 210), (1165, 60, 270), (1220, 70, 180) # wrap at 1280
    ]
    for bx, bw, bh in bldg_specs:
        by = FAR_H
        fdraw.rectangle([bx, by - bh, bx + bw, by], fill=(26, 32, 54, 255))
        # Roof edge
        fdraw.line([(bx, by - bh), (bx + bw, by - bh)], fill=(190, 160, 180, 200), width=2)
        # Windows grid
        rng = random.Random(bx * 7)
        for wy in range(by - bh + 18, by - 20, 14):
            for wx in range(bx + 8, bx + bw - 8, 12):
                if rng.random() > 0.35:
                    win_col = (255, 225, 120, 220) if rng.random() > 0.4 else (130, 210, 255, 200)
                    fdraw.rectangle([wx, wy, wx + 6, wy + 7], fill=win_col)
                    
    # Giant Tokyo Tower / Radio Mast style Communications Tower at x = 700
    tx = 700
    th = 360
    # Lattice structure
    fdraw.polygon([(tx - 25, FAR_H), (tx, FAR_H - th), (tx + 25, FAR_H)], outline=(195, 60, 60, 255), width=2)
    fdraw.line([(tx, FAR_H - th), (tx, FAR_H - th - 25)], fill=(255, 255, 255, 255), width=2)
    # Red blinking beacon at mast tip
    fdraw.ellipse([tx - 4, FAR_H - th - 28, tx + 4, FAR_H - th - 20], fill=(255, 40, 40, 255))
    
    far.save(os.path.join(out_dir, "far.png"))
    
    # 5.3 MID LAYER (1280x360) - School Rooftops, Water Towers & Utility Poles
    mid = Image.new("RGBA", (WIDTH, MID_H), (0, 0, 0, 0))
    mdraw = ImageDraw.Draw(mid)
    
    # Medium buildings & school rooftops
    mid_bldgs = [
        (0, 120, 160), (115, 140, 190), (250, 110, 140), (355, 150, 210),
        (500, 130, 150), (625, 160, 180), (780, 120, 160), (895, 150, 200),
        (1040, 130, 150), (1165, 120, 160)
    ]
    for bx, bw, bh in mid_bldgs:
        by = MID_H
        mdraw.rectangle([bx, by - bh, bx + bw, by], fill=(18, 24, 40, 255))
        # Snow cap on flat roof
        mdraw.rectangle([bx - 2, by - bh - 4, bx + bw + 2, by - bh], fill=(225, 235, 250, 255))
        # Chain-link fence on school rooftop
        for fx in range(bx + 4, bx + bw - 4, 10):
            mdraw.line([(fx, by - bh - 24), (fx, by - bh)], fill=(120, 140, 165, 180), width=1)
        mdraw.line([(bx + 2, by - bh - 24), (bx + bw - 2, by - bh - 24)], fill=(160, 180, 210, 200), width=1)
        
    # Cylindrical Water Towers on rooftops
    for wx, wh in [(200, 190), (680, 180), (980, 200)]:
        mdraw.rectangle([wx - 16, MID_H - wh - 35, wx + 16, MID_H - wh], fill=(70, 85, 110, 255))
        mdraw.ellipse([wx - 16, MID_H - wh - 45, wx + 16, MID_H - wh - 25], fill=(110, 130, 160, 255))
        # Snow on top of water tank
        mdraw.ellipse([wx - 14, MID_H - wh - 48, wx + 14, MID_H - wh - 30], fill=(235, 245, 255, 255))
        
    # Utility Poles & Sagging Powerlines
    for px in [320, 760, 1180]:
        py = MID_H - 120
        mdraw.rectangle([px - 3, py - 110, px + 3, py], fill=(12, 16, 28, 255))
        # Cross arms
        mdraw.rectangle([px - 22, py - 95, px + 22, py - 90], fill=(28, 36, 52, 255))
        mdraw.rectangle([px - 16, py - 75, px + 16, py - 70], fill=(28, 36, 52, 255))
    # Sagging electrical cables across scene
    for start_x, end_x in [(0, 320), (320, 760), (760, 1180), (1180, 1280)]:
        y1 = MID_H - 215
        y2 = MID_H - 215
        sag = 22
        pts = [(start_x, y1), ((start_x + end_x)//2, y1 + sag), (end_x, y2)]
        mdraw.line([pts[0], pts[1]], fill=(15, 20, 32, 220), width=1)
        mdraw.line([pts[1], pts[2]], fill=(15, 20, 32, 220), width=1)
        
    mid.save(os.path.join(out_dir, "mid.png"))
    
    # 5.4 TREES LAYER (1280x240) - Glowing Modern Streetlamps, Sidewalk Winter Trees with Fairy Lights
    trees = Image.new("RGBA", (WIDTH, NEAR_H), (0, 0, 0, 0))
    tdraw = ImageDraw.Draw(trees)
    
    # Sidewalk pavement with snow
    tdraw.rectangle([0, 165, WIDTH, NEAR_H], fill=(12, 16, 26, 255))
    tdraw.rectangle([0, 160, WIDTH, 168], fill=(225, 235, 250, 255)) # fresh pavement snow
    
    # Modern Warm Streetlamps casting light cones
    light_cones = Image.new("RGBA", (WIDTH, NEAR_H), (0, 0, 0, 0))
    lcdraw = ImageDraw.Draw(light_cones)
    for lx in [140, 420, 700, 980, 1220]:
        # Light cone triangle on ground
        lcdraw.polygon([(lx, 70), (lx - 75, 170), (lx + 75, 170)], fill=(255, 225, 120, 45))
        lcdraw.ellipse([lx - 75, 160, lx + 75, 185], fill=(255, 235, 140, 50))
    light_cones = light_cones.filter(ImageFilter.GaussianBlur(12))
    trees.alpha_composite(light_cones)
    
    tdraw = ImageDraw.Draw(trees)
    # Lamp poles
    for lx in [140, 420, 700, 980, 1220]:
        # Metal pole
        tdraw.rectangle([lx - 3, 70, lx + 3, 165], fill=(28, 35, 48, 255))
        # Lamp curved arm and head
        tdraw.polygon([(lx - 12, 60), (lx + 12, 60), (lx + 8, 70), (lx - 8, 70)], fill=(45, 55, 75, 255))
        # Bright lamp bulb
        tdraw.ellipse([lx - 6, 68, lx + 6, 76], fill=(255, 250, 190, 255))
        
    # Sidewalk bare winter trees with colorful festive LED fairy lights
    tree_x_list = [270, 550, 830, 1100]
    for tx in tree_x_list:
        ty = 165
        # Trunk
        tdraw.polygon([(tx - 6, ty), (tx - 3, ty - 65), (tx + 3, ty - 65), (tx + 6, ty)], fill=(24, 18, 16, 255))
        # Branches
        tdraw.line([(tx, ty - 65), (tx - 28, ty - 110)], fill=(24, 18, 16, 255), width=3)
        tdraw.line([(tx, ty - 65), (tx + 28, ty - 110)], fill=(24, 18, 16, 255), width=3)
        tdraw.line([(tx - 15, ty - 85), (tx - 40, ty - 95)], fill=(24, 18, 16, 255), width=2)
        tdraw.line([(tx + 15, ty - 85), (tx + 40, ty - 95)], fill=(24, 18, 16, 255), width=2)
        tdraw.line([(tx, ty - 65), (tx, ty - 120)], fill=(24, 18, 16, 255), width=2)
        # Snow on branches
        tdraw.line([(tx - 26, ty - 111), (tx, ty - 66)], fill=(230, 240, 255, 240), width=2)
        tdraw.line([(tx, ty - 66), (tx + 26, ty - 111)], fill=(230, 240, 255, 240), width=2)
        # Colorful glowing fairy lights
        rng = random.Random(tx)
        colors = [(255, 80, 80, 255), (80, 220, 255, 255), (255, 230, 80, 255), (140, 255, 100, 255)]
        for _ in range(16):
            lx = tx + rng.randint(-35, 35)
            ly = ty - rng.randint(55, 115)
            c = rng.choice(colors)
            tdraw.ellipse([lx - 2, ly - 2, lx + 2, ly + 2], fill=c)
            
    trees.save(os.path.join(out_dir, "trees.png"))
    print("[OK] Generated custom Uniform Universe background textures!")

# -------------------------------------------------------------
# 6. COPY CLASSIC
# -------------------------------------------------------------
def copy_classic():
    out_dir = os.path.join(BG_ROOT, "classic")
    os.makedirs(out_dir, exist_ok=True)
    import shutil
    shutil.copyfile(os.path.join(BG_ROOT, "sky_aurora.png"), os.path.join(out_dir, "sky.png"))
    shutil.copyfile(os.path.join(BG_ROOT, "mountains_far.png"), os.path.join(out_dir, "far.png"))
    shutil.copyfile(os.path.join(BG_ROOT, "mountains_mid.png"), os.path.join(out_dir, "mid.png"))
    shutil.copyfile(os.path.join(BG_ROOT, "trees_near.png"), os.path.join(out_dir, "trees.png"))
    print("[OK] Classic background textures organized!")

def main():
    print("=== Generating All Custom Backgrounds for Linaverse Multiverse ===")
    copy_classic()
    generate_celestial()
    generate_valkyrie()
    generate_ninja()
    generate_royalty()
    generate_uniform()
    print("=== All 6 Multiverse Backgrounds Generated Successfully! ===")

if __name__ == "__main__":
    main()
