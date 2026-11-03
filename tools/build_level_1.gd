@tool
extends SceneTree

func _init() -> void:
	print("Building level_1.tscn with Godot engine...")
	var root = Node2D.new()
	root.name = "Level1"
	var level_script = load("res://scenes/levels/level_1.gd")
	root.set_script(level_script)
	
	# Preload scenes
	var parallax_sc = load("res://scenes/levels/parallax_background.tscn")
	var player_sc = load("res://scenes/player/player.tscn")
	var ground_sc = load("res://scenes/objects/ground_platform.tscn")
	var ice_sc = load("res://scenes/objects/ice_platform.tscn")
	var moving_sc = load("res://scenes/objects/moving_platform.tscn")
	var crystal_sc = load("res://scenes/objects/crystal.tscn")
	var enemy_sc = load("res://scenes/enemies/enemy.tscn")
	var spring_sc = load("res://scenes/objects/spring_mushroom.tscn")
	var checkpoint_sc = load("res://scenes/objects/checkpoint.tscn")
	var spikes_sc = load("res://scenes/objects/spikes.tscn")
	var portal_sc = load("res://scenes/objects/portal.tscn")
	var hud_sc = load("res://scenes/ui/hud.tscn")
	var pause_sc = load("res://scenes/ui/pause_menu.tscn")
	var gover_sc = load("res://scenes/ui/game_over_menu.tscn")
	var vic_sc = load("res://scenes/ui/victory_menu.tscn")
	
	# 1. Parallax
	var bg = parallax_sc.instantiate()
	root.add_child(bg)
	bg.owner = root
	
	# Containers
	var platforms_node = Node2D.new()
	platforms_node.name = "Platforms"
	root.add_child(platforms_node)
	platforms_node.owner = root
	
	var hazards_node = Node2D.new()
	hazards_node.name = "Hazards"
	root.add_child(hazards_node)
	hazards_node.owner = root
	
	var collectibles_node = Node2D.new()
	collectibles_node.name = "Collectibles"
	root.add_child(collectibles_node)
	collectibles_node.owner = root
	
	var enemies_node = Node2D.new()
	enemies_node.name = "Enemies"
	root.add_child(enemies_node)
	enemies_node.owner = root
	
	var objects_node = Node2D.new()
	objects_node.name = "InteractiveObjects"
	root.add_child(objects_node)
	objects_node.owner = root
	
	# Helper: add ground platform
	var add_ground = func(pos: Vector2, sz: Vector2):
		var p = ground_sc.instantiate()
		p.position = pos
		p.set("platform_size", sz)
		platforms_node.add_child(p)
		p.owner = root
		return p

	# Helper: add ice platform
	var add_ice = func(pos: Vector2):
		var p = ice_sc.instantiate()
		p.position = pos
		platforms_node.add_child(p)
		p.owner = root
		return p

	# Helper: add moving platform
	var add_moving = func(pos: Vector2, offset: Vector2, dur: float):
		var p = moving_sc.instantiate()
		p.position = pos
		p.set("move_offset", offset)
		p.set("duration", dur)
		platforms_node.add_child(p)
		p.owner = root
		return p

	# Helper: add crystal
	var add_crystal = func(pos: Vector2):
		var c = crystal_sc.instantiate()
		c.position = pos
		collectibles_node.add_child(c)
		c.owner = root
		return c

	# Helper: add enemy
	var add_enemy = func(pos: Vector2, dist: float):
		var e = enemy_sc.instantiate()
		e.position = pos
		e.set("patrol_distance", dist)
		enemies_node.add_child(e)
		e.owner = root
		return e

	# Helper: add spikes
	var add_spikes = func(pos: Vector2):
		var s = spikes_sc.instantiate()
		s.position = pos
		hazards_node.add_child(s)
		s.owner = root
		return s

	# ==========================================
	# SECTION 0: SPAWN AREA (x: 0 .. 450)
	# ==========================================
	add_ground.call(Vector2(200, 560), Vector2(460, 64))
	# Tutorial crystals
	add_crystal.call(Vector2(180, 480))
	add_crystal.call(Vector2(260, 450))
	add_crystal.call(Vector2(340, 480))
	
	# ==========================================
	# SECTION 1: FLOATING ICE STEPS (x: 450 .. 1100)
	# ==========================================
	# Lower hazard pit
	add_spikes.call(Vector2(550, 600))
	add_spikes.call(Vector2(650, 600))
	add_spikes.call(Vector2(750, 600))
	add_spikes.call(Vector2(850, 600))
	
	# Floating steps
	add_ice.call(Vector2(540, 490))
	add_crystal.call(Vector2(540, 430))
	
	add_ice.call(Vector2(710, 430))
	add_crystal.call(Vector2(710, 370))
	
	add_ice.call(Vector2(880, 370))
	add_crystal.call(Vector2(880, 310))
	
	add_ground.call(Vector2(1060, 330), Vector2(180, 64))
	add_crystal.call(Vector2(1060, 260))
	
	# ==========================================
	# SECTION 2: SLIME VALLEY (x: 1150 .. 1900)
	# ==========================================
	add_ground.call(Vector2(1520, 540), Vector2(740, 64))
	# Patrol Slimes
	add_enemy.call(Vector2(1380, 490), 120.0)
	add_enemy.call(Vector2(1680, 490), 140.0)
	
	# Crystals to collect
	add_crystal.call(Vector2(1300, 470))
	add_crystal.call(Vector2(1450, 440))
	add_crystal.call(Vector2(1600, 440))
	add_crystal.call(Vector2(1750, 470))
	
	# ==========================================
	# SECTION 3: CHECKPOINT 1 & BOUNCY SPRING (x: 1900 .. 2500)
	# ==========================================
	add_ground.call(Vector2(2150, 540), Vector2(400, 64))
	
	# Checkpoint 1
	var cp1 = checkpoint_sc.instantiate()
	cp1.position = Vector2(2020, 476)
	objects_node.add_child(cp1)
	cp1.owner = root
	
	# Spring Pad
	var spring1 = spring_sc.instantiate()
	spring1.position = Vector2(2260, 492)
	objects_node.add_child(spring1)
	spring1.owner = root
	
	# High Cloud path (reached via spring bounce!)
	add_ice.call(Vector2(2260, 160))
	add_crystal.call(Vector2(2260, 90))
	
	add_ice.call(Vector2(2420, 130))
	add_crystal.call(Vector2(2420, 60))
	
	add_ice.call(Vector2(2580, 160))
	add_crystal.call(Vector2(2580, 90))
	
	# Lower transition crystals
	add_crystal.call(Vector2(2400, 470))
	
	# ==========================================
	# SECTION 4: MOVING RUNES & SPIKE PIT (x: 2500 .. 3450)
	# ==========================================
	# Lower spike pit
	for sx in range(2650, 3350, 60):
		add_spikes.call(Vector2(sx, 610))
		
	# Moving rune platforms
	add_moving.call(Vector2(2700, 440), Vector2(180, 0), 2.8)
	add_crystal.call(Vector2(2700, 370))
	add_crystal.call(Vector2(2880, 370))
	
	# Mid resting ledge
	add_ground.call(Vector2(3040, 410), Vector2(160, 64))
	add_enemy.call(Vector2(3040, 360), 60.0)
	add_crystal.call(Vector2(3040, 320))
	
	add_moving.call(Vector2(3220, 380), Vector2(180, 0), 2.5)
	add_crystal.call(Vector2(3310, 310))
	
	# ==========================================
	# SECTION 5: CHECKPOINT 2 & SUMMIT ASCENT (x: 3450 .. 4200)
	# ==========================================
	add_ground.call(Vector2(3600, 460), Vector2(340, 64))
	
	# Checkpoint 2
	var cp2 = checkpoint_sc.instantiate()
	cp2.position = Vector2(3520, 396)
	objects_node.add_child(cp2)
	cp2.owner = root
	
	# Spring Pad 2 for vertical ascent
	var spring2 = spring_sc.instantiate()
	spring2.position = Vector2(3700, 412)
	objects_node.add_child(spring2)
	spring2.owner = root
	
	# Ascending steps
	add_ice.call(Vector2(3720, 240))
	add_crystal.call(Vector2(3720, 170))
	
	add_ice.call(Vector2(3880, 140))
	add_crystal.call(Vector2(3880, 70))
	
	# Vertical moving platform
	add_moving.call(Vector2(4040, 60), Vector2(0, -120), 2.4)
	add_crystal.call(Vector2(4040, -10))
	add_crystal.call(Vector2(4040, -130))
	
	# ==========================================
	# SECTION 6: THE LINAVERSE SUMMIT & PORTAL (x: 4200 .. 4800)
	# ==========================================
	add_ground.call(Vector2(4460, -20), Vector2(520, 64))
	
	# Final crown crystals
	add_crystal.call(Vector2(4340, -90))
	add_crystal.call(Vector2(4460, -120))
	add_crystal.call(Vector2(4580, -90))
	
	# Portal Gateway
	var portal = portal_sc.instantiate()
	portal.position = Vector2(4620, -78)
	objects_node.add_child(portal)
	portal.owner = root
	
	# ==========================================
	# PLAYER & UI
	# ==========================================
	var player = player_sc.instantiate()
	player.position = Vector2(100, 460)
	root.add_child(player)
	player.owner = root
	
	var hud = hud_sc.instantiate()
	root.add_child(hud)
	hud.owner = root
	
	var pause_menu = pause_sc.instantiate()
	root.add_child(pause_menu)
	pause_menu.owner = root
	
	var game_over = gover_sc.instantiate()
	root.add_child(game_over)
	game_over.owner = root
	
	var victory = vic_sc.instantiate()
	root.add_child(victory)
	victory.owner = root
	
	var packed_scene = PackedScene.new()
	var err = packed_scene.pack(root)
	if err == OK:
		err = ResourceSaver.save(packed_scene, "res://scenes/levels/level_1.tscn")
		if err == OK:
			print("SUCCESS: level_1.tscn created and saved successfully!")
		else:
			print("ERROR saving level_1.tscn: ", err)
	else:
		print("ERROR packing level_1: ", err)
	quit()
