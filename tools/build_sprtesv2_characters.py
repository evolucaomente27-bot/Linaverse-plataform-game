import os
import cv2
import numpy as np
from PIL import Image, ImageDraw, ImageFilter
import random
import math

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SPRTES_DIR = os.path.join(BASE_DIR, "sprtesV2")
PLAYER_OUT_DIR = os.path.join(BASE_DIR, "assets", "sprites", "player")
UI_OUT_DIR = os.path.join(BASE_DIR, "assets", "sprites", "ui")
SCENES_PLAYER_DIR = os.path.join(BASE_DIR, "scenes", "player")
BG_ROOT_DIR = os.path.join(BASE_DIR, "assets", "sprites", "background")

os.makedirs(PLAYER_OUT_DIR, exist_ok=True)
os.makedirs(UI_OUT_DIR, exist_ok=True)
os.makedirs(SCENES_PLAYER_DIR, exist_ok=True)
os.makedirs(BG_ROOT_DIR, exist_ok=True)

# Definition of the 7 new characters from sprtesV2
NEW_CHARACTERS = {
    "agnes": {
        "walk_file": "linaagnes.jfif",
        "action_file": "linaagnesA.jfif",
        "name": "Lina Agnes",
        "title": "Cientista Quântica",
        "color": (230, 115, 190),
    },
    "frieren": {
        "walk_file": "linafrieren.jfif",
        "action_file": "linafrierenA.jfif",
        "name": "Maga Élfica Lina",
        "title": "Maga Ancestral",
        "color": (215, 225, 255),
    },
    "maid": {
        "walk_file": "linamaid.jfif",
        "action_file": "linamaidA.jfif",
        "name": "Lina Meido",
        "title": "Governante dos Salões",
        "color": (240, 205, 230),
    },
    "maomao": {
        "walk_file": "linamaomao.jfif",
        "action_file": "linamaomaoA.jfif",
        "name": "Boticária Lina",
        "title": "Boticária Imperial",
        "color": (100, 215, 130),
    },
    "miku": {
        "walk_file": "linamiku.jfif",
        "action_file": "linamikuA.jfif",
        "name": "Lina Vocal Synth",
        "title": "Ídolo Virtual",
        "color": (50, 245, 215),
    },
    "sonserina": {
        "walk_file": "linasonserina.jfif",
        "action_file": "linasonserinaA.jfif",
        "name": "Bruxa das Serpentes",
        "title": "Feiticeira das Masmorras",
        "color": (65, 190, 115),
    },
    "tracen": {
        "walk_file": "Gemini_Generated_Image_oi0bkmoi0bkmoi0b.jfif",
        "action_file": "Gemini_Generated_Image_kp8kxvkp8kxvkp8k.jfif",
        "name": "Lina Velocista",
        "title": "Atleta da Academia",
        "color": (215, 100, 100),
    }
}

def remove_background(im_arr):
    """Accurately removes either light or dark background using border sampling and soft alpha ramp."""
    h, w = im_arr.shape[:2]
    corner_samples = np.concatenate([
        im_arr[:15, :15].reshape(-1, 3),
        im_arr[:15, -15:].reshape(-1, 3),
        im_arr[-15:, :15].reshape(-1, 3),
        im_arr[-15:, -15:].reshape(-1, 3)
    ])
    bg_color = np.median(corner_samples, axis=0)
    is_light = np.mean(bg_color) > 128
    
    diff = np.linalg.norm(im_arr.astype(float) - bg_color, axis=2)
    low_t = 18.0 if is_light else 14.0
    high_t = 48.0 if is_light else 42.0
    
    alpha = np.clip((diff - low_t) / (high_t - low_t) * 255.0, 0, 255).astype(np.uint8)
    
    # Flood-fill outer background candidate pixels
    bg_candidate = (diff < high_t).astype(np.uint8)
    ff_mask = np.zeros((h + 2, w + 2), dtype=np.uint8)
    cv_img = bg_candidate.copy()
    for pt in [(0, 0), (w - 1, 0), (0, h - 1), (w - 1, h - 1)]:
        if cv_img[pt[1], pt[0]] == 1:
            cv2.floodFill(cv_img, ff_mask, pt, 2)
            
    is_outer_bg = (cv_img == 2)
    
    rgba = np.zeros((h, w, 4), dtype=np.uint8)
    rgba[:, :, :3] = im_arr
    rgba[:, :, 3] = np.where(is_outer_bg, alpha, 255)
    return rgba

def extract_sheet_figures(sheet_path):
    """Splits a 6-figure sheet into 6 cleanly cropped RGBA arrays."""
    im = Image.open(sheet_path)
    arr = np.array(im)
    h, w = arr.shape[:2]
    
    rgba = remove_background(arr)
    alpha = rgba[:, :, 3]
    
    col_w = w // 6
    figures = []
    for i in range(6):
        xs_start = i * col_w
        xs_end = (i + 1) * col_w if i < 5 else w
        sub_alpha = alpha[:, xs_start:xs_end]
        ys, xs = np.where(sub_alpha > 30)
        if len(ys) == 0:
            # Fallback if empty
            figures.append(np.zeros((100, 100, 4), dtype=np.uint8))
            continue
            
        y0, y1 = ys.min(), ys.max()
        x0, x1 = xs.min() + xs_start, xs.max() + xs_start
        
        # Crop tight figure
        tight = rgba[y0:y1+1, x0:x1+1]
        figures.append(tight)
    return figures

def fit_to_128(tight_arr, target_h=106, ground_y=121, center_x=64):
    """Scales and positions a character figure onto a standard 128x128 canvas."""
    th, tw = tight_arr.shape[:2]
    scale = target_h / float(th)
    new_w = max(1, int(round(tw * scale)))
    new_h = max(1, int(round(th * scale)))
    
    resized = cv2.resize(tight_arr, (new_w, new_h), interpolation=cv2.INTER_LANCZOS4)
    
    canvas = np.zeros((128, 128, 4), dtype=np.uint8)
    x0 = int(round(center_x - new_w / 2.0))
    y0 = ground_y - new_h
    
    for y in range(new_h):
        for x in range(new_w):
            dx = x0 + x
            dy = y0 + y
            if 0 <= dx < 128 and 0 <= dy < 128:
                canvas[dy, dx] = resized[y, x]
                
    return canvas

def make_hurt_frame(base_128, angle=-6.0, shift_x=-2.0, tint_red=True):
    """Generates a hurt frame by rotating, shifting, and tinting red."""
    h, w = 128, 128
    M = cv2.getRotationMatrix2D((64, 121), angle, 1.0)
    M[0, 2] += shift_x
    hurt = cv2.warpAffine(base_128, M, (w, h), flags=cv2.INTER_LANCZOS4, borderMode=cv2.BORDER_CONSTANT, borderValue=(0,0,0,0))
    if tint_red:
        mask = hurt[:, :, 3] > 30
        hurt[mask, 0] = np.clip(hurt[mask, 0] * 1.3 + 40, 0, 255).astype(np.uint8)
        hurt[mask, 1] = np.clip(hurt[mask, 1] * 0.7, 0, 255).astype(np.uint8)
        hurt[mask, 2] = np.clip(hurt[mask, 2] * 0.7, 0, 255).astype(np.uint8)
    return hurt

def generate_player_frames_tres(char_id):
    """Generates the scenes/player/player_frames_<char_id>.tres file."""
    def make_atlas(tag, ext_id, n_frames):
        lines = []
        for i in range(n_frames):
            lines.append(f"""[sub_resource type="AtlasTexture" id="AtlasTexture_{tag}_{i}"]
atlas = ExtResource("{ext_id}")
region = Rect2({i*128}, 0, 128, 128)
""")
        return "\n".join(lines)
        
    def make_anim_frames(tag, n_frames):
        entries = []
        for i in range(n_frames):
            entries.append(f"""{{
"duration": 1.0,
"texture": SubResource("AtlasTexture_{tag}_{i}")
}}""")
        return ", ".join(entries)

    tres_content = f"""[gd_resource type="SpriteFrames" format=3]

[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_fall_{char_id}.png" id="1_fall"]
[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_hurt_{char_id}.png" id="2_hurt"]
[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_idle_{char_id}.png" id="3_idle"]
[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_jump_{char_id}.png" id="4_jump"]
[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_run_{char_id}.png" id="5_run"]
[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_walk_{char_id}.png" id="6_walk"]

{make_atlas("fall", "1_fall", 2)}
{make_atlas("hurt", "2_hurt", 3)}
{make_atlas("idle", "3_idle", 6)}
{make_atlas("jump", "4_jump", 3)}
{make_atlas("run", "5_run", 12)}
{make_atlas("walk", "6_walk", 12)}

[resource]
animations = [{{
"frames": [{make_anim_frames("fall", 2)}],
"loop": 1,
"name": &"fall",
"speed": 6.0
}}, {{
"frames": [{make_anim_frames("hurt", 3)}],
"loop": 0,
"name": &"hurt",
"speed": 12.0
}}, {{
"frames": [{make_anim_frames("idle", 6)}],
"loop": 1,
"name": &"idle",
"speed": 6.0
}}, {{
"frames": [{make_anim_frames("jump", 3)}],
"loop": 0,
"name": &"jump",
"speed": 8.0
}}, {{
"frames": [{make_anim_frames("run", 12)}],
"loop": 1,
"name": &"run",
"speed": 14.0
}}, {{
"frames": [{make_anim_frames("walk", 12)}],
"loop": 1,
"name": &"walk",
"speed": 10.0
}}]
"""
    tres_path = os.path.join(SCENES_PLAYER_DIR, f"player_frames_{char_id}.tres")
    with open(tres_path, "w", encoding="utf-8") as f:
        f.write(tres_content)
    print(f"  [OK] Gerado: {tres_path}")

def build_character_sprites(char_id, config):
    print(f"\n=======================================================")
    print(f"=== Processando Personagem: {config['name']} ({char_id}) ===")
    print(f"=======================================================")
    
    walk_path = os.path.join(SPRTES_DIR, config["walk_file"])
    action_path = os.path.join(SPRTES_DIR, config["action_file"])
    
    raw_walk = extract_sheet_figures(walk_path)
    raw_action = extract_sheet_figures(action_path)
    
    print(f"  Extraídos: {len(raw_walk)} figuras de caminhada, {len(raw_action)} figuras de ação")
    
    # 1. Normalizar para 128x128
    walk_128 = [fit_to_128(f, 106, 121, 64) for f in raw_walk]
    action_128 = [fit_to_128(f, 106, 121, 64) for f in raw_action]
    
    # 2. Idle (6 frames): Usar poses suaves de caminhada/espera
    # Ou se a caminhada tem 6 frames, pegamos os frames mais parados ou ciclo suave
    idle_128 = [walk_128[0], walk_128[1], walk_128[2], walk_128[1], walk_128[0], walk_128[5]]
    
    # 3. Walk (12 frames): ciclo de caminhada estendido (6 frames duplicados suavemente)
    walk_full_128 = walk_128 + walk_128
    
    # 4. Run (12 frames): ciclo de corrida de alta velocidade da folha de ação
    run_full_128 = action_128 + action_128
    
    # 5. Jump (3 frames):
    # j0: Preparação/anticipation (squash leve)
    j0 = cv2.resize(idle_128[0], (132, 100), interpolation=cv2.INTER_LANCZOS4)
    c_j0 = np.zeros((128, 128, 4), dtype=np.uint8)
    c_j0[21:121, max(0, 64-66):min(128, 64+66)] = j0[:, :min(128, 132)]
    # j1: Salto no ar (da folha de ação)
    j1 = action_128[2].copy()
    # j2: Ápice do salto (esticamento vertical)
    j2 = cv2.resize(action_128[3], (122, 114), interpolation=cv2.INTER_LANCZOS4)
    c_j2 = np.zeros((128, 128, 4), dtype=np.uint8)
    c_j2[7:121, max(0, 64-61):min(128, 64+61)] = j2[:, :min(128, 122)]
    jump_128 = [c_j0, j1, c_j2]
    
    # 6. Fall (2 frames):
    f0 = action_128[1].copy()
    f1 = action_128[4].copy()
    fall_128 = [f0, f1]
    
    # 7. Hurt (3 frames):
    base_hurt = idle_128[0].copy()
    h0 = make_hurt_frame(base_hurt, angle=-6.0, shift_x=-2.0, tint_red=True)
    h1 = make_hurt_frame(base_hurt, angle=-12.0, shift_x=-4.0, tint_red=True)
    h2 = make_hurt_frame(base_hurt, angle=-4.0, shift_x=-1.0, tint_red=False)
    hurt_128 = [h0, h1, h2]
    
    # 8. Salvar Spritesheets em assets/sprites/player/
    Image.fromarray(np.hstack(idle_128)).save(os.path.join(PLAYER_OUT_DIR, f"lina_idle_{char_id}.png"))
    Image.fromarray(np.hstack(walk_full_128)).save(os.path.join(PLAYER_OUT_DIR, f"lina_walk_{char_id}.png"))
    Image.fromarray(np.hstack(run_full_128)).save(os.path.join(PLAYER_OUT_DIR, f"lina_run_{char_id}.png"))
    Image.fromarray(np.hstack(jump_128)).save(os.path.join(PLAYER_OUT_DIR, f"lina_jump_{char_id}.png"))
    Image.fromarray(np.hstack(fall_128)).save(os.path.join(PLAYER_OUT_DIR, f"lina_fall_{char_id}.png"))
    Image.fromarray(np.hstack(hurt_128)).save(os.path.join(PLAYER_OUT_DIR, f"lina_hurt_{char_id}.png"))
    Image.fromarray(idle_128[0]).save(os.path.join(PLAYER_OUT_DIR, f"lina_sprite_{char_id}.png"))
    print(f"  [OK] Spritesheets salvas em assets/sprites/player/ para '{char_id}'!")
    
    # 9. Gerar Retrato em assets/sprites/ui/outfit_<char_id>.png (256x256)
    # Extrair cabeça + busto da primeira figura de caminhada
    first_fig = raw_walk[0]
    fh, fw = first_fig.shape[:2]
    bust_h = int(fh * 0.48)
    bust_crop = first_fig[:bust_h, :]
    # Centralizar em 240x240 mantendo proporção
    bh, bw = bust_crop.shape[:2]
    b_scale = 230.0 / float(max(bh, bw))
    new_bw = max(1, int(round(bw * b_scale)))
    new_bh = max(1, int(round(bh * b_scale)))
    bust_resized = cv2.resize(bust_crop, (new_bw, new_bh), interpolation=cv2.INTER_LANCZOS4)
    
    portrait = Image.new("RGBA", (256, 256), (0, 0, 0, 0))
    p_x = (256 - new_bw) // 2
    p_y = (256 - new_bh) // 2 + 10
    
    # Adicionar suave aura colorida de fundo
    glow = Image.new("RGBA", (256, 256), (0, 0, 0, 0))
    gdraw = ImageDraw.Draw(glow)
    theme_col = config["color"]
    gdraw.ellipse([28, 28, 228, 228], fill=(theme_col[0], theme_col[1], theme_col[2], 55))
    glow = glow.filter(ImageFilter.GaussianBlur(14))
    portrait.paste(glow, (0, 0), glow)
    
    pil_bust = Image.fromarray(bust_resized)
    portrait.paste(pil_bust, (p_x, p_y), pil_bust)
    portrait.save(os.path.join(UI_OUT_DIR, f"outfit_{char_id}.png"))
    print(f"  [OK] Retrato gerado em assets/sprites/ui/outfit_{char_id}.png!")
    
    # 10. Gerar SpriteFrames .tres
    generate_player_frames_tres(char_id)

if __name__ == "__main__":
    for c_id, cfg in NEW_CHARACTERS.items():
        build_character_sprites(c_id, cfg)
    print("\n[SUCESSO] Todos os 7 novos trajes e sprites foram construídos com perfeição!")
