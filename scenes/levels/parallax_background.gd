extends ParallaxBackground

@onready var sky_sprite: Sprite2D = $LayerSky/Sprite2D
@onready var far_sprite: Sprite2D = $LayerFar/Sprite2D
@onready var mid_sprite: Sprite2D = $LayerMid/Sprite2D
@onready var trees_sprite: Sprite2D = $LayerTrees/Sprite2D
@onready var snow_particles: CPUParticles2D = $SnowParticles

var current_tween: Tween = null

func _ready() -> void:
	GameManager.universe_shifted.connect(func(_data): apply_universe_theme(false))
	GameManager.outfit_changed.connect(func(_id): apply_universe_theme(false))
	call_deferred("apply_universe_theme", true)

func apply_universe_theme(immediate: bool = false) -> void:
	var theme: Dictionary = GameManager.get_current_universe_theme()
	if theme.is_empty():
		return
	
	var duration: float = 0.0 if immediate else 0.45
	
	if not immediate:
		if current_tween and current_tween.is_valid():
			current_tween.kill()
		current_tween = create_tween().set_parallel(true)
	
	# 1. Carrega as texturas personalizadas e exclusivas do universo ativo
	var bg_tex: Dictionary = GameManager.get_current_universe_bg_textures()
	if not bg_tex.is_empty():
		if sky_sprite and bg_tex.has("sky") and ResourceLoader.exists(bg_tex["sky"]):
			sky_sprite.texture = load(bg_tex["sky"])
		if far_sprite and bg_tex.has("far") and ResourceLoader.exists(bg_tex["far"]):
			far_sprite.texture = load(bg_tex["far"])
		if mid_sprite and bg_tex.has("mid") and ResourceLoader.exists(bg_tex["mid"]):
			mid_sprite.texture = load(bg_tex["mid"])
		if trees_sprite and bg_tex.has("trees") and ResourceLoader.exists(bg_tex["trees"]):
			trees_sprite.texture = load(bg_tex["trees"])
	
	# Transição de cores e iluminação nas camadas de Parallax
	var sky_col: Color = theme.get("sky_color", Color.WHITE)
	var far_col: Color = theme.get("mountains_far_color", Color.WHITE)
	var mid_col: Color = theme.get("mountains_mid_color", Color.WHITE)
	var trees_col: Color = theme.get("trees_color", Color.WHITE)
	
	if immediate:
		if sky_sprite: sky_sprite.modulate = sky_col
		if far_sprite: far_sprite.modulate = far_col
		if mid_sprite: mid_sprite.modulate = mid_col
		if trees_sprite: trees_sprite.modulate = trees_col
	else:
		if sky_sprite and current_tween: current_tween.tween_property(sky_sprite, "modulate", sky_col, duration)
		if far_sprite and current_tween: current_tween.tween_property(far_sprite, "modulate", far_col, duration)
		if mid_sprite and current_tween: current_tween.tween_property(mid_sprite, "modulate", mid_col, duration)
		if trees_sprite and current_tween: current_tween.tween_property(trees_sprite, "modulate", trees_col, duration)
	
	# 2. Clima e partículas dinâmicas do universo ativo
	if snow_particles:
		snow_particles.color = theme.get("particles_color", Color.WHITE)
		snow_particles.gravity = theme.get("particles_gravity", Vector2(25, 45))
		var speed_range: Vector2 = theme.get("particles_speed", Vector2(40, 90))
		snow_particles.initial_velocity_min = speed_range.x
		snow_particles.initial_velocity_max = speed_range.y
		snow_particles.spread = theme.get("particles_spread", 20.0)
	
	# 3. Transforma o cenário, plataformas e objetos da fase atual
	_apply_theme_to_stage(theme, immediate, duration)

func _apply_theme_to_stage(theme: Dictionary, immediate: bool, duration: float) -> void:
	var level = get_parent()
	if not level:
		return
	
	var plat_col: Color = theme.get("platform_modulate", Color.WHITE)
	var ice_col: Color = theme.get("ice_modulate", Color.WHITE)
	var cryst_col: Color = theme.get("crystal_modulate", Color.WHITE)
	var amb_col: Color = theme.get("ambient_modulate", Color.WHITE)
	
	# Plataformas de neve, móveis e gelo
	var platforms = level.get_node_or_null("Platforms")
	if platforms:
		for p in platforms.get_children():
			var target_col = ice_col if ("Ice" in p.name or p.name.begins_with("Ice")) else plat_col
			if immediate:
				p.modulate = target_col
			elif current_tween:
				current_tween.tween_property(p, "modulate", target_col, duration)
	
	# Cristais colecionáveis
	var collectibles = level.get_node_or_null("Collectibles")
	if collectibles:
		for c in collectibles.get_children():
			if immediate:
				c.modulate = cryst_col
			elif current_tween:
				current_tween.tween_property(c, "modulate", cryst_col, duration)
	
	# Espinhos e perigos do cenário
	var hazards = level.get_node_or_null("Hazards")
	if hazards:
		for h in hazards.get_children():
			if immediate:
				h.modulate = ice_col
			elif current_tween:
				current_tween.tween_property(h, "modulate", ice_col, duration)
	
	# Objetos interativos (Portal, Checkpoints, Cogumelos)
	var interactive = level.get_node_or_null("InteractiveObjects")
	if interactive:
		for obj in interactive.get_children():
			var target_col = cryst_col if "Portal" in obj.name else plat_col
			if immediate:
				obj.modulate = target_col
			elif current_tween:
				current_tween.tween_property(obj, "modulate", target_col, duration)
	
	# Luz ambiente cósmica da fase (CanvasModulate)
	var canvas_mod = level.get_node_or_null("UniverseLighting") as CanvasModulate
	if not canvas_mod:
		canvas_mod = CanvasModulate.new()
		canvas_mod.name = "UniverseLighting"
		if level.is_node_ready():
			level.add_child(canvas_mod)
		else:
			level.add_child.call_deferred(canvas_mod)
	
	canvas_mod.color = amb_col
	if not immediate and current_tween:
		current_tween.tween_property(canvas_mod, "color", amb_col, duration)
