extends Area2D
class_name PowerUpItem

@export_enum("dash", "magnet", "chrono", "shield", "wings", "heal") var powerup_type: String = "dash"
@export var duration_override: float = -1.0

var base_y: float = 0.0
var float_phase: float = 0.0
var collected: bool = false
var orbit_angle: float = 0.0

@onready var icon_label: Label = $IconLabel
@onready var particles: CPUParticles2D = $Particles

const TYPE_COLORS: Dictionary = {
	"dash": Color(1.0, 0.88, 0.15),
	"magnet": Color(0.2, 0.92, 1.0),
	"chrono": Color(1.0, 0.65, 0.2),
	"shield": Color(0.35, 0.85, 1.0),
	"wings": Color(0.85, 0.72, 1.0),
	"heal": Color(1.0, 0.35, 0.55)
}

const TYPE_ICONS: Dictionary = {
	"dash": "⚡",
	"magnet": "🧲",
	"chrono": "⏳",
	"shield": "🛡️",
	"wings": "🪶",
	"heal": "💖"
}

func _ready() -> void:
	base_y = position.y
	float_phase = randf_range(0.0, TAU)
	body_entered.connect(_on_body_entered)
	_update_visuals()

func _update_visuals() -> void:
	if not icon_label:
		return
	icon_label.text = TYPE_ICONS.get(powerup_type, "✦")
	if particles:
		particles.color = TYPE_COLORS.get(powerup_type, Color.WHITE)

func _process(delta: float) -> void:
	if collected:
		return
	
	orbit_angle += 3.5 * delta
	position.y = base_y + sin(Time.get_ticks_msec() * 0.005 + float_phase) * 6.0
	queue_redraw()

func _draw() -> void:
	if collected:
		return
	var col: Color = TYPE_COLORS.get(powerup_type, Color.WHITE)
	var pulse: float = 0.8 + 0.2 * sin(Time.get_ticks_msec() * 0.008)
	
	# Glow externo translúcido
	draw_circle(Vector2.ZERO, 22.0 * pulse, Color(col.r, col.g, col.b, 0.22))
	# Anel externo
	draw_arc(Vector2.ZERO, 18.0, 0, TAU, 32, Color(col.r, col.g, col.b, 0.85), 2.2)
	# Fundo do medalhão
	draw_circle(Vector2.ZERO, 16.0, Color(0.08, 0.12, 0.22, 0.88))
	
	# Satélites em órbita
	for i in range(3):
		var ang = orbit_angle + i * (TAU / 3.0)
		var sat_pos = Vector2(cos(ang), sin(ang)) * 25.0
		draw_circle(sat_pos, 2.5, Color(col.r, col.g, col.b, 0.9))

func _on_body_entered(body: Node2D) -> void:
	if collected or not (body is Player or body.is_in_group("player")):
		return
	
	collected = true
	var p_info = GameManager.trigger_powerup(powerup_type, duration_override)
	
	if body.has_method("recharge_dash"):
		body.recharge_dash()
	
	_spawn_floating_text(p_info.get("name", "Power-Up!"), TYPE_COLORS.get(powerup_type, Color.WHITE))
	
	if particles:
		particles.emitting = true
	
	var tw = create_tween().set_parallel(true)
	tw.tween_property(self, "scale", Vector2(1.8, 1.8), 0.2).set_trans(Tween.TRANS_BACK)
	tw.tween_property(self, "modulate:a", 0.0, 0.2)
	await tw.finished
	queue_free()

func _spawn_floating_text(text: String, color: Color) -> void:
	var label = Label.new()
	label.text = text
	label.top_level = true
	label.global_position = global_position - Vector2(60, 30)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	label.add_theme_font_size_override("font_size", 14)
	label.z_index = 100
	get_parent().add_child(label)
	
	var tw = label.create_tween().set_parallel(true)
	tw.tween_property(label, "position:y", label.position.y - 45.0, 0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tw.tween_property(label, "modulate:a", 0.0, 0.8).set_delay(0.3)
	tw.chain().tween_callback(label.queue_free)
