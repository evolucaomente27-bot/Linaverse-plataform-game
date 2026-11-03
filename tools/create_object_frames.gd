@tool
extends SceneTree

func _init() -> void:
	print("Creating object SpriteFrames resources...")
	
	# 1. CRYSTAL
	var crystal_tex = load("res://assets/sprites/collectibles/ice_crystal.png")
	var crystal_sf = SpriteFrames.new()
	crystal_sf.remove_animation("default")
	crystal_sf.add_animation("spin")
	crystal_sf.set_animation_speed("spin", 8.0)
	crystal_sf.set_animation_loop("spin", true)
	for i in range(6):
		var atlas = AtlasTexture.new()
		atlas.atlas = crystal_tex
		atlas.region = Rect2(i * 32, 0, 32, 32)
		crystal_sf.add_frame("spin", atlas)
	ResourceSaver.save(crystal_sf, "res://scenes/objects/crystal_frames.tres")
	
	# 2. SLIME
	var slime_tex = load("res://assets/sprites/enemies/frost_slime.png")
	var slime_sf = SpriteFrames.new()
	slime_sf.remove_animation("default")
	slime_sf.add_animation("walk")
	slime_sf.set_animation_speed("walk", 6.0)
	slime_sf.set_animation_loop("walk", true)
	for i in range(4):
		var atlas = AtlasTexture.new()
		atlas.atlas = slime_tex
		atlas.region = Rect2(i * 48, 0, 48, 48)
		slime_sf.add_frame("walk", atlas)
	ResourceSaver.save(slime_sf, "res://scenes/enemies/slime_frames.tres")
	
	# 3. SPRING PAD
	var spring_tex = load("res://assets/sprites/objects/spring_pad.png")
	var spring_sf = SpriteFrames.new()
	spring_sf.remove_animation("default")
	spring_sf.add_animation("idle")
	spring_sf.set_animation_speed("idle", 1.0)
	spring_sf.set_animation_loop("idle", true)
	var sp_idle = AtlasTexture.new()
	sp_idle.atlas = spring_tex
	sp_idle.region = Rect2(0, 0, 48, 48)
	spring_sf.add_frame("idle", sp_idle)
	
	spring_sf.add_animation("bounce")
	spring_sf.set_animation_speed("bounce", 1.0)
	spring_sf.set_animation_loop("bounce", false)
	var sp_bounce = AtlasTexture.new()
	sp_bounce.atlas = spring_tex
	sp_bounce.region = Rect2(48, 0, 48, 48)
	spring_sf.add_frame("bounce", sp_bounce)
	ResourceSaver.save(spring_sf, "res://scenes/objects/spring_frames.tres")
	
	# 4. CHECKPOINT
	var cp_tex = load("res://assets/sprites/objects/checkpoint_lantern.png")
	var cp_sf = SpriteFrames.new()
	cp_sf.remove_animation("default")
	cp_sf.add_animation("unlit")
	cp_sf.set_animation_speed("unlit", 1.0)
	cp_sf.set_animation_loop("unlit", true)
	var cp_unlit = AtlasTexture.new()
	cp_unlit.atlas = cp_tex
	cp_unlit.region = Rect2(0, 0, 48, 64)
	cp_sf.add_frame("unlit", cp_unlit)
	
	cp_sf.add_animation("lit")
	cp_sf.set_animation_speed("lit", 1.0)
	cp_sf.set_animation_loop("lit", true)
	var cp_lit = AtlasTexture.new()
	cp_lit.atlas = cp_tex
	cp_lit.region = Rect2(48, 0, 48, 64)
	cp_sf.add_frame("lit", cp_lit)
	ResourceSaver.save(cp_sf, "res://scenes/objects/checkpoint_frames.tres")
	
	print("SUCCESS: Object SpriteFrames created successfully!")
	quit()
