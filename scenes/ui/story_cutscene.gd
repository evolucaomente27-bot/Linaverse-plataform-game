extends Control

@onready var cutscene_image: TextureRect = $ImageContainer/CutsceneImage
@onready var image_container: Control = $ImageContainer
@onready var dialog_panel: PanelContainer = $DialogBox
@onready var speaker_badge: Label = $DialogBox/Margin/VBox/HeaderRow/SpeakerBadge
@onready var slide_counter: Label = $DialogBox/Margin/VBox/HeaderRow/SlideCounter
@onready var story_label: RichTextLabel = $DialogBox/Margin/VBox/StoryText
@onready var continue_prompt: Label = $DialogBox/Margin/VBox/BottomRow/ContinuePrompt
@onready var skip_btn: Button = $TopBar/SkipBtn
@onready var fade_rect: ColorRect = $FadeOverlay
@onready var snow_particles: CPUParticles2D = $SnowParticles

const CUTSCENE_SLIDES: Array[Dictionary] = [
	{
		"id": 1,
		"title": "CAPÍTULO 1 • DIAS DE PAZ",
		"speaker": "❄️ NARRADOR",
		"speaker_color": Color(0.4, 0.85, 1.0),
		"image": "res://assets/sprites/story/cutscene_1_friends.png",
		"text": "Nas encostas geladas do Linaverse, a jovem [b]Lina[/b] e seu fiel gatinho [b]Nix[/b] eram inseparáveis. Entre a lareira quentinha da cabana e as brincadeiras na neve fofa, cada dia era repleto de carinho, paz e alegria.",
		"sfx": "crystal",
		"zoom_start": 1.0,
		"zoom_end": 1.04
	},
	{
		"id": 2,
		"title": "CAPÍTULO 2 • A FEBRE MÁGICA",
		"speaker": "🌡️ URGÊNCIA",
		"speaker_color": Color(1.0, 0.45, 0.45),
		"image": "res://assets/sprites/story/nix_sick.png",
		"text": "Porém, em uma manhã tempestuosa, Nix não acordou para brincar. O pequeno gatinho ardia em uma perigosa [color=#ff6b6b][b]febre cósmica dimensional[/b][/color]. Seus miados eram fraquinhos e seu corpinho tremia de frio sob a mantinha azul...",
		"sfx": "hurt",
		"zoom_start": 1.0,
		"zoom_end": 1.05
	},
	{
		"id": 3,
		"title": "CAPÍTULO 3 • A ÚNICA ESPERANÇA",
		"speaker": "✨ O ELIXIR ANCESTRAL",
		"speaker_color": Color(1.0, 0.85, 0.3),
		"image": "res://assets/sprites/story/nix_medicine.png",
		"text": "Os antigos pergaminhos revelaram o segredo: a única cura existente é o milagroso [color=#ffd700][b]Elixir Celestial das 12 Essências[/b][/color]! Doze ingredientes sagrados estão dispersos através dos [b]6 universos paralelos[/b] do Linaverse.",
		"sfx": "checkpoint",
		"zoom_start": 1.0,
		"zoom_end": 1.06
	},
	{
		"id": 4,
		"title": "CAPÍTULO 4 • A CORRIDA CONTRA O TEMPO",
		"speaker": "⚡ LINA",
		"speaker_color": Color(0.3, 0.95, 1.0),
		"image": "res://assets/sprites/story/cutscene_4_dash.png",
		"text": "\"Aguente firme, Nix! Não vou deixar você sofrer!\"\n\nO tempo está se esgotando! Lina amarrou seu cachecol, acionou seus poderes de [color=#00e5ff][b]Dash[/b][/color] e partiu em disparada em um [color=#ffd700][b]SPEEDRUN[/b][/color] desesperado através de 12 fases para reunir os remédios e salvar seu melhor amigo!",
		"sfx": "win",
		"zoom_start": 1.0,
		"zoom_end": 1.05
	}
]

var current_slide_idx: int = 0
var is_typing: bool = false
var typewriter_tween: Tween = null
var zoom_tween: Tween = null
var is_transitioning: bool = false
var prompt_time: float = 0.0

func _ready() -> void:
	skip_btn.pressed.connect(_on_skip_pressed)
	skip_btn.focus_entered.connect(func(): SoundManager.play_sfx("land", 0.05))
	
	fade_rect.visible = true
	fade_rect.modulate.a = 1.0
	
	SoundManager.play_bgm()
	
	if "--test-cutscene" in OS.get_cmdline_args() or "--test-cutscene" in OS.get_cmdline_user_args():
		print("\n=======================================================")
		print("=== TESTE AUTOMATIZADO: CUTSCENE DE HISTÓRIA DO NIX ===")
		print("=======================================================")
		assert(CUTSCENE_SLIDES.size() == 4, "A cutscene deve conter 4 capítulos!")
		for i in range(CUTSCENE_SLIDES.size()):
			var s = CUTSCENE_SLIDES[i]
			assert(ResourceLoader.exists(s["image"]), "Imagem do slide %d não existe: %s" % [i, s["image"]])
			assert(s["text"] != "", "Texto do slide %d vazio!" % i)
			assert(s.has("speaker"), "Slide %d sem speaker!" % i)
			_show_slide(i)
			assert(cutscene_image.texture != null, "Textura nula no slide %d!" % i)
			print("[PASS] Slide %d: %s carregado com sucesso!" % [i + 1, s["title"]])
		print("[PASS] Todos os 4 slides da cutscene validados com sucesso!")
		print("=======================================================\n")
		get_tree().quit(0)
		return

	if "--screenshot-cutscene" in OS.get_cmdline_args() or "--screenshot-cutscene" in OS.get_cmdline_user_args():
		fade_rect.visible = false
		for i in range(CUTSCENE_SLIDES.size()):
			_show_slide(i)
			cutscene_image.modulate.a = 1.0
			if story_label:
				story_label.visible_ratio = 1.0
			await get_tree().create_timer(0.4).timeout
			cutscene_image.modulate.a = 1.0
			var tex = get_viewport().get_texture()
			if tex:
				var img = tex.get_image()
				if img:
					img.save_png("screenshot_cutscene_slide_%d.png" % (i + 1))
					print("Cutscene slide %d captured!" % (i + 1))
		get_tree().quit(0)
		return


	# Fade in inicial suave
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 0.5)
	await tween.finished
	
	_show_slide(0)


func _process(delta: float) -> void:
	prompt_time += delta
	if continue_prompt:
		continue_prompt.modulate.a = 0.45 + 0.55 * sin(prompt_time * 4.0)

func _show_slide(idx: int) -> void:
	if idx < 0 or idx >= CUTSCENE_SLIDES.size():
		_finish_cutscene()
		return
		
	current_slide_idx = idx
	var slide: Dictionary = CUTSCENE_SLIDES[idx]
	
	# Atualiza cabeçalho e speaker
	if slide_counter:
		slide_counter.text = "%d / %d" % [idx + 1, CUTSCENE_SLIDES.size()]
	if speaker_badge:
		speaker_badge.text = "[ %s • %s ]" % [slide.get("title", ""), slide.get("speaker", "")]
		speaker_badge.modulate = slide.get("speaker_color", Color.CYAN)
		
	# Efeito sonoro do slide
	var sfx: String = slide.get("sfx", "")
	if sfx != "":
		SoundManager.play_sfx(sfx, 0.12)
		
	# Transição visual da imagem (Crossfade suave)
	var tex = load(slide["image"])
	if tex and cutscene_image:
		var img_tween = create_tween()
		img_tween.tween_property(cutscene_image, "modulate:a", 0.3, 0.15)
		img_tween.tween_callback(func():
			cutscene_image.texture = tex
			cutscene_image.scale = Vector2.ONE * slide.get("zoom_start", 1.0)
		)
		img_tween.tween_property(cutscene_image, "modulate:a", 1.0, 0.3)
		
		# Efeito Ken Burns sutil (Zoom lento cinematográfico)
		if zoom_tween:
			zoom_tween.kill()
		zoom_tween = create_tween()
		zoom_tween.tween_property(cutscene_image, "scale", Vector2.ONE * slide.get("zoom_end", 1.05), 8.0)
		
	# Efeito máquina de escrever no texto
	if story_label:
		if typewriter_tween:
			typewriter_tween.kill()
		story_label.text = slide["text"]
		story_label.visible_ratio = 0.0
		is_typing = true
		
		# Ajusta botão de continuar para a última cena
		if continue_prompt:
			if idx == CUTSCENE_SLIDES.size() - 1:
				continue_prompt.text = "⚡ INICIAR SPEEDRUN! [ESPAÇO / CLIQUE] ❯❯"
				continue_prompt.modulate = Color(1.0, 0.85, 0.25)
			else:
				continue_prompt.text = "Continuar [ESPAÇO / CLIQUE] ❯"
				continue_prompt.modulate = Color(0.7, 0.9, 1.0)
		
		var char_count: int = slide["text"].length()
		var type_speed: float = max(1.2, char_count * 0.022)
		typewriter_tween = create_tween()
		typewriter_tween.tween_property(story_label, "visible_ratio", 1.0, type_speed)
		typewriter_tween.finished.connect(func(): is_typing = false)

func _advance() -> void:
	if is_transitioning:
		return
		
	if is_typing:
		# Se ainda estiver digitando, completa o texto instantaneamente
		if typewriter_tween:
			typewriter_tween.kill()
		if story_label:
			story_label.visible_ratio = 1.0
		is_typing = false
		SoundManager.play_sfx("land", 0.05)
	else:
		# Se já terminou o texto, avança para o próximo slide
		SoundManager.play_sfx("jump", 0.08)
		if current_slide_idx < CUTSCENE_SLIDES.size() - 1:
			_show_slide(current_slide_idx + 1)
		else:
			_finish_cutscene()

func _unhandled_input(event: InputEvent) -> void:
	if is_transitioning:
		return
		
	if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		_on_skip_pressed()
		get_viewport().set_input_as_handled()
		return
		
	if event.is_action_pressed("jump") or event.is_action_pressed("ui_accept"):
		_advance()
		get_viewport().set_input_as_handled()
		return
		
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_advance()
		get_viewport().set_input_as_handled()
		return

func _on_skip_pressed() -> void:
	SoundManager.play_sfx("land", 0.1)
	_finish_cutscene()

func _finish_cutscene() -> void:
	if is_transitioning:
		return
	is_transitioning = true
	
	SoundManager.play_sfx("portal")
	
	var fade_out = create_tween()
	fade_out.tween_property(fade_rect, "modulate:a", 1.0, 0.45)
	await fade_out.finished
	
	GameManager.start_game()
	get_tree().change_scene_to_file(GameManager.get_level_path(1))
