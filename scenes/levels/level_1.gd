extends Node2D

func _ready() -> void:
	# Inicializa dados da Fase 1
	var count = $Collectibles.get_child_count()
	GameManager.start_level(1, Vector2(100, 460), count)
	SoundManager.play_bgm()
	
	if "--screenshot-game" in OS.get_cmdline_args() or "--screenshot-game" in OS.get_cmdline_user_args():
		await get_tree().create_timer(0.4).timeout
		var tex = get_viewport().get_texture()
		if tex:
			var img = tex.get_image()
			if img:
				img.save_png("screenshot_gameplay_outfit.png")
				print("Gameplay screenshot captured!")
		get_tree().quit()

