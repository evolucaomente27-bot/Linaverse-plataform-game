import os

outfits = ['celestial', 'valkyrie', 'ninja', 'royalty']

template = """[gd_resource type="SpriteFrames" format=3]

[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_fall_{outfit}.png" id="1_fall"]
[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_hurt_{outfit}.png" id="2_hurt"]
[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_idle_{outfit}.png" id="3_idle"]
[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_jump_{outfit}.png" id="4_jump"]
[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_run_{outfit}.png" id="5_run"]
[ext_resource type="Texture2D" path="res://assets/sprites/player/lina_walk_{outfit}.png" id="6_walk"]

[sub_resource type="AtlasTexture" id="AtlasTexture_fall"]
atlas = ExtResource("1_fall")
region = Rect2(0, 0, 128, 128)

[sub_resource type="AtlasTexture" id="AtlasTexture_hurt"]
atlas = ExtResource("2_hurt")
region = Rect2(0, 0, 128, 128)

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

[sub_resource type="AtlasTexture" id="AtlasTexture_jump"]
atlas = ExtResource("4_jump")
region = Rect2(0, 0, 128, 128)

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
"texture": SubResource("AtlasTexture_fall")
}],
"loop": 0,
"name": &"fall",
"speed": 1.0
}, {
"frames": [{
"duration": 1.0,
"texture": SubResource("AtlasTexture_hurt")
}],
"loop": 0,
"name": &"hurt",
"speed": 1.0
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
"texture": SubResource("AtlasTexture_jump")
}],
"loop": 0,
"name": &"jump",
"speed": 1.0
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

os.makedirs("scenes/player", exist_ok=True)
for outfit in outfits:
    content = template.replace("{outfit}", outfit)
    target = f"scenes/player/player_frames_{outfit}.tres"
    with open(target, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"Generated {target}")
