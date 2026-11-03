extends StaticBody2D
class_name CrumblingPlatform

@export var platform_size: Vector2 = Vector2(120.0, 24.0)
@export var crumble_delay: float = 0.65
@export var respawn_delay: float = 3.0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var trigger_area: Area2D = $TriggerArea
@onready var trigger_shape: CollisionShape2D = $TriggerArea/TriggerShape2D
@onready var particles: CPUParticles2D = $Particles

var is_crumbling: bool = false
var is_broken: bool = false
var crumble_timer: float = 0.0
var shake_offset: Vector2 = Vector2.ZERO
var base_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	base_pos = position
	trigger_area.body_entered.connect(_on_trigger_entered)
	
	if collision_shape and collision_shape.shape is RectangleShape2D:
		(collision_shape.shape as RectangleShape2D).size = platform_size
	if trigger_shape and trigger_shape.shape is RectangleShape2D:
		(trigger_shape.shape as RectangleShape2D).size = Vector2(platform_size.x - 4.0, 8.0)
		trigger_shape.position = Vector2(0, -platform_size.y / 2.0 - 4.0)

func _process(delta: float) -> void:
	if is_crumbling and not is_broken:
		crumble_timer -= delta
		# Efeito de tremor e estalo
		shake_offset = Vector2(randf_range(-2.5, 2.5), randf_range(-1.5, 1.5))
		if crumble_timer <= 0.0:
			_break_platform()
	else:
		shake_offset = Vector2.ZERO
		
	queue_redraw()

func _draw() -> void:
	if is_broken:
		return
		
	var w = platform_size.x
	var h = platform_size.y
	var rect = Rect2(-w / 2.0 + shake_offset.x, -h / 2.0 + shake_offset.y, w, h)
	
	# Gelo cristalino quebradiço
	var bg_col = Color(0.2, 0.45, 0.7, 0.9)
	var border_col = Color(0.65, 0.9, 1.0, 0.95) if not is_crumbling else Color(1.0, 0.6, 0.6, 1.0)
	draw_rect(rect, bg_col, true)
	draw_rect(rect, border_col, false, 2.0)
	
	# Rachaduras desenhadas no gelo
	var crack_col = Color(1.0, 1.0, 1.0, 0.85 if is_crumbling else 0.4)
	draw_line(Vector2(-w * 0.25, -h * 0.3) + shake_offset, Vector2(-w * 0.1, h * 0.3) + shake_offset, crack_col, 1.5)
	draw_line(Vector2(-w * 0.1, h * 0.3) + shake_offset, Vector2(w * 0.1, 0) + shake_offset, crack_col, 1.5)
	draw_line(Vector2(w * 0.1, 0) + shake_offset, Vector2(w * 0.28, -h * 0.25) + shake_offset, crack_col, 1.5)

func _on_trigger_entered(body: Node2D) -> void:
	if is_broken or is_crumbling:
		return
	if body is Player or body.is_in_group("player"):
		is_crumbling = true
		crumble_timer = crumble_delay
		SoundManager.play_sfx("land", 0.2)
		if particles:
			particles.emitting = true

func _break_platform() -> void:
	is_broken = true
	is_crumbling = false
	collision_shape.set_deferred("disabled", true)
	trigger_shape.set_deferred("disabled", true)
	SoundManager.play_sfx("stomp", 0.3)
	
	# Animação de queda e fade
	var tw = create_tween().set_parallel(true)
	tw.tween_property(self, "position:y", base_pos.y + 45.0, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tw.tween_property(self, "modulate:a", 0.0, 0.4)
	
	await get_tree().create_timer(respawn_delay).timeout
	_respawn_platform()

func _respawn_platform() -> void:
	position = base_pos
	modulate.a = 0.0
	is_broken = false
	collision_shape.set_deferred("disabled", false)
	trigger_shape.set_deferred("disabled", false)
	
	var tw = create_tween()
	tw.tween_property(self, "modulate:a", 1.0, 0.5)
