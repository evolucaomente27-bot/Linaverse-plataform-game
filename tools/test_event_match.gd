extends SceneTree

func _init() -> void:
	print("--- INSPECTING EVENT MATCHING ---")
	var registered_events = InputMap.action_get_events("move_right")
	for i in range(len(registered_events)):
		var ev = registered_events[i]
		print("Registered Event ", i, ":")
		print("  keycode: ", ev.keycode)
		print("  physical_keycode: ", ev.physical_keycode)
		print("  key_label: ", ev.key_label)
		print("  unicode: ", ev.unicode)
		print("  echo: ", ev.echo)
		print("  pressed: ", ev.pressed)
	
	# Test creating an event that matches
	var test_ev = InputEventKey.new()
	test_ev.physical_keycode = KEY_D
	print("test_ev matches action 'move_right' via event.is_action():", test_ev.is_action("move_right"))
	print("test_ev matches action 'move_right' via InputMap:", InputMap.event_is_action(test_ev, "move_right"))
	
	# What about keycode = KEY_D?
	test_ev.keycode = KEY_D
	print("test_ev with keycode=68 matches via is_action():", test_ev.is_action("move_right"))
	print("test_ev with keycode=68 matches via InputMap:", InputMap.event_is_action(test_ev, "move_right"))
	
	# What if we register via InputMap.action_add_event()?
	InputMap.erase_action("test_action")
	InputMap.add_action("test_action")
	var new_ev = InputEventKey.new()
	new_ev.physical_keycode = KEY_D
	InputMap.action_add_event("test_action", new_ev)
	print("new_ev matches test_action via is_action():", new_ev.is_action("test_action"))
	print("new_ev matches test_action via InputMap:", InputMap.event_is_action(new_ev, "test_action"))
	
	# Now test parse_input_event
	new_ev.pressed = true
	Input.parse_input_event(new_ev)
	print("Input.is_action_pressed('test_action'):", Input.is_action_pressed("test_action"))
	
	quit()
