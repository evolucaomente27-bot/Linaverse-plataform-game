extends CanvasLayer

@onready var avatar: TextureRect = $Control/MarginContainer/HBoxContainer/PlayerInfo/AvatarFrame/Avatar
@onready var avatar_frame: PanelContainer = $Control/MarginContainer/HBoxContainer/PlayerInfo/AvatarFrame
@onready var level_badge: Label = $Control/MarginContainer/HBoxContainer/PlayerInfo/VBoxContainer/LevelBadge
@onready var hearts_container: HBoxContainer = $Control/MarginContainer/HBoxContainer/PlayerInfo/VBoxContainer/Hearts
@onready var power_container: HBoxContainer = $Control/PowerContainer
@onready var score_label: Label = $Control/MarginContainer/HBoxContainer/Stats/Crystals/ScoreLabel
@onready var timer_label: Label = $Control/MarginContainer/HBoxContainer/Stats/TimerLabel

@onready var nix_quest_banner: PanelContainer = $Control/NixQuestBanner
@onready var nix_quest_title: Label = $Control/NixQuestBanner/Margin/HBox/VBox/QuestTitle
@onready var nix_ingredient_label: Label = $Control/NixQuestBanner/Margin/HBox/VBox/IngredientLabel
@onready var nix_icon_rect: TextureRect = $Control/NixQuestBanner/Margin/HBox/NixIcon

# 4 Expressões Faciais da Lina
var face_normal: Texture2D = preload("res://assets/sprites/ui/lina_face_normal.png")
var face_happy: Texture2D = preload("res://assets/sprites/ui/lina_face_happy.png")
var face_hurt: Texture2D = preload("res://assets/sprites/ui/lina_face_hurt.png")
var face_win: Texture2D = preload("res://assets/sprites/ui/lina_face_win.png")

var full_heart_tex: Texture2D = preload("res://assets/sprites/ui/heart_full.png")
var empty_heart_tex: Texture2D = preload("res://assets/sprites/ui/heart_empty.png")

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

var temp_face_timer: float = 0.0
var is_temp_face: bool = false
var is_level_finished: bool = false
var current_avatar_tween: Tween = null
var nix_quest_base_y: float = 14.0

var dash_badge: PanelContainer = null
var dash_label: Label = null
var dash_bar: ProgressBar = null

func _ready() -> void:
	if nix_quest_banner:
		nix_quest_base_y = nix_quest_banner.position.y
	
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.health_changed.connect(_on_health_changed)
	GameManager.player_damaged.connect(_on_player_damaged)
	GameManager.checkpoint_updated.connect(_on_checkpoint_reached)
	GameManager.level_completed.connect(_on_level_completed)
	GameManager.level_started.connect(_on_level_started)
	GameManager.powers_updated.connect(_update_powers_display)
	GameManager.shield_status_changed.connect(_on_shield_status_changed)
	GameManager.outfit_changed.connect(func(_id): _apply_base_face())
	GameManager.universe_shifted.connect(func(_u): _update_level_badge())
	
	GameManager.dash_state_changed.connect(_on_dash_state_changed)
	GameManager.powerup_activated.connect(func(_t, _d, _inf): _update_powers_display())
	GameManager.powerup_ended.connect(func(_t): _update_powers_display())
	
	_setup_dash_badge()
	_update_level_badge()
	_update_nix_quest_display()
	_update_hearts(GameManager.current_hp)
	_update_powers_display()
	_on_score_changed(GameManager.score, GameManager.total_crystals)
	_apply_base_face()

func _on_level_started(_lvl: int) -> void:
	is_level_finished = false
	is_temp_face = false
	_update_level_badge()
	_update_nix_quest_display()
	_update_hearts(GameManager.current_hp)
	_update_powers_display()
	_on_score_changed(GameManager.score, GameManager.total_crystals)
	_apply_base_face()

func _process(delta: float) -> void:
	var total_sec: float = GameManager.elapsed_time
	var mins: int = int(total_sec) / 60
	var secs: int = int(total_sec) % 60
	var ms: int = int((total_sec - int(total_sec)) * 100.0)
	
	var target = GameManager.get_speedrun_target(GameManager.current_level)
	var s_time = target.get("s", 25.0)
	var a_time = target.get("a", 35.0)
	
	if timer_label:
		if GameManager.is_chrono_active():
			var p = 0.7 + 0.3 * sin(Time.get_ticks_msec() * 0.015)
			timer_label.text = "⏳ %02d:%02d.%02d [PARADO]" % [mins, secs, ms]
			timer_label.modulate = Color(1.0, 0.7, 0.2, p)
		elif total_sec <= s_time:
			timer_label.text = "⚡ %02d:%02d.%02d [S]" % [mins, secs, ms]
			timer_label.modulate = Color(1.0, 0.85, 0.25)
		elif total_sec <= a_time:
			timer_label.text = "⭐ %02d:%02d.%02d [A]" % [mins, secs, ms]
			timer_label.modulate = Color(0.4, 0.9, 1.0)
		else:
			timer_label.text = "✦ %02d:%02d.%02d [B]" % [mins, secs, ms]
			timer_label.modulate = Color(0.85, 0.85, 0.95)
	
	# Efeito flutuante de onda senoidal suave no banner do Nix
	if nix_quest_banner:
		var bob = sin(Time.get_ticks_msec() * 0.003) * 2.5
		nix_quest_banner.position.y = nix_quest_base_y + bob
	
	# Alerta pulsante de vida crítica (1 HP)
	_process_critical_health_effects()
	
	# Atualização de barras de progresso dos power-ups ativos
	if not GameManager.active_powerups.is_empty():
		_update_powers_display()
	
	if is_temp_face and not is_level_finished:
		temp_face_timer -= delta
		if temp_face_timer <= 0.0:
			is_temp_face = false
			_apply_base_face()

func _process_critical_health_effects() -> void:
	if hearts_container and hearts_container.get_child_count() > 0:
		if GameManager.current_hp == 1:
			var heart = hearts_container.get_child(0) as TextureRect
			if heart:
				heart.pivot_offset = heart.size / 2.0
				var pulse = 1.0 + 0.18 * sin(Time.get_ticks_msec() * 0.012)
				heart.scale = Vector2(pulse, pulse)
				heart.modulate = Color(1.0, 0.35 + 0.35 * sin(Time.get_ticks_msec() * 0.012), 0.35)
		else:
			for i in range(hearts_container.get_child_count()):
				var h = hearts_container.get_child(i) as TextureRect
				if h:
					h.scale = Vector2.ONE
					h.modulate = Color.WHITE

func _update_level_badge() -> void:
	var u_data: Dictionary = GameManager.get_current_outfit_data()
	var lvl: int = GameManager.current_level
	var target = GameManager.get_speedrun_target(lvl)
	var rec = GameManager.get_speedrun_record_for_level(lvl)
	var pb_str = ""
	if rec.has("best_time"):
		var pb_sec = rec["best_time"]
		pb_str = " | 🏆 PB: %02d:%02d.%02d" % [int(pb_sec)/60, int(pb_sec)%60, int((pb_sec - int(pb_sec))*100)]
	
	if level_badge:
		var name_str: String = GameManager.get_stage_name(lvl)
		var u_icon: String = u_data.get("icon", "❄️")
		var u_name: String = u_data.get("name", "Clássica")
		level_badge.text = "FASE %d • %s [%s %s]" % [lvl, name_str, u_icon, u_name]
		level_badge.modulate = u_data.get("color", Color(0.4, 0.85, 1.0))
	
	if avatar_frame:
		var sb = avatar_frame.get_theme_stylebox("panel")
		if sb is StyleBoxFlat:
			var new_sb = sb.duplicate() as StyleBoxFlat
			new_sb.border_color = u_data.get("color", Color(0.35, 0.7, 0.95, 0.9))
			avatar_frame.add_theme_stylebox_override("panel", new_sb)

func _update_nix_quest_display() -> void:
	if not nix_quest_banner:
		return
	var lvl: int = GameManager.current_level
	var story: Dictionary = GameManager.get_stage_story(lvl)
	if nix_quest_title:
		if lvl < 12:
			nix_quest_title.text = "🐾 REMÉDIO DO NIX [%d/12]" % lvl
			nix_quest_title.modulate = Color(1.0, 0.85, 0.35)
		else:
			nix_quest_title.text = "💖 MISSÃO FINAL: CURA DO NIX! [12/12] 💖"
			nix_quest_title.modulate = Color(1.0, 0.9, 0.45)
			
	if nix_ingredient_label:
		var icon_str: String = story.get("icon", "🌿")
		var ing_name: String = story.get("ingredient", "Ingrediente Curativo")
		nix_ingredient_label.text = "%s %s" % [icon_str, ing_name]

func _update_powers_display() -> void:
	if not power_container:
		return
	
	for c in power_container.get_children():
		c.queue_free()
	
	# Power-ups de Cartas
	for p in GameManager.active_powers:
		var badge = PanelContainer.new()
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.08, 0.14, 0.26, 0.9)
		style.set_border_width_all(1)
		style.border_color = p.get("rarity_color", Color(0.4, 0.8, 1.0))
		style.set_corner_radius_all(6)
		badge.add_theme_stylebox_override("panel", style)
		
		var m = MarginContainer.new()
		m.add_theme_constant_override("margin_left", 6)
		m.add_theme_constant_override("margin_right", 6)
		m.add_theme_constant_override("margin_top", 2)
		m.add_theme_constant_override("margin_bottom", 2)
		badge.add_child(m)
		
		var lbl = Label.new()
		lbl.text = "%s %s" % [p.get("icon", "✦"), p.get("name", "Poder")]
		lbl.add_theme_font_size_override("font_size", 11)
		lbl.modulate = p.get("rarity_color", Color(0.4, 0.8, 1.0))
		m.add_child(lbl)
		power_container.add_child(badge)
	
	# Power-ups de Fase Coletados Ativos com Barra de Duração
	for p_type in GameManager.active_powerups.keys():
		var p_data = GameManager.active_powerups[p_type]
		var pup_badge = PanelContainer.new()
		var p_style = StyleBoxFlat.new()
		p_style.bg_color = Color(0.08, 0.12, 0.22, 0.95)
		p_style.set_border_width_all(2)
		var p_col: Color = p_data.get("color", Color.YELLOW)
		p_style.border_color = p_col
		p_style.set_corner_radius_all(6)
		pup_badge.add_theme_stylebox_override("panel", p_style)
		
		var m = MarginContainer.new()
		m.add_theme_constant_override("margin_left", 6)
		m.add_theme_constant_override("margin_right", 6)
		m.add_theme_constant_override("margin_top", 2)
		m.add_theme_constant_override("margin_bottom", 2)
		pup_badge.add_child(m)
		
		var vbox = VBoxContainer.new()
		vbox.add_theme_constant_override("separation", 2)
		m.add_child(vbox)
		
		var time_rem = max(0.0, p_data.get("time_left", 0.0))
		var duration = max(0.1, p_data.get("duration", 5.0))
		
		var pup_lbl = Label.new()
		pup_lbl.text = "%s %.1fs" % [p_data.get("icon", "⚡"), time_rem]
		pup_lbl.add_theme_font_size_override("font_size", 11)
		pup_lbl.modulate = p_col
		vbox.add_child(pup_lbl)
		
		var p_bar = ProgressBar.new()
		p_bar.custom_minimum_size = Vector2(44, 4)
		p_bar.max_value = 1.0
		p_bar.value = time_rem / duration
		p_bar.show_percentage = false
		
		var b_fill = StyleBoxFlat.new()
		b_fill.bg_color = p_col
		b_fill.set_corner_radius_all(2)
		var b_bg = StyleBoxFlat.new()
		b_bg.bg_color = Color(0.1, 0.15, 0.25, 0.8)
		b_bg.set_corner_radius_all(2)
		p_bar.add_theme_stylebox_override("fill", b_fill)
		p_bar.add_theme_stylebox_override("background", b_bg)
		vbox.add_child(p_bar)
		
		if time_rem <= 1.5:
			var blink = 0.5 + 0.5 * sin(Time.get_ticks_msec() * 0.02)
			pup_badge.modulate.a = blink
			
		power_container.add_child(pup_badge)
	
	# Indicador do Escudo de Aurora se ativo
	if GameManager.shield_active:
		var shield_badge = PanelContainer.new()
		var s_style = StyleBoxFlat.new()
		s_style.bg_color = Color(0.08, 0.22, 0.35, 0.95)
		s_style.set_border_width_all(1)
		s_style.border_color = Color(0.4, 1.0, 1.0)
		s_style.set_corner_radius_all(6)
		shield_badge.add_theme_stylebox_override("panel", s_style)
		
		var m = MarginContainer.new()
		m.add_theme_constant_override("margin_left", 6)
		m.add_theme_constant_override("margin_right", 6)
		m.add_theme_constant_override("margin_top", 3)
		m.add_theme_constant_override("margin_bottom", 3)
		shield_badge.add_child(m)
		
		var s_lbl = Label.new()
		s_lbl.text = "🛡️ ESCUDO"
		s_lbl.add_theme_font_size_override("font_size", 11)
		s_lbl.modulate = Color(0.4, 1.0, 1.0)
		m.add_child(s_lbl)
		power_container.add_child(shield_badge)

func _setup_dash_badge() -> void:
	if dash_badge:
		return
	dash_badge = PanelContainer.new()
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.14, 0.24, 0.9)
	style.set_border_width_all(1)
	style.border_color = Color(0.3, 0.95, 0.7, 0.8)
	style.set_corner_radius_all(6)
	dash_badge.add_theme_stylebox_override("panel", style)
	
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 6)
	margin.add_theme_constant_override("margin_right", 6)
	margin.add_theme_constant_override("margin_top", 2)
	margin.add_theme_constant_override("margin_bottom", 2)
	dash_badge.add_child(margin)
	
	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 6)
	margin.add_child(hbox)
	
	dash_label = Label.new()
	dash_label.text = "⚡ DASH [J/C]: PRONTO"
	dash_label.add_theme_font_size_override("font_size", 11)
	dash_label.modulate = Color(0.35, 1.0, 0.65)
	hbox.add_child(dash_label)
	
	dash_bar = ProgressBar.new()
	dash_bar.custom_minimum_size = Vector2(36, 6)
	dash_bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	dash_bar.max_value = 1.0
	dash_bar.value = 1.0
	dash_bar.show_percentage = false
	
	var fill_style = StyleBoxFlat.new()
	fill_style.bg_color = Color(0.35, 1.0, 0.65)
	fill_style.set_corner_radius_all(3)
	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = Color(0.1, 0.15, 0.25, 0.8)
	bg_style.set_corner_radius_all(3)
	
	dash_bar.add_theme_stylebox_override("fill", fill_style)
	dash_bar.add_theme_stylebox_override("background", bg_style)
	hbox.add_child(dash_bar)
	
	var parent_box = $Control/MarginContainer/HBoxContainer/PlayerInfo/VBoxContainer
	if parent_box:
		parent_box.add_child(dash_badge)

func _on_dash_state_changed(is_ready: bool, cooldown_ratio: float) -> void:
	if not dash_label:
		return
	if is_ready:
		dash_label.text = "⚡ DASH [J/C]: PRONTO"
		dash_label.modulate = Color(0.35, 1.0, 0.65)
		if dash_bar:
			dash_bar.value = 1.0
			var fill_sb = dash_bar.get_theme_stylebox("fill") as StyleBoxFlat
			if fill_sb:
				fill_sb.bg_color = Color(0.35, 1.0, 0.65)
		dash_badge.modulate.a = 1.0
		# Brilho rápido quando o dash recarrega
		dash_badge.pivot_offset = dash_badge.size / 2.0
		var tw = create_tween()
		tw.tween_property(dash_badge, "scale", Vector2(1.08, 1.08), 0.08).set_trans(Tween.TRANS_BACK)
		tw.tween_property(dash_badge, "scale", Vector2.ONE, 0.12)
	else:
		var cd_sec = max(0.1, (1.0 - cooldown_ratio) * 0.85)
		dash_label.text = "⚡ DASH (%.1fs)" % cd_sec
		dash_label.modulate = Color(0.7, 0.75, 0.85)
		if dash_bar:
			dash_bar.value = cooldown_ratio
			var fill_sb = dash_bar.get_theme_stylebox("fill") as StyleBoxFlat
			if fill_sb:
				fill_sb.bg_color = Color(0.4, 0.7, 1.0)
		dash_badge.modulate.a = 0.75

func _on_shield_status_changed(_active: bool) -> void:
	_update_powers_display()

func _apply_base_face() -> void:
	if is_level_finished:
		avatar.texture = face_win
		return
	if GameManager.current_hp <= 1:
		avatar.texture = face_hurt
	else:
		avatar.texture = GameManager.get_current_outfit_portrait()

func _set_temporary_face(tex: Texture2D, duration: float) -> void:
	if is_level_finished:
		return
	avatar.texture = tex
	is_temp_face = true
	temp_face_timer = duration

func _on_score_changed(current: int, total: int) -> void:
	score_label.text = "%d / %d" % [current, total]
	
	# Efeito de bump centralizado no score
	score_label.pivot_offset = score_label.size / 2.0
	var tween = create_tween()
	score_label.scale = Vector2(1.25, 1.25)
	tween.tween_property(score_label, "scale", Vector2.ONE, 0.18)
	
	# Quando coleta cristal, Lina sorri alegremente
	if current > 0 and not is_level_finished:
		_set_temporary_face(face_happy, 0.7)
		_animate_avatar_bounce()

func _on_player_damaged() -> void:
	_set_temporary_face(face_hurt, 1.2)
	_animate_avatar_shake()

func _on_checkpoint_reached(_pos: Vector2) -> void:
	if not is_level_finished:
		_set_temporary_face(face_happy, 1.0)
		_animate_avatar_bounce()

func _on_level_completed() -> void:
	is_level_finished = true
	avatar.texture = face_win
	_animate_avatar_victory()

func _on_health_changed(hp: int, _max_hp: int) -> void:
	_update_hearts(hp)
	if not is_temp_face:
		_apply_base_face()

func _update_hearts(hp: int) -> void:
	if not hearts_container:
		return
	
	while hearts_container.get_child_count() < GameManager.max_hp:
		var extra_heart = TextureRect.new()
		extra_heart.custom_minimum_size = Vector2(24, 24)
		extra_heart.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		extra_heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		extra_heart.texture = full_heart_tex
		hearts_container.add_child(extra_heart)
	
	while hearts_container.get_child_count() > GameManager.max_hp:
		var last = hearts_container.get_child(hearts_container.get_child_count() - 1)
		hearts_container.remove_child(last)
		last.queue_free()
	
	for i in range(hearts_container.get_child_count()):
		var h_rect = hearts_container.get_child(i) as TextureRect
		if h_rect:
			h_rect.texture = full_heart_tex if i < hp else empty_heart_tex

func _animate_avatar_bounce() -> void:
	if current_avatar_tween and current_avatar_tween.is_valid():
		current_avatar_tween.kill()
	
	avatar.pivot_offset = avatar.size / 2.0
	current_avatar_tween = create_tween()
	avatar.scale = Vector2(1.2, 1.2)
	current_avatar_tween.tween_property(avatar, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _animate_avatar_shake() -> void:
	if current_avatar_tween and current_avatar_tween.is_valid():
		current_avatar_tween.kill()
	
	avatar.pivot_offset = avatar.size / 2.0
	current_avatar_tween = create_tween()
	current_avatar_tween.tween_property(avatar, "position:x", avatar.position.x - 4, 0.04)
	current_avatar_tween.tween_property(avatar, "position:x", avatar.position.x + 6, 0.04)
	current_avatar_tween.tween_property(avatar, "position:x", avatar.position.x - 4, 0.04)
	current_avatar_tween.tween_property(avatar, "position:x", avatar.position.x, 0.04)

func _animate_avatar_victory() -> void:
	if current_avatar_tween and current_avatar_tween.is_valid():
		current_avatar_tween.kill()
	
	avatar.pivot_offset = avatar.size / 2.0
	current_avatar_tween = create_tween().set_loops(4)
	current_avatar_tween.tween_property(avatar, "scale", Vector2(1.25, 1.25), 0.18).set_trans(Tween.TRANS_SINE)
	current_avatar_tween.tween_property(avatar, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_SINE)
