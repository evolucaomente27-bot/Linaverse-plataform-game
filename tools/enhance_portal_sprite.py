from PIL import Image, ImageDraw
import math

width, height = 96, 120
img = Image.new("RGBA", (width, height), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

cx, cy = width / 2, height / 2

# Draw a glowing celestial vortex portal
# 1. Outer halo
for r in range(48, 10, -2):
    alpha = int(120 * (1.0 - (r / 48.0)**1.5))
    draw.ellipse([cx - r, cy - r * 1.15, cx + r, cy + r * 1.15], fill=(30, 180, 255, alpha))

# 2. Portal outer stone/crystal arch frame
arch_points_left = []
arch_points_right = []
for deg in range(0, 185, 5):
    rad = math.radians(deg)
    rx = 36 * math.cos(rad)
    ry = -46 * math.sin(rad)
    
# Draw oval swirling rings
for ring in range(32, 6, -3):
    t = ring / 32.0
    # Gradient from gold/magenta outside to brilliant cyan/white inside
    r = int(255 * (1.0 - t) + 80 * t)
    g = int(230 * (1.0 - t) + 210 * t)
    b = int(255)
    a = int(180 + 75 * (1.0 - t))
    draw.ellipse([cx - ring, cy - ring * 1.25, cx + ring, cy + ring * 1.25], outline=(r, g, b, a), width=2)

# 3. Inner bright celestial core
for r in range(16, 0, -2):
    a = int(255 * (1.0 - r / 16.0))
    draw.ellipse([cx - r, cy - r * 1.2, cx + r, cy + r * 1.2], fill=(230, 250, 255, a))

# 4. Swirling spiral arms
for arm in range(4):
    base_angle = arm * (math.pi / 2.0)
    for step in range(25):
        prog = step / 25.0
        angle = base_angle + prog * 3.5
        dist = 8 + prog * 32
        px = cx + dist * math.cos(angle)
        py = cy + dist * 1.2 * math.sin(angle)
        size = 1.5 + prog * 2.5
        alpha = int(240 * (1.0 - prog * 0.4))
        col = (255, int(220 + 35 * math.sin(prog * 3)), 120, alpha) if arm % 2 == 0 else (100, 230, 255, alpha)
        draw.ellipse([px - size, py - size, px + size, py + size], fill=col)

# 5. Golden runic crystal pillars at sides
for side in [-1, 1]:
    px = cx + side * 34
    draw.rounded_rectangle([px - 4, cy - 25, px + 4, cy + 35], radius=2, fill=(40, 80, 140, 240), outline=(100, 220, 255, 255))
    draw.polygon([(px - 4, cy - 25), (px, cy - 35), (px + 4, cy - 25)], fill=(120, 230, 255, 255))
    # Glowing jewel on top
    draw.ellipse([px - 3, cy - 32, px + 3, cy - 26], fill=(255, 235, 120, 255))

# 6. Base pedestal
draw.rounded_rectangle([cx - 38, cy + 32, cx + 38, cy + 42], radius=4, fill=(30, 50, 90, 240), outline=(80, 190, 255, 255), width=2)
draw.line([cx - 30, cy + 37, cx + 30, cy + 37], fill=(120, 240, 255, 200), width=1)

img.save("assets/sprites/objects/portal.png")
print("[OK] Enhanced bright luminous portal.png generated successfully!")
