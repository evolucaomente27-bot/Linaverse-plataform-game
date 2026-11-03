extends CanvasLayer

@onready var stats_panel: VBoxContainer = $Panel/StatsPanel
@onready var card_select_panel: Control = $Panel/CardSelectPanel

@onready var crystals_val: Label = $Panel/StatsPanel/StatsBox/Margin/Grid/CrystalsVal
@onready var time_val: Label = $Panel/StatsPanel/StatsBox/Margin/Grid/TimeVal
@onready var rank_val: Label = $Panel/StatsPanel/RankVal
@onready var current_powers_label: Label = $Panel/StatsPanel/CurrentPowersLabel
@onready var next_level_btn: Button = $Panel/StatsPanel/NextLevelBtn
@onready var play_again_btn: Button = $Panel/StatsPanel/PlayAgainBtn
@onready var main_menu_btn: Button = $Panel/StatsPanel/MainMenuBtn
@onready var title_label: Label = $Panel/StatsPanel/Title
@onready var subtitle_label: Label = $Panel/StatsPanel/Subtitle

@onready var avatar_frame: PanelContainer = $Panel/StatsPanel/AvatarFrame
@onready var avatar_rect: TextureRect = $Panel/StatsPanel/AvatarFrame/Avatar
@onready var nix_reward_box: PanelContainer = $Panel/StatsPanel/NixRewardBox
@onready var nix_reward_icon: TextureRect = $Panel/StatsPanel/NixRewardBox/Margin/HBox/NixRewardIcon
@onready var nix_reward_title: Label = $Panel/StatsPanel/NixRewardBox/Margin/HBox/VBox/RewardTitle
@onready var nix_reward_desc: Label = $Panel/StatsPanel/NixRewardBox/Margin/HBox/VBox/RewardDesc
@onready var nix_reward_status: Label = $Panel/StatsPanel/NixRewardBox/Margin/HBox/VBox/NixStatus


@onready var card1: Button = $Panel/CardSelectPanel/VBox/CardsContainer/Card1
@onready var card2: Button = $Panel/CardSelectPanel/VBox/CardsContainer/Card2
@onready var card3: Button = $Panel/CardSelectPanel/VBox/CardsContainer/Card3
@onready var status_banner: Label = $Panel/CardSelectPanel/VBox/StatusBanner
@onready var card_title: Label = $Panel/CardSelectPanel/VBox/Title
@onready var card_subtitle: Label = $Panel/CardSelectPanel/VBox/Subtitle

var current_offered_cards: Array[Dictionary] = []
var is_card_selected: bool = false
var card_buttons: Array[Button] = []

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	card_buttons = [card1, card2, card3]
	
	GameManager.level_completed.connect(_on_level_completed)
	next_level_btn.pressed.connect(_on_next_level_pressed)
	play_again_btn.pressed.connect(_on_play_again_pressed)
	main_menu_btn.pressed.connect(_on_main_menu_pressed)
	
	_setup_btn_hover(next_level_btn)
	_setup_btn_hover(play_again_btn)
	_setup_btn_hover(main_menu_btn)
	
	for i in range(card_buttons.size()):
		var btn = card_buttons[i]
		var idx = i
		btn.pressed.connect(func(): _on_card_chosen(idx))
		btn.mouse_entered.connect(func(): _on_card_hover(btn, true))
		btn.mouse_exited.connect(func(): _on_card_hover(btn, false))
		btn.focus_entered.connect(func(): _on_card_hover(btn, true))
		btn.focus_exited.connect(func(): _on_card_hover(btn, false))

func _setup_btn_hover(btn: Button) -> void:
	btn.pivot_offset = btn.size / 2.0
	btn.mouse_entered.connect(func():
		var tw = create_tween()
		tw.tween_property(btn, "scale", Vector2(1.035, 1.035), 0.1).set_trans(Tween.TRANS_SINE)
	)
	btn.mouse_exited.connect(func():
		var tw = create_tween()
		tw.tween_property(btn, "scale", Vector2.ONE, 0.1)
	)
	btn.focus_entered.connect(func():
		var tw = create_tween()
		tw.tween_property(btn, "scale", Vector2(1.035, 1.035), 0.1).set_trans(Tween.TRANS_SINE)
	)
	btn.focus_exited.connect(func():
		var tw = create_tween()
		tw.tween_property(btn, "scale", Vector2.ONE, 0.1)
	)

func _on_level_completed() -> void:
	await get_tree().create_timer(0.4).timeout
	visible = true
	is_card_selected = false
	stats_panel.visible = true
	card_select_panel.visible = false
	status_banner.visible = false
	
	crystals_val.text = "%d / %d" % [GameManager.score, GameManager.total_crystals]
	var total_sec: float = GameManager.elapsed_time
	var mins: int = int(total_sec) / 60
	var secs: int = int(total_sec) % 60
	var msecs: int = int((total_sec - int(total_sec)) * 100)
	time_val.text = "%02d:%02d.%02d" % [mins, secs, msecs]
	
	# Salva e avalia Speedrun Record
	var speedrun_res: Dictionary = GameManager.save_speedrun_record(GameManager.current_level, total_sec, GameManager.score)
	var rank: String = speedrun_res.get("rank", "B")
	var is_pb: bool = speedrun_res.get("is_new_pb", false)
	var target: Dictionary = GameManager.get_speedrun_target(GameManager.current_level)
	var target_s: float = target.get("s", 30.0)
	
	# Exibição de poderes acumulados
	if GameManager.active_powers.is_empty():
		current_powers_label.text = "Poderes Ativos: Nenhum ainda"
	else:
		var names: Array[String] = []
		for p in GameManager.active_powers:
			names.append("%s %s" % [p.get("icon", "✦"), p.get("name", "Poder")])
		current_powers_label.text = "Poderes: " + ", ".join(names)
	
	# Cálculo de Rank Speedrun
	if rank == "S":
		rank_val.text = "⚡ SPEEDRUN RANK S ★★★ (IMPECÁVEL!)"
		rank_val.modulate = Color(1.0, 0.84, 0.0)
		rank_val.pivot_offset = rank_val.size / 2.0
		var rtw = create_tween().set_loops(3)
		rtw.tween_property(rank_val, "scale", Vector2(1.08, 1.08), 0.2).set_trans(Tween.TRANS_SINE)
		rtw.tween_property(rank_val, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_SINE)
	elif rank == "A":
		rank_val.text = "⭐ SPEEDRUN RANK A ★★ (MUITO RÁPIDO!)"
		rank_val.modulate = Color(0.25, 0.9, 1.0)
		rank_val.scale = Vector2.ONE
	elif rank == "B":
		rank_val.text = "✦ SPEEDRUN RANK B ★ (BOM TEMPO!)"
		rank_val.modulate = Color(0.75, 0.88, 1.0)
		rank_val.scale = Vector2.ONE
	else:
		rank_val.text = "SPEEDRUN RANK C (TENTE MAIS RÁPIDO!)"
		rank_val.modulate = Color(0.7, 0.7, 0.7)
		rank_val.scale = Vector2.ONE
	
	var pb_tag = " [NOVO RECORDE PESSOAL! 🏆]" if is_pb else ""
	var target_tag = "Meta S: %.1fs" % target_s
	
	var lvl: int = GameManager.current_level
	var story: Dictionary = GameManager.get_stage_story(lvl)
	
	if nix_reward_box:
		if lvl < 12:
			nix_reward_title.text = "🐾 REMÉDIO DO NIX • ESSÊNCIA [%d/12] RESGATADA!" % lvl
			nix_reward_desc.text = "%s %s" % [story.get("icon", "🧪"), story.get("ingredient", "Ingrediente")]
			nix_reward_status.text = story.get("nix_status", "Nix descansa sob a mantinha de lã...")
			nix_reward_icon.texture = preload("res://assets/sprites/story/medicine_icon.png")
			if avatar_rect:
				avatar_rect.texture = preload("res://assets/sprites/ui/lina_face_win.png")
			if avatar_frame:
				avatar_frame.custom_minimum_size = Vector2(72, 72)
		else:
			# Fase 12: Grande Vitória - Nix curado!
			if avatar_rect:
				avatar_rect.texture = preload("res://assets/sprites/story/nix_happy.png")
			if avatar_frame:
				avatar_frame.custom_minimum_size = Vector2(100, 100)
			nix_reward_title.text = "🐾 MISSÃO CUMPRIDA: O AMOR VENCEU A FEBRE!"
			nix_reward_desc.text = "✨ Elixir Celestial das 12 Essências Administrado!"
			nix_reward_status.text = "Nix saltou da caminha são e salvo, ronronando de alegria e enchendo Lina de carinho! 🐱🐾💖"
			nix_reward_icon.texture = preload("res://assets/sprites/story/nix_icon_happy.png")

	# Controle de Próxima Fase / Seleção de Cartas
	if GameManager.has_next_level():
		next_level_btn.visible = true
		next_level_btn.text = "▶ Escolher Carta de Poder (Fase %d)" % (GameManager.current_level + 1)
		title_label.text = "FASE %d CONCLUÍDA!%s" % [GameManager.current_level, pb_tag]
		title_label.modulate = Color(0.4, 0.9, 1.0)
		subtitle_label.text = "Tempo: %02d:%02d.%02d (%s) • Próximo portal liberado!" % [mins, secs, msecs, target_tag]
		next_level_btn.grab_focus()
	else:
		next_level_btn.visible = false
		title_label.text = "🎉 NIX ESTÁ CURADO E SALVO!%s" % pb_tag
		title_label.modulate = Color(1.0, 0.88, 0.35)
		subtitle_label.text = "Tempo Final: %02d:%02d.%02d • Nix recebeu o remédio a tempo e está saudável! 🐾💖" % [mins, secs, msecs]
		play_again_btn.text = "▶ Jogar Speedrun Novamente"
		play_again_btn.grab_focus()


func _on_next_level_pressed() -> void:
	if not GameManager.has_next_level():
		return
	
	SoundManager.play_sfx("jump", 0.1)
	stats_panel.visible = false
	card_select_panel.visible = true
	status_banner.visible = false
	
	card_subtitle.text = "Selecione 1 bênção celestial para a jornada rumo à Fase %d" % (GameManager.current_level + 1)
	
	# Sorteia 3 cartas de poder
	current_offered_cards = PowerCards.get_random_selection(GameManager.get_owned_power_ids(), 3)
	
	for i in range(card_buttons.size()):
		var btn = card_buttons[i]
		btn.scale = Vector2.ONE
		btn.modulate = Color(1, 1, 1, 1)
		btn.pivot_offset = btn.size / 2.0
		
		if i < current_offered_cards.size():
			btn.visible = true
			var card_data = current_offered_cards[i]
			_setup_card_ui(btn, card_data)
		else:
			btn.visible = false
	
	card1.grab_focus()

func _setup_card_ui(btn: Button, data: Dictionary) -> void:
	var vbox = btn.get_node("Margin/VBox")
	var rarity_label = vbox.get_node("RarityLabel") as Label
	var icon_label = vbox.get_node("IconFrame/IconLabel") as Label
	var name_label = vbox.get_node("NameLabel") as Label
	var desc_label = vbox.get_node("DescLabel") as Label
	var badge_label = vbox.get_node("BadgePanel/BadgeLabel") as Label
	
	var r_color: Color = data.get("rarity_color", Color(0.35, 0.75, 1.0))
	rarity_label.text = "[ %s • %s ]" % [data.get("rarity", "COMUM").to_upper(), data.get("type", "BÊNÇÃO").to_upper()]
	rarity_label.modulate = r_color
	
	icon_label.text = data.get("icon", "✦")
	name_label.text = data.get("name", "Poder Ancestral")
	desc_label.text = data.get("desc", "")
	badge_label.text = data.get("badge", "Ativo")
	badge_label.modulate = r_color
	
	# Estilo personalizado com a cor da raridade
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.12, 0.22, 0.95)
	style.set_border_width_all(3)
	style.border_color = r_color
	style.set_corner_radius_all(12)
	style.shadow_color = Color(0, 0, 0, 0.5)
	style.shadow_size = 8
	btn.add_theme_stylebox_override("normal", style)

func _on_card_hover(btn: Button, is_hover: bool) -> void:
	if is_card_selected or not btn.visible:
		return
	btn.pivot_offset = btn.size / 2.0
	if not btn.has_meta("base_y"):
		btn.set_meta("base_y", btn.position.y)
	var base_y: float = btn.get_meta("base_y")
	var tw = create_tween().set_parallel(true)
	if is_hover:
		tw.tween_property(btn, "scale", Vector2(1.06, 1.06), 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tw.tween_property(btn, "position:y", base_y - 8.0, 0.12).set_trans(Tween.TRANS_SINE)
		SoundManager.play_sfx("land", 0.05)
	else:
		tw.tween_property(btn, "scale", Vector2.ONE, 0.12)
		tw.tween_property(btn, "position:y", base_y, 0.12).set_trans(Tween.TRANS_SINE)

func _on_card_chosen(index: int) -> void:
	if is_card_selected or index >= current_offered_cards.size():
		return
	is_card_selected = true
	
	var chosen_card = current_offered_cards[index]
	var chosen_btn = card_buttons[index]
	
	# Aplica poder no GameManager
	GameManager.apply_power_card(chosen_card)
	SoundManager.play_sfx("portal")
	
	# Animação de consagração da carta
	chosen_btn.pivot_offset = chosen_btn.size / 2.0
	var tw = create_tween().set_parallel(true)
	tw.tween_property(chosen_btn, "scale", Vector2(1.12, 1.12), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	# Fading das outras cartas
	for i in range(card_buttons.size()):
		if i != index:
			tw.tween_property(card_buttons[i], "modulate:a", 0.2, 0.2)
	
	status_banner.text = "✦ PODER CONSAGRADO: %s! INICIANDO FASE %d... ✦" % [chosen_card.get("name", ""), GameManager.current_level + 1]
	status_banner.modulate = chosen_card.get("rarity_color", Color.CYAN)
	status_banner.visible = true
	
	await get_tree().create_timer(0.85).timeout
	visible = false
	GameManager.go_to_next_level()

func _on_play_again_pressed() -> void:
	visible = false
	GameManager.restart_current_level()

func _on_main_menu_pressed() -> void:
	visible = false
	GameManager.current_level = 1
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
