extends StaticBody2D
class_name BreakableWall

@export var wall_size: Vector2 = Vector2(36.0, 120.0)

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hit_area: Area2D = $HitArea
@onready var hit_shape: CollisionShape2D = $HitArea/HitShape2D
@onready var particles: CPUParticles2D = $Particles

var is_broken: bool = false

func _ready() -> void:
	hit_area.body_entered.connect(_on_hit_area_entered)
	
	if collision_shape and collision_shape.shape is RectangleShape2D:
		(collision_shape.shape as RectangleShape2D).size = wall_size
	if hit_shape and hit_shape.shape is RectangleShape2D:
		(hit_shape.shape as RectangleShape2D).size = wall_size + Vector2(12.0, 6.0)

func _draw() -> void:
	if is_broken:
		return
	var w = wall_size.x
	var h = wall_size.y
	var rect = Rect2(-w / 2.0, -h / 2.0, w, h)
	
	# Cristal rúnico azul-celeste translúcido
	draw_rect(rect, Color(0.12, 0.35, 0.65, 0.92), true)
	draw_rect(rect, Color(0.5, 0.9, 1.0, 0.9), false, 2.5)
	
	# Cristais internos e rachaduras
	var pulse = 0.7 + 0.3 * sin(Time.get_ticks_msec() * 0.005)
	var glow_col = Color(0.7, 0.95, 1.0, 0.8 * pulse)
	draw_line(Vector2(0, -h * 0.45), Vector2(0, h * 0.45), glow_col, 2.0)
	draw_line(Vector2(-w * 0.35, -h * 0.2), Vector2(w * 0.35, -h * 0.1), glow_col, 1.5)
	draw_line(Vector2(-w * 0.3, h * 0.2), Vector2(w * 0.3, h * 0.15), glow_col, 1.5)

func _on_hit_area_entered(body: Node2D) -> void:
	if is_broken:
		return
	if body is Player or body.is_in_group("player"):
		# Quebra se o jogador estiver em Dash ou caindo com Stomp
		if body.get("is_dashing") == true or body.velocity.y > 400.0:
			break_wall(body)

func break_wall(player: Node2D = null) -> void:
	if is_broken:
		return
	is_broken = true
	
	collision_shape.set_deferred("disabled", true)
	hit_shape.set_deferred("disabled", true)
	
	SoundManager.play_sfx("stomp", 0.1)
	SoundManager.play_sfx("crystal", 0.2)
	
	if player and player.has_method("apply_screen_shake"):
		player.apply_screen_shake(6.5)
	
	if particles:
		particles.emitting = true
	
	_spawn_break_popup()
	
	var tw = create_tween().set_parallel(true)
	tw.tween_property(self, "scale", Vector2(1.2, 1.2), 0.15)
	tw.tween_property(self, "modulate:a", 0.0, 0.15)
	await tw.finished
	await get_tree().create_timer(0.4).timeout
	queue_free()

func _spawn_break_popup() -> void:
	var label = Label.new()
	label.text = "✦ ATALHO SECRETO! ✦"
	label.top_level = true
	label.global_position = global_position - Vector2(70, 20)
	label.add_theme_color_override("font_color", Color(0.4, 0.95, 1.0))
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	label.add_theme_font_size_override("font_size", 14)
	label.z_index = 100
	get_parent().add_child(label)
	
	var tw = label.create_tween().set_parallel(true)
	tw.tween_property(label, "position:y", label.position.y - 40.0, 0.75).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tw.tween_property(label, "modulate:a", 0.0, 0.75).set_delay(0.25)
	tw.chain().tween_callback(label.queue_free)
