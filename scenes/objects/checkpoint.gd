extends Area2D

var is_activated: bool = false
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var particles: CPUParticles2D = $SparkleParticles

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	# Base estável de pedra e runas místicas (220px de largura) sob o checkpoint
	var p_rect = Rect2(-110, 22, 220, 20)
	var bg_col = Color(0.08, 0.12, 0.22, 0.96)
	var border_col = Color(0.4, 0.9, 1.0, 1.0) if is_activated else Color(0.3, 0.6, 0.8, 0.75)
	
	draw_rect(p_rect, bg_col)
	draw_rect(p_rect, border_col, false, 2.0)
	
	# Detalhe chanfrado nas pontas da base
	draw_line(Vector2(-110, 22), Vector2(-95, 42), border_col, 1.5)
	draw_line(Vector2(110, 22), Vector2(95, 42), border_col, 1.5)
	
	# Linha rúnica central que brilha intensamente quando ativado
	if is_activated:
		var pulse = 0.8 + 0.2 * sin(Time.get_ticks_msec() * 0.008)
		draw_line(Vector2(-90, 32), Vector2(90, 32), Color(0.3, 0.95, 1.0, 0.9 * pulse), 2.0)
		draw_circle(Vector2(0, 32), 4.0, Color(1.0, 1.0, 1.0, pulse))
	else:
		draw_line(Vector2(-90, 32), Vector2(90, 32), Color(0.2, 0.45, 0.65, 0.5), 1.5)

func _on_body_entered(body: Node2D) -> void:
	if is_activated or not (body is Player or body.is_in_group("player")):
		return
	
	is_activated = true
	sprite.play("lit")
	particles.emitting = true
	GameManager.set_checkpoint(global_position + Vector2(0, -20))
	
	# Efeito de brilho pulsar
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(1.25, 1.25), 0.15)
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.15)
