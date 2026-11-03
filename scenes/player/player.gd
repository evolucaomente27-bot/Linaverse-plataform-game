extends CharacterBody2D
class_name Player

# Constantes de movimentação e física base
const WALK_SPEED: float = 220.0
const RUN_SPEED: float = 360.0
const ACCELERATION: float = 1600.0
const FRICTION: float = 1400.0
const AIR_ACCEL: float = 1000.0
const AIR_FRICTION: float = 300.0

const JUMP_VELOCITY: float = -510.0
const DOUBLE_JUMP_VELOCITY: float = -460.0
const GRAVITY: float = 1350.0
const FALL_GRAVITY_MULT: float = 1.35
const MAX_FALL_SPEED: float = 850.0

# Timers de Game Feel
var coyote_timer: float = 0.0
const COYOTE_TIME: float = 0.12
var jump_buffer_timer: float = 0.0
const JUMP_BUFFER_TIME: float = 0.12

# Estado de pulos aéreos (suporte a duplo e triplo pulo via cartas)
var air_jumps_left: int = 1
var was_on_floor: bool = false
var is_invulnerable: bool = false
var invulnerable_timer: float = 0.0
const INVULNERABILITY_DURATION: float = 1.4

# Referências de nós
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dust_particles: CPUParticles2D = $DustParticles
@onready var camera: Camera2D = $Camera2D

var screen_shake_amount: float = 0.0
var _prev_jump_key_down: bool = false

# === Nova Mecânica de Dash da Lina ===
var is_dashing: bool = false
var dash_timer: float = 0.0
const DASH_SPEED: float = 750.0
const DASH_DURATION: float = 0.18
var dash_cooldown: float = 0.0
const DASH_COOLDOWN_BASE: float = 0.85
var dash_direction: float = 1.0
var _prev_dash_key_down: bool = false
var _afterimage_timer: float = 0.0

func _ready() -> void:
	add_to_group("player")
	# Posiciona no checkpoint do GameManager
	global_position = GameManager.checkpoint_pos
	velocity = Vector2.ZERO
	scale = Vector2.ONE
	rotation = 0.0
	air_jumps_left = GameManager.max_air_jumps
	if camera:
		camera.reset_smoothing()
	
	GameManager.player_damaged.connect(_on_player_damaged)
	GameManager.player_died.connect(_on_player_died)
	GameManager.shield_status_changed.connect(_on_shield_changed)
	GameManager.outfit_changed.connect(_on_outfit_changed)
	GameManager.level_started.connect(_on_level_started)
	
	_apply_outfit(GameManager.current_outfit)

func _on_level_started(_level_idx: int) -> void:
	global_position = GameManager.checkpoint_pos
	velocity = Vector2.ZERO
	scale = Vector2.ONE
	rotation = 0.0
	is_invulnerable = false
	invulnerable_timer = 0.0
	air_jumps_left = GameManager.max_air_jumps
	if camera:
		camera.reset_smoothing()
	if sprite:
		sprite.play("idle")

func _on_outfit_changed(outfit_id: String) -> void:
	_apply_outfit(outfit_id)

func _apply_outfit(_outfit_id: String) -> void:
	if not sprite:
		return
	var frames: SpriteFrames = GameManager.get_current_outfit_sprite_frames()
	if frames:
		var current_anim: StringName = sprite.animation
		var current_frame: int = sprite.frame
		var current_progress: float = sprite.frame_progress
		sprite.sprite_frames = frames
		if sprite.sprite_frames.has_animation(current_anim):
			sprite.play(current_anim)
			sprite.set_frame_and_progress(current_frame, current_progress)
		else:
			sprite.play("idle")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		GameManager.restart_level()
		get_viewport().set_input_as_handled()
		return
	
	if GameManager.is_game_over or GameManager.is_level_completed:
		return

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	# Aura visual do Escudo de Aurora quando ativo
	if GameManager.shield_active:
		var pulse = 0.8 + 0.2 * sin(Time.get_ticks_msec() * 0.007)
		draw_arc(Vector2(0, -18), 28.0, 0, TAU, 32, Color(0.35, 0.9, 1.0, 0.75 * pulse), 2.5)
		draw_circle(Vector2(0, -18), 27.0, Color(0.2, 0.7, 1.0, 0.15 * pulse))
	
	# Aura do Hiper Dash Turbo
	if GameManager.is_powerup_active("dash"):
		var p_dash = 0.7 + 0.3 * sin(Time.get_ticks_msec() * 0.015)
		draw_arc(Vector2(0, -18), 22.0, 0, TAU, 16, Color(1.0, 0.85, 0.2, 0.6 * p_dash), 2.0)
	
	# Aura das Asas Celestiais
	if GameManager.is_powerup_active("wings"):
		var p_wings = 0.7 + 0.3 * sin(Time.get_ticks_msec() * 0.008)
		draw_arc(Vector2(0, -22), 24.0, PI * 0.8, PI * 2.2, 16, Color(0.85, 0.75, 1.0, 0.5 * p_wings), 2.0)
	
	# Aura do Ímã Astral
	if GameManager.is_powerup_active("magnet"):
		var p_mag = fmod(Time.get_ticks_msec() * 0.003, 1.0)
		draw_arc(Vector2(0, -18), 15.0 + p_mag * 35.0, 0, TAU, 24, Color(0.25, 0.9, 1.0, (1.0 - p_mag) * 0.45), 1.5)

func _on_shield_changed(_active: bool) -> void:
	queue_redraw()

func _physics_process(delta: float) -> void:
	if GameManager.is_game_over or GameManager.is_level_completed:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	# Gerenciamento de invulnerabilidade
	if is_invulnerable:
		invulnerable_timer -= delta
		# Efeito de piscar
		sprite.visible = fmod(invulnerable_timer, 0.15) > 0.075
		if invulnerable_timer <= 0.0:
			is_invulnerable = false
			sprite.visible = true
			sprite.modulate = Color(1, 1, 1, 1)

	# Detecção robusta de pulo com edge detection real para teclas diretas
	var direct_jump_down: bool = (
		Input.is_key_pressed(KEY_SPACE) or 
		Input.is_physical_key_pressed(KEY_SPACE) or 
		Input.is_key_pressed(KEY_W) or 
		Input.is_physical_key_pressed(KEY_W) or 
		Input.is_key_pressed(KEY_UP) or 
		Input.is_physical_key_pressed(KEY_UP)
	)
	var direct_jump_just_pressed: bool = direct_jump_down and not _prev_jump_key_down
	var direct_jump_just_released: bool = not direct_jump_down and _prev_jump_key_down
	_prev_jump_key_down = direct_jump_down

	var jump_just_pressed: bool = (
		Input.is_action_just_pressed("jump") or 
		Input.is_action_just_pressed("ui_up") or 
		Input.is_action_just_pressed("ui_accept") or 
		direct_jump_just_pressed
	)
	var jump_just_released: bool = (
		Input.is_action_just_released("jump") or 
		Input.is_action_just_released("ui_up") or 
		Input.is_action_just_released("ui_accept") or 
		direct_jump_just_released
	)

	# Gerenciamento do Dash
	if dash_cooldown > 0.0:
		dash_cooldown -= delta
		GameManager.dash_state_changed.emit(dash_cooldown <= 0.0, 1.0 - (dash_cooldown / DASH_COOLDOWN_BASE))
	elif not is_dashing:
		GameManager.dash_state_changed.emit(true, 1.0)
	
	if is_dashing:
		dash_timer -= delta
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0.0
		_afterimage_timer -= delta
		if _afterimage_timer <= 0.0:
			_spawn_afterimage()
			_afterimage_timer = 0.035
		
		_check_dash_collisions()
		move_and_slide()
		
		if dash_timer <= 0.0:
			is_dashing = false
			velocity.x *= 0.4
		return

	# Gravidade com queda mais rápida
	if not is_on_floor():
		var current_grav = GRAVITY
		if velocity.y > 0.0:
			# Carta Pena de Neve ou Power-Up Asas - Planeio suave se segurar botão de pulo na queda
			if (GameManager.feather_fall_active or GameManager.is_powerup_active("wings")) and (Input.is_action_pressed("jump") or direct_jump_down):
				current_grav = GRAVITY * 0.35
				velocity.y = min(velocity.y, 220.0)
			else:
				current_grav *= FALL_GRAVITY_MULT
		velocity.y = min(velocity.y + current_grav * delta, MAX_FALL_SPEED)
		coyote_timer -= delta
	else:
		coyote_timer = COYOTE_TIME
		air_jumps_left = GameManager.get_effective_air_jumps()
		# Efeito de aterrissagem (Squash)
		if not was_on_floor:
			scale = Vector2(1.22, 0.8)
			SoundManager.play_sfx("land", 0.1)
			_spawn_land_dust()
	
	was_on_floor = is_on_floor()

	# Jump Buffer
	if jump_just_pressed:
		jump_buffer_timer = JUMP_BUFFER_TIME
	else:
		jump_buffer_timer -= delta

	# Execução do pulo primário (com coyote time e jump buffer)
	if jump_buffer_timer > 0.0 and coyote_timer > 0.0:
		_execute_jump(JUMP_VELOCITY)
		jump_buffer_timer = 0.0
		coyote_timer = 0.0
	elif jump_just_pressed and air_jumps_left > 0 and not is_on_floor():
		# Pulos aéreos mágicos (Duplo / Triplo / Asas)
		air_jumps_left -= 1
		_execute_double_jump()
		jump_buffer_timer = 0.0

	# Pulo variável (cortar pulo se soltar botão antes do topo)
	if jump_just_released and velocity.y < -120.0:
		velocity.y *= 0.5

	# Movimento Horizontal (Action + UI Fallback + Teclas Diretas Físicas e Lógicas)
	var input_dir: float = Input.get_axis("move_left", "move_right")
	if input_dir == 0.0:
		input_dir = Input.get_axis("ui_left", "ui_right")
	if input_dir == 0.0:
		var left_press: bool = (
			Input.is_key_pressed(KEY_A) or 
			Input.is_physical_key_pressed(KEY_A) or 
			Input.is_key_pressed(KEY_LEFT) or 
			Input.is_physical_key_pressed(KEY_LEFT)
		)
		var right_press: bool = (
			Input.is_key_pressed(KEY_D) or 
			Input.is_physical_key_pressed(KEY_D) or 
			Input.is_key_pressed(KEY_RIGHT) or 
			Input.is_physical_key_pressed(KEY_RIGHT)
		)
		if left_press and not right_press:
			input_dir = -1.0
		elif right_press and not left_press:
			input_dir = 1.0

	# Detecção de Dash (J, K, C, X, Z ou ação "dash")
	var direct_dash_down: bool = (
		Input.is_key_pressed(KEY_J) or 
		Input.is_physical_key_pressed(KEY_J) or 
		Input.is_key_pressed(KEY_K) or 
		Input.is_physical_key_pressed(KEY_K) or 
		Input.is_key_pressed(KEY_C) or 
		Input.is_physical_key_pressed(KEY_C) or 
		Input.is_key_pressed(KEY_X) or 
		Input.is_physical_key_pressed(KEY_X) or 
		Input.is_key_pressed(KEY_Z) or 
		Input.is_physical_key_pressed(KEY_Z) or 
		Input.is_action_just_pressed("dash")
	)
	var direct_dash_just_pressed: bool = direct_dash_down and not _prev_dash_key_down
	_prev_dash_key_down = direct_dash_down

	if direct_dash_just_pressed and dash_cooldown <= 0.0 and not is_dashing:
		_execute_dash(input_dir)
		return

	var is_running: bool = (
		Input.is_action_pressed("run") or 
		Input.is_key_pressed(KEY_SHIFT) or 
		Input.is_physical_key_pressed(KEY_SHIFT) or
		GameManager.is_auto_run_active()
	)
	var active_speed_mult: float = GameManager.get_active_speed_multiplier()
	var target_speed: float = (RUN_SPEED if is_running else WALK_SPEED) * active_speed_mult
	
	var accel = (ACCELERATION if is_on_floor() else AIR_ACCEL) * active_speed_mult
	var fric = FRICTION if is_on_floor() else AIR_FRICTION

	if input_dir != 0.0:
		velocity.x = move_toward(velocity.x, input_dir * target_speed, accel * delta)
		sprite.flip_h = input_dir < 0.0
		# Partículas de corrida
		if is_on_floor() and abs(velocity.x) > WALK_SPEED:
			dust_particles.emitting = true
		else:
			dust_particles.emitting = false
	else:
		velocity.x = move_toward(velocity.x, 0.0, fric * delta)
		dust_particles.emitting = false

	# Movimento e colisão
	move_and_slide()

	# Retorno suave de Squash & Stretch para escala 1.0
	scale = scale.lerp(Vector2.ONE, 12.0 * delta)

	# Atualizar animação
	_update_animation(input_dir, is_running)

	# Atualizar screen shake da câmera
	_process_screen_shake(delta)

	# Queda do abismo (respawn ágil ao cair das plataformas)
	if global_position.y > 680.0:
		_fall_out_of_world()

func _execute_jump(force: float) -> void:
	velocity.y = force * GameManager.jump_mult
	scale = Vector2(0.82, 1.25) # Stretch
	SoundManager.play_sfx("jump", 0.08)
	_spawn_land_dust()

func _execute_double_jump() -> void:
	velocity.y = DOUBLE_JUMP_VELOCITY * GameManager.jump_mult
	scale = Vector2(0.85, 1.22)
	SoundManager.play_sfx("double_jump", 0.1)
	_spawn_double_jump_sparkles()

func bounce(bounce_force: float = -680.0) -> void:
	velocity.y = bounce_force * GameManager.jump_mult
	scale = Vector2(0.8, 1.3)
	air_jumps_left = GameManager.get_effective_air_jumps()
	recharge_dash()

func recharge_dash() -> void:
	dash_cooldown = 0.0
	GameManager.dash_state_changed.emit(true, 1.0)

func _execute_dash(input_dir: float = 0.0) -> void:
	is_dashing = true
	dash_timer = DASH_DURATION
	var cd = 0.25 if GameManager.is_powerup_active("dash") else DASH_COOLDOWN_BASE
	dash_cooldown = cd
	
	if input_dir != 0.0:
		dash_direction = sign(input_dir)
	else:
		dash_direction = -1.0 if sprite.flip_h else 1.0
	
	velocity = Vector2(dash_direction * DASH_SPEED, 0.0)
	scale = Vector2(1.35, 0.75)
	is_invulnerable = true
	invulnerable_timer = max(invulnerable_timer, DASH_DURATION + 0.12)
	apply_screen_shake(4.0)
	SoundManager.play_sfx("double_jump", 0.2)
	_spawn_afterimage()
	_spawn_land_dust()
	GameManager.dash_state_changed.emit(false, 0.0)

func _spawn_afterimage() -> void:
	if not sprite or not sprite.sprite_frames:
		return
	var anim_name = sprite.animation
	var cur_frame = sprite.frame
	if not sprite.sprite_frames.has_animation(anim_name):
		return
	var frame_tex = sprite.sprite_frames.get_frame_texture(anim_name, cur_frame)
	if not frame_tex:
		return
		
	var ghost = Sprite2D.new()
	ghost.texture = frame_tex
	ghost.global_position = sprite.global_position
	ghost.scale = sprite.scale * scale
	ghost.flip_h = sprite.flip_h
	ghost.modulate = Color(1.0, 0.85, 0.2, 0.75) if GameManager.is_powerup_active("dash") else Color(0.3, 0.85, 1.0, 0.65)
	ghost.z_index = max(0, z_index - 1)
	get_parent().add_child(ghost)
	
	var tw = ghost.create_tween()
	tw.tween_property(ghost, "modulate:a", 0.0, 0.22)
	tw.tween_callback(ghost.queue_free)

func _check_dash_collisions() -> void:
	for i in range(get_slide_collision_count()):
		var col = get_slide_collision(i)
		var collider = col.get_collider()
		if collider:
			if collider.has_method("break_wall"):
				collider.break_wall()
			elif collider.get_parent() and collider.get_parent().has_method("break_wall"):
				collider.get_parent().break_wall()
			elif collider is CharacterBody2D and collider.has_method("_on_stomp_area_entered"):
				collider._on_stomp_area_entered(self)
				apply_screen_shake(6.0)


func _update_animation(input_dir: float, is_running: bool) -> void:
	if is_invulnerable and invulnerable_timer > (INVULNERABILITY_DURATION * GameManager.invulnerable_mult) - 0.2:
		sprite.play("hurt")
		return
		
	if not is_on_floor():
		if velocity.y < -30.0:
			sprite.play("jump")
		else:
			sprite.play("fall")
	else:
		if abs(velocity.x) > 10.0:
			if is_running and abs(velocity.x) > WALK_SPEED * 0.9:
				sprite.play("run")
			else:
				sprite.play("walk")
		else:
			sprite.play("idle")

func _spawn_land_dust() -> void:
	dust_particles.restart()
	dust_particles.emitting = true

func _spawn_double_jump_sparkles() -> void:
	dust_particles.restart()
	dust_particles.emitting = true

func take_damage(amount: int = 1, source_pos: Vector2 = Vector2.ZERO) -> void:
	if is_invulnerable or GameManager.is_game_over or GameManager.is_level_completed:
		return
	
	is_invulnerable = true
	invulnerable_timer = INVULNERABILITY_DURATION * GameManager.invulnerable_mult
	
	# Direção de knockback calculada para longe da fonte de dano
	var knockback_dir_x = 1.0
	if source_pos != Vector2.ZERO:
		knockback_dir_x = 1.0 if global_position.x >= source_pos.x else -1.0
	else:
		knockback_dir_x = -1.0 if sprite.flip_h else 1.0
	
	velocity = Vector2(knockback_dir_x * 240.0, -320.0)
	scale = Vector2(1.2, 0.8)
	screen_shake_amount = 9.0
	
	GameManager.damage_player(amount)

func _on_player_damaged() -> void:
	# Chamado quando GameManager emite dano
	if not is_invulnerable:
		is_invulnerable = true
		invulnerable_timer = INVULNERABILITY_DURATION * GameManager.invulnerable_mult
		screen_shake_amount = 8.0

func _on_player_died() -> void:
	velocity = Vector2.ZERO
	sprite.play("hurt")
	is_invulnerable = true

func _fall_out_of_world() -> void:
	if is_invulnerable:
		global_position = GameManager.checkpoint_pos
		velocity = Vector2.ZERO
		scale = Vector2.ONE
		rotation = 0.0
		if camera:
			camera.reset_smoothing()
		return
	
	take_damage(1, global_position)
	global_position = GameManager.checkpoint_pos
	velocity = Vector2.ZERO
	scale = Vector2.ONE
	rotation = 0.0
	if camera:
		camera.reset_smoothing()

func apply_screen_shake(amount: float = 6.0) -> void:
	screen_shake_amount = amount

func _process_screen_shake(delta: float) -> void:
	if screen_shake_amount > 0.0:
		screen_shake_amount = move_toward(screen_shake_amount, 0.0, 18.0 * delta)
		camera.offset = Vector2(
			randf_range(-screen_shake_amount, screen_shake_amount),
			randf_range(-screen_shake_amount, screen_shake_amount)
		)
	else:
		camera.offset = Vector2.ZERO
