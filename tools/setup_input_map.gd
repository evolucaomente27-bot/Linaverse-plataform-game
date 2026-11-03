@tool
extends SceneTree

func _init() -> void:
	print("Configuring input actions in ProjectSettings with device = -1 and Joypad support...")
	
	var actions = {
		"move_left": [
			{"type": "key", "keycode": KEY_A, "physical_keycode": KEY_A},
			{"type": "key", "keycode": KEY_LEFT, "physical_keycode": KEY_LEFT},
			{"type": "joy_button", "button_index": JOY_BUTTON_DPAD_LEFT},
			{"type": "joy_axis", "axis": JOY_AXIS_LEFT_X, "axis_value": -1.0}
		],
		"move_right": [
			{"type": "key", "keycode": KEY_D, "physical_keycode": KEY_D},
			{"type": "key", "keycode": KEY_RIGHT, "physical_keycode": KEY_RIGHT},
			{"type": "joy_button", "button_index": JOY_BUTTON_DPAD_RIGHT},
			{"type": "joy_axis", "axis": JOY_AXIS_LEFT_X, "axis_value": 1.0}
		],
		"jump": [
			{"type": "key", "keycode": KEY_SPACE, "physical_keycode": KEY_SPACE},
			{"type": "key", "keycode": KEY_W, "physical_keycode": KEY_W},
			{"type": "key", "keycode": KEY_UP, "physical_keycode": KEY_UP},
			{"type": "joy_button", "button_index": JOY_BUTTON_A},
			{"type": "joy_button", "button_index": JOY_BUTTON_Y},
			{"type": "joy_button", "button_index": JOY_BUTTON_DPAD_UP}
		],
		"run": [
			{"type": "key", "keycode": KEY_SHIFT, "physical_keycode": KEY_SHIFT},
			{"type": "joy_button", "button_index": JOY_BUTTON_B},
			{"type": "joy_button", "button_index": JOY_BUTTON_RIGHT_SHOULDER}
		],
		"pause": [
			{"type": "key", "keycode": KEY_ESCAPE, "physical_keycode": KEY_ESCAPE},
			{"type": "key", "keycode": KEY_P, "physical_keycode": KEY_P},
			{"type": "joy_button", "button_index": JOY_BUTTON_START}
		],
		"restart": [
			{"type": "key", "keycode": KEY_R, "physical_keycode": KEY_R},
			{"type": "joy_button", "button_index": JOY_BUTTON_BACK}
		]
	}
	
	for action_name in actions.keys():
		var events_data = actions[action_name]
		var events_array: Array = []
		for item in events_data:
			if item["type"] == "key":
				# Keycode event
				var ev_key = InputEventKey.new()
				ev_key.device = -1
				ev_key.keycode = item.get("keycode", KEY_NONE)
				ev_key.physical_keycode = 0
				events_array.append(ev_key)
				
				# Physical keycode event
				var ev_phys = InputEventKey.new()
				ev_phys.device = -1
				ev_phys.keycode = 0
				ev_phys.physical_keycode = item.get("physical_keycode", KEY_NONE)
				events_array.append(ev_phys)
			elif item["type"] == "joy_button":
				var ev_btn = InputEventJoypadButton.new()
				ev_btn.device = -1
				ev_btn.button_index = item["button_index"]
				events_array.append(ev_btn)
			elif item["type"] == "joy_axis":
				var ev_axis = InputEventJoypadMotion.new()
				ev_axis.device = -1
				ev_axis.axis = item["axis"]
				ev_axis.axis_value = item["axis_value"]
				events_array.append(ev_axis)
		
		var setting_name = "input/" + action_name
		var action_dict = {
			"deadzone": 0.5,
			"events": events_array
		}
		ProjectSettings.set_setting(setting_name, action_dict)
		print("Configured action: ", action_name, " with ", len(events_array), " events")
	
	var err = ProjectSettings.save()
	if err == OK:
		print("SUCCESS: project.godot input settings saved successfully with device = -1!")
	else:
		print("ERROR saving project.godot: ", err)
	quit()
