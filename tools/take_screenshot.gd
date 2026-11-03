extends SceneTree

var frame_count = 0
var level_node: Node = null

func _init() -> void:
	print("Starting screenshot capture...")
	var root_viewport = get_root()
	var level_sc = load("res://scenes/levels/level_1.tscn")
	level_node = level_sc.instantiate()
	root_viewport.add_child(level_node)
	process_frame.connect(_on_process_frame)

func _on_process_frame() -> void:
	frame_count += 1
	if frame_count == 30:
		var img = get_root().get_texture().get_image()
		if img:
			img.save_png("screenshot_level1.png")
			print("SUCCESS: screenshot_level1.png captured!")
		quit()
