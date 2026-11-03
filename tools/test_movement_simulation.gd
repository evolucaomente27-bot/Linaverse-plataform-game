extends SceneTree

var frames = 0
var level: Node = null
var player: CharacterBody2D = null

func _init() -> void:
	print("--- TESTING PLAYER MOVEMENT SIMULATION ---")
	var level_sc = load("res://scenes/levels/level_1.tscn")
	level = level_sc.instantiate()
	get_root().add_child(level)
	player = level.get_node("Player") as CharacterBody2D
	process_frame.connect(_on_process_frame)

func _on_process_frame() -> void:
	frames += 1
	
	if frames == 5:
		print("Frame 5: Initial Player pos:", player.global_position, " on floor:", player.is_on_floor())
		# Simulate pressing move_right
		Input.action_press("move_right")
	
	if frames == 20:
		print("Frame 20: Player pos after move_right:", player.global_position, " vel.x:", player.velocity.x)
		if player.velocity.x > 50.0:
			print(" [SUCCESS] Player is moving RIGHT! Velocity:", player.velocity.x)
		else:
			print(" [FAIL] Player did not move right! Velocity:", player.velocity.x)
		Input.action_release("move_right")
		
		# Simulate pressing jump
		Input.action_press("jump")
	
	if frames == 25:
		print("Frame 25: Player pos after jump:", player.global_position, " vel.y:", player.velocity.y)
		if player.velocity.y < -200.0:
			print(" [SUCCESS] Player is JUMPING! Velocity:", player.velocity.y)
		else:
			print(" [FAIL] Player did not jump! Velocity:", player.velocity.y)
		Input.action_release("jump")
		quit()
