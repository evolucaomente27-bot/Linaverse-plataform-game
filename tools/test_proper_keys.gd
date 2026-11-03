extends SceneTree

func _init() -> void:
	print("--- TESTING PROPER KEY CONFIG ---")
	
	InputMap.erase_action("test_move_left")
	InputMap.add_action("test_move_left")
	
	# Event with keycode = KEY_A
	var ev_a = InputEventKey.new()
	ev_a.keycode = KEY_A
	InputMap.action_add_event("test_move_left", ev_a)
	
	# Event with keycode = KEY_LEFT
	var ev_left = InputEventKey.new()
	ev_left.keycode = KEY_LEFT
	InputMap.action_add_event("test_move_left", ev_left)
	
	# Test with OS events
	var test_os_a = InputEventKey.new()
	test_os_a.keycode = KEY_A
	test_os_a.physical_keycode = KEY_NONE
	print("OS Event A matches test_move_left:", test_os_a.is_action("test_move_left"))
	
	var test_os_left = InputEventKey.new()
	test_os_left.keycode = KEY_LEFT
	test_os_left.physical_keycode = KEY_NONE
	print("OS Event Left matches test_move_left:", test_os_left.is_action("test_move_left"))
	
	# Test with physical events (for people on non-QWERTY layouts like AZERTY)
	var test_phys_a = InputEventKey.new()
	test_phys_a.keycode = KEY_NONE
	test_phys_a.physical_keycode = KEY_A
	print("Physical A matches test_move_left:", test_phys_a.is_action("test_move_left"))
	
	quit()
