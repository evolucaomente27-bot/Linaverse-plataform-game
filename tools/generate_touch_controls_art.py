import os
import math
from PIL import Image, ImageDraw, ImageFont

OUT_DIR = "assets/sprites/ui"
os.makedirs(OUT_DIR, exist_ok=True)

def create_button(size, symbol, base_color, accent_color, pressed=False):
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    pad = 6
    radius = (size - pad * 2) // 2
    center = (size // 2, size // 2)
    
    # Outer glow / border
    glow_alpha = 180 if pressed else 120
    border_col = (*accent_color, glow_alpha)
    bg_alpha = 150 if pressed else 90
    bg_col = (*base_color, bg_alpha)
    
    # Draw circle background
    bbox = [pad, pad, size - pad, size - pad]
    draw.ellipse(bbox, fill=bg_col, outline=border_col, width=3 if not pressed else 4)
    
    # Inner ring
    inner_pad = pad + 6
    inner_bbox = [inner_pad, inner_pad, size - inner_pad, size - inner_pad]
    draw.ellipse(inner_bbox, outline=(*accent_color, 60 if not pressed else 100), width=1)
    
    # Draw Symbol / Arrow
    cx, cy = center
    if pressed:
        cy += 2 # slight pressed depress feel
        
    symbol_col = (255, 255, 255, 240) if pressed else (*accent_color, 220)
    
    if symbol == "left":
        # Left triangle arrow
        pts = [(cx + 12, cy - 18), (cx + 12, cy + 18), (cx - 16, cy)]
        draw.polygon(pts, fill=symbol_col)
    elif symbol == "right":
        # Right triangle arrow
        pts = [(cx - 12, cy - 18), (cx - 12, cy + 18), (cx + 16, cy)]
        draw.polygon(pts, fill=symbol_col)
    elif symbol == "jump":
        # Up triangle arrow + underline
        pts = [(cx, cy - 18), (cx - 16, cy + 8), (cx + 16, cy + 8)]
        draw.polygon(pts, fill=symbol_col)
        draw.rectangle([cx - 14, cy + 14, cx + 14, cy + 18], fill=symbol_col)
    elif symbol == "dash":
        # Lightning bolt
        pts = [
            (cx + 2, cy - 20),
            (cx - 12, cy - 2),
            (cx - 1, cy - 2),
            (cx - 5, cy + 18),
            (cx + 14, cy + 0),
            (cx + 2, cy + 0)
        ]
        draw.polygon(pts, fill=symbol_col)
    elif symbol == "run":
        # Double fast forward speed chevrons with trailing wind lines
        # First chevron
        pts1 = [
            (cx - 14, cy - 14),
            (cx - 3, cy),
            (cx - 14, cy + 14),
            (cx - 7, cy + 14),
            (cx + 4, cy),
            (cx - 7, cy - 14)
        ]
        draw.polygon(pts1, fill=symbol_col)
        # Second chevron
        pts2 = [
            (cx - 1, cy - 14),
            (cx + 10, cy),
            (cx - 1, cy + 14),
            (cx + 6, cy + 14),
            (cx + 17, cy),
            (cx + 6, cy - 14)
        ]
        draw.polygon(pts2, fill=symbol_col)
        # Speed dash bar underneath
        draw.rectangle([cx - 14, cy + 17, cx + 17, cy + 20], fill=symbol_col)
    elif symbol == "pause":
        # Two vertical bars
        draw.rectangle([cx - 10, cy - 14, cx - 4, cy + 14], fill=symbol_col)
        draw.rectangle([cx + 4, cy - 14, cx + 10, cy + 14], fill=symbol_col)
    elif symbol == "settings":
        # Gear icon
        # Outer teeth
        for i in range(8):
            ang = i * (math.pi / 4)
            tx = cx + int(math.cos(ang) * 16)
            ty = cy + int(math.sin(ang) * 16)
            draw.rectangle([tx - 4, ty - 4, tx + 4, ty + 4], fill=symbol_col)
        # Main gear ring
        draw.ellipse([cx - 14, cy - 14, cx + 14, cy + 14], fill=symbol_col)
        # Inner hole
        draw.ellipse([cx - 6, cy - 6, cx + 6, cy + 6], fill=(*base_color, 255))
        
    return img

buttons = [
    ("touch_left", 84, "left", (15, 25, 45), (100, 200, 255)),
    ("touch_right", 84, "right", (15, 25, 45), (100, 200, 255)),
    ("touch_jump", 96, "jump", (18, 35, 60), (90, 225, 255)),
    ("touch_dash", 84, "dash", (35, 20, 45), (255, 195, 60)),
    ("touch_run", 84, "run", (15, 36, 42), (60, 245, 190)),
    ("touch_pause", 64, "pause", (15, 20, 35), (200, 220, 255)),
    ("touch_settings", 64, "settings", (15, 22, 38), (180, 210, 255)),
]

for name, size, symbol, base, accent in buttons:
    normal_img = create_button(size, symbol, base, accent, pressed=False)
    normal_img.save(f"{OUT_DIR}/{name}.png")
    
    pressed_img = create_button(size, symbol, base, accent, pressed=True)
    pressed_img.save(f"{OUT_DIR}/{name}_pressed.png")
    
    print(f"Generated {name}.png and {name}_pressed.png ({size}x{size})")

print("\n=== ALL TOUCH BUTTON TEXTURES GENERATED! ===")
