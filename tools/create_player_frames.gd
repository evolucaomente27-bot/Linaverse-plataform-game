@tool
extends SceneTree

func _init() -> void:
	print("Creating player SpriteFrames resource...")
	var sf = SpriteFrames.new()
	sf.remove_animation("default")
	
	# IDLE (6 frames)
	var idle_tex = load("res://assets/sprites/player/lina_idle.png")
	sf.add_animation("idle")
	sf.set_animation_speed("idle", 6.0)
	sf.set_animation_loop("idle", true)
	for i in range(6):
		var atlas = AtlasTexture.new()
		atlas.atlas = idle_tex
		atlas.region = Rect2(i * 128, 0, 128, 128)
		sf.add_frame("idle", atlas)
		
	# WALK (8 frames)
	var walk_tex = load("res://assets/sprites/player/lina_walk.png")
	sf.add_animation("walk")
	sf.set_animation_speed("walk", 10.0)
	sf.set_animation_loop("walk", true)
	for i in range(8):
		var atlas = AtlasTexture.new()
		atlas.atlas = walk_tex
		atlas.region = Rect2(i * 128, 0, 128, 128)
		sf.add_frame("walk", atlas)
		
	# RUN (6 frames)
	var run_tex = load("res://assets/sprites/player/lina_run.png")
	sf.add_animation("run")
	sf.set_animation_speed("run", 12.0)
	sf.set_animation_loop("run", true)
	for i in range(6):
		var atlas = AtlasTexture.new()
		atlas.atlas = run_tex
		atlas.region = Rect2(i * 128, 0, 128, 128)
		sf.add_frame("run", atlas)
		
	# JUMP (1 frame)
	var jump_tex = load("res://assets/sprites/player/lina_jump.png")
	sf.add_animation("jump")
	sf.set_animation_speed("jump", 1.0)
	sf.set_animation_loop("jump", false)
	var jump_atlas = AtlasTexture.new()
	jump_atlas.atlas = jump_tex
	jump_atlas.region = Rect2(0, 0, 128, 128)
	sf.add_frame("jump", jump_atlas)
	
	# FALL (1 frame)
	var fall_tex = load("res://assets/sprites/player/lina_fall.png")
	sf.add_animation("fall")
	sf.set_animation_speed("fall", 1.0)
	sf.set_animation_loop("fall", false)
	var fall_atlas = AtlasTexture.new()
	fall_atlas.atlas = fall_tex
	fall_atlas.region = Rect2(0, 0, 128, 128)
	sf.add_frame("fall", fall_atlas)
	
	# HURT (1 frame)
	var hurt_tex = load("res://assets/sprites/player/lina_hurt.png")
	sf.add_animation("hurt")
	sf.set_animation_speed("hurt", 1.0)
	sf.set_animation_loop("hurt", false)
	var hurt_atlas = AtlasTexture.new()
	hurt_atlas.atlas = hurt_tex
	hurt_atlas.region = Rect2(0, 0, 128, 128)
	sf.add_frame("hurt", hurt_atlas)
	
	var err = ResourceSaver.save(sf, "res://scenes/player/player_frames.tres")
	if err == OK:
		print("SUCCESS: player_frames.tres created successfully!")
	else:
		print("ERROR saving player_frames.tres: ", err)
	quit()
