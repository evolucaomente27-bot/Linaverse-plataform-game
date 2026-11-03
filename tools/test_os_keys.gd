extends SceneTree

func _init() -> void:
	print("--- TEST KEY MATCHING ---")
	
	# Event coming from OS on Windows when pressing Left Arrow
	var os_event = InputEventKey.new()
	os_event.keycode = KEY_LEFT
	os_event.physical_keycode = KEY_NONE
	
	print("OS Left arrow (keycode=KEY_LEFT, physical=0):")
	print("  matches 'move_left':", os_event.is_action("move_left"))
	print("  matches 'ui_left':", os_event.is_action("ui_left"))
	
	# Event coming from OS on Windows when pressing Right Arrow
	var os_event_r = InputEventKey.new()
	os_event_r.keycode = KEY_RIGHT
	os_event_r.physical_keycode = KEY_NONE
	print("OS Right arrow (keycode=KEY_RIGHT, physical=0):")
	print("  matches 'move_right':", os_event_r.is_action("move_right"))
	print("  matches 'ui_right':", os_event_r.is_action("ui_right"))
	
	# Event coming from OS when pressing D
	var os_event_d = InputEventKey.new()
	os_event_d.keycode = KEY_D
	os_event_d.physical_keycode = KEY_NONE
	print("OS D key (keycode=KEY_D, physical=0):")
	print("  matches 'move_right':", os_event_d.is_action("move_right"))
	
	# Event coming from OS when pressing A
	var os_event_a = InputEventKey.new()
	os_event_a.keycode = KEY_A
	os_event_a.physical_keycode = KEY_NONE
	print("OS A key (keycode=KEY_A, physical=0):")
	print("  matches 'move_left':", os_event_a.is_action("move_left"))
	
	quit()
