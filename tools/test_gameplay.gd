@tool
extends SceneTree

func _init() -> void:
	print("--- INICIANDO TESTES AUTOMATIZADOS DO LINAVERSE ---")
	var passed = 0
	var total = 0
	
	var assert_true = func(cond: bool, test_name: String):
		total += 1
		if cond:
			print(" [PASS] ", test_name)
			passed += 1
		else:
			print(" [FAIL] ", test_name)
	
	# Teste 1: GameManager
	var gm = get_root().get_node_or_null("GameManager")
	assert_true.call(gm != null, "GameManager autoload está ativo")
	if gm:
		gm.start_game()
		assert_true.call(gm.score == 0, "Score inicial é 0")
		assert_true.call(gm.current_hp == 3, "HP inicial é 3")
		
		gm.add_crystal(1)
		assert_true.call(gm.score == 1, "add_crystal(1) incrementou o score")
		
		gm.damage_player(1)
		assert_true.call(gm.current_hp == 2, "damage_player(1) reduziu HP para 2")
		
		gm.heal_player(1)
		assert_true.call(gm.current_hp == 3, "heal_player(1) restaurou HP para 3")
		
		var test_cp = Vector2(500, 300)
		gm.set_checkpoint(test_cp)
		assert_true.call(gm.checkpoint_pos == test_cp, "set_checkpoint atualizou a posição")
		
	# Teste 2: Instanciação do Player
	var player_sc = load("res://scenes/player/player.tscn")
	assert_true.call(player_sc != null, "player.tscn carregou com sucesso")
	var player = player_sc.instantiate()
	assert_true.call(player != null, "Player instanciado com sucesso")
	assert_true.call(player.has_node("AnimatedSprite2D"), "Player tem AnimatedSprite2D")
	assert_true.call(player.has_node("CollisionShape2D"), "Player tem CollisionShape2D")
	assert_true.call(player.has_node("Camera2D"), "Player tem Camera2D")
	player.queue_free()

	# Teste 3: Instanciação de Objetos
	var crystal_sc = load("res://scenes/objects/crystal.tscn")
	assert_true.call(crystal_sc != null, "crystal.tscn carregou com sucesso")
	
	var enemy_sc = load("res://scenes/enemies/enemy.tscn")
	assert_true.call(enemy_sc != null, "enemy.tscn carregou com sucesso")
	
	var spring_sc = load("res://scenes/objects/spring_mushroom.tscn")
	assert_true.call(spring_sc != null, "spring_mushroom.tscn carregou com sucesso")
	
	var cp_sc = load("res://scenes/objects/checkpoint.tscn")
	assert_true.call(cp_sc != null, "checkpoint.tscn carregou com sucesso")
	
	var portal_sc = load("res://scenes/objects/portal.tscn")
	assert_true.call(portal_sc != null, "portal.tscn carregou com sucesso")
	
	# Teste 4: Instanciação da Fase 1
	var level_sc = load("res://scenes/levels/level_1.tscn")
	assert_true.call(level_sc != null, "level_1.tscn carregou com sucesso")
	var level = level_sc.instantiate()
	assert_true.call(level != null, "Level 1 instanciado com sucesso")
	assert_true.call(level.has_node("Player"), "Level 1 contém Player")
	assert_true.call(level.has_node("Platforms"), "Level 1 contém plataformas")
	assert_true.call(level.has_node("Collectibles"), "Level 1 contém colecionáveis")
	assert_true.call(level.has_node("Enemies"), "Level 1 contém inimigos")
	assert_true.call(level.has_node("HUD"), "Level 1 contém HUD")
	level.queue_free()

	print("--- RESULTADO: %d / %d TESTES PASSARAM ---" % [passed, total])
	quit()
