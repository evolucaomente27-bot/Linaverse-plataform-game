import cv2
import numpy as np
from PIL import Image
import os

player_dir = "assets/sprites/player"
ui_dir = "assets/sprites/ui"

def get_frames(fname):
    im = Image.open(fname)
    arr = np.array(im)
    alpha = arr[:, :, 3]
    h, w = arr.shape[:2]
    
    col_sum = np.sum(alpha > 20, axis=0)
    is_char = col_sum > 0
    diff = np.diff(is_char.astype(int))
    starts = np.where(diff == 1)[0] + 1
    if is_char[0]:
        starts = np.insert(starts, 0, 0)
    ends = np.where(diff == -1)[0]
    if is_char[-1]:
        ends = np.append(ends, w - 1)
        
    frames = []
    for s, e in zip(starts, ends):
        frame = arr[:, s:e+1]
        ys, xs = np.where(frame[:, :, 3] > 20)
        tight = frame[ys.min():ys.max()+1, xs.min():xs.max()+1]
        frames.append(tight)
    return frames

def fit_to_128(tight_arr, target_h=106, ground_y=121, center_x=64):
    th, tw = tight_arr.shape[:2]
    scale = target_h / float(th)
    new_w = int(round(tw * scale))
    new_h = int(round(th * scale))
    
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

def build_uniform():
    print("=== Processando Uniforme da Lina (idleU, andarU1/U2, correrU1/U2) ===")
    
    # 1. Extrair frames brutos
    idle_raw = get_frames("idleU.png")
    walk_raw = get_frames("andarU1.png") + get_frames("andarU2.png")
    run_raw = get_frames("correrU1.png") + get_frames("correrU2.png")
    
    print(f"Frames brutos: Idle={len(idle_raw)}, Walk={len(walk_raw)}, Run={len(run_raw)}")
    
    # 2. Ajustar para o grid padrão 128x128
    idle_128 = [fit_to_128(f, 106, 121, 64) for f in idle_raw]
    walk_128 = [fit_to_128(f, 106, 121, 64) for f in walk_raw]
    run_128 = [fit_to_128(f, 106, 121, 64) for f in run_raw]
    
    # 3. Gerar Jump (3 frames)
    # Frame 0: Push-off (agachamento)
    j0 = cv2.resize(idle_128[0], (132, 100), interpolation=cv2.INTER_LANCZOS4)
    c_j0 = np.zeros((128, 128, 4), dtype=np.uint8)
    c_j0[21:121, max(0, 64-66):min(128, 64+66)] = j0[:, :min(128, 132)]
    
    # Frame 1: Mid-air leap (a partir do ápice da corrida onde os pés estão estendidos no ar)
    j1 = run_128[2].copy()
    
    # Frame 2: Apex stretch (alongamento vertical)
    M_stretch = cv2.getRotationMatrix2D((64, 64), 0, 1.0)
    j2 = cv2.resize(run_128[3], (122, 114), interpolation=cv2.INTER_LANCZOS4)
    c_j2 = np.zeros((128, 128, 4), dtype=np.uint8)
    c_j2[7:121, max(0, 64-61):min(128, 64+61)] = j2[:, :min(128, 122)]
    
    jump_128 = [c_j0, j1, c_j2]
    
    # 4. Gerar Fall (2 frames)
    # Frame 0: Queda com flutuação de saia/cabelo
    f0 = run_128[1].copy()
    # Frame 1: Queda rápida
    f1 = run_128[4].copy()
    fall_128 = [f0, f1]
    
    # 5. Gerar Hurt (3 frames)
    # Impacto, recuo e recuperação
    h_base = idle_128[0].copy()
    w, h = 128, 128
    
    M0 = cv2.getRotationMatrix2D((64, 121), -6.0, 1.0)
    h0 = cv2.warpAffine(h_base, M0, (w, h), flags=cv2.INTER_LANCZOS4, borderMode=cv2.BORDER_CONSTANT, borderValue=(0,0,0,0))
    M1 = cv2.getRotationMatrix2D((64, 121), -12.0, 1.0)
    M1[0, 2] -= 4.0
    h1 = cv2.warpAffine(h_base, M1, (w, h), flags=cv2.INTER_LANCZOS4, borderMode=cv2.BORDER_CONSTANT, borderValue=(0,0,0,0))
    M2 = cv2.getRotationMatrix2D((64, 121), -4.0, 1.0)
    M2[0, 2] -= 2.0
    h2 = cv2.warpAffine(h_base, M2, (w, h), flags=cv2.INTER_LANCZOS4, borderMode=cv2.BORDER_CONSTANT, borderValue=(0,0,0,0))
    
    for frame_h in [h0, h1]:
        mask = frame_h[:, :, 3] > 30
        frame_h[mask, 0] = np.clip(frame_h[mask, 0] * 1.35 + 45, 0, 255).astype(np.uint8)
        frame_h[mask, 1] = np.clip(frame_h[mask, 1] * 0.75, 0, 255).astype(np.uint8)
        frame_h[mask, 2] = np.clip(frame_h[mask, 2] * 0.75, 0, 255).astype(np.uint8)
    hurt_128 = [h0, h1, h2]
    
    # 6. Salvar Spritesheets em assets/sprites/player
    Image.fromarray(np.hstack(idle_128)).save(f"{player_dir}/lina_idle_uniform.png")
    Image.fromarray(np.hstack(walk_128)).save(f"{player_dir}/lina_walk_uniform.png")
    Image.fromarray(np.hstack(run_128)).save(f"{player_dir}/lina_run_uniform.png")
    Image.fromarray(np.hstack(jump_128)).save(f"{player_dir}/lina_jump_uniform.png")
    Image.fromarray(np.hstack(fall_128)).save(f"{player_dir}/lina_fall_uniform.png")
    Image.fromarray(np.hstack(hurt_128)).save(f"{player_dir}/lina_hurt_uniform.png")
    Image.fromarray(idle_128[0]).save(f"{player_dir}/lina_sprite_uniform.png")
    
    print("[OK] Todas as 6 folhas de sprite geradas em assets/sprites/player!")
    
    # 7. Criar Retrato do Uniforme para HUD e Guarda-Roupa (256x256)
    im_u = Image.open("idleU.png")
    f0_crop = im_u.crop((63, 24, 310, 270))
    # Resize mantendo proporção para 240x240
    f0_resized = f0_crop.resize((230, 230), Image.Resampling.LANCZOS)
    canvas_portrait = Image.new("RGBA", (256, 256), (0, 0, 0, 0))
    canvas_portrait.paste(f0_resized, (13, 20), f0_resized)
    canvas_portrait.save(f"{ui_dir}/outfit_uniform.png")
    print("[OK] Retrato gerado em assets/sprites/ui/outfit_uniform.png!")
    
    # 8. Gerar scenes/player/player_frames_uniform.tres
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

[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_fall_uniform.png" id="1_fall"]
[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_hurt_uniform.png" id="2_hurt"]
[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_idle_uniform.png" id="3_idle"]
[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_jump_uniform.png" id="4_jump"]
[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_run_uniform.png" id="5_run"]
[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_walk_uniform.png" id="6_walk"]

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
    with open("scenes/player/player_frames_uniform.tres", "w", encoding="utf-8") as f:
        f.write(tres_content)
    print("[OK] Recurso scenes/player/player_frames_uniform.tres gerado com sucesso!")

if __name__ == "__main__":
    build_uniform()
