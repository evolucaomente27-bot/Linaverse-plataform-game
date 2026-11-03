extends Control

@export var always_show: bool = false

@onready var left_pad: Control = $LeftPad
@onready var right_pad: Control = $RightPad
@onready var top_pad: Control = $TopPad

@onready var btn_left: TouchScreenButton = $LeftPad/BtnLeft
@onready var btn_right: TouchScreenButton = $LeftPad/BtnRight
@onready var btn_run: TouchScreenButton = $RightPad/BtnRun
@onready var btn_dash: TouchScreenButton = $RightPad/BtnDash
@onready var btn_jump: TouchScreenButton = $RightPad/BtnJump
@onready var btn_settings: TouchScreenButton = $TopPad/BtnSettings
@onready var btn_pause: TouchScreenButton = $TopPad/BtnPause

@onready var left_drag_box: Panel = $LeftPad/DragBox
@onready var right_drag_box: Panel = $RightPad/DragBox

var is_drag_editing: bool = false
var dragging_pad: Control = null
var drag_touch_offset: Vector2 = Vector2.ZERO

var run_toggled: bool = false

func _ready() -> void:
	var is_mobile_env: bool = (
		OS.has_feature("mobile") or 
		OS.has_feature("android") or 
		OS.has_feature("ios") or 
		DisplayServer.is_touchscreen_available() or 
		"--mobile" in OS.get_cmdline_args() or 
		"--mobile" in OS.get_cmdline_user_args()
	)
	visible = is_mobile_env or always_show

	GameManager.touch_controls_changed.connect(_apply_configuration)
	_apply_configuration()
	
	if btn_settings:
		btn_settings.pressed.connect(_on_settings_pressed)
	if btn_run:
		btn_run.pressed.connect(_on_run_btn_pressed)
		btn_run.released.connect(_on_run_btn_released)

func _apply_configuration() -> void:
	var cfg = GameManager.get_touch_config()
	var sc: float = cfg.get("scale", 1.0)
	var op: float = cfg.get("opacity", 0.75)
	var hand: String = cfg.get("handedness", "right")
	var margin: float = cfg.get("margin", 24.0)
	var custom_pos: bool = cfg.get("custom_positions", false)
	var run_mode: String = cfg.get("run_mode", "hold")
	
	# Opacidade geral dos controles touch
	modulate.a = op
	
	# Escala dos painéis
	if left_pad:
		left_pad.scale = Vector2.ONE * sc
		left_pad.pivot_offset = Vector2(0, left_pad.size.y)
	if right_pad:
		right_pad.scale = Vector2.ONE * sc
		right_pad.pivot_offset = Vector2(right_pad.size.x, right_pad.size.y)
	if top_pad:
		top_pad.scale = Vector2.ONE * sc
		top_pad.pivot_offset = Vector2(top_pad.size.x, 0)
	
	# Posicionamento
	if custom_pos and cfg.has("left_pad_offset_x") and cfg.has("right_pad_offset_x"):
		if left_pad:
			left_pad.position.x = cfg["left_pad_offset_x"]
			left_pad.position.y = cfg["left_pad_offset_y"]
		if right_pad:
			right_pad.position.x = cfg["right_pad_offset_x"]
			right_pad.position.y = cfg["right_pad_offset_y"]
	else:
		# Layout automático baseado em Margem e Destro/Canhoto
		if hand == "right":
			# Padrão: D-pad na esquerda, Ações na direita
			if left_pad:
				left_pad.anchor_left = 0.0
				left_pad.anchor_right = 0.0
				left_pad.anchor_top = 1.0
				left_pad.anchor_bottom = 1.0
				left_pad.offset_left = margin + 12.0
				left_pad.offset_right = margin + 12.0 + 224.0
				left_pad.offset_bottom = -margin
				left_pad.offset_top = -margin - 120.0
			if right_pad:
				right_pad.anchor_left = 1.0
				right_pad.anchor_right = 1.0
				right_pad.anchor_top = 1.0
				right_pad.anchor_bottom = 1.0
				right_pad.offset_right = -margin
				right_pad.offset_left = -margin - 290.0
				right_pad.offset_bottom = -margin
				right_pad.offset_top = -margin - 150.0
		else:
			# Invertido (Canhoto): Ações na esquerda, D-pad na direita
			if left_pad:
				left_pad.anchor_left = 1.0
				left_pad.anchor_right = 1.0
				left_pad.anchor_top = 1.0
				left_pad.anchor_bottom = 1.0
				left_pad.offset_right = -margin
				left_pad.offset_left = -margin - 224.0
				left_pad.offset_bottom = -margin
				left_pad.offset_top = -margin - 120.0
			if right_pad:
				right_pad.anchor_left = 0.0
				right_pad.anchor_right = 0.0
				right_pad.anchor_top = 1.0
				right_pad.anchor_bottom = 1.0
				right_pad.offset_left = margin + 12.0
				right_pad.offset_right = margin + 12.0 + 290.0
				right_pad.offset_bottom = -margin
				right_pad.offset_top = -margin - 150.0
	
	# Atualiza feedback visual do botão de corrida de acordo com o modo
	_update_run_button_visuals(run_mode)

func _update_run_button_visuals(run_mode: String) -> void:
	if not btn_run:
		return
	match run_mode:
		"auto":
			btn_run.self_modulate = Color(1.0, 0.9, 0.35, 1.0)
		"toggle":
			if run_toggled:
				btn_run.self_modulate = Color(0.4, 1.0, 0.7, 1.0)
			else:
				btn_run.self_modulate = Color(1.0, 1.0, 1.0, 0.9)
		"hold":
			btn_run.self_modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_run_btn_pressed() -> void:
	var cfg = GameManager.get_touch_config()
	var mode = cfg.get("run_mode", "hold")
	if mode == "toggle":
		run_toggled = not run_toggled
		GameManager.run_toggled_active = run_toggled
		_update_run_button_visuals(mode)
		if run_toggled:
			Input.action_press("run")
			SoundManager.play_sfx("jump", 0.05)
		else:
			Input.action_release("run")
			SoundManager.play_sfx("land", 0.05)

func _on_run_btn_released() -> void:
	var cfg = GameManager.get_touch_config()
	var mode = cfg.get("run_mode", "hold")
	if mode == "hold":
		Input.action_release("run")

func _on_settings_pressed() -> void:
	# Abre a janela de configuração de controles
	var root = get_tree().root
	var dlg = root.find_child("ControlsConfigDialog", true, false)
	if not dlg:
		var dlg_sc = load("res://scenes/ui/controls_config_dialog.tscn")
		dlg = dlg_sc.instantiate()
		root.add_child(dlg)
	
	if dlg and dlg.has_method("open_dialog"):
		dlg.open_dialog()

func set_drag_editing(enabled: bool) -> void:
	is_drag_editing = enabled
	if left_drag_box: left_drag_box.visible = enabled
	if right_drag_box: right_drag_box.visible = enabled
	
	if not enabled:
		# Salva posições finais após o arraste
		var cfg = GameManager.get_touch_config()
		cfg["custom_positions"] = true
		if left_pad:
			cfg["left_pad_offset_x"] = left_pad.position.x
			cfg["left_pad_offset_y"] = left_pad.position.y
		if right_pad:
			cfg["right_pad_offset_x"] = right_pad.position.x
			cfg["right_pad_offset_y"] = right_pad.position.y
		GameManager.save_touch_config(cfg)

func _input(event: InputEvent) -> void:
	if not visible and (event is InputEventScreenTouch or event is InputEventScreenDrag):
		visible = true
	
	if not is_drag_editing:
		return
	
	if event is InputEventScreenTouch:
		if event.pressed:
			var touch_pos = event.position
			if left_pad and left_pad.get_global_rect().has_point(touch_pos):
				dragging_pad = left_pad
				drag_touch_offset = touch_pos - left_pad.position
			elif right_pad and right_pad.get_global_rect().has_point(touch_pos):
				dragging_pad = right_pad
				drag_touch_offset = touch_pos - right_pad.position
		else:
			dragging_pad = null
			
	elif event is InputEventScreenDrag and dragging_pad:
		var target_pos = event.position - drag_touch_offset
		var vp_size = get_viewport_rect().size
		target_pos.x = clamp(target_pos.x, 10.0, vp_size.x - dragging_pad.size.x * dragging_pad.scale.x - 10.0)
		target_pos.y = clamp(target_pos.y, 40.0, vp_size.y - dragging_pad.size.y * dragging_pad.scale.y - 10.0)
		dragging_pad.position = target_pos
		get_viewport().set_input_as_handled()
	
	# Suporte a mouse durante testes no PC
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var m_pos = event.position
				if left_pad and left_pad.get_global_rect().has_point(m_pos):
					dragging_pad = left_pad
					drag_touch_offset = m_pos - left_pad.position
				elif right_pad and right_pad.get_global_rect().has_point(m_pos):
					dragging_pad = right_pad
					drag_touch_offset = m_pos - right_pad.position
			else:
				dragging_pad = null
				
	elif event is InputEventMouseMotion and dragging_pad:
		var target_pos = event.position - drag_touch_offset
		var vp_size = get_viewport_rect().size
		target_pos.x = clamp(target_pos.x, 10.0, vp_size.x - dragging_pad.size.x * dragging_pad.scale.x - 10.0)
		target_pos.y = clamp(target_pos.y, 40.0, vp_size.y - dragging_pad.size.y * dragging_pad.scale.y - 10.0)
		dragging_pad.position = target_pos
