extends Area2D
class_name WindCurrent

@export var updraft_force: float = -520.0
@export var current_size: Vector2 = Vector2(80.0, 260.0)

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var particles: CPUParticles2D = $Particles

var players_inside: Array[Player] = []
var wave_time: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	if collision_shape and collision_shape.shape is RectangleShape2D:
		(collision_shape.shape as RectangleShape2D).size = current_size
		collision_shape.position = Vector2(0, -current_size.y / 2.0)
	
	if particles:
		particles.position = Vector2(0, 0)
		particles.emission_rect_extents = Vector2(current_size.x / 2.0, 8.0)
		particles.lifetime = current_size.y / 180.0

func _process(delta: float) -> void:
	wave_time += delta * 4.0
	queue_redraw()

func _physics_process(delta: float) -> void:
	for p in players_inside:
		if is_instance_valid(p):
			p.velocity.y = move_toward(p.velocity.y, updraft_force, 1800.0 * delta)
			p.air_jumps_left = GameManager.get_effective_air_jumps()

func _draw() -> void:
	var w = current_size.x
	var h = current_size.y
	var top_y = -h
	
	# Coluna translúcida de corrente de ar
	var col_bg = Color(0.4, 0.85, 1.0, 0.08)
	var col_border = Color(0.5, 0.9, 1.0, 0.25)
	var rect = Rect2(-w / 2.0, top_y, w, h)
	draw_rect(rect, col_bg, true)
	draw_rect(rect, col_border, false, 1.5)
	
	# Linhas ondulantes de corrente ascendente
	for i in range(3):
		var x_pos = -w / 3.0 + i * (w / 3.0)
		var pts = PackedVector2Array()
		var steps = 8
		for s in range(steps + 1):
			var y_pos = top_y + s * (h / steps)
			var sway = sin(wave_time + y_pos * 0.02 + i) * 6.0
			pts.append(Vector2(x_pos + sway, y_pos))
		draw_polyline(pts, Color(0.7, 0.95, 1.0, 0.35), 1.5)

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not players_inside.has(body):
		players_inside.append(body)
		SoundManager.play_sfx("jump", 0.05)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		players_inside.erase(body)
