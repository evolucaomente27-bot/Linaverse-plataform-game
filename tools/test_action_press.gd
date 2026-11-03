extends SceneTree

func _init() -> void:
	print("--- TESTING ACTION PRESS ---")
	
	# Test key D press
	var ev_d = InputEventKey.new()
	ev_d.physical_keycode = KEY_D
	ev_d.pressed = true
	Input.parse_input_event(ev_d)
	
	print("After D pressed:")
	print("  is_action_pressed('move_right'):", Input.is_action_pressed("move_right"))
	print("  get_axis('move_left', 'move_right'):", Input.get_axis("move_left", "move_right"))
	
	# Release D
	ev_d.pressed = false
	Input.parse_input_event(ev_d)
	
	# Test key Right arrow
	var ev_r = InputEventKey.new()
	ev_r.physical_keycode = KEY_RIGHT
	ev_r.pressed = true
	Input.parse_input_event(ev_r)
	
	print("After RIGHT arrow pressed with physical_keycode:")
	print("  is_action_pressed('move_right'):", Input.is_action_pressed("move_right"))
	print("  get_axis('move_left', 'move_right'):", Input.get_axis("move_left", "move_right"))
	
	# What if right arrow has keycode instead of physical_keycode?
	ev_r.pressed = false
	Input.parse_input_event(ev_r)
	
	var ev_r_kc = InputEventKey.new()
	ev_r_kc.keycode = KEY_RIGHT
	ev_r_kc.pressed = true
	Input.parse_input_event(ev_r_kc)
	print("After RIGHT arrow pressed with KEYCODE (not physical):")
	print("  is_action_pressed('move_right'):", Input.is_action_pressed("move_right"))
	print("  get_axis('move_left', 'move_right'):", Input.get_axis("move_left", "move_right"))
	
	quit()
