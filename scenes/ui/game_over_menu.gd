extends CanvasLayer

@onready var modal_card: PanelContainer = find_child("ModalCard", true, false)
@onready var stage_val: Label = find_child("StageVal", true, false)
@onready var time_val: Label = find_child("TimeVal", true, false)
@onready var cryst_val: Label = find_child("CrystVal", true, false)
@onready var retry_btn: Button = find_child("RetryBtn", true, false)
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
	GameManager.player_died.connect(_on_player_died)
	
	if retry_btn:
		retry_btn.pressed.connect(_on_retry_pressed)
		_setup_button_hover(retry_btn)
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

func _process(_delta: float) -> void:
	if visible and retry_btn:
		# Pulsar suave no botão de reiniciar para incentivar o jogador
		var p = 1.0 + 0.03 * sin(Time.get_ticks_msec() * 0.006)
		retry_btn.scale = Vector2(p, p)
		retry_btn.pivot_offset = retry_btn.size / 2.0

func _unhandled_input(event: InputEvent) -> void:
	if visible and (event.is_action_pressed("restart") or event.is_action_pressed("jump")):
		_on_retry_pressed()

func _on_player_died() -> void:
	if GameManager.current_hp <= 0:
		await get_tree().create_timer(0.7).timeout
		_populate_stats()
		visible = true
		if retry_btn:
			retry_btn.grab_focus()
		if modal_card:
			modal_card.pivot_offset = modal_card.size / 2.0
			modal_card.scale = Vector2(0.9, 0.9)
			var tw = create_tween()
			tw.tween_property(modal_card, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _populate_stats() -> void:
	var lvl = GameManager.current_level
	var name_str = GameManager.get_stage_name(lvl)
	if stage_val:
		stage_val.text = "Fase %d • %s" % [lvl, name_str]
	
	var total_sec: float = GameManager.elapsed_time
	var mins: int = int(total_sec) / 60
	var secs: int = int(total_sec) % 60
	var ms: int = int((total_sec - int(total_sec)) * 100.0)
	if time_val:
		time_val.text = "%02d:%02d.%02d" % [mins, secs, ms]
	if cryst_val:
		cryst_val.text = "%d / %d" % [GameManager.score, GameManager.total_crystals]

func _on_retry_pressed() -> void:
	visible = false
	GameManager.restart_current_level()

func _on_main_menu_pressed() -> void:
	visible = false
	GameManager.current_level = 1
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
