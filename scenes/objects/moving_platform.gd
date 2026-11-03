extends AnimatableBody2D

@export var move_offset: Vector2 = Vector2(200, 0)
@export var duration: float = 3.0

var start_pos: Vector2

func _ready() -> void:
	start_pos = position

func _physics_process(delta: float) -> void:
	var t = fmod(Time.get_ticks_msec() * 0.001, duration * 2.0) / duration
	var factor = (1.0 - cos(t * PI)) * 0.5
	position = start_pos + move_offset * factor
