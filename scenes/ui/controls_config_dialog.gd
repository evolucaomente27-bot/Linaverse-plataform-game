extends CanvasLayer
class_name ControlsConfigDialog

signal closed()

@onready var modal_card: PanelContainer = $Overlay/CenterContainer/ModalCard
@onready var touch_tab: VBoxContainer = $Overlay/CenterContainer/ModalCard/Margin/VBox/TabContainer/TouchTab
@onready var pc_tab: VBoxContainer = $Overlay/CenterContainer/ModalCard/Margin/VBox/TabContainer/PCTab
@onready var tab_btn_touch: Button = $Overlay/CenterContainer/ModalCard/Margin/VBox/TabButtons/BtnTabTouch
@onready var tab_btn_pc: Button = $Overlay/CenterContainer/ModalCard/Margin/VBox/TabButtons/BtnTabPC

# Scale Buttons
@onready var btn_scale_85: Button = find_child("BtnScale85", true, false)
@onready var btn_scale_100: Button = find_child("BtnScale100", true, false)
@onready var btn_scale_120: Button = find_child("BtnScale120", true, false)
@onready var btn_scale_140: Button = find_child("BtnScale140", true, false)

# Opacity Buttons
@onready var btn_opac_35: Button = find_child("BtnOpac35", true, false)
@onready var btn_opac_55: Button = find_child("BtnOpac55", true, false)
@onready var btn_opac_75: Button = find_child("BtnOpac75", true, false)
@onready var btn_opac_100: Button = find_child("BtnOpac100", true, false)

# Run Mode Buttons
@onready var btn_run_hold: Button = find_child("BtnRunHold", true, false)
@onready var btn_run_toggle: Button = find_child("BtnRunToggle", true, false)
@onready var btn_run_auto: Button = find_child("BtnRunAuto", true, false)
@onready var run_desc_label: Label = find_child("RunDescLabel", true, false)

# Handedness & Margins
@onready var btn_hand_right: Button = find_child("BtnHandRight", true, false)
@onready var btn_hand_left: Button = find_child("BtnHandLeft", true, false)
@onready var btn_margin_12: Button = find_child("BtnMargin12", true, false)
@onready var btn_margin_24: Button = find_child("BtnMargin24", true, false)
@onready var btn_margin_48: Button = find_child("BtnMargin48", true, false)

# Drag Mode & Bottom Actions
@onready var btn_drag_mode: Button = find_child("BtnDragMode", true, false)
@onready var btn_reset: Button = find_child("BtnReset", true, false)
@onready var btn_save: Button = find_child("BtnSave", true, false)

# Drag overlay banner
@onready var drag_banner: PanelContainer = $DragBanner
@onready var btn_finish_drag: Button = $DragBanner/Margin/HBox/BtnFinishDrag

var current_cfg: Dictionary = {}
var is_in_drag_mode: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	if drag_banner:
		drag_banner.visible = false
	
	_connect_signals()

func _connect_signals() -> void:
	if tab_btn_touch:
		tab_btn_touch.pressed.connect(func(): _switch_tab(0))
	if tab_btn_pc:
		tab_btn_pc.pressed.connect(func(): _switch_tab(1))
	
	# Scale
	if btn_scale_85: btn_scale_85.pressed.connect(func(): _set_scale(0.85))
	if btn_scale_100: btn_scale_100.pressed.connect(func(): _set_scale(1.0))
	if btn_scale_120: btn_scale_120.pressed.connect(func(): _set_scale(1.2))
	if btn_scale_140: btn_scale_140.pressed.connect(func(): _set_scale(1.4))
	
	# Opacity
	if btn_opac_35: btn_opac_35.pressed.connect(func(): _set_opacity(0.35))
	if btn_opac_55: btn_opac_55.pressed.connect(func(): _set_opacity(0.55))
	if btn_opac_75: btn_opac_75.pressed.connect(func(): _set_opacity(0.75))
	if btn_opac_100: btn_opac_100.pressed.connect(func(): _set_opacity(1.0))
	
	# Run Mode
	if btn_run_hold: btn_run_hold.pressed.connect(func(): _set_run_mode("hold"))
	if btn_run_toggle: btn_run_toggle.pressed.connect(func(): _set_run_mode("toggle"))
	if btn_run_auto: btn_run_auto.pressed.connect(func(): _set_run_mode("auto"))
	
	# Handedness
	if btn_hand_right: btn_hand_right.pressed.connect(func(): _set_handedness("right"))
	if btn_hand_left: btn_hand_left.pressed.connect(func(): _set_handedness("left"))
	
	# Margin
	if btn_margin_12: btn_margin_12.pressed.connect(func(): _set_margin(12.0))
	if btn_margin_24: btn_margin_24.pressed.connect(func(): _set_margin(24.0))
	if btn_margin_48: btn_margin_48.pressed.connect(func(): _set_margin(48.0))
	
	# Drag mode
	if btn_drag_mode:
		btn_drag_mode.pressed.connect(_enter_drag_mode)
	if btn_finish_drag:
		btn_finish_drag.pressed.connect(_exit_drag_mode)
	
	# Bottom
	if btn_reset:
		btn_reset.pressed.connect(_on_reset_pressed)
	if btn_save:
		btn_save.pressed.connect(_on_save_pressed)

func open_dialog() -> void:
	current_cfg = GameManager.get_touch_config()
	visible = true
	$Overlay.visible = true
	if drag_banner:
		drag_banner.visible = false
	_switch_tab(0)
	_update_ui_state()
	
	if modal_card:
		modal_card.pivot_offset = modal_card.size / 2.0
		modal_card.scale = Vector2(0.92, 0.92)
		var tw = create_tween()
		tw.tween_property(modal_card, "scale", Vector2.ONE, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _switch_tab(tab_idx: int) -> void:
	if touch_tab: touch_tab.visible = (tab_idx == 0)
	if pc_tab: pc_tab.visible = (tab_idx == 1)
	
	if tab_btn_touch:
		tab_btn_touch.modulate = Color(1.0, 1.0, 1.0, 1.0) if tab_idx == 0 else Color(0.65, 0.75, 0.9, 0.8)
	if tab_btn_pc:
		tab_btn_pc.modulate = Color(1.0, 1.0, 1.0, 1.0) if tab_idx == 1 else Color(0.65, 0.75, 0.9, 0.8)

func _update_ui_state() -> void:
	# Scale
	var sc = current_cfg.get("scale", 1.0)
	_highlight_button(btn_scale_85, is_equal_approx(sc, 0.85))
	_highlight_button(btn_scale_100, is_equal_approx(sc, 1.0))
	_highlight_button(btn_scale_120, is_equal_approx(sc, 1.2))
	_highlight_button(btn_scale_140, is_equal_approx(sc, 1.4))
	
	# Opacity
	var op = current_cfg.get("opacity", 0.75)
	_highlight_button(btn_opac_35, is_equal_approx(op, 0.35))
	_highlight_button(btn_opac_55, is_equal_approx(op, 0.55))
	_highlight_button(btn_opac_75, is_equal_approx(op, 0.75))
	_highlight_button(btn_opac_100, is_equal_approx(op, 1.0))
	
	# Run mode
	var rm = current_cfg.get("run_mode", "hold")
	_highlight_button(btn_run_hold, rm == "hold")
	_highlight_button(btn_run_toggle, rm == "toggle")
	_highlight_button(btn_run_auto, rm == "auto")
	if run_desc_label:
		match rm:
			"hold":
				run_desc_label.text = "🏃 Modo Segurar: O personagem corre somente enquanto o botão for mantido pressionado."
			"toggle":
				run_desc_label.text = "⚡ Modo Alternar: Toque uma vez no botão de corrida para travar o sprint rápido, toque de novo para soltar."
			"auto":
				run_desc_label.text = "🚀 Modo Sempre Correr: O personagem corre sempre na velocidade máxima (360px/s) automaticamente!"
	
	# Handedness
	var hand = current_cfg.get("handedness", "right")
	_highlight_button(btn_hand_right, hand == "right")
	_highlight_button(btn_hand_left, hand == "left")
	
	# Margin
	var mg = current_cfg.get("margin", 24.0)
	_highlight_button(btn_margin_12, is_equal_approx(mg, 12.0))
	_highlight_button(btn_margin_24, is_equal_approx(mg, 24.0))
	_highlight_button(btn_margin_48, is_equal_approx(mg, 48.0))

func _highlight_button(btn: Button, is_selected: bool) -> void:
	if not btn: return
	if is_selected:
		btn.modulate = Color(1.0, 0.9, 0.35, 1.0)
	else:
		btn.modulate = Color(0.7, 0.8, 0.95, 0.8)

func _set_scale(val: float) -> void:
	SoundManager.play_sfx("jump", 0.04)
	current_cfg["scale"] = val
	GameManager.save_touch_config(current_cfg)
	_update_ui_state()

func _set_opacity(val: float) -> void:
	SoundManager.play_sfx("jump", 0.04)
	current_cfg["opacity"] = val
	GameManager.save_touch_config(current_cfg)
	_update_ui_state()

func _set_run_mode(val: String) -> void:
	SoundManager.play_sfx("crystal", 0.05)
	current_cfg["run_mode"] = val
	GameManager.save_touch_config(current_cfg)
	_update_ui_state()

func _set_handedness(val: String) -> void:
	SoundManager.play_sfx("land", 0.05)
	current_cfg["handedness"] = val
	current_cfg["custom_positions"] = false
	GameManager.save_touch_config(current_cfg)
	_update_ui_state()

func _set_margin(val: float) -> void:
	SoundManager.play_sfx("jump", 0.04)
	current_cfg["margin"] = val
	current_cfg["custom_positions"] = false
	GameManager.save_touch_config(current_cfg)
	_update_ui_state()

func _enter_drag_mode() -> void:
	SoundManager.play_sfx("portal", 0.08)
	$Overlay.visible = false
	if drag_banner:
		drag_banner.visible = true
	is_in_drag_mode = true
	
	# Avisa o TouchControls para entrar no modo de arraste
	var tc = _find_touch_controls()
	if tc and tc.has_method("set_drag_editing"):
		tc.set_drag_editing(true)

func _exit_drag_mode() -> void:
	SoundManager.play_sfx("land", 0.08)
	var tc = _find_touch_controls()
	if tc and tc.has_method("set_drag_editing"):
		tc.set_drag_editing(false)
	
	is_in_drag_mode = false
	if drag_banner:
		drag_banner.visible = false
	$Overlay.visible = true
	_update_ui_state()

func _find_touch_controls() -> Node:
	return get_tree().root.find_child("TouchControls", true, false)

func _on_reset_pressed() -> void:
	SoundManager.play_sfx("land", 0.1)
	GameManager.reset_touch_config()
	current_cfg = GameManager.get_touch_config()
	_update_ui_state()

func _on_save_pressed() -> void:
	SoundManager.play_sfx("jump", 0.1)
	GameManager.save_touch_config(current_cfg)
	visible = false
	closed.emit()
