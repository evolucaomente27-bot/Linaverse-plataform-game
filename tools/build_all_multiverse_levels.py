import os
import shutil
import random

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LEVELS_DIR = os.path.join(BASE_DIR, "scenes", "levels")

UNIVERSES = ["classic", "celestial", "valkyrie", "ninja", "royalty", "uniform"]

# Ensure directories exist
for u in UNIVERSES:
    os.makedirs(os.path.join(LEVELS_DIR, u), exist_ok=True)

# 1. Copy classic levels
print("Configuring classic levels...")
for lvl in range(1, 13):
    src_tscn = os.path.join(LEVELS_DIR, f"level_{lvl}.tscn")
    src_gd = os.path.join(LEVELS_DIR, f"level_{lvl}.gd")
    dst_tscn = os.path.join(LEVELS_DIR, "classic", f"level_{lvl}.tscn")
    dst_gd = os.path.join(LEVELS_DIR, "classic", f"level_{lvl}.gd")
    
    if os.path.exists(src_gd):
        with open(src_gd, "r", encoding="utf-8") as f:
            gd_content = f.read()
        with open(dst_gd, "w", encoding="utf-8") as f:
            f.write(gd_content)
            
    if os.path.exists(src_tscn):
        with open(src_tscn, "r", encoding="utf-8") as f:
            tscn_content = f.read()
        tscn_content = tscn_content.replace(f'res://scenes/levels/level_{lvl}.gd', f'res://scenes/levels/classic/level_{lvl}.gd')
        with open(dst_tscn, "w", encoding="utf-8") as f:
            f.write(tscn_content)

print("[OK] Classic levels copied to scenes/levels/classic/")

def make_level_script(universe: str, lvl: int, count: int = 24) -> str:
    return f"""extends Node2D

func _ready() -> void:
\tvar count = $Collectibles.get_child_count()
\tGameManager.start_level({lvl}, Vector2(100, 460), count)
\tSoundManager.play_bgm()
"""

def generate_multiverse_level(universe: str, lvl: int) -> str:
    # Deterministic seed per universe and level for consistency
    seed_val = hash(f"{universe}_{lvl}") & 0xFFFFFFFF
    rng = random.Random(seed_val)
    
    # Archetype properties
    total_length = 4000 + (lvl * 110) + rng.randint(-100, 150)
    end_x = total_length
    
    lines = []
    lines.append('[gd_scene format=3]')
    lines.append('')
    lines.append('[ext_resource type="PackedScene" path="res://scenes/levels/parallax_background.tscn" id="1_bg"]')
    lines.append('[ext_resource type="PackedScene" path="res://scenes/objects/ground_platform.tscn" id="2_ground"]')
    lines.append('[ext_resource type="Script" path="res://scenes/objects/ground_platform.gd" id="3_ground_script"]')
    lines.append('[ext_resource type="PackedScene" path="res://scenes/objects/ice_platform.tscn" id="4_ice"]')
    lines.append('[ext_resource type="PackedScene" path="res://scenes/objects/moving_platform.tscn" id="5_moving"]')
    lines.append('[ext_resource type="Script" path="res://scenes/objects/moving_platform.gd" id="6_moving_script"]')
    lines.append('[ext_resource type="PackedScene" path="res://scenes/objects/spikes.tscn" id="7_spikes"]')
    lines.append('[ext_resource type="PackedScene" path="res://scenes/objects/crystal.tscn" id="8_crystal"]')
    lines.append('[ext_resource type="PackedScene" path="res://scenes/enemies/enemy.tscn" id="9_enemy"]')
    lines.append('[ext_resource type="Script" path="res://scenes/enemies/enemy.gd" id="10_enemy_script"]')
    lines.append('[ext_resource type="PackedScene" path="res://scenes/objects/checkpoint.tscn" id="11_cp"]')
    lines.append('[ext_resource type="PackedScene" path="res://scenes/objects/spring_mushroom.tscn" id="12_spring"]')
    lines.append('[ext_resource type="Script" path="res://scenes/objects/spring_mushroom.gd" id="13_spring_script"]')
    lines.append('[ext_resource type="PackedScene" path="res://scenes/objects/portal.tscn" id="14_portal"]')
    lines.append('[ext_resource type="PackedScene" path="res://scenes/player/player.tscn" id="15_player"]')
    lines.append('[ext_resource type="PackedScene" path="res://scenes/ui/hud.tscn" id="16_hud"]')
    lines.append('[ext_resource type="PackedScene" path="res://scenes/ui/pause_menu.tscn" id="17_pause"]')
    lines.append('[ext_resource type="PackedScene" path="res://scenes/ui/game_over_menu.tscn" id="18_gameover"]')
    lines.append('[ext_resource type="PackedScene" path="res://scenes/ui/victory_menu.tscn" id="19_victory"]')
    lines.append('[ext_resource type="PackedScene" path="res://scenes/objects/powerup.tscn" id="20_powerup"]')
    lines.append('[ext_resource type="Script" path="res://scenes/objects/powerup.gd" id="21_powerup_script"]')
    lines.append('[ext_resource type="PackedScene" path="res://scenes/objects/boost_pad.tscn" id="22_boost"]')
    lines.append('[ext_resource type="Script" path="res://scenes/objects/boost_pad.gd" id="23_boost_script"]')
    lines.append('[ext_resource type="PackedScene" path="res://scenes/objects/wind_current.tscn" id="24_wind"]')
    lines.append('[ext_resource type="Script" path="res://scenes/objects/wind_current.gd" id="25_wind_script"]')
    lines.append('[ext_resource type="PackedScene" path="res://scenes/objects/crumbling_platform.tscn" id="26_crumble"]')
    lines.append('[ext_resource type="Script" path="res://scenes/objects/crumbling_platform.gd" id="27_crumble_script"]')
    lines.append('[ext_resource type="PackedScene" path="res://scenes/objects/breakable_wall.tscn" id="28_wall"]')
    lines.append('[ext_resource type="Script" path="res://scenes/objects/breakable_wall.gd" id="29_wall_script"]')
    lines.append(f'[ext_resource type="Script" path="res://scenes/levels/{universe}/level_{lvl}.gd" id="30_lvl_script"]')
    lines.append('')
    lines.append('[sub_resource type="RectangleShape2D" id="RectangleShape2D_wall_left"]')
    lines.append('size = Vector2(40, 800)')
    lines.append('')
    lines.append('[sub_resource type="RectangleShape2D" id="RectangleShape2D_wall_right"]')
    lines.append('size = Vector2(40, 800)')
    lines.append('')
    lines.append(f'[node name="Level{lvl}" type="Node2D"]')
    lines.append('script = ExtResource("30_lvl_script")')
    lines.append('')
    lines.append('[node name="ParallaxBackground" type="ParallaxBackground" parent="." instance=ExtResource("1_bg")]')
    lines.append('')
    lines.append('[node name="Boundaries" type="Node2D" parent="."]')
    lines.append('')
    lines.append('[node name="LeftWall" type="StaticBody2D" parent="Boundaries"]')
    lines.append('position = Vector2(-20, 350)')
    lines.append('collision_mask = 0')
    lines.append('')
    lines.append('[node name="CollisionShape2D" type="CollisionShape2D" parent="Boundaries/LeftWall"]')
    lines.append('shape = SubResource("RectangleShape2D_wall_left")')
    lines.append('')
    lines.append('[node name="RightWall" type="StaticBody2D" parent="Boundaries"]')
    lines.append(f'position = Vector2({end_x + 120}, 350)')
    lines.append('collision_mask = 0')
    lines.append('')
    lines.append('[node name="CollisionShape2D" type="CollisionShape2D" parent="Boundaries/RightWall"]')
    lines.append('shape = SubResource("RectangleShape2D_wall_right")')
    lines.append('')
    lines.append('[node name="Platforms" type="Node2D" parent="."]')
    lines.append('')
    
    # 1. Starting platform: exactly at (200, 560), width 460
    lines.append('[node name="Ground_Start" type="StaticBody2D" parent="Platforms" instance=ExtResource("2_ground")]')
    lines.append('position = Vector2(200, 560)')
    lines.append('collision_mask = 0')
    lines.append('script = ExtResource("3_ground_script")')
    lines.append('platform_size = Vector2(460, 64)')
    lines.append('')
    
    # We will generate a sequence of platforms, hazards, mechanics, crystals, checkpoints
    curr_x = 480
    curr_y = 520
    platform_idx = 1
    
    platforms = []
    spikes_list = []
    crystals_list = []
    enemies_list = []
    checkpoints_list = []
    springs_list = []
    powerups_list = []
    boosts_list = []
    winds_list = []
    crumbles_list = []
    walls_list = []
    
    # Initial crystals
    crystals_list.append((250, 480))
    crystals_list.append((340, 470))
    
    cp1_placed = False
    cp2_placed = False
    
    step_num = 0
    while curr_x < end_x - 450:
        step_num += 1
        
        # Checkpoint 1 around 30% of length
        if not cp1_placed and curr_x > end_x * 0.30:
            cp_x = curr_x + 180
            cp_y = curr_y - 64
            checkpoints_list.append((cp_x, cp_y))
            platforms.append(("ground", cp_x, curr_y, 360, 64))
            crystals_list.append((cp_x - 90, cp_y - 20))
            crystals_list.append((cp_x + 90, cp_y - 20))
            curr_x += 380
            cp1_placed = True
            continue
            
        # Checkpoint 2 around 65% of length
        if not cp2_placed and curr_x > end_x * 0.65:
            cp_x = curr_x + 180
            cp_y = curr_y - 64
            checkpoints_list.append((cp_x, cp_y))
            platforms.append(("ground", cp_x, curr_y, 360, 64))
            crystals_list.append((cp_x - 90, cp_y - 20))
            crystals_list.append((cp_x + 90, cp_y - 20))
            curr_x += 380
            cp2_placed = True
            continue
            
        # Archetype decision
        pattern = rng.choice(["ground", "ice_steps", "moving", "gap_with_spring", "crumble_chain", "boost_runway"])
        
        if universe == "celestial":
            # Floatier, higher platforms, wind currents
            curr_y = max(240, min(500, curr_y + rng.choice([-60, -40, 40, 60])))
            if pattern in ["gap_with_spring", "crumble_chain"]:
                pattern = "wind_updraft"
        elif universe == "valkyrie":
            # Crumbling shelves, rugged gaps, enemies
            if pattern == "boost_runway":
                pattern = "crumble_chain"
        elif universe == "ninja":
            # Rooftop dashing, breakable walls, tight boost pads
            if pattern == "moving":
                pattern = "boost_runway"
        elif universe == "royalty":
            # Grand terraces, moving crystal elevators, lots of crystals
            if pattern == "crumble_chain":
                pattern = "moving"
        elif universe == "uniform":
            # Long track sprints, boost chains, vaulting leaps
            if pattern in ["gap_with_spring", "ice_steps"]:
                pattern = "boost_runway"
                
        # Build pattern
        if pattern == "ground":
            w = rng.randint(380, 560)
            platforms.append(("ground", curr_x + w//2, curr_y, w, 64))
            crystals_list.append((curr_x + w//3, curr_y - 45))
            crystals_list.append((curr_x + (2*w)//3, curr_y - 45))
            if rng.random() < 0.6:
                enemies_list.append((curr_x + w//2, curr_y - 25, 90))
            curr_x += w + rng.randint(90, 150)
            
        elif pattern == "ice_steps":
            # 2 to 3 ice steps
            num_steps = rng.randint(2, 3)
            for s in range(num_steps):
                curr_y = max(260, min(500, curr_y + rng.choice([-45, 45])))
                platforms.append(("ice", curr_x + 80, curr_y, 140, 32))
                crystals_list.append((curr_x + 80, curr_y - 40))
                curr_x += 160 + rng.randint(30, 70)
            if rng.random() < 0.5:
                spikes_list.append((curr_x - 120, 590))
                
        elif pattern == "moving":
            m_off_x = rng.choice([120, 160, -120])
            m_off_y = rng.choice([0, -60, 60])
            platforms.append(("moving", curr_x + 80, curr_y, m_off_x, m_off_y, 2.4))
            crystals_list.append((curr_x + 80, curr_y - 45))
            curr_x += 220 + rng.randint(40, 80)
            
        elif pattern == "gap_with_spring":
            # Ground with spring mushroom launching across gap
            platforms.append(("ground", curr_x + 120, curr_y, 240, 64))
            springs_list.append((curr_x + 160, curr_y - 50, -820.0))
            spikes_list.append((curr_x + 280, 590))
            spikes_list.append((curr_x + 350, 590))
            curr_x += 420
            curr_y = max(240, curr_y - 80)
            platforms.append(("ice", curr_x + 100, curr_y, 180, 32))
            crystals_list.append((curr_x + 100, curr_y - 45))
            curr_x += 240
            
        elif pattern == "crumble_chain":
            # 2 crumbling platforms over hazard
            crumbles_list.append((curr_x + 70, curr_y, 120, 24))
            crumbles_list.append((curr_x + 220, curr_y, 120, 24))
            spikes_list.append((curr_x + 150, 590))
            crystals_list.append((curr_x + 70, curr_y - 40))
            crystals_list.append((curr_x + 220, curr_y - 40))
            curr_x += 350
            
        elif pattern == "boost_runway":
            w = rng.randint(450, 650)
            platforms.append(("ground", curr_x + w//2, curr_y, w, 64))
            boosts_list.append((curr_x + 100, curr_y - 10, 880.0, 1.0))
            crystals_list.append((curr_x + w//2, curr_y - 45))
            crystals_list.append((curr_x + w - 100, curr_y - 45))
            curr_x += w + rng.randint(120, 180)
            
        elif pattern == "wind_updraft":
            # Gap with strong vertical wind current
            winds_list.append((curr_x + 90, curr_y, 90, 240, -900.0))
            crystals_list.append((curr_x + 90, curr_y - 90))
            crystals_list.append((curr_x + 90, curr_y - 150))
            curr_y = max(220, curr_y - 120)
            platforms.append(("ice", curr_x + 220, curr_y, 160, 32))
            curr_x += 340

        # Occasional power-up distribution
        if step_num in [2, 5, 8]:
            p_type = rng.choice(["dash", "magnet", "chrono", "shield", "wings"])
            powerups_list.append((curr_x - 100, curr_y - 60, p_type))
            
        # Occasional breakable wall shortcut
        if step_num in [3, 7] and rng.random() < 0.7:
            walls_list.append((curr_x - 80, curr_y - 50, 36, 110))
            crystals_list.append((curr_x - 20, curr_y - 40))

    # Final Goal Platform
    end_platform_w = 480
    end_platform_x = end_x - 200
    end_platform_y = 520
    platforms.append(("ground", end_platform_x, end_platform_y, end_platform_w, 64))
    portal_x = end_platform_x + 120
    portal_y = end_platform_y - 46
    
    # Write Platforms
    p_count = 0
    for p in platforms:
        p_count += 1
        p_type = p[0]
        if p_type == "ground":
            lines.append(f'[node name="Ground_{p_count}" type="StaticBody2D" parent="Platforms" instance=ExtResource("2_ground")]')
            lines.append(f'position = Vector2({p[1]}, {p[2]})')
            lines.append('collision_mask = 0')
            lines.append('script = ExtResource("3_ground_script")')
            lines.append(f'platform_size = Vector2({p[3]}, {p[4]})')
            lines.append('')
        elif p_type == "ice":
            lines.append(f'[node name="Ice_{p_count}" type="StaticBody2D" parent="Platforms" instance=ExtResource("4_ice")]')
            lines.append(f'position = Vector2({p[1]}, {p[2]})')
            lines.append('collision_mask = 0')
            lines.append('')
        elif p_type == "moving":
            lines.append(f'[node name="Moving_{p_count}" type="AnimatableBody2D" parent="Platforms" instance=ExtResource("5_moving")]')
            lines.append(f'position = Vector2({p[1]}, {p[2]})')
            lines.append('collision_mask = 0')
            lines.append('script = ExtResource("6_moving_script")')
            lines.append(f'move_offset = Vector2({p[3]}, {p[4]})')
            lines.append(f'duration = {p[5]}')
            lines.append('')
            
    # Spikes
    lines.append('[node name="Spikes" type="Node2D" parent="."]')
    lines.append('')
    for idx, sp in enumerate(spikes_list):
        lines.append(f'[node name="Spike_{idx+1}" type="Area2D" parent="Spikes" instance=ExtResource("7_spikes")]')
        lines.append(f'position = Vector2({sp[0]}, {sp[1]})')
        lines.append('collision_layer = 0')
        lines.append('collision_mask = 2')
        lines.append('')
        
    # Collectibles
    lines.append('[node name="Collectibles" type="Node2D" parent="."]')
    lines.append('')
    for idx, c in enumerate(crystals_list):
        lines.append(f'[node name="Crystal_{idx+1}" type="Area2D" parent="Collectibles" instance=ExtResource("8_crystal")]')
        lines.append(f'position = Vector2({c[0]}, {c[1]})')
        lines.append('collision_layer = 4')
        lines.append('collision_mask = 2')
        lines.append('')
        
    # Enemies
    lines.append('[node name="Enemies" type="Node2D" parent="."]')
    lines.append('')
    for idx, e in enumerate(enemies_list):
        lines.append(f'[node name="Enemy_{idx+1}" type="CharacterBody2D" parent="Enemies" groups=["enemies"] instance=ExtResource("9_enemy")]')
        lines.append(f'position = Vector2({e[0]}, {e[1]})')
        lines.append('collision_layer = 8')
        lines.append('script = ExtResource("10_enemy_script")')
        lines.append(f'patrol_distance = {e[2]}')
        lines.append('')
        
    # InteractiveObjects (Checkpoints, SpringMushrooms, Portal)
    lines.append('[node name="InteractiveObjects" type="Node2D" parent="."]')
    lines.append('')
    for idx, cp in enumerate(checkpoints_list):
        lines.append(f'[node name="Checkpoint_{idx+1}" type="Area2D" parent="InteractiveObjects" instance=ExtResource("11_cp")]')
        lines.append(f'position = Vector2({cp[0]}, {cp[1]})')
        lines.append('collision_layer = 0')
        lines.append('collision_mask = 2')
        lines.append('')
    for idx, sm in enumerate(springs_list):
        lines.append(f'[node name="Spring_{idx+1}" type="Area2D" parent="InteractiveObjects" instance=ExtResource("12_spring")]')
        lines.append(f'position = Vector2({sm[0]}, {sm[1]})')
        lines.append('collision_layer = 0')
        lines.append('collision_mask = 2')
        lines.append('script = ExtResource("13_spring_script")')
        lines.append(f'bounce_velocity = {sm[2]}')
        lines.append('')
        
    lines.append('[node name="Portal" type="Area2D" parent="InteractiveObjects" instance=ExtResource("14_portal")]')
    lines.append(f'position = Vector2({portal_x}, {portal_y})')
    lines.append('collision_layer = 0')
    lines.append('collision_mask = 2')
    lines.append('')
    
    # Player & UI
    lines.append('[node name="Player" type="CharacterBody2D" parent="." groups=["player"] instance=ExtResource("15_player")]')
    lines.append('position = Vector2(100, 460)')
    lines.append('collision_layer = 2')
    lines.append('floor_constant_speed = true')
    lines.append('floor_snap_length = 6.0')
    lines.append('')
    lines.append('[node name="HUD" type="CanvasLayer" parent="." instance=ExtResource("16_hud")]')
    lines.append('')
    lines.append('[node name="PauseMenu" type="CanvasLayer" parent="." instance=ExtResource("17_pause")]')
    lines.append('process_mode = 3')
    lines.append('visible = false')
    lines.append('')
    lines.append('[node name="GameOverMenu" type="CanvasLayer" parent="." instance=ExtResource("18_gameover")]')
    lines.append('process_mode = 3')
    lines.append('visible = false')
    lines.append('')
    lines.append('[node name="VictoryMenu" type="CanvasLayer" parent="." instance=ExtResource("19_victory")]')
    lines.append('process_mode = 3')
    lines.append('visible = false')
    lines.append('')
    
    # Mechanics
    lines.append('[node name="Mechanics" type="Node2D" parent="."]')
    lines.append('')
    # Ensure at least 1 powerup, 1 boost, 1 crumble, 1 wind, 1 wall per level
    if not powerups_list:
        powerups_list.append((800, 420, "dash"))
    if not boosts_list:
        boosts_list.append((1200, 500, 880.0, 1.0))
    if not winds_list:
        winds_list.append((1800, 450, 80, 220, -850.0))
    if not crumbles_list:
        cx = 2400
        while any(abs(cx - cp[0]) < 220 for cp in checkpoints_list):
            cx += 200
        crumbles_list.append((cx, 450, 110, 24))
    if not walls_list:
        wx = 3000
        while any(abs(wx - cp[0]) < 220 for cp in checkpoints_list):
            wx += 200
        walls_list.append((wx, 440, 36, 110))
        
    for idx, pup in enumerate(powerups_list):
        lines.append(f'[node name="PowerUp_{idx+1}" type="Area2D" parent="Mechanics" instance=ExtResource("20_powerup")]')
        lines.append(f'position = Vector2({pup[0]}, {pup[1]})')
        lines.append('collision_layer = 4')
        lines.append('collision_mask = 2')
        lines.append('script = ExtResource("21_powerup_script")')
        lines.append(f'powerup_type = "{pup[2]}"')
        lines.append('')
        
    for idx, b in enumerate(boosts_list):
        lines.append(f'[node name="BoostPad_{idx+1}" type="Area2D" parent="Mechanics" instance=ExtResource("22_boost")]')
        lines.append(f'position = Vector2({b[0]}, {b[1]})')
        lines.append('collision_layer = 0')
        lines.append('collision_mask = 2')
        lines.append('script = ExtResource("23_boost_script")')
        lines.append(f'boost_speed = {b[2]}')
        lines.append(f'boost_dir = {b[3]}')
        lines.append('')
        
    for idx, w in enumerate(winds_list):
        lines.append(f'[node name="WindCurrent_{idx+1}" type="Area2D" parent="Mechanics" instance=ExtResource("24_wind")]')
        lines.append(f'position = Vector2({w[0]}, {w[1]})')
        lines.append('collision_layer = 0')
        lines.append('collision_mask = 2')
        lines.append('script = ExtResource("25_wind_script")')
        lines.append(f'current_size = Vector2({w[2]}, {w[3]})')
        lines.append(f'wind_force = {w[4]}')
        lines.append('')
        
    for idx, cr in enumerate(crumbles_list):
        lines.append(f'[node name="Crumble_{idx+1}" type="StaticBody2D" parent="Mechanics" instance=ExtResource("26_crumble")]')
        lines.append(f'position = Vector2({cr[0]}, {cr[1]})')
        lines.append('collision_mask = 0')
        lines.append('script = ExtResource("27_crumble_script")')
        lines.append(f'platform_size = Vector2({cr[2]}, {cr[3]})')
        lines.append('')
        
    for idx, wl in enumerate(walls_list):
        lines.append(f'[node name="BreakableWall_{idx+1}" type="StaticBody2D" parent="Mechanics" instance=ExtResource("28_wall")]')
        lines.append(f'position = Vector2({wl[0]}, {wl[1]})')
        lines.append('collision_mask = 0')
        lines.append('script = ExtResource("29_wall_script")')
        lines.append(f'wall_size = Vector2({wl[2]}, {wl[3]})')
        lines.append('')
        
    return "\n".join(lines)

# Generate levels for the remaining 5 universes
target_universes = ["celestial", "valkyrie", "ninja", "royalty", "uniform"]

for u in target_universes:
    u_dir = os.path.join(LEVELS_DIR, u)
    print(f"Generating 12 unique levels for universe '{u}'...")
    for lvl in range(1, 13):
        tscn_content = generate_multiverse_level(u, lvl)
        gd_content = make_level_script(u, lvl)
        
        tscn_path = os.path.join(u_dir, f"level_{lvl}.tscn")
        gd_path = os.path.join(u_dir, f"level_{lvl}.gd")
        
        with open(tscn_path, "w", encoding="utf-8") as f:
            f.write(tscn_content)
        with open(gd_path, "w", encoding="utf-8") as f:
            f.write(gd_content)
            
    print(f"[OK] Generated 12 levels for '{u}' in {u_dir}")

print("\n=== SUCESSO: TODAS AS 72 FASES DO MULTIVERSO FORAM GERADAS! ===")
