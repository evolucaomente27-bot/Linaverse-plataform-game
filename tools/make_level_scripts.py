import os

base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
levels_dir = os.path.join(base_dir, "scenes", "levels")

for i in range(6, 16):
    content = f"""extends Node2D

func _ready() -> void:
\tvar count = $Collectibles.get_child_count()
\tGameManager.start_level({i}, Vector2(100, 460), count)
\tSoundManager.play_bgm()
"""
    file_path = os.path.join(levels_dir, f"level_{i}.gd")
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(content)

print("Successfully written level_6.gd through level_15.gd!")
