import os
import cv2
import numpy as np
from PIL import Image

OUT_DIR = "assets/sprites/player"
os.makedirs(OUT_DIR, exist_ok=True)

PATH_IDLE = r"C:/Users/user/.gemini/antigravity/brain/5174f9b6-7889-4fa3-96ed-6ccd9eee812f/.user_uploaded/media_1791412150536.png"
PATH_WALK = r"C:/Users/user/.gemini/antigravity/brain/5174f9b6-7889-4fa3-96ed-6ccd9eee812f/.user_uploaded/media_1791412150524.png"
PATH_RUN  = r"C:/Users/user/.gemini/antigravity/brain/5174f9b6-7889-4fa3-96ed-6ccd9eee812f/.user_uploaded/media_1791412150511.png"

# Extraction using Connected Components
def extract_components(image_path, min_major_area=1000, filter_artifacts=False):
    im = Image.open(image_path)
    arr = np.array(im)
    alpha = arr[:, :, 3]
    binary = (alpha > 20).astype(np.uint8)
    num_labels, labels, stats, centroids = cv2.connectedComponentsWithStats(binary)
    
    majors = []
    for i in range(1, num_labels):
        if stats[i][4] >= min_major_area:
            majors.append((i, stats[i], centroids[i]))
    majors.sort(key=lambda m: m[1][0])
    
    minors = []
    for i in range(1, num_labels):
        if 0 < stats[i][4] < min_major_area:
            if filter_artifacts and (stats[i][2] <= 1 or stats[i][3] <= 1):
                continue
            minors.append((i, stats[i], centroids[i]))
            
    frames = []
    for idx, (m_id, m_stat, m_cent) in enumerate(majors):
        char_mask = (labels == m_id)
        for min_id, min_stat, min_cent in minors:
            dists = [abs(min_cent[0] - maj[2][0]) for maj in majors]
            if np.argmin(dists) == idx:
                char_mask = char_mask | (labels == min_id)
                
        char_arr = np.zeros_like(arr)
        char_arr[char_mask] = arr[char_mask]
        
        y_idx = np.where(char_mask.any(axis=1))[0]
        x_idx = np.where(char_mask.any(axis=0))[0]
        cropped = char_arr[y_idx[0]:y_idx[-1]+1, x_idx[0]:x_idx[-1]+1]
        
        frames.append({
            'arr': cropped,
            'w': cropped.shape[1],
            'h': cropped.shape[0],
            'orig_bottom': y_idx[-1],
            'orig_top': y_idx[0]
        })
    return frames

print("1. Extracting frames...")
idle_frames = extract_components(PATH_IDLE)
walk_frames = extract_components(PATH_WALK, filter_artifacts=True)
run_frames  = extract_components(PATH_RUN)

print(f"Extracted: Idle={len(idle_frames)}, Walk={len(walk_frames)}, Run={len(run_frames)}")

# Target metrics in in-game 128x128 canvas
# Standard Lina feet baseline in 128x128 is y = 121
BASELINE_Y = 121
TARGET_HEIGHT = 108.0
SCALE = TARGET_HEIGHT / 266.0 # Idle character is 266px tall

def place_frame_on_canvas(frame_dict, ground_offset=0, x_shift=0, scale_mul=1.0):
    cropped_arr = frame_dict['arr']
    orig_h, orig_w = cropped_arr.shape[:2]
    
    cur_scale = SCALE * scale_mul
    target_w = max(1, int(round(orig_w * cur_scale)))
    target_h = max(1, int(round(orig_h * cur_scale)))
    
    pil_img = Image.fromarray(cropped_arr)
    resized = pil_img.resize((target_w, target_h), resample=Image.Resampling.LANCZOS)
    
    canvas = Image.new("RGBA", (128, 128), (0, 0, 0, 0))
    # Align feet to BASELINE_Y + ground_offset
    dest_y = (BASELINE_Y + ground_offset) - target_h
    dest_x = (64 + x_shift) - (target_w // 2)
    
    canvas.paste(resized, (dest_x, dest_y), resized)
    return canvas

# 2. Build IDLE Strip (6 frames, 768x128)
print("2. Building Idle strip...")
strip_idle = Image.new("RGBA", (128 * len(idle_frames), 128), (0, 0, 0, 0))
for i, f in enumerate(idle_frames):
    c = place_frame_on_canvas(f)
    strip_idle.paste(c, (i * 128, 0))
strip_idle.save(f"{OUT_DIR}/lina_idle_celestial.png")
print(f"Saved: {OUT_DIR}/lina_idle_celestial.png ({strip_idle.size})")

# 3. Build WALK Strip (6 frames, 768x128)
print("3. Building Walk strip...")
strip_walk = Image.new("RGBA", (128 * len(walk_frames), 128), (0, 0, 0, 0))
for i, f in enumerate(walk_frames):
    c = place_frame_on_canvas(f)
    strip_walk.paste(c, (i * 128, 0))
strip_walk.save(f"{OUT_DIR}/lina_walk_celestial.png")
print(f"Saved: {OUT_DIR}/lina_walk_celestial.png ({strip_walk.size})")

# 4. Build RUN Strip (6 frames, 768x128)
print("4. Building Run strip...")
strip_run = Image.new("RGBA", (128 * len(run_frames), 128), (0, 0, 0, 0))
for i, f in enumerate(run_frames):
    # During sprint, character leans slightly forward
    c = place_frame_on_canvas(f, ground_offset=0, x_shift=2)
    strip_run.paste(c, (i * 128, 0))
strip_run.save(f"{OUT_DIR}/lina_run_celestial.png")
print(f"Saved: {OUT_DIR}/lina_run_celestial.png ({strip_run.size})")

# 5. Build JUMP Strip (3 frames, 384x128)
print("5. Building Jump strip...")
strip_jump = Image.new("RGBA", (128 * 3, 128), (0, 0, 0, 0))

# Frame 0: Crouch anticipation (squash)
j0 = place_frame_on_canvas(run_frames[0], ground_offset=2, scale_mul=0.98)
strip_jump.paste(j0, (0, 0))

# Frame 1: Ascending leap (high stride from run frame 3)
j1 = place_frame_on_canvas(run_frames[3], ground_offset=-10, x_shift=2)
strip_jump.paste(j1, (128, 0))

# Frame 2: Apex stretch (lifted higher)
j2 = place_frame_on_canvas(run_frames[3], ground_offset=-16, x_shift=1, scale_mul=1.02)
strip_jump.paste(j2, (256, 0))

strip_jump.save(f"{OUT_DIR}/lina_jump_celestial.png")
print(f"Saved: {OUT_DIR}/lina_jump_celestial.png ({strip_jump.size})")

# 6. Build FALL Strip (2 frames, 256x128)
print("6. Building Fall strip...")
strip_fall = Image.new("RGBA", (128 * 2, 128), (0, 0, 0, 0))

# Frame 0: Mid-air descent
f0 = place_frame_on_canvas(run_frames[1], ground_offset=-8, x_shift=1)
strip_fall.paste(f0, (0, 0))

# Frame 1: Wind flapping descent
f1 = place_frame_on_canvas(run_frames[2], ground_offset=-10, x_shift=0)
strip_fall.paste(f1, (128, 0))

strip_fall.save(f"{OUT_DIR}/lina_fall_celestial.png")
print(f"Saved: {OUT_DIR}/lina_fall_celestial.png ({strip_fall.size})")

# 7. Build HURT Strip (3 frames, 384x128)
print("7. Building Hurt strip...")
strip_hurt = Image.new("RGBA", (128 * 3, 128), (0, 0, 0, 0))
base_idle_c = place_frame_on_canvas(idle_frames[0])
base_arr = np.array(base_idle_c)

# Frame 0: Impact (-8 deg, reddish tint)
M0 = cv2.getRotationMatrix2D((64, 121), -8.0, 1.0)
h0 = cv2.warpAffine(base_arr, M0, (128, 128), flags=cv2.INTER_LANCZOS4, borderMode=cv2.BORDER_CONSTANT, borderValue=(0,0,0,0))
mask0 = h0[:, :, 3] > 20
h0[mask0, 0] = np.clip(h0[mask0, 0] * 1.35 + 50, 0, 255).astype(np.uint8)
h0[mask0, 1] = np.clip(h0[mask0, 1] * 0.7, 0, 255).astype(np.uint8)
h0[mask0, 2] = np.clip(h0[mask0, 2] * 0.7, 0, 255).astype(np.uint8)
strip_hurt.paste(Image.fromarray(h0), (0, 0))

# Frame 1: Knockback (-14 deg, shifted -4px, strong red flash)
M1 = cv2.getRotationMatrix2D((64, 121), -14.0, 1.0)
M1[0, 2] -= 4.0
h1 = cv2.warpAffine(base_arr, M1, (128, 128), flags=cv2.INTER_LANCZOS4, borderMode=cv2.BORDER_CONSTANT, borderValue=(0,0,0,0))
mask1 = h1[:, :, 3] > 20
h1[mask1, 0] = np.clip(h1[mask1, 0] * 1.5 + 70, 0, 255).astype(np.uint8)
h1[mask1, 1] = np.clip(h1[mask1, 1] * 0.6, 0, 255).astype(np.uint8)
h1[mask1, 2] = np.clip(h1[mask1, 2] * 0.6, 0, 255).astype(np.uint8)
strip_hurt.paste(Image.fromarray(h1), (128, 0))

# Frame 2: Recovery (-4 deg)
M2 = cv2.getRotationMatrix2D((64, 121), -4.0, 1.0)
M2[0, 2] -= 2.0
h2 = cv2.warpAffine(base_arr, M2, (128, 128), flags=cv2.INTER_LANCZOS4, borderMode=cv2.BORDER_CONSTANT, borderValue=(0,0,0,0))
strip_hurt.paste(Image.fromarray(h2), (256, 0))

strip_hurt.save(f"{OUT_DIR}/lina_hurt_celestial.png")
print(f"Saved: {OUT_DIR}/lina_hurt_celestial.png ({strip_hurt.size})")

# 8. Character portrait / UI icon
print("8. Building UI Icon / Portrait...")
portrait = place_frame_on_canvas(idle_frames[0])
portrait.save(f"{OUT_DIR}/lina_sprite_celestial.png")
print(f"Saved: {OUT_DIR}/lina_sprite_celestial.png ({portrait.size})")

print("\n=== ALL CELESTIAL SPRITES CREATED SUCCESSFULLY! ===")
