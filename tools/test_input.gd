extends SceneTree

func _init() -> void:
	print("Checking InputMap actions...")
	for action in ["move_left", "move_right", "jump", "run", "pause", "restart", "ui_left", "ui_right"]:
		var has = InputMap.has_action(action)
		var event_count = len(InputMap.action_get_events(action)) if has else 0
		print("Action '", action, "': exists=", has, ", events=", event_count)
		if has:
			for ev in InputMap.action_get_events(action):
				print("  -> ", ev.as_text())
	quit()
