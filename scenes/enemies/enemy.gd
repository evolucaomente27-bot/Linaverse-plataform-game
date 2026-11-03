extends CharacterBody2D

@export var move_speed: float = 65.0
@export var patrol_distance: float = 160.0

var direction: float = 1.0
var start_x: float = 0.0
var is_dead: bool = false
const GRAVITY: float = 980.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var floor_detector: RayCast2D = $FloorDetector
@onready var wall_detector: RayCast2D = $WallDetector

func _ready() -> void:
	start_x = global_position.x
	$StompArea.body_entered.connect(_on_stomp_area_entered)
	$BodyArea.body_entered.connect(_on_body_area_entered)

var turn_cooldown: float = 0.0

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if turn_cooldown > 0.0:
		turn_cooldown -= delta
	else:
		# Checagem de limite de patrulha
		if abs(global_position.x - start_x) > patrol_distance:
			direction = -sign(global_position.x - start_x)
			_update_direction()
			turn_cooldown = 0.25
		# Checagem de colisão com paredes ou fim de plataforma
		elif is_on_wall() or wall_detector.is_colliding() or (is_on_floor() and not floor_detector.is_colliding()):
			direction *= -1.0
			_update_direction()
			turn_cooldown = 0.25
		
	velocity.x = direction * move_speed
	move_and_slide()

func _update_direction() -> void:
	sprite.flip_h = direction < 0.0
	floor_detector.position.x = 18.0 * direction
	wall_detector.target_position.x = 24.0 * direction

func _on_stomp_area_entered(body: Node2D) -> void:
	if is_dead:
		return
	if body is Player or body.is_in_group("player"):
		# Jogador pisou em cima do slime
		if body.velocity.y > 0.0 or body.global_position.y < global_position.y - 6:
			is_dead = true
			# Desativa imediatamente colisões para evitar qualquer dano ao jogador
			$BodyArea/CollisionShape2D.set_deferred("disabled", true)
			$StompArea/CollisionShape2D.set_deferred("disabled", true)
			$CollisionShape2D.set_deferred("disabled", true)
			
			SoundManager.play_sfx("stomp")
			body.bounce(-500.0)
			
			# Efeito de esmagamento
			var tween = create_tween().set_parallel(true)
			tween.tween_property(sprite, "scale", Vector2(1.5, 0.2), 0.15)
			tween.tween_property(sprite, "modulate:a", 0.0, 0.25)
			await tween.finished
			queue_free()

func _on_body_area_entered(body: Node2D) -> void:
	if is_dead:
		return
	# Se o jogador estiver caindo de cima, ignora para não penalizar o stomp
	if body.velocity.y > 0.0 and body.global_position.y < global_position.y - 4:
		return
	if body.has_method("take_damage"):
		body.take_damage(1, global_position)
