extends Area2D

@export var bounce_velocity: float = -850.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_bouncing: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if is_bouncing:
		return
	if body.has_method("bounce"):
		is_bouncing = true
		body.bounce(bounce_velocity)
		SoundManager.play_sfx("bounce", 0.1)
		sprite.play("bounce")
		
		var tween = create_tween()
		tween.tween_property(sprite, "scale", Vector2(1.3, 0.7), 0.08)
		tween.tween_property(sprite, "scale", Vector2(0.85, 1.25), 0.12)
		tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.15)
		await tween.finished
		sprite.play("idle")
		is_bouncing = false
