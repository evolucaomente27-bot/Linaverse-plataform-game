@tool
extends SceneTree

func _init() -> void:
	print("=== INICIANDO DISTRIBUIÇÃO DE POWER-UPS E NOVAS MECÂNICAS (FASES 1 A 15) ===")
	
	var powerup_sc = load("res://scenes/objects/powerup.tscn")
	var boost_sc = load("res://scenes/objects/boost_pad.tscn")
	var wind_sc = load("res://scenes/objects/wind_current.tscn")
	var crumble_sc = load("res://scenes/objects/crumbling_platform.tscn")
	var wall_sc = load("res://scenes/objects/breakable_wall.tscn")
	
	# Especificações de power-ups e mecânicas por fase
	var stage_mechanics = {
		1: {
			"powerups": [
				[Vector2(650, 420), "dash"],
				[Vector2(2260, 320), "magnet"],
				[Vector2(3250, 300), "chrono"],
				[Vector2(4100, 180), "shield"]
			],
			"boosts": [
				[Vector2(1420, 528), 1.0, 96.0]
			],
			"winds": [
				[Vector2(2800, 480), -480.0, Vector2(70, 220)]
			],
			"crumbles": [
				[Vector2(1150, 440), Vector2(100, 24)]
			],
			"walls": [
				[Vector2(3200, 380), Vector2(32, 100)]
			]
		},
		2: {
			"powerups": [
				[Vector2(750, 360), "wings"],
				[Vector2(2000, 280), "dash"],
				[Vector2(3300, 220), "chrono"]
			],
			"boosts": [
				[Vector2(1200, 450), 1.0, 96.0],
				[Vector2(2900, 380), 1.0, 96.0]
			],
			"winds": [
				[Vector2(1750, 500), -520.0, Vector2(80, 240)]
			],
			"crumbles": [
				[Vector2(2450, 410), Vector2(110, 24)],
				[Vector2(2650, 360), Vector2(110, 24)]
			],
			"walls": [
				[Vector2(3600, 340), Vector2(36, 110)]
			]
		},
		3: {
			"powerups": [
				[Vector2(600, 420), "magnet"],
				[Vector2(1700, 260), "shield"],
				[Vector2(3400, 200), "chrono"]
			],
			"boosts": [
				[Vector2(2100, 460), 1.0, 96.0]
			],
			"winds": [
				[Vector2(1300, 520), -540.0, Vector2(80, 260)],
				[Vector2(3000, 480), -500.0, Vector2(70, 220)]
			],
			"crumbles": [
				[Vector2(1850, 380), Vector2(100, 24)],
				[Vector2(2750, 360), Vector2(100, 24)]
			],
			"walls": [
				[Vector2(2350, 370), Vector2(32, 100)]
			]
		},
		4: {
			"powerups": [
				[Vector2(680, 380), "dash"],
				[Vector2(1950, 240), "wings"],
				[Vector2(3600, 180), "chrono"]
			],
			"boosts": [
				[Vector2(1400, 420), 1.0, 96.0],
				[Vector2(2850, 360), 1.0, 96.0]
			],
			"winds": [
				[Vector2(2200, 460), -550.0, Vector2(80, 250)]
			],
			"crumbles": [
				[Vector2(1050, 420), Vector2(110, 24)],
				[Vector2(3200, 320), Vector2(110, 24)]
			],
			"walls": [
				[Vector2(2700, 330), Vector2(36, 110)]
			]
		},
		5: {
			"powerups": [
				[Vector2(850, 360), "shield"],
				[Vector2(2100, 260), "dash"],
				[Vector2(3500, 190), "chrono"]
			],
			"boosts": [
				[Vector2(1350, 440), 1.0, 96.0],
				[Vector2(3000, 360), 1.0, 96.0]
			],
			"winds": [
				[Vector2(1650, 480), -560.0, Vector2(80, 260)]
			],
			"crumbles": [
				[Vector2(2450, 370), Vector2(120, 24)],
				[Vector2(3700, 250), Vector2(120, 24)]
			],
			"walls": [
				[Vector2(3300, 290), Vector2(36, 120)]
			]
		},
		6: {
			"powerups": [
				[Vector2(620, 380), "dash"],
				[Vector2(1850, 160), "wings"],
				[Vector2(3650, 120), "chrono"]
			],
			"boosts": [
				[Vector2(950, 450), 1.0, 96.0]
			],
			"winds": [
				[Vector2(2400, 520), -500.0, Vector2(80, 240)]
			],
			"crumbles": [
				[Vector2(1500, 380), Vector2(110, 24)],
				[Vector2(2850, 340), Vector2(110, 24)]
			],
			"walls": [
				[Vector2(3100, 420), Vector2(32, 100)]
			]
		},
		7: {
			"powerups": [
				[Vector2(700, 340), "magnet"],
				[Vector2(2300, 320), "shield"],
				[Vector2(3850, 130), "chrono"]
			],
			"boosts": [
				[Vector2(1050, 500), 1.0, 96.0],
				[Vector2(3300, 440), 1.0, 96.0]
			],
			"winds": [
				[Vector2(1950, 480), -520.0, Vector2(80, 240)]
			],
			"crumbles": [
				[Vector2(2600, 360), Vector2(110, 24)]
			],
			"walls": [
				[Vector2(3500, 380), Vector2(36, 110)]
			]
		},
		8: {
			"powerups": [
				[Vector2(750, 340), "dash"],
				[Vector2(2200, 260), "wings"],
				[Vector2(3950, 140), "chrono"]
			],
			"boosts": [
				[Vector2(1250, 460), 1.0, 96.0]
			],
			"winds": [
				[Vector2(1800, 500), -540.0, Vector2(80, 250)]
			],
			"crumbles": [
				[Vector2(2750, 360), Vector2(110, 24)],
				[Vector2(3450, 320), Vector2(110, 24)]
			],
			"walls": [
				[Vector2(3000, 380), Vector2(32, 100)]
			]
		},
		9: {
			"powerups": [
				[Vector2(650, 360), "shield"],
				[Vector2(2100, 300), "magnet"],
				[Vector2(3650, 160), "chrono"]
			],
			"boosts": [
				[Vector2(950, 480), 1.0, 96.0],
				[Vector2(2850, 420), 1.0, 96.0]
			],
			"winds": [
				[Vector2(1600, 490), -530.0, Vector2(80, 240)]
			],
			"crumbles": [
				[Vector2(2400, 380), Vector2(110, 24)]
			],
			"walls": [
				[Vector2(3200, 360), Vector2(36, 110)]
			]
		},
		10: {
			"powerups": [
				[Vector2(750, 360), "dash"],
				[Vector2(2250, 250), "wings"],
				[Vector2(4000, 160), "chrono"]
			],
			"boosts": [
				[Vector2(1150, 460), 1.0, 96.0],
				[Vector2(3100, 400), 1.0, 96.0]
			],
			"winds": [
				[Vector2(1850, 480), -550.0, Vector2(80, 260)]
			],
			"crumbles": [
				[Vector2(2650, 360), Vector2(110, 24)],
				[Vector2(3500, 300), Vector2(110, 24)]
			],
			"walls": [
				[Vector2(2850, 360), Vector2(36, 110)]
			]
		},
		11: {
			"powerups": [
				[Vector2(800, 350), "magnet"],
				[Vector2(2300, 260), "shield"],
				[Vector2(4100, 140), "chrono"]
			],
			"boosts": [
				[Vector2(1300, 450), 1.0, 96.0]
			],
			"winds": [
				[Vector2(1900, 500), -560.0, Vector2(80, 260)],
				[Vector2(3400, 460), -520.0, Vector2(80, 240)]
			],
			"crumbles": [
				[Vector2(2800, 350), Vector2(110, 24)]
			],
			"walls": [
				[Vector2(3100, 360), Vector2(32, 100)]
			]
		},
		12: {
			"powerups": [
				[Vector2(700, 380), "dash"],
				[Vector2(2150, 280), "wings"],
				[Vector2(3800, 170), "chrono"]
			],
			"boosts": [
				[Vector2(1000, 480), 1.0, 96.0],
				[Vector2(2950, 420), 1.0, 96.0]
			],
			"winds": [
				[Vector2(1700, 490), -520.0, Vector2(80, 240)]
			],
			"crumbles": [
				[Vector2(2500, 370), Vector2(110, 24)],
				[Vector2(3400, 310), Vector2(110, 24)]
			],
			"walls": [
				[Vector2(3150, 370), Vector2(36, 110)]
			]
		},
		13: {
			"powerups": [
				[Vector2(850, 360), "shield"],
				[Vector2(2400, 270), "dash"],
				[Vector2(4200, 150), "chrono"]
			],
			"boosts": [
				[Vector2(1200, 480), 1.0, 96.0],
				[Vector2(3200, 420), 1.0, 96.0]
			],
			"winds": [
				[Vector2(1950, 510), -550.0, Vector2(80, 260)]
			],
			"crumbles": [
				[Vector2(2750, 370), Vector2(120, 24)],
				[Vector2(3700, 300), Vector2(120, 24)]
			],
			"walls": [
				[Vector2(3450, 370), Vector2(36, 120)]
			]
		},
		14: {
			"powerups": [
				[Vector2(700, 380), "dash"],
				[Vector2(2000, 290), "magnet"],
				[Vector2(3700, 180), "chrono"]
			],
			"boosts": [
				[Vector2(900, 480), 1.0, 96.0],
				[Vector2(2700, 420), 1.0, 96.0]
			],
			"winds": [
				[Vector2(1600, 490), -540.0, Vector2(80, 250)]
			],
			"crumbles": [
				[Vector2(2300, 380), Vector2(110, 24)]
			],
			"walls": [
				[Vector2(3000, 360), Vector2(32, 100)]
			]
		},
		15: {
			"powerups": [
				[Vector2(750, 360), "wings"],
				[Vector2(1600, 280), "dash"],
				[Vector2(2500, 260), "shield"],
				[Vector2(3400, 220), "magnet"],
				[Vector2(4200, 160), "chrono"]
			],
			"boosts": [
				[Vector2(1100, 480), 1.0, 96.0],
				[Vector2(3100, 420), 1.0, 96.0]
			],
			"winds": [
				[Vector2(1900, 520), -560.0, Vector2(80, 260)],
				[Vector2(3750, 480), -540.0, Vector2(80, 250)]
			],
			"crumbles": [
				[Vector2(2300, 370), Vector2(120, 24)],
				[Vector2(2850, 340), Vector2(120, 24)],
				[Vector2(3900, 280), Vector2(120, 24)]
			],
			"walls": [
				[Vector2(3200, 370), Vector2(36, 120)]
			]
		}
	}
	
	for lvl in range(1, 16):
		var scene_path = "res://scenes/levels/level_%d.tscn" % lvl
		var sc = load(scene_path)
		if not sc:
			printerr("Erro ao abrir cena: ", scene_path)
			continue
			
		var root = sc.instantiate()
		
		# Procura ou cria nós organizadores
		var interactive = root.get_node_or_null("InteractiveObjects")
		if not interactive:
			interactive = Node2D.new()
			interactive.name = "InteractiveObjects"
			root.add_child(interactive)
			interactive.owner = root
			
		var mechanics = root.get_node_or_null("Mechanics")
		if mechanics:
			mechanics.free()
			
		mechanics = Node2D.new()
		mechanics.name = "Mechanics"
		root.add_child(mechanics)
		mechanics.owner = root
		
		var cfg = stage_mechanics.get(lvl, {})
		
		# 1. Power-ups
		for p_data in cfg.get("powerups", []):
			var pup = powerup_sc.instantiate()
			pup.position = p_data[0]
			pup.set("powerup_type", p_data[1])
			mechanics.add_child(pup)
			pup.owner = root
			
		# 2. Boost Pads
		for b_data in cfg.get("boosts", []):
			var b = boost_sc.instantiate()
			b.position = b_data[0]
			b.set("boost_direction", b_data[1])
			b.set("pad_width", b_data[2])
			mechanics.add_child(b)
			b.owner = root
			
		# 3. Wind Currents
		for w_data in cfg.get("winds", []):
			var w = wind_sc.instantiate()
			w.position = w_data[0]
			w.set("updraft_force", w_data[1])
			w.set("current_size", w_data[2])
			mechanics.add_child(w)
			w.owner = root
			
		# 4. Crumbling Platforms
		for c_data in cfg.get("crumbles", []):
			var c = crumble_sc.instantiate()
			c.position = c_data[0]
			c.set("platform_size", c_data[1])
			mechanics.add_child(c)
			c.owner = root
			
		# 5. Breakable Walls
		for wl_data in cfg.get("walls", []):
			var wl = wall_sc.instantiate()
			wl.position = wl_data[0]
			wl.set("wall_size", wl_data[1])
			mechanics.add_child(wl)
			wl.owner = root
			
		var packed = PackedScene.new()
		var res = packed.pack(root)
		if res == OK:
			var save_res = ResourceSaver.save(packed, scene_path)
			if save_res == OK:
				print("[OK] Fase %d atualizada com Power-Ups e Mecânicas!" % lvl)
			else:
				printerr("Falha ao salvar fase %d: " % lvl, save_res)
		else:
			printerr("Falha ao empacotar fase %d: " % lvl, res)
			
		root.free()
		
	print("=== TODAS AS 15 FASES FORAM ATUALIZADAS COM SUCESSO! ===")
	quit(0)
