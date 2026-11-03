extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var particles: CPUParticles2D = $SparkleParticles

var collected: bool = false
var base_y: float = 0.0
var float_offset: float = 0.0

func _ready() -> void:
	base_y = position.y
	float_offset = randf_range(0.0, 6.28)
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if not collected:
		# Movimento sutil de flutuação vertical
		position.y = base_y + sin(Time.get_ticks_msec() * 0.004 + float_offset) * 5.0
		
		# Magnetismo Polar (Carta de Poder ou Power-Up Ímã)
		var m_rad: float = GameManager.get_effective_magnet_radius()
		if m_rad > 0.0:
			var player = get_tree().get_first_node_in_group("player")
			if player and is_instance_valid(player):
				var dist = global_position.distance_to(player.global_position)
				if dist < m_rad:
					# Atrai suavemente e acelera quanto mais próximo
					var pull_speed = lerp(350.0, 950.0, 1.0 - (dist / m_rad))
					global_position = global_position.move_toward(player.global_position, pull_speed * delta)
					base_y = position.y

func _on_body_entered(body: Node2D) -> void:
	if collected or not (body is Player or body.is_in_group("player")):
		return
	
	collected = true
	GameManager.add_crystal(1)
	
	# Efeito visual de coleta
	particles.emitting = true
	var tween = create_tween().set_parallel(true)
	tween.tween_property(sprite, "scale", Vector2(1.6, 1.6), 0.25)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.25)
	tween.tween_property(sprite, "position:y", sprite.position.y - 20.0, 0.25)
	
	await tween.finished
	queue_free()
