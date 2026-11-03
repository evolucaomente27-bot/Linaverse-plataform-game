@tool
extends SceneTree

func _init() -> void:
	print("=== INICIANDO CONSTRUÇÃO DAS FASES 6 A 15 COM GODOT ENGINE ===")
	
	# Preload base scenes
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
	
	var ground_script = load("res://scenes/objects/ground_platform.gd")
	var moving_script = load("res://scenes/objects/moving_platform.gd")
	
	# Definições específicas de level design speedrun para cada fase (6 a 15)
	var level_configs = {
		6: {
			"name": "Passagem das Estalactites",
			"end_x": 4200,
			"desc": "Descidas rápidas de gelo e cogumelo impulsionador gigante",
			"portal_pos": Vector2(4050, 260),
			"checkpoints": [Vector2(2200, 396)],
			"springs": [Vector2(1400, 480), Vector2(3200, 420)],
			"grounds": [
				[Vector2(200, 560), Vector2(400, 64)],
				[Vector2(1000, 480), Vector2(300, 64)],
				[Vector2(2200, 460), Vector2(320, 64)],
				[Vector2(3200, 490), Vector2(280, 64)],
				[Vector2(4050, 340), Vector2(420, 64)]
			],
			"ices": [
				Vector2(480, 510), Vector2(620, 450), Vector2(760, 400),
				Vector2(1650, 280), Vector2(1850, 220),
				Vector2(2550, 410), Vector2(2750, 360), Vector2(2950, 310),
				Vector2(3450, 240), Vector2(3650, 180), Vector2(3850, 240)
			],
			"movings": [
				[Vector2(1250, 420), Vector2(120, 0), 2.0],
				[Vector2(2050, 340), Vector2(0, -90), 2.2]
			],
			"spikes": [
				Vector2(600, 600), Vector2(700, 600), Vector2(1400, 600),
				Vector2(1500, 600), Vector2(1600, 600), Vector2(2650, 580)
			],
			"enemies": [
				[Vector2(1000, 440), 60.0],
				[Vector2(2250, 420), 50.0]
			]
		},
		7: {
			"name": "Ruínas Rúnicas",
			"end_x": 4400,
			"desc": "Plataformas móveis sincronizadas sobre abismo gélido",
			"portal_pos": Vector2(4250, 180),
			"checkpoints": [Vector2(2150, 376)],
			"springs": [Vector2(1100, 460), Vector2(3350, 400)],
			"grounds": [
				[Vector2(200, 560), Vector2(420, 64)],
				[Vector2(1100, 530), Vector2(240, 64)],
				[Vector2(2150, 440), Vector2(300, 64)],
				[Vector2(3350, 470), Vector2(260, 64)],
				[Vector2(4250, 260), Vector2(440, 64)]
			],
			"ices": [
				Vector2(500, 480), Vector2(660, 420), Vector2(820, 360),
				Vector2(1400, 260), Vector2(1600, 210), Vector2(1800, 260),
				Vector2(2500, 380), Vector2(2700, 330), Vector2(2900, 280),
				Vector2(3650, 240), Vector2(3850, 190), Vector2(4050, 150)
			],
			"movings": [
				[Vector2(950, 340), Vector2(160, 0), 1.8],
				[Vector2(1950, 310), Vector2(150, 0), 1.9],
				[Vector2(3100, 300), Vector2(0, -110), 2.1]
			],
			"spikes": [
				Vector2(650, 600), Vector2(750, 600), Vector2(1500, 580),
				Vector2(1600, 580), Vector2(2600, 590), Vector2(2700, 590)
			],
			"enemies": [
				[Vector2(2150, 400), 55.0]
			]
		},
		8: {
			"name": "Abismo dos Ventos Cósmicos",
			"end_x": 4500,
			"desc": "Cadeia de cogumelos elásticos e saltos aéreos estelares",
			"portal_pos": Vector2(4350, 120),
			"checkpoints": [Vector2(2300, 356)],
			"springs": [
				Vector2(850, 480),
				Vector2(1550, 420),
				Vector2(2250, 420),
				Vector2(3350, 340)
			],
			"grounds": [
				[Vector2(200, 560), Vector2(400, 64)],
				[Vector2(850, 550), Vector2(220, 64)],
				[Vector2(1550, 490), Vector2(220, 64)],
				[Vector2(2300, 420), Vector2(340, 64)],
				[Vector2(3350, 410), Vector2(240, 64)],
				[Vector2(4350, 200), Vector2(450, 64)]
			],
			"ices": [
				Vector2(480, 500), Vector2(650, 440),
				Vector2(1150, 240), Vector2(1320, 190),
				Vector2(1850, 220), Vector2(2020, 270),
				Vector2(2750, 360), Vector2(2950, 310), Vector2(3150, 260),
				Vector2(3700, 180), Vector2(3900, 130), Vector2(4100, 90)
			],
			"movings": [
				[Vector2(2550, 370), Vector2(130, 0), 2.0]
			],
			"spikes": [
				Vector2(550, 600), Vector2(1000, 600), Vector2(1700, 600),
				Vector2(2450, 600), Vector2(3500, 600)
			],
			"enemies": [
				[Vector2(2350, 380), 60.0]
			]
		},
		9: {
			"name": "Trilha dos Portais Ocultos",
			"end_x": 4300,
			"desc": "Degraus estreitos shinobi e rotas aéreas de precisão",
			"portal_pos": Vector2(4150, 140),
			"checkpoints": [Vector2(2100, 336)],
			"springs": [Vector2(1200, 440), Vector2(3100, 380)],
			"grounds": [
				[Vector2(200, 560), Vector2(400, 64)],
				[Vector2(1200, 510), Vector2(220, 64)],
				[Vector2(2100, 400), Vector2(300, 64)],
				[Vector2(3100, 450), Vector2(220, 64)],
				[Vector2(4150, 220), Vector2(420, 64)]
			],
			"ices": [
				Vector2(460, 490), Vector2(600, 430), Vector2(740, 380), Vector2(880, 330),
				Vector2(1450, 250), Vector2(1620, 210), Vector2(1790, 250),
				Vector2(2450, 350), Vector2(2620, 300), Vector2(2790, 260),
				Vector2(3400, 220), Vector2(3600, 180), Vector2(3800, 150)
			],
			"movings": [
				[Vector2(1030, 320), Vector2(0, -90), 1.9],
				[Vector2(1950, 290), Vector2(110, 0), 1.8],
				[Vector2(2950, 250), Vector2(120, 0), 1.7]
			],
			"spikes": [
				Vector2(650, 600), Vector2(1350, 600), Vector2(2250, 580),
				Vector2(3250, 580)
			],
			"enemies": [
				[Vector2(2100, 360), 50.0]
			]
		},
		10: {
			"name": "Geleira do Trovão",
			"end_x": 4600,
			"desc": "Pistas contínuas de gelo rápido e saltos com inércia total",
			"portal_pos": Vector2(4450, 160),
			"checkpoints": [Vector2(2350, 376)],
			"springs": [Vector2(1350, 440), Vector2(3450, 360)],
			"grounds": [
				[Vector2(200, 560), Vector2(420, 64)],
				[Vector2(1350, 510), Vector2(260, 64)],
				[Vector2(2350, 440), Vector2(320, 64)],
				[Vector2(3450, 430), Vector2(260, 64)],
				[Vector2(4450, 240), Vector2(440, 64)]
			],
			"ices": [
				Vector2(480, 500), Vector2(660, 450), Vector2(840, 400), Vector2(1020, 360),
				Vector2(1650, 270), Vector2(1850, 220), Vector2(2050, 270),
				Vector2(2700, 390), Vector2(2880, 340), Vector2(3060, 290),
				Vector2(3750, 220), Vector2(3950, 180), Vector2(4150, 150)
			],
			"movings": [
				[Vector2(1200, 350), Vector2(120, 0), 1.8],
				[Vector2(2200, 320), Vector2(0, -90), 2.0],
				[Vector2(3260, 280), Vector2(140, 0), 1.9]
			],
			"spikes": [
				Vector2(700, 600), Vector2(800, 600), Vector2(1500, 600),
				Vector2(2500, 600), Vector2(3600, 600)
			],
			"enemies": [
				[Vector2(2350, 400), 65.0]
			]
		},
		11: {
			"name": "Santuário das Constelações",
			"end_x": 4500,
			"desc": "Elevadores cósmicos verticais e saltos na alta atmosfera",
			"portal_pos": Vector2(4350, 60),
			"checkpoints": [Vector2(2250, 336)],
			"springs": [Vector2(1100, 440), Vector2(3200, 360)],
			"grounds": [
				[Vector2(200, 560), Vector2(400, 64)],
				[Vector2(1100, 510), Vector2(240, 64)],
				[Vector2(2250, 400), Vector2(300, 64)],
				[Vector2(3200, 430), Vector2(240, 64)],
				[Vector2(4350, 140), Vector2(420, 64)]
			],
			"ices": [
				Vector2(460, 490), Vector2(620, 440), Vector2(780, 390),
				Vector2(1400, 240), Vector2(1600, 180), Vector2(1800, 140),
				Vector2(2550, 360), Vector2(2750, 300), Vector2(2950, 240),
				Vector2(3500, 180), Vector2(3700, 120), Vector2(3950, 80)
			],
			"movings": [
				[Vector2(940, 350), Vector2(0, -120), 2.2],
				[Vector2(2020, 200), Vector2(0, -130), 2.4],
				[Vector2(3080, 260), Vector2(120, 0), 1.9],
				[Vector2(4150, 100), Vector2(0, -90), 2.0]
			],
			"spikes": [
				Vector2(600, 600), Vector2(1250, 600), Vector2(2400, 600),
				Vector2(3350, 600)
			],
			"enemies": [
				[Vector2(2250, 360), 55.0]
			]
		},
		12: {
			"name": "Canyon da Meia-Noite",
			"end_x": 4600,
			"desc": "Rota dupla: Rota Alta perigosa veloz vs Rota Baixa segura",
			"portal_pos": Vector2(4450, 120),
			"checkpoints": [Vector2(2300, 356)],
			"springs": [Vector2(950, 460), Vector2(3100, 380)],
			"grounds": [
				[Vector2(200, 560), Vector2(400, 64)],
				[Vector2(950, 530), Vector2(220, 64)],
				[Vector2(2300, 420), Vector2(340, 64)],
				[Vector2(3100, 450), Vector2(220, 64)],
				[Vector2(4450, 200), Vector2(440, 64)]
			],
			"ices": [
				# Rota Alta (Speedrun)
				Vector2(480, 450), Vector2(640, 370), Vector2(800, 290),
				Vector2(1250, 180), Vector2(1450, 120), Vector2(1650, 180),
				Vector2(2550, 260), Vector2(2750, 190), Vector2(2950, 250),
				Vector2(3450, 160), Vector2(3700, 110), Vector2(3950, 80), Vector2(4200, 100)
			],
			"movings": [
				[Vector2(1100, 360), Vector2(130, 0), 1.9],
				[Vector2(1950, 300), Vector2(0, -90), 2.1]
			],
			"spikes": [
				Vector2(550, 600), Vector2(1300, 600), Vector2(2000, 600),
				Vector2(2700, 600), Vector2(3600, 600)
			],
			"enemies": [
				[Vector2(2300, 380), 60.0]
			]
		},
		13: {
			"name": "Torres da Nevasca Real",
			"end_x": 4700,
			"desc": "Escalada acelerada entre quatro torres do palácio real",
			"portal_pos": Vector2(4550, 80),
			"checkpoints": [Vector2(2450, 316)],
			"springs": [Vector2(1200, 420), Vector2(2350, 380), Vector2(3400, 280)],
			"grounds": [
				[Vector2(200, 560), Vector2(400, 64)],
				[Vector2(1200, 490), Vector2(240, 64)],
				[Vector2(2450, 380), Vector2(300, 64)],
				[Vector2(3400, 350), Vector2(240, 64)],
				[Vector2(4550, 160), Vector2(440, 64)]
			],
			"ices": [
				Vector2(480, 500), Vector2(660, 440), Vector2(840, 380), Vector2(1020, 320),
				Vector2(1500, 260), Vector2(1700, 210), Vector2(1900, 250),
				Vector2(2650, 320), Vector2(2850, 260), Vector2(3050, 200),
				Vector2(3750, 160), Vector2(3950, 110), Vector2(4150, 70), Vector2(4350, 90)
			],
			"movings": [
				[Vector2(2150, 280), Vector2(120, 0), 1.9],
				[Vector2(3250, 240), Vector2(0, -90), 2.0]
			],
			"spikes": [
				Vector2(650, 600), Vector2(1400, 600), Vector2(2200, 600),
				Vector2(3200, 600), Vector2(4200, 600)
			],
			"enemies": [
				[Vector2(2450, 340), 55.0]
			]
		},
		14: {
			"name": "Corredor Dimensional",
			"end_x": 4800,
			"desc": "Corredor supersônico com saltos em cadeia ininterruptos",
			"portal_pos": Vector2(4650, 120),
			"checkpoints": [Vector2(2400, 336)],
			"springs": [
				Vector2(900, 460),
				Vector2(1700, 380),
				Vector2(2600, 360),
				Vector2(3600, 280)
			],
			"grounds": [
				[Vector2(200, 560), Vector2(400, 64)],
				[Vector2(900, 530), Vector2(220, 64)],
				[Vector2(1700, 450), Vector2(220, 64)],
				[Vector2(2400, 400), Vector2(320, 64)],
				[Vector2(3600, 350), Vector2(240, 64)],
				[Vector2(4650, 200), Vector2(450, 64)]
			],
			"ices": [
				Vector2(480, 490), Vector2(650, 430),
				Vector2(1250, 260), Vector2(1450, 210),
				Vector2(2050, 240), Vector2(2250, 280),
				Vector2(2950, 280), Vector2(3150, 220), Vector2(3350, 170),
				Vector2(3950, 160), Vector2(4150, 110), Vector2(4350, 80)
			],
			"movings": [
				[Vector2(1100, 340), Vector2(140, 0), 1.8],
				[Vector2(2750, 280), Vector2(130, 0), 1.8],
				[Vector2(4480, 140), Vector2(0, -90), 2.0]
			],
			"spikes": [
				Vector2(600, 600), Vector2(1300, 600), Vector2(2000, 600),
				Vector2(2800, 600), Vector2(3800, 600)
			],
			"enemies": [
				[Vector2(2400, 360), 60.0]
			]
		},
		15: {
			"name": "Coração do Linaverse",
			"end_x": 5200,
			"desc": "O Grande Desafio Final que reúne todas as dimensões do Multiverso!",
			"portal_pos": Vector2(5050, 60),
			"checkpoints": [Vector2(1900, 356), Vector2(3600, 276)],
			"springs": [
				Vector2(1100, 460),
				Vector2(2300, 380),
				Vector2(3400, 340),
				Vector2(4400, 220)
			],
			"grounds": [
				[Vector2(200, 560), Vector2(420, 64)],
				[Vector2(1100, 530), Vector2(240, 64)],
				[Vector2(1900, 420), Vector2(320, 64)],
				[Vector2(2700, 380), Vector2(260, 64)],
				[Vector2(3600, 340), Vector2(320, 64)],
				[Vector2(4400, 290), Vector2(260, 64)],
				[Vector2(5050, 140), Vector2(480, 64)]
			],
			"ices": [
				Vector2(480, 500), Vector2(660, 440), Vector2(840, 380),
				Vector2(1450, 270), Vector2(1650, 220),
				Vector2(2150, 330),
				Vector2(3000, 290), Vector2(3200, 230),
				Vector2(3850, 240), Vector2(4050, 180), Vector2(4250, 130),
				Vector2(4650, 110), Vector2(4850, 70)
			],
			"movings": [
				[Vector2(1300, 360), Vector2(130, 0), 1.9],
				[Vector2(2480, 290), Vector2(0, -100), 2.2],
				[Vector2(3300, 250), Vector2(140, 0), 1.8],
				[Vector2(4550, 160), Vector2(0, -90), 2.0]
			],
			"spikes": [
				Vector2(600, 600), Vector2(1350, 600), Vector2(2100, 600),
				Vector2(2900, 600), Vector2(3800, 600), Vector2(4550, 600)
			],
			"enemies": [
				[Vector2(1900, 380), 60.0],
				[Vector2(3600, 300), 60.0]
			]
		}
	}
	
	# Itera e cria cada fase de 6 a 15
	for lvl_num in range(6, 16):
		var cfg = level_configs[lvl_num]
		var end_x: float = float(cfg["end_x"])
		
		var root = Node2D.new()
		root.name = "Level%d" % lvl_num
		var lvl_script = load("res://scenes/levels/level_%d.gd" % lvl_num)
		root.set_script(lvl_script)
		
		# 1. Parallax
		var bg = parallax_sc.instantiate()
		root.add_child(bg)
		bg.owner = root
		
		# 2. Containers
		var bounds_node = Node2D.new()
		bounds_node.name = "Boundaries"
		root.add_child(bounds_node)
		bounds_node.owner = root
		
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
		
		# Boundaries (Paredes esquerda e direita)
		var left_wall = StaticBody2D.new()
		left_wall.name = "LeftWall"
		left_wall.position = Vector2(-20, 350)
		left_wall.collision_layer = 1
		left_wall.collision_mask = 0
		var lw_shape = CollisionShape2D.new()
		var lw_rect = RectangleShape2D.new()
		lw_rect.size = Vector2(40, 700)
		lw_shape.shape = lw_rect
		left_wall.add_child(lw_shape)
		bounds_node.add_child(left_wall)
		left_wall.owner = root
		lw_shape.owner = root
		
		var right_wall = StaticBody2D.new()
		right_wall.name = "RightWall"
		right_wall.position = Vector2(end_x + 80, 200)
		right_wall.collision_layer = 1
		right_wall.collision_mask = 0
		var rw_shape = CollisionShape2D.new()
		var rw_rect = RectangleShape2D.new()
		rw_rect.size = Vector2(40, 700)
		rw_shape.shape = rw_rect
		right_wall.add_child(rw_shape)
		bounds_node.add_child(right_wall)
		right_wall.owner = root
		rw_shape.owner = root
		
		# Adiciona plataformas de chão
		var g_idx = 1
		for g_spec in cfg["grounds"]:
			var p = ground_sc.instantiate()
			p.name = "Ground_%d" % g_idx
			p.position = g_spec[0]
			p.set_script(ground_script)
			p.set("platform_size", g_spec[1])
			platforms_node.add_child(p)
			p.owner = root
			g_idx += 1
			
		# Adiciona plataformas de gelo
		var ice_idx = 1
		for i_pos in cfg["ices"]:
			var p = ice_sc.instantiate()
			p.name = "Ice_Step%d" % ice_idx
			p.position = i_pos
			platforms_node.add_child(p)
			p.owner = root
			
			# Cristal sobre a plataforma de gelo
			var c = crystal_sc.instantiate()
			c.name = "Crystal_Ice%d" % ice_idx
			c.position = i_pos + Vector2(0, -60)
			collectibles_node.add_child(c)
			c.owner = root
			ice_idx += 1
			
		# Adiciona plataformas móveis
		var m_idx = 1
		for m_spec in cfg["movings"]:
			var p = moving_sc.instantiate()
			p.name = "MovingPlatform_%d" % m_idx
			p.position = m_spec[0]
			p.set_script(moving_script)
			p.set("move_offset", m_spec[1])
			p.set("duration", m_spec[2])
			platforms_node.add_child(p)
			p.owner = root
			
			# Cristal sobre plataforma móvel
			var c = crystal_sc.instantiate()
			c.name = "Crystal_Mov%d" % m_idx
			c.position = m_spec[0] + Vector2(0, -65)
			collectibles_node.add_child(c)
			c.owner = root
			m_idx += 1
			
		# Adiciona espinhos
		var spk_idx = 1
		for s_pos in cfg["spikes"]:
			var s = spikes_sc.instantiate()
			s.name = "Spikes_%d" % spk_idx
			s.position = s_pos
			hazards_node.add_child(s)
			s.owner = root
			spk_idx += 1
			
		# Adiciona inimigos
		var en_idx = 1
		for e_spec in cfg["enemies"]:
			var e = enemy_sc.instantiate()
			e.name = "Enemy_%d" % en_idx
			e.position = e_spec[0]
			e.set("patrol_distance", e_spec[1])
			enemies_node.add_child(e)
			e.owner = root
			en_idx += 1
			
		# Adiciona Checkpoints
		var cp_idx = 1
		for cp_pos in cfg["checkpoints"]:
			var cp = checkpoint_sc.instantiate()
			cp.name = "Checkpoint_%d" % cp_idx
			cp.position = cp_pos
			objects_node.add_child(cp)
			cp.owner = root
			cp_idx += 1
			
		# Adiciona Cogumelos Elásticos (Springs)
		var spg_idx = 1
		for spg_pos in cfg["springs"]:
			var spg = spring_sc.instantiate()
			spg.name = "SpringMushroom_%d" % spg_idx
			spg.position = spg_pos
			spg.set("bounce_velocity", -860.0)
			objects_node.add_child(spg)
			spg.owner = root
			
			# Arco de cristais aéreos impulsionados pelo cogumelo
			for arc_i in range(3):
				var arc_c = crystal_sc.instantiate()
				arc_c.name = "Crystal_Arc%d_%d" % [spg_idx, arc_i]
				arc_c.position = spg_pos + Vector2((arc_i + 1) * 75, -120 - arc_i * 35)
				collectibles_node.add_child(arc_c)
				arc_c.owner = root
			spg_idx += 1
			
		# Adiciona Portal de Conclusão da Fase
		var portal = portal_sc.instantiate()
		portal.name = "Portal"
		portal.position = cfg["portal_pos"]
		objects_node.add_child(portal)
		portal.owner = root
		
		# Cristais de coroa no final da fase
		for crown_i in range(3):
			var crown_c = crystal_sc.instantiate()
			crown_c.name = "Crystal_Crown_%d" % crown_i
			crown_c.position = cfg["portal_pos"] + Vector2((crown_i - 1) * 60, -85)
			collectibles_node.add_child(crown_c)
			crown_c.owner = root
			
		# Cristais no Spawn
		for spw_i in range(3):
			var spw_c = crystal_sc.instantiate()
			spw_c.name = "Crystal_Spawn_%d" % spw_i
			spw_c.position = Vector2(180 + spw_i * 80, 480 - spw_i * 20)
			collectibles_node.add_child(spw_c)
			spw_c.owner = root
			
		# Player
		var player = player_sc.instantiate()
		player.name = "Player"
		player.position = Vector2(100, 460)
		root.add_child(player)
		player.owner = root
		
		# HUD & Menus
		var hud = hud_sc.instantiate()
		hud.name = "HUD"
		root.add_child(hud)
		hud.owner = root
		
		var pause_menu = pause_sc.instantiate()
		pause_menu.name = "PauseMenu"
		pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
		root.add_child(pause_menu)
		pause_menu.owner = root
		
		var game_over = gover_sc.instantiate()
		game_over.name = "GameOverMenu"
		game_over.process_mode = Node.PROCESS_MODE_ALWAYS
		root.add_child(game_over)
		game_over.owner = root
		
		var victory = vic_sc.instantiate()
		victory.name = "VictoryMenu"
		victory.process_mode = Node.PROCESS_MODE_ALWAYS
		root.add_child(victory)
		victory.owner = root
		
		# Salva a cena compilada
		var packed = PackedScene.new()
		var err = packed.pack(root)
		if err == OK:
			var save_path = "res://scenes/levels/level_%d.tscn" % lvl_num
			err = ResourceSaver.save(packed, save_path)
			if err == OK:
				print("[OK] Fase %d (%s) construída e salva com sucesso!" % [lvl_num, cfg["name"]])
			else:
				print("[ERRO] Falha ao salvar %s: %d" % [save_path, err])
		else:
			print("[ERRO] Falha ao empacotar Fase %d: %d" % [lvl_num, err])
			
	print("=== TODAS AS 10 NOVAS FASES (6 A 15) FORAM CONSTRUÍDAS COM SUCESSO! ===")
	quit(0)
