extends Area2D
class_name BoostPad

@export var boost_speed: float = 880.0
@export var boost_direction: float = 1.0 # 1.0 para direita, -1.0 para esquerda
@export var pad_width: float = 96.0

@onready var particles: CPUParticles2D = $Particles
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var anim_phase: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if collision_shape and collision_shape.shape is RectangleShape2D:
		(collision_shape.shape as RectangleShape2D).size = Vector2(pad_width, 16.0)

func _process(delta: float) -> void:
	anim_phase += 8.0 * delta
	queue_redraw()

func _draw() -> void:
	var w = pad_width
	var h = 12.0
	var rect = Rect2(-w / 2.0, -h / 2.0, w, h)
	
	# Placa base metálica/tecnológica
	draw_rect(rect, Color(0.06, 0.1, 0.18, 0.95), true)
	draw_rect(rect, Color(0.2, 0.7, 1.0, 0.9), false, 2.0)
	
	# Setas neon direcionais animadas
	var arrow_count = int(w / 24.0)
	for i in range(arrow_count):
		var x_pos = -w / 2.0 + (i + 1) * (w / (arrow_count + 1))
		var offset = fmod(anim_phase + i * 1.2, 3.0)
		var glow = clamp(1.0 - (offset / 3.0), 0.3, 1.0)
		var col = Color(1.0, 0.85, 0.2, glow) if boost_direction > 0 else Color(0.3, 0.9, 1.0, glow)
		
		# Desenha seta '>' ou '<'
		var arrow_pts = PackedVector2Array()
		var dir_sign = 1.0 if boost_direction > 0 else -1.0
		arrow_pts.append(Vector2(x_pos - 6.0 * dir_sign, -4.0))
		arrow_pts.append(Vector2(x_pos + 6.0 * dir_sign, 0.0))
		arrow_pts.append(Vector2(x_pos - 6.0 * dir_sign, 4.0))
		draw_polyline(arrow_pts, col, 2.5)

func _on_body_entered(body: Node2D) -> void:
	if not (body is Player or body.is_in_group("player")):
		return
	
	# Impulso de velocidade no jogador
	body.velocity.x = boost_direction * boost_speed
	body.velocity.y = min(body.velocity.y, -140.0)
	body.scale = Vector2(1.35, 0.75)
	
	if body.has_method("recharge_dash"):
		body.recharge_dash()
	if body.has_method("apply_screen_shake"):
		body.apply_screen_shake(3.5)
	
	SoundManager.play_sfx("jump", 0.25)
	if particles:
		particles.direction = Vector2(boost_direction, -0.2)
		particles.restart()
		particles.emitting = true
