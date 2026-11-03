import cv2
import numpy as np
from PIL import Image
import os
import math

player_dir = "assets/sprites/player"

# 1. Base frame generators for jump (3 frames), fall (2 frames), hurt (3 frames)
def create_multiframe_actions():
    jump_base = Image.open(f"{player_dir}/lina_jump.png")
    fall_base = Image.open(f"{player_dir}/lina_fall.png")
    hurt_base = Image.open(f"{player_dir}/lina_hurt.png")
    
    j_arr = np.array(jump_base)
    f_arr = np.array(fall_base)
    h_arr = np.array(hurt_base)
    
    # Jump 3 frames:
    # 0: Push-off / crouch anticipation (squash Y 0.94, stretch X 1.04)
    # 1: Mid-air rise (original jump)
    # 2: Apex stretch (stretch Y 1.06, stretch X 0.95, lifted up 3px)
    h, w = 128, 128
    y_grid, x_grid = np.indices((h, w), dtype=np.float32)
    
    # Frame 0: Squash
    s0_y = 121.0 - (121.0 - y_grid) / 0.94
    s0_x = 64.0 + (x_grid - 64.0) / 1.04
    j0 = cv2.remap(j_arr, s0_x, s0_y, interpolation=cv2.INTER_LANCZOS4, borderMode=cv2.BORDER_CONSTANT, borderValue=(0,0,0,0))
    
    # Frame 1: Original
    j1 = j_arr.copy()
    
    # Frame 2: Stretch apex
    s2_y = (121.0 - (121.0 - y_grid) / 1.06) - 3.0
    s2_x = 64.0 + (x_grid - 64.0) / 0.95
    j2 = cv2.remap(j_arr, s2_x, s2_y, interpolation=cv2.INTER_LANCZOS4, borderMode=cv2.BORDER_CONSTANT, borderValue=(0,0,0,0))
    
    jump_3f = [j0, j1, j2]
    
    # Fall 2 frames:
    # 0: Original falling
    # 1: Wind resistance flapping (billow upward, wavy hem)
    wave = np.sin((121.0 - y_grid) / 106.0 * np.pi * 3.0) * 2.0
    f1_y = y_grid - 1.5
    f1_x = x_grid + np.where(y_grid > 50, wave, 0.0)
    f1 = cv2.remap(f_arr, f1_x.astype(np.float32), f1_y.astype(np.float32), interpolation=cv2.INTER_LANCZOS4, borderMode=cv2.BORDER_CONSTANT, borderValue=(0,0,0,0))
    fall_2f = [f_arr, f1]
    
    # Hurt 3 frames:
    # 0: Impact (lean back 6 degrees, white/red flash)
    # 1: Maximum knockback (lean back 12 degrees, shifted back 4px)
    # 2: Recovery (recovering to 4 degrees)
    M0 = cv2.getRotationMatrix2D((64, 121), -6.0, 1.0)
    h0 = cv2.warpAffine(h_arr, M0, (w, h), flags=cv2.INTER_LANCZOS4, borderMode=cv2.BORDER_CONSTANT, borderValue=(0,0,0,0))
    
    M1 = cv2.getRotationMatrix2D((64, 121), -12.0, 1.0)
    M1[0, 2] -= 4.0
    h1 = cv2.warpAffine(h_arr, M1, (w, h), flags=cv2.INTER_LANCZOS4, borderMode=cv2.BORDER_CONSTANT, borderValue=(0,0,0,0))
    
    M2 = cv2.getRotationMatrix2D((64, 121), -4.0, 1.0)
    M2[0, 2] -= 2.0
    h2 = cv2.warpAffine(h_arr, M2, (w, h), flags=cv2.INTER_LANCZOS4, borderMode=cv2.BORDER_CONSTANT, borderValue=(0,0,0,0))
    
    # Add damage flash tint to h0 and h1
    for frame_h in [h0, h1]:
        mask = frame_h[:, :, 3] > 30
        frame_h[mask, 0] = np.clip(frame_h[mask, 0] * 1.35 + 45, 0, 255).astype(np.uint8)
        frame_h[mask, 1] = np.clip(frame_h[mask, 1] * 0.75, 0, 255).astype(np.uint8)
        frame_h[mask, 2] = np.clip(frame_h[mask, 2] * 0.75, 0, 255).astype(np.uint8)
        
    hurt_3f = [h0, h1, h2]
    
    return jump_3f, fall_2f, hurt_3f

# 2. Outfit color transformer for any arbitrary Lina frame
def apply_outfit_to_frame(frame_rgba, outfit, frame_idx=0, anim_name="idle"):
    if outfit == "classic":
        return frame_rgba.copy()
        
    res = frame_rgba.copy()
    rgb = res[:, :, :3]
    alpha = res[:, :, 3]
    h, w = res.shape[:2]
    
    # HSV segmentation
    hsv = cv2.cvtColor(rgb, cv2.COLOR_RGB2HSV)
    H = hsv[:, :, 0]
    S = hsv[:, :, 1]
    V = hsv[:, :, 2]
    
    opaque = alpha > 35
    y_grid, x_grid = np.indices((h, w))
    
    # Regions
    is_hair = opaque & ((H > 135) | (H < 12)) & (S > 45)
    is_skin = opaque & (H >= 8) & (H <= 26) & (S >= 25) & (S <= 140) & (V > 175)
    is_eyes = opaque & (H >= 85) & (H <= 125) & (y_grid < 45) & (y_grid > 20)
    is_scarf = opaque & (H >= 85) & (H <= 120) & (S > 50) & (y_grid >= 42) & (y_grid <= 75) & (~is_eyes)
    is_coat = opaque & (S < 75) & (V >= 110) & (~is_skin) & (~is_hair) & (~is_eyes) & (y_grid >= 46) & (y_grid <= 98)
    is_boots = opaque & (V < 145) & (S < 95) & (~is_hair) & (~is_eyes) & (y_grid > 88)
    is_gloves = opaque & (V < 145) & (S < 95) & (~is_hair) & (~is_eyes) & (y_grid >= 58) & (y_grid <= 88) & (np.abs(x_grid - 64) > 15)
    
    lum = V.astype(np.float32) / 255.0
    phase = 2.0 * math.pi * frame_idx / 8.0
    
    if outfit == "celestial":
        # === MAGA CELESTIAL ===
        # Robe: midnight blue / astral violet velvet
        res[is_coat, 0] = np.clip(lum[is_coat] * 38 + 5, 0, 255).astype(np.uint8)
        res[is_coat, 1] = np.clip(lum[is_coat] * 28 + 5, 0, 255).astype(np.uint8)
        res[is_coat, 2] = np.clip(lum[is_coat] * 145 + 38, 0, 255).astype(np.uint8)
        
        # Gold trims and constellations
        gold_trim = is_coat & ((y_grid >= 91) | (np.abs(x_grid - 64) <= 1))
        res[gold_trim, 0] = np.clip(lum[gold_trim] * 255, 0, 255).astype(np.uint8)
        res[gold_trim, 1] = np.clip(lum[gold_trim] * 205 + 10, 0, 255).astype(np.uint8)
        res[gold_trim, 2] = np.clip(lum[gold_trim] * 45, 0, 255).astype(np.uint8)
        
        # Constellation stars on coat
        star_dots = is_coat & (((x_grid % 14 == 0) & (y_grid % 10 == 0)) | ((x_grid % 19 == 0) & (y_grid % 13 == 0)))
        res[star_dots, 0] = 255
        res[star_dots, 1] = 240
        res[star_dots, 2] = 160
        
        # Scarf: Royal cosmic violet
        res[is_scarf, 0] = np.clip(lum[is_scarf] * 125 + 30, 0, 255).astype(np.uint8)
        res[is_scarf, 1] = np.clip(lum[is_scarf] * 40 + 10, 0, 255).astype(np.uint8)
        res[is_scarf, 2] = np.clip(lum[is_scarf] * 205 + 40, 0, 255).astype(np.uint8)
        
        # Golden star brooch on center of scarf
        brooch = is_scarf & (np.abs(x_grid - 64) <= 2) & (y_grid >= 52) & (y_grid <= 56)
        res[brooch, 0] = 255
        res[brooch, 1] = 220
        res[brooch, 2] = 60
        
        # Boots: Navy with gold buckles
        gold_boot = is_boots & ((y_grid == 95) | (y_grid == 96))
        res[is_boots, 0] = np.clip(lum[is_boots] * 35, 0, 255).astype(np.uint8)
        res[is_boots, 1] = np.clip(lum[is_boots] * 30, 0, 255).astype(np.uint8)
        res[is_boots, 2] = np.clip(lum[is_boots] * 95 + 20, 0, 255).astype(np.uint8)
        res[gold_boot, 0] = 255
        res[gold_boot, 1] = 200
        res[gold_boot, 2] = 45
        
        # Gloves: Violet lace
        res[is_gloves, 0] = np.clip(lum[is_gloves] * 70 + 20, 0, 255).astype(np.uint8)
        res[is_gloves, 1] = np.clip(lum[is_gloves] * 45 + 10, 0, 255).astype(np.uint8)
        res[is_gloves, 2] = np.clip(lum[is_gloves] * 145 + 30, 0, 255).astype(np.uint8)
        
        # Hair clips: Golden stars on twintails (near y=26..29, x around 48..50 and 78..80)
        star_clips = is_hair & (y_grid >= 25) & (y_grid <= 29) & ((np.abs(x_grid - 48) <= 2) | (np.abs(x_grid - 80) <= 2))
        res[star_clips, 0] = 255
        res[star_clips, 1] = 225
        res[star_clips, 2] = 70

    elif outfit == "valkyrie":
        # === VALQUÍRIA GLACIAL ===
        # Armor: Polished silver plate cuirass with steel luster
        res[is_coat, 0] = np.clip(lum[is_coat] * 185 + 35, 0, 255).astype(np.uint8)
        res[is_coat, 1] = np.clip(lum[is_coat] * 200 + 40, 0, 255).astype(np.uint8)
        res[is_coat, 2] = np.clip(lum[is_coat] * 220 + 45, 0, 255).astype(np.uint8)
        
        # Glacial glowing runes on chest
        runes = is_coat & (((np.abs(x_grid - 64) == 4) & (y_grid >= 65) & (y_grid <= 80)) | ((y_grid == 72) & (np.abs(x_grid - 64) <= 6)))
        res[runes, 0] = 60
        res[runes, 1] = 220
        res[runes, 2] = 255
        
        # Scarf: Snow-white fur collar
        res[is_scarf, 0] = np.clip(lum[is_scarf] * 230 + 25, 0, 255).astype(np.uint8)
        res[is_scarf, 1] = np.clip(lum[is_scarf] * 235 + 20, 0, 255).astype(np.uint8)
        res[is_scarf, 2] = np.clip(lum[is_scarf] * 245 + 10, 0, 255).astype(np.uint8)
        
        # Boots: Silver plate greaves
        res[is_boots, 0] = np.clip(lum[is_boots] * 170 + 30, 0, 255).astype(np.uint8)
        res[is_boots, 1] = np.clip(lum[is_boots] * 185 + 35, 0, 255).astype(np.uint8)
        res[is_boots, 2] = np.clip(lum[is_boots] * 205 + 40, 0, 255).astype(np.uint8)
        
        # Gloves: Steel gauntlets
        res[is_gloves, 0] = np.clip(lum[is_gloves] * 170 + 30, 0, 255).astype(np.uint8)
        res[is_gloves, 1] = np.clip(lum[is_gloves] * 185 + 35, 0, 255).astype(np.uint8)
        res[is_gloves, 2] = np.clip(lum[is_gloves] * 205 + 40, 0, 255).astype(np.uint8)
        
        # Wing clips on twintails
        wings = is_hair & (y_grid >= 24) & (y_grid <= 30) & ((np.abs(x_grid - 46) <= 3) | (np.abs(x_grid - 82) <= 3))
        res[wings, 0] = 245
        res[wings, 1] = 250
        res[wings, 2] = 255

    elif outfit == "ninja":
        # === NINJA DA NEVE ===
        # Tunic: Dark shinobi stealth fabric
        res[is_coat, 0] = np.clip(lum[is_coat] * 30 + 10, 0, 255).astype(np.uint8)
        res[is_coat, 1] = np.clip(lum[is_coat] * 40 + 12, 0, 255).astype(np.uint8)
        res[is_coat, 2] = np.clip(lum[is_coat] * 65 + 18, 0, 255).astype(np.uint8)
        
        # Cyan shinobi belts & cords
        ninja_belt = is_coat & ((y_grid == 75) | (y_grid == 76) | ((y_grid >= 88) & (np.abs(x_grid - 64) <= 2)))
        res[ninja_belt, 0] = 15
        res[ninja_belt, 1] = 195
        res[ninja_belt, 2] = 235
        
        # Scarf: Flowing cyan shinobi muffler
        res[is_scarf, 0] = np.clip(lum[is_scarf] * 25 + 5, 0, 255).astype(np.uint8)
        res[is_scarf, 1] = np.clip(lum[is_scarf] * 140 + 25, 0, 255).astype(np.uint8)
        res[is_scarf, 2] = np.clip(lum[is_scarf] * 195 + 40, 0, 255).astype(np.uint8)
        
        # Boots: Dark shinobi tabi wraps
        res[is_boots, 0] = np.clip(lum[is_boots] * 25 + 8, 0, 255).astype(np.uint8)
        res[is_boots, 1] = np.clip(lum[is_boots] * 35 + 10, 0, 255).astype(np.uint8)
        res[is_boots, 2] = np.clip(lum[is_boots] * 55 + 15, 0, 255).astype(np.uint8)
        tabi_cords = is_boots & ((y_grid == 96) | (y_grid == 106))
        res[tabi_cords, 0] = 10
        res[tabi_cords, 1] = 180
        res[tabi_cords, 2] = 230
        
        # Gloves: Dark fingerless hand wraps
        res[is_gloves, 0] = np.clip(lum[is_gloves] * 25 + 8, 0, 255).astype(np.uint8)
        res[is_gloves, 1] = np.clip(lum[is_gloves] * 35 + 10, 0, 255).astype(np.uint8)
        res[is_gloves, 2] = np.clip(lum[is_gloves] * 55 + 15, 0, 255).astype(np.uint8)
        
        # Forehead protector plate (near forehead y=23..26, x=58..70)
        plate = is_hair & (y_grid >= 23) & (y_grid <= 26) & (np.abs(x_grid - 64) <= 6)
        res[plate, 0] = 190
        res[plate, 1] = 210
        res[plate, 2] = 225

    elif outfit == "royalty":
        # === PRINCESA DO INVERNO ===
        # Gown: Sapphire blue & royal purple velvet
        res[is_coat, 0] = np.clip(lum[is_coat] * 25 + 10, 0, 255).astype(np.uint8)
        res[is_coat, 1] = np.clip(lum[is_coat] * 65 + 20, 0, 255).astype(np.uint8)
        res[is_coat, 2] = np.clip(lum[is_coat] * 205 + 40, 0, 255).astype(np.uint8)
        
        # Gold embroidery hem & buttons
        gold_gown = is_coat & ((y_grid >= 90) | ((y_grid >= 58) & (y_grid <= 85) & (np.abs(x_grid - 64) == 3)))
        res[gold_gown, 0] = np.clip(lum[gold_gown] * 255, 0, 255).astype(np.uint8)
        res[gold_gown, 1] = np.clip(lum[gold_gown] * 210, 0, 255).astype(np.uint8)
        res[gold_gown, 2] = np.clip(lum[gold_gown] * 40, 0, 255).astype(np.uint8)
        
        # Scarf: Royal ermine fur collar (white with ermine tail specks)
        res[is_scarf, 0] = np.clip(lum[is_scarf] * 240 + 15, 0, 255).astype(np.uint8)
        res[is_scarf, 1] = np.clip(lum[is_scarf] * 240 + 15, 0, 255).astype(np.uint8)
        res[is_scarf, 2] = np.clip(lum[is_scarf] * 245 + 10, 0, 255).astype(np.uint8)
        ermine_spots = is_scarf & (((x_grid % 10 == 0) & (y_grid % 6 == 0)) | ((x_grid % 13 == 0) & (y_grid % 7 == 0)))
        res[ermine_spots, 0] = 20
        res[ermine_spots, 1] = 20
        res[ermine_spots, 2] = 25
        
        # Boots: Sapphire boots with gold buckles
        gold_buckle = is_boots & ((y_grid == 95) | (y_grid == 96))
        res[is_boots, 0] = np.clip(lum[is_boots] * 30 + 10, 0, 255).astype(np.uint8)
        res[is_boots, 1] = np.clip(lum[is_boots] * 55 + 15, 0, 255).astype(np.uint8)
        res[is_boots, 2] = np.clip(lum[is_boots] * 160 + 35, 0, 255).astype(np.uint8)
        res[gold_buckle, 0] = 255
        res[gold_buckle, 1] = 215
        res[gold_buckle, 2] = 45
        
        # Gloves: White silk royal gloves
        res[is_gloves, 0] = np.clip(lum[is_gloves] * 240 + 15, 0, 255).astype(np.uint8)
        res[is_gloves, 1] = np.clip(lum[is_gloves] * 240 + 15, 0, 255).astype(np.uint8)
        res[is_gloves, 2] = np.clip(lum[is_gloves] * 245 + 10, 0, 255).astype(np.uint8)
        
        # Diamond tiara on brow (y=16..20, x=58..70)
        tiara = is_hair & (y_grid >= 16) & (y_grid <= 19) & (np.abs(x_grid - 64) <= 6)
        res[tiara, 0] = 255
        res[tiara, 1] = 220
        res[tiara, 2] = 50
        # Center diamond gem
        tiara_gem = is_hair & (y_grid >= 17) & (y_grid <= 18) & (np.abs(x_grid - 64) <= 1)
        res[tiara_gem, 0] = 120
        res[tiara_gem, 1] = 245
        res[tiara_gem, 2] = 255

    return res

def build_all():
    print("=== Gerando animações completas com todos os frames para cada traje ===")
    
    # Load original frames
    orig_idle = Image.open(f"{player_dir}/lina_idle.png")
    orig_walk = Image.open(f"{player_dir}/lina_walk.png")
    orig_run = Image.open(f"{player_dir}/lina_run.png")
    
    idle_frames = [np.array(orig_idle.crop((i*128, 0, (i+1)*128, 128))) for i in range(orig_idle.width // 128)]
    walk_frames = [np.array(orig_walk.crop((i*128, 0, (i+1)*128, 128))) for i in range(orig_walk.width // 128)]
    run_frames = [np.array(orig_run.crop((i*128, 0, (i+1)*128, 128))) for i in range(orig_run.width // 128)]
    
    jump_frames, fall_frames, hurt_frames = create_multiframe_actions()
    
    outfits = ["classic", "celestial", "valkyrie", "ninja", "royalty"]
    
    for outfit in outfits:
        print(f"\nProcessando traje: {outfit}")
        
        # 1. Idle (6 frames)
        trans_idle = [apply_outfit_to_frame(f, outfit, i, "idle") for i, f in enumerate(idle_frames)]
        idle_sheet = np.hstack(trans_idle)
        Image.fromarray(idle_sheet).save(f"{player_dir}/lina_idle_{outfit}.png")
        print(f"  [OK] lina_idle_{outfit}.png ({len(trans_idle)} frames)")
        
        # 2. Walk (8 frames)
        trans_walk = [apply_outfit_to_frame(f, outfit, i, "walk") for i, f in enumerate(walk_frames)]
        walk_sheet = np.hstack(trans_walk)
        Image.fromarray(walk_sheet).save(f"{player_dir}/lina_walk_{outfit}.png")
        print(f"  [OK] lina_walk_{outfit}.png ({len(trans_walk)} frames)")
        
        # 3. Run (6 frames)
        trans_run = [apply_outfit_to_frame(f, outfit, i, "run") for i, f in enumerate(run_frames)]
        run_sheet = np.hstack(trans_run)
        Image.fromarray(run_sheet).save(f"{player_dir}/lina_run_{outfit}.png")
        print(f"  [OK] lina_run_{outfit}.png ({len(trans_run)} frames)")
        
        # 4. Jump (3 frames)
        trans_jump = [apply_outfit_to_frame(f, outfit, i, "jump") for i, f in enumerate(jump_frames)]
        jump_sheet = np.hstack(trans_jump)
        Image.fromarray(jump_sheet).save(f"{player_dir}/lina_jump_{outfit}.png")
        print(f"  [OK] lina_jump_{outfit}.png ({len(trans_jump)} frames)")
        
        # 5. Fall (2 frames)
        trans_fall = [apply_outfit_to_frame(f, outfit, i, "fall") for i, f in enumerate(fall_frames)]
        fall_sheet = np.hstack(trans_fall)
        Image.fromarray(fall_sheet).save(f"{player_dir}/lina_fall_{outfit}.png")
        print(f"  [OK] lina_fall_{outfit}.png ({len(trans_fall)} frames)")
        
        # 6. Hurt (3 frames)
        trans_hurt = [apply_outfit_to_frame(f, outfit, i, "hurt") for i, f in enumerate(hurt_frames)]
        hurt_sheet = np.hstack(trans_hurt)
        Image.fromarray(hurt_sheet).save(f"{player_dir}/lina_hurt_{outfit}.png")
        print(f"  [OK] lina_hurt_{outfit}.png ({len(trans_hurt)} frames)")
        
        # Save master sprite for wardrobe preview
        Image.fromarray(trans_idle[0]).save(f"{player_dir}/lina_sprite_{outfit}.png")
        print(f"  [OK] lina_sprite_{outfit}.png master")

    # Generate SpriteFrames resources
    template_tres = """[gd_resource type="SpriteFrames" format=3]

[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_fall_{outfit}.png" id="1_fall"]
[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_hurt_{outfit}.png" id="2_hurt"]
[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_idle_{outfit}.png" id="3_idle"]
[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_jump_{outfit}.png" id="4_jump"]
[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_run_{outfit}.png" id="5_run"]
[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_walk_{outfit}.png" id="6_walk"]

[sub_resource type="AtlasTexture" id="AtlasTexture_fall_0"]
atlas = ExtResource("1_fall")
region = Rect2(0, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_fall_1"]
atlas = ExtResource("1_fall")
region = Rect2(128, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_hurt_0"]
atlas = ExtResource("2_hurt")
region = Rect2(0, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_hurt_1"]
atlas = ExtResource("2_hurt")
region = Rect2(128, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_hurt_2"]
atlas = ExtResource("2_hurt")
region = Rect2(256, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_idle_0"]
atlas = ExtResource("3_idle")
region = Rect2(0, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_idle_1"]
atlas = ExtResource("3_idle")
region = Rect2(128, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_idle_2"]
atlas = ExtResource("3_idle")
region = Rect2(256, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_idle_3"]
atlas = ExtResource("3_idle")
region = Rect2(384, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_idle_4"]
atlas = ExtResource("3_idle")
region = Rect2(512, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_idle_5"]
atlas = ExtResource("3_idle")
region = Rect2(640, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_jump_0"]
atlas = ExtResource("4_jump")
region = Rect2(0, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_jump_1"]
atlas = ExtResource("4_jump")
region = Rect2(128, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_jump_2"]
atlas = ExtResource("4_jump")
region = Rect2(256, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_run_0"]
atlas = ExtResource("5_run")
region = Rect2(0, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_run_1"]
atlas = ExtResource("5_run")
region = Rect2(128, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_run_2"]
atlas = ExtResource("5_run")
region = Rect2(256, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_run_3"]
atlas = ExtResource("5_run")
region = Rect2(384, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_run_4"]
atlas = ExtResource("5_run")
region = Rect2(512, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_run_5"]
atlas = ExtResource("5_run")
region = Rect2(640, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_walk_0"]
atlas = ExtResource("6_walk")
region = Rect2(0, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_walk_1"]
atlas = ExtResource("6_walk")
region = Rect2(128, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_walk_2"]
atlas = ExtResource("6_walk")
region = Rect2(256, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_walk_3"]
atlas = ExtResource("6_walk")
region = Rect2(384, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_walk_4"]
atlas = ExtResource("6_walk")
region = Rect2(512, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_walk_5"]
atlas = ExtResource("6_walk")
region = Rect2(640, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_walk_6"]
atlas = ExtResource("6_walk")
region = Rect2(768, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_walk_7"]
atlas = ExtResource("6_walk")
region = Rect2(896, 0, 128, 128)

[resource]
animations = [{
"frames": [{
"duration": 1.0,
"texture": SubResource("AtlasTexture_fall_0")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_fall_1")
}],
"loop": 1,
"name": &"fall",
"speed": 6.0
}, {
"frames": [{
"duration": 1.0,
"texture": SubResource("AtlasTexture_hurt_0")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_hurt_1")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_hurt_2")
}],
"loop": 0,
"name": &"hurt",
"speed": 12.0
}, {
"frames": [{
"duration": 1.0,
"texture": SubResource("AtlasTexture_idle_0")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_idle_1")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_idle_2")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_idle_3")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_idle_4")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_idle_5")
}],
"loop": 1,
"name": &"idle",
"speed": 6.0
}, {
"frames": [{
"duration": 1.0,
"texture": SubResource("AtlasTexture_jump_0")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_jump_1")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_jump_2")
}],
"loop": 0,
"name": &"jump",
"speed": 8.0
}, {
"frames": [{
"duration": 1.0,
"texture": SubResource("AtlasTexture_run_0")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_run_1")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_run_2")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_run_3")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_run_4")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_run_5")
}],
"loop": 1,
"name": &"run",
"speed": 12.0
}, {
"frames": [{
"duration": 1.0,
"texture": SubResource("AtlasTexture_walk_0")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_walk_1")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_walk_2")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_walk_3")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_walk_4")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_walk_5")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_walk_6")
}, {
"duration": 1.0,
"texture": SubResource("AtlasTexture_walk_7")
}],
"loop": 1,
"name": &"walk",
"speed": 10.0
}]
"""
    
    for outfit in outfits:
        content = template_tres.replace("{outfit}", outfit)
        tres_path = f"scenes/player/player_frames_{outfit}.tres"
        with open(tres_path, "w", encoding="utf-8") as f:
            f.write(content)
        print(f"  [OK] Gravado {tres_path}")
        
    # Also update default player_frames.tres to point to classic with full multi-frame animations
    content_default = template_tres.replace("{outfit}", "classic")
    with open("scenes/player/player_frames.tres", "w", encoding="utf-8") as f:
        f.write(content_default)
    print("  [OK] Atualizado default scenes/player/player_frames.tres")

if __name__ == "__main__":
    build_all()
