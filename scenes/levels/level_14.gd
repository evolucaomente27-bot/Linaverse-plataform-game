extends Node2D

func _ready() -> void:
	var count = $Collectibles.get_child_count()
	GameManager.start_level(14, Vector2(100, 460), count)
	SoundManager.play_bgm()
