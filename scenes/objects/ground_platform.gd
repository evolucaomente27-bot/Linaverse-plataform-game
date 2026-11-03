@tool
extends StaticBody2D

@export var platform_size: Vector2 = Vector2(192, 64):
	set(val):
		platform_size = val
		_update_platform()

@export var one_way: bool = false:
	set(val):
		one_way = val
		_update_platform()

@onready var texture_rect: TextureRect = $TextureRect
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	_update_platform()

func _update_platform() -> void:
	if not is_inside_tree():
		return
	if texture_rect:
		texture_rect.size = platform_size
		texture_rect.position = -platform_size / 2.0
	if collision_shape:
		var rect = RectangleShape2D.new()
		rect.size = platform_size
		collision_shape.shape = rect
		collision_shape.position = Vector2.ZERO
		collision_shape.one_way_collision = one_way
