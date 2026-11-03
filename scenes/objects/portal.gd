extends Area2D

var triggered: bool = false
@onready var sprite: Sprite2D = $Sprite2D
@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var portal_badge: PanelContainer = get_node_or_null("PortalBadge")

var time_passed: float = 0.0
var badge_base_y: float = -80.0

func _ready() -> void:
	z_index = 10
	body_entered.connect(_on_body_entered)
	if sprite:
		# Brilho vibrante e luminoso para visualização perfeita contra qualquer fundo
		sprite.modulate = Color(1.3, 1.4, 2.0, 1.0)
	if portal_badge:
		badge_base_y = portal_badge.position.y

func _process(delta: float) -> void:
	time_passed += delta
	var pulse = 1.0 + sin(time_passed * 3.5) * 0.1
	if sprite:
		sprite.scale = Vector2(pulse, pulse)
		sprite.rotation += delta * 0.6
		
	# Efeito flutuante suave na plaquinha de META / PORTAL
	if portal_badge:
		var bob = sin(time_passed * 3.0) * 3.5
		portal_badge.position.y = badge_base_y + bob
		
	queue_redraw()

func _draw() -> void:
	var t = time_passed
	var pulse = 0.85 + 0.15 * sin(t * 4.0)
	
	# 1. Coluna de Luz Celestial Vertical (Feixe Luminoso visível de longe)
	var beam_col = Color(0.25, 0.85, 1.0, 0.15 * pulse)
	var beam_core = Color(0.75, 0.95, 1.0, 0.28 * pulse)
	draw_rect(Rect2(-24, -650, 48, 650), beam_col)
	draw_rect(Rect2(-8, -650, 16, 650), beam_core)
	
	# 2. Halo de Brilho Cósmico Radial ao redor do portal
	draw_circle(Vector2.ZERO, 58.0 * pulse, Color(0.2, 0.75, 1.0, 0.22 * pulse))
	draw_circle(Vector2.ZERO, 38.0 * pulse, Color(0.5, 0.9, 1.0, 0.35 * pulse))
	draw_circle(Vector2.ZERO, 18.0 * pulse, Color(1.0, 1.0, 1.0, 0.65 * pulse))
	
	# 3. Anéis de Energia Mágica em Rotação Contrária
	var r1 = 44.0 + 3.0 * sin(t * 3.0)
	var r2 = 56.0 + 4.0 * cos(t * 2.5)
	var rot1 = t * 2.2
	var rot2 = -t * 1.8
	draw_arc(Vector2.ZERO, r1, rot1, rot1 + TAU * 0.75, 32, Color(0.3, 0.9, 1.0, 0.85), 3.0)
	draw_arc(Vector2.ZERO, r2, rot2, rot2 + TAU * 0.65, 32, Color(1.0, 0.85, 0.3, 0.8), 2.5)
	
	# 4. Reflexo de luz na plataforma do chão
	draw_set_transform(Vector2(0, 40), 0.0, Vector2(1.0, 0.35))
	draw_circle(Vector2.ZERO, 44.0 * pulse, Color(0.3, 0.9, 1.0, 0.45 * pulse))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _on_body_entered(body: Node2D) -> void:
	if triggered or not (body is Player or body.is_in_group("player")):
		return
	
	triggered = true
	SoundManager.play_sfx("portal")
	
	# Efeito de sucção e teleporte da Lina para o portal
	var tween = create_tween().set_parallel(true)
	tween.tween_property(body, "global_position", global_position, 0.6)
	tween.tween_property(body, "scale", Vector2.ZERO, 0.6)
	tween.tween_property(body, "rotation", TAU * 2.0, 0.6)
	
	await tween.finished
	GameManager.complete_level()
