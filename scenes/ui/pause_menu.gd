extends CanvasLayer

@onready var modal_card: PanelContainer = find_child("ModalCard", true, false)
@onready var stage_label: Label = find_child("StageLabel", true, false)
@onready var nix_title: Label = find_child("NixTitle", true, false)
@onready var nix_desc: Label = find_child("NixDesc", true, false)
@onready var nix_icon: TextureRect = find_child("NixIcon", true, false)

@onready var stat_time_val: Label = find_child("TimeVal", true, false)
@onready var stat_cryst_val: Label = find_child("CrystVal", true, false)
@onready var stat_target_val: Label = find_child("TargetVal", true, false)
@onready var stat_pb_val: Label = find_child("PBVal", true, false)

@onready var active_powers_label: Label = find_child("ActivePowersLabel", true, false)

@onready var resume_btn: Button = find_child("ResumeBtn", true, false)
@onready var restart_btn: Button = find_child("RestartBtn", true, false)
@onready var controls_btn: Button = find_child("ControlsBtn", true, false)
@onready var main_menu_btn: Button = find_child("MainMenuBtn", true, false)

const LEVEL_NAMES: Dictionary = {
	1: "Planície Serena",
	2: "Caverna de Cristais",
	3: "Vale dos Cogumelos",
	4: "Pico da Nevasca",
	5: "Palácio Celestial",
	6: "Passagem das Estalactites",
	7: "Ruínas Rúnicas",
	8: "Abismo dos Ventos Cósmicos",
	9: "Trilha dos Portais Ocultos",
	10: "Geleira do Trovão",
	11: "Santuário das Constelações",
	12: "Coração do Linaverse"
}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	
	if resume_btn:
		resume_btn.pressed.connect(_on_resume_pressed)
		_setup_button_hover(resume_btn)
	if restart_btn:
		restart_btn.pressed.connect(_on_restart_pressed)
		_setup_button_hover(restart_btn)
	if controls_btn:
		controls_btn.pressed.connect(_on_controls_pressed)
		_setup_button_hover(controls_btn)
	if main_menu_btn:
		main_menu_btn.pressed.connect(_on_main_menu_pressed)
		_setup_button_hover(main_menu_btn)

func _setup_button_hover(btn: Button) -> void:
	btn.pivot_offset = btn.size / 2.0
	btn.mouse_entered.connect(func():
		var tw = create_tween()
		tw.tween_property(btn, "scale", Vector2(1.03, 1.03), 0.1).set_trans(Tween.TRANS_SINE)
	)
	btn.mouse_exited.connect(func():
		var tw = create_tween()
		tw.tween_property(btn, "scale", Vector2.ONE, 0.1)
	)
	btn.focus_entered.connect(func():
		var tw = create_tween()
		tw.tween_property(btn, "scale", Vector2(1.03, 1.03), 0.1).set_trans(Tween.TRANS_SINE)
	)
	btn.focus_exited.connect(func():
		var tw = create_tween()
		tw.tween_property(btn, "scale", Vector2.ONE, 0.1)
	)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if not GameManager.is_game_over and not GameManager.is_level_completed:
			toggle_pause()
	elif visible and event.is_action_pressed("restart"):
		_on_restart_pressed()

func toggle_pause() -> void:
	var paused = not get_tree().paused
	get_tree().paused = paused
	visible = paused
	
	if visible:
		_populate_pause_data()
		if resume_btn:
			resume_btn.grab_focus()
		if modal_card:
			modal_card.pivot_offset = modal_card.size / 2.0
			modal_card.scale = Vector2(0.92, 0.92)
			var tw = create_tween()
			tw.tween_property(modal_card, "scale", Vector2.ONE, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _populate_pause_data() -> void:
	var lvl = GameManager.current_level
	var name_str = GameManager.get_stage_name(lvl)
	var u_data = GameManager.get_current_outfit_data()
	var u_icon = u_data.get("icon", "❄️")
	var u_name = u_data.get("name", "Clássica")
	
	if stage_label:
		stage_label.text = "FASE %d • %s [%s %s]" % [lvl, name_str, u_icon, u_name]
		stage_label.modulate = u_data.get("color", Color(0.4, 0.85, 1.0))
	
	# Nix Quest Lore
	var story = GameManager.get_stage_story(lvl)
	if nix_title:
		nix_title.text = "🐾 MISSÃO DO NIX • [%d/12] %s %s" % [lvl, story.get("icon", "🧪"), story.get("ingredient", "Ingrediente")]
	if nix_desc:
		nix_desc.text = story.get("nix_status", "Nix descansa sob a mantinha quentinha aguardando o remédio...")
	if nix_icon and lvl == 12:
		nix_icon.texture = preload("res://assets/sprites/story/nix_icon_happy.png")
	
	# Live Run Stats
	var total_sec: float = GameManager.elapsed_time
	var mins: int = int(total_sec) / 60
	var secs: int = int(total_sec) % 60
	var ms: int = int((total_sec - int(total_sec)) * 100.0)
	
	if stat_time_val:
		stat_time_val.text = "%02d:%02d.%02d" % [mins, secs, ms]
	if stat_cryst_val:
		stat_cryst_val.text = "%d / %d" % [GameManager.score, GameManager.total_crystals]
	
	var target = GameManager.get_speedrun_target(lvl)
	if stat_target_val:
		stat_target_val.text = "< %.1fs" % target.get("s", 25.0)
	
	var rec = GameManager.get_speedrun_record_for_level(lvl)
	if stat_pb_val:
		if rec.has("best_time"):
			var pb_sec = rec["best_time"]
			stat_pb_val.text = "%02d:%02d.%02d (%s)" % [int(pb_sec)/60, int(pb_sec)%60, int((pb_sec - int(pb_sec))*100), rec.get("rank", "S")]
		else:
			stat_pb_val.text = "Sem registro ainda"
	
	_update_powers_label()

func _update_powers_label() -> void:
	if not active_powers_label:
		return
	var items: Array[String] = []
	
	# Poderes permanentes de cartas
	for p in GameManager.active_powers:
		items.append("%s %s" % [p.get("icon", "✦"), p.get("name", "Poder")])
	
	# Power-ups temporários de fase ativos
	for p_type in GameManager.active_powerups.keys():
		var p_data = GameManager.active_powerups[p_type]
		var rem = max(0.0, p_data.get("time_left", 0.0))
		items.append("%s %s (%.1fs)" % [p_data.get("icon", "⚡"), p_data.get("name", "PowerUp"), rem])
	
	if GameManager.shield_active:
		items.append("🛡️ Escudo de Aurora")
	
	if items.is_empty():
		active_powers_label.text = "Poderes & Efeitos Ativos: Nenhum no momento"
	else:
		active_powers_label.text = "Poderes & Efeitos Ativos:\n" + "  •  ".join(items)

func _on_resume_pressed() -> void:
	toggle_pause()

func _on_restart_pressed() -> void:
	get_tree().paused = false
	visible = false
	GameManager.restart_current_level()

func _on_controls_pressed() -> void:
	SoundManager.play_sfx("crystal")
	var root = get_tree().root
	var dlg = root.find_child("ControlsConfigDialog", true, false)
	if not dlg:
		var dlg_sc = load("res://scenes/ui/controls_config_dialog.tscn")
		dlg = dlg_sc.instantiate()
		root.add_child(dlg)
	if dlg and dlg.has_method("open_dialog"):
		dlg.open_dialog()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	visible = false
	GameManager.current_level = 1
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
