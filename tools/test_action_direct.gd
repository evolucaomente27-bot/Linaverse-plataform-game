extends SceneTree

func _init() -> void:
	Input.action_press("move_right")
	print("After Input.action_press('move_right'):", Input.is_action_pressed("move_right"))
	print("Input.get_axis('move_left', 'move_right'):", Input.get_axis("move_left", "move_right"))
	Input.action_release("move_right")
	print("After Input.action_release('move_right'):", Input.is_action_pressed("move_right"))
	quit()
