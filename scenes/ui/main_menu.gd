extends Control

@onready var play_btn: Button = $MenuCard/Margin/VBoxContainer/PlayBtn
@onready var story_btn: Button = $MenuCard/Margin/VBoxContainer/StoryBtn
@onready var shift_universe_btn: Button = $MenuCard/Margin/VBoxContainer/ShiftUniverseBtn
@onready var wardrobe_btn: Button = $MenuCard/Margin/VBoxContainer/WardrobeBtn
@onready var controls_btn: Button = $MenuCard/Margin/VBoxContainer/ControlsBtn
@onready var quit_btn: Button = $MenuCard/Margin/VBoxContainer/QuitBtn
@onready var prompt_label: Label = $MenuCard/Margin/VBoxContainer/PromptLabel

@onready var story_panel: Panel = $StoryPanel
@onready var close_story_btn: Button = $StoryPanel/Margin/VBox/BottomHBox/CloseStoryBtn
@onready var story_start_btn: Button = $StoryPanel/Margin/VBox/BottomHBox/StoryStartBtn


@onready var title_badge: Label = $TitleBox/Badge
@onready var title_label: Label = $TitleBox/Title
@onready var title_subtitle: Label = $TitleBox/Subtitle

@onready var universe_toast: PanelContainer = $UniverseToast
@onready var toast_icon: Label = $UniverseToast/Margin/HBox/ToastIcon
@onready var toast_title: Label = $UniverseToast/Margin/HBox/VBox/ToastTitle
@onready var toast_desc: Label = $UniverseToast/Margin/HBox/VBox/ToastDesc
@onready var toast_shift_btn: Button = $UniverseToast/Margin/HBox/ToastShiftBtn

@onready var controls_panel: Panel = $ControlsPanel
@onready var close_btn: Button = $ControlsPanel/CloseBtn
@onready var settings_top_btn: Button = get_node_or_null("SettingsTopBtn")

@onready var wardrobe_panel: Panel = $WardrobePanel
@onready var close_wardrobe_btn: Button = $WardrobePanel/VBox/CloseWardrobeBtn
@onready var preview_rect: TextureRect = $WardrobePanel/VBox/Content/LeftCol/PreviewFrame/PreviewRect
@onready var rarity_badge: Label = $WardrobePanel/VBox/Content/LeftCol/RarityBadge
@onready var outfit_title: Label = $WardrobePanel/VBox/Content/RightCol/OutfitTitle
@onready var outfit_desc: Label = $WardrobePanel/VBox/Content/RightCol/OutfitDesc
@onready var equip_btn: Button = $WardrobePanel/VBox/Content/RightCol/EquipBtn

@onready var btn_classic: Button = $WardrobePanel/VBox/Content/RightCol/OutfitButtons/BtnClassic
@onready var btn_celestial: Button = $WardrobePanel/VBox/Content/RightCol/OutfitButtons/BtnCelestial
@onready var btn_valkyrie: Button = $WardrobePanel/VBox/Content/RightCol/OutfitButtons/BtnValkyrie
@onready var btn_ninja: Button = $WardrobePanel/VBox/Content/RightCol/OutfitButtons/BtnNinja
@onready var btn_royalty: Button = $WardrobePanel/VBox/Content/RightCol/OutfitButtons/BtnRoyalty
@onready var btn_uniform: Button = $WardrobePanel/VBox/Content/RightCol/OutfitButtons/BtnUniform
@onready var btn_agnes: Button = $WardrobePanel/VBox/Content/RightCol/OutfitButtons/BtnAgnes
@onready var btn_frieren: Button = $WardrobePanel/VBox/Content/RightCol/OutfitButtons/BtnFrieren
@onready var btn_maid: Button = $WardrobePanel/VBox/Content/RightCol/OutfitButtons/BtnMaid
@onready var btn_maomao: Button = $WardrobePanel/VBox/Content/RightCol/OutfitButtons/BtnMaomao
@onready var btn_miku: Button = $WardrobePanel/VBox/Content/RightCol/OutfitButtons/BtnMiku
@onready var btn_sonserina: Button = $WardrobePanel/VBox/Content/RightCol/OutfitButtons/BtnSonserina
@onready var btn_tracen: Button = $WardrobePanel/VBox/Content/RightCol/OutfitButtons/BtnTracen
@onready var view_mode_btn: Button = $WardrobePanel/VBox/Content/LeftCol/ViewModeBtn
@onready var anim_toggle_btn: Button = $WardrobePanel/VBox/Content/LeftCol/AnimToggleBtn
@onready var preview_anim_container: Control = $WardrobePanel/VBox/Content/LeftCol/PreviewFrame/PreviewAnimContainer
@onready var preview_sprite: AnimatedSprite2D = $WardrobePanel/VBox/Content/LeftCol/PreviewFrame/PreviewAnimContainer/PreviewSprite

var preview_mode: String = "portrait"
var current_anim_idx: int = 0
const PREVIEW_ANIMS: Array[Dictionary] = [
	{"name": "walk", "label": "🏃 Animação: Andando"},
	{"name": "run", "label": "⚡ Animação: Correndo"},
	{"name": "jump", "label": "🦘 Animação: Pulando"},
	{"name": "idle", "label": "🧘 Animação: Parada"}
]

@onready var lina: AnimatedSprite2D = $LinaContainer/LinaCharacter
@onready var crystal_deco: AnimatedSprite2D = $LinaContainer/DecoCrystal
@onready var lantern: AnimatedSprite2D = $LinaContainer/Lantern
@onready var bg_sky: TextureRect = $BackgroundSky
@onready var bg_mountains_far: TextureRect = $MountainsFar
@onready var bg_mountains_mid: TextureRect = $MountainsMid
@onready var bg_trees_near: TextureRect = $TreesNear
@onready var bg_snow_particles: CPUParticles2D = $SnowParticles
@onready var bg_snow_ground: Panel = $SnowGround
@onready var fade_rect: ColorRect = $FadeOverlay

var is_starting: bool = false
var anim_time: float = 0.0
var highlighted_outfit: String = "classic"

func _ready() -> void:
	controls_panel.visible = false
	wardrobe_panel.visible = false
	story_panel.visible = false
	fade_rect.visible = true
	fade_rect.modulate.a = 1.0
	
	# Fade in ao entrar no menu
	var fade_in = create_tween()
	fade_in.tween_property(fade_rect, "modulate:a", 0.0, 0.35)
	
	# Configura conexões dos botões principais
	play_btn.pressed.connect(_on_play_pressed)
	story_btn.pressed.connect(_on_story_pressed)
	story_btn.focus_entered.connect(_on_btn_focused)
	close_story_btn.pressed.connect(_on_close_story_pressed)
	story_start_btn.pressed.connect(_on_play_pressed)
	
	shift_universe_btn.pressed.connect(_on_shift_universe_pressed)
	shift_universe_btn.focus_entered.connect(_on_btn_focused)
	toast_shift_btn.pressed.connect(_on_shift_universe_pressed)
	wardrobe_btn.pressed.connect(_on_wardrobe_pressed)
	controls_btn.pressed.connect(_on_controls_pressed)
	quit_btn.pressed.connect(_on_quit_pressed)
	close_btn.pressed.connect(_on_close_controls_pressed)
	close_wardrobe_btn.pressed.connect(_on_close_wardrobe_pressed)
	equip_btn.pressed.connect(_on_equip_pressed)
	view_mode_btn.pressed.connect(_on_toggle_view_mode)
	anim_toggle_btn.pressed.connect(_on_toggle_anim)

	
	GameManager.universe_shifted.connect(_on_universe_shifted)
	
	# Botões de seleção de traje no guarda-roupa
	btn_classic.pressed.connect(func(): _preview_outfit("classic"))
	btn_celestial.pressed.connect(func(): _preview_outfit("celestial"))
	btn_valkyrie.pressed.connect(func(): _preview_outfit("valkyrie"))
	btn_ninja.pressed.connect(func(): _preview_outfit("ninja"))
	btn_royalty.pressed.connect(func(): _preview_outfit("royalty"))
	btn_uniform.pressed.connect(func(): _preview_outfit("uniform"))
	btn_agnes.pressed.connect(func(): _preview_outfit("agnes"))
	btn_frieren.pressed.connect(func(): _preview_outfit("frieren"))
	btn_maid.pressed.connect(func(): _preview_outfit("maid"))
	btn_maomao.pressed.connect(func(): _preview_outfit("maomao"))
	btn_miku.pressed.connect(func(): _preview_outfit("miku"))
	btn_sonserina.pressed.connect(func(): _preview_outfit("sonserina"))
	btn_tracen.pressed.connect(func(): _preview_outfit("tracen"))
	
	_update_view_mode_visibility()
	_apply_active_universe_ui(GameManager.get_current_outfit_data(), true)
	
	if settings_top_btn:
		settings_top_btn.pressed.connect(_on_controls_pressed)
	
	# Efeitos de som e animações ao focar e passar mouse nos botões
	var all_menu_btns = [
		play_btn, story_btn, shift_universe_btn, wardrobe_btn, controls_btn, settings_top_btn, quit_btn,
		toast_shift_btn, close_btn, close_wardrobe_btn, close_story_btn, story_start_btn, equip_btn,
		btn_classic, btn_celestial, btn_valkyrie, btn_ninja, btn_royalty, btn_uniform,
		btn_agnes, btn_frieren, btn_maid, btn_maomao, btn_miku, btn_sonserina, btn_tracen
	]
	for btn in all_menu_btns:
		if btn:
			_setup_menu_btn_hover(btn)
	
	# Foco inicial no botão principal
	play_btn.grab_focus()
	
	# Música de fundo atmosférica
	SoundManager.play_bgm()
	
	if "--test-story" in OS.get_cmdline_args() or "--test-story" in OS.get_cmdline_user_args():
		print("\n=======================================================")
		print("=== TESTE AUTOMATIZADO: HISTÓRIA E LORE DO GATINHO NIX ===")
		print("=======================================================")
		
		# 1. Validação de dados do Nix e do Elixir
		assert(GameManager.NIX_STORY_INTRO["kitten_name"] == "Nix")
		assert(GameManager.STAGE_STORY_LORE.size() == 12, "Deve haver exatamente 12 ingredientes!")
		
		for lvl in range(1, 13):
			var story = GameManager.get_stage_story(lvl)
			assert(story.has("ingredient"), "Fase %d falta ingredient!" % lvl)
			assert(story.has("nix_status"), "Fase %d falta nix_status!" % lvl)
			assert(story.has("quote"), "Fase %d falta quote!" % lvl)
			assert(story.has("reward_text"), "Fase %d falta reward_text!" % lvl)
			print("[PASS] Fase %02d: %s %s | Nix: %s" % [lvl, story["icon"], story["ingredient"], story["nix_status"].substr(0, 32) + "..."])
		
		# 2. Validação visual do StoryPanel
		assert(story_panel != null, "StoryPanel deve existir!")
		assert(story_btn != null, "StoryBtn deve existir!")
		_on_story_pressed()
		assert(story_panel.visible == true)
		_on_close_story_pressed()
		assert(story_panel.visible == false)
		print("[PASS] StoryPanel e navegação modal validadas com sucesso!")
		
		# 3. Validação do HUD NixQuestBanner
		var hud_sc = load("res://scenes/ui/hud.tscn")
		var hud = hud_sc.instantiate()
		add_child(hud)
		assert(hud.get_node_or_null("Control/NixQuestBanner") != null)
		hud._update_nix_quest_display()
		assert("REMÉDIO DO NIX" in hud.nix_quest_title.text)
		print("[PASS] HUD NixQuestBanner instanciado e atualizado corretamente!")
		hud.queue_free()
		
		# 4. Validação do VictoryMenu com NixRewardBox e cura no final (Fase 12)
		var vic_sc = load("res://scenes/ui/victory_menu.tscn")
		var vic = vic_sc.instantiate()
		add_child(vic)
		assert(vic.get_node_or_null("Panel/StatsPanel/NixRewardBox") != null)
		
		# Teste Fase 1
		GameManager.current_level = 1
		await vic._on_level_completed()
		var story1 = GameManager.get_stage_story(1)
		assert(story1["ingredient"] in vic.nix_reward_desc.text)
		print("[PASS] VictoryMenu Fase 1 exibe ingrediente 1/12 e status do Nix!")
		
		# Teste Fase 12 (Cura total)
		GameManager.current_level = 12
		await vic._on_level_completed()
		assert("CURADO" in vic.title_label.text)
		assert("AMOR VENCEU" in vic.nix_reward_title.text)
		print("[PASS] VictoryMenu Fase 12 celebra CURA TOTAL do Nix com sprite feliz!")
		vic.queue_free()

		# 5. Validação da Cutscene de História
		var cutscene_sc = load("res://scenes/ui/story_cutscene.tscn")
		assert(cutscene_sc != null, "Cena story_cutscene.tscn deve existir!")
		var cutscene = cutscene_sc.instantiate()
		add_child(cutscene)
		assert(cutscene.CUTSCENE_SLIDES.size() == 4)
		print("[PASS] StoryCutscene instanciada com 4 capítulos cinematográficos!")
		cutscene.queue_free()

		
		print("\n=======================================================")
		print("=== TESTE DA HISTÓRIA DE NIX CONCLUÍDO COM 100% SUCESSO! ===")
		print("=======================================================\n")
		get_tree().quit(0)
		return

	if "--test-mobile-controls" in OS.get_cmdline_args() or "--test-mobile-controls" in OS.get_cmdline_user_args():
		print("\n=======================================================")
		print("=== TESTE AUTOMATIZADO: CONTROLES MOBILE, CORRIDA & CONFIG ===")
		print("=======================================================")
		
		# 1. Validação de Orientação de Tela (Landscape = 0)
		var proj_orient = ProjectSettings.get_setting("display/window/handheld/orientation")
		print("[TEST] Orientação em project.godot: ", proj_orient)
		assert(proj_orient == 0, "Orientação em project.godot deve ser 0 (Landscape)!")
		print("[PASS] Orientação Landscape verificada em project.godot!")
		
		# 2. Validação da Cena TouchControls e Botão de Corrida
		var touch_sc = load("res://scenes/ui/touch_controls.tscn")
		assert(touch_sc != null, "touch_controls.tscn deve existir!")
		var tc = touch_sc.instantiate()
		add_child(tc)
		
		var btn_left = tc.get_node_or_null("LeftPad/BtnLeft")
		var btn_right = tc.get_node_or_null("LeftPad/BtnRight")
		var btn_run = tc.get_node_or_null("RightPad/BtnRun")
		var btn_dash = tc.get_node_or_null("RightPad/BtnDash")
		var btn_jump = tc.get_node_or_null("RightPad/BtnJump")
		var btn_settings = tc.get_node_or_null("TopPad/BtnSettings")
		var btn_pause = tc.get_node_or_null("TopPad/BtnPause")
		
		assert(btn_left != null, "BtnLeft deve existir!")
		assert(btn_right != null, "BtnRight deve existir!")
		assert(btn_run != null, "BtnRun deve existir!")
		assert(btn_dash != null, "BtnDash deve existir!")
		assert(btn_jump != null, "BtnJump deve existir!")
		assert(btn_settings != null, "BtnSettings deve existir!")
		assert(btn_pause != null, "BtnPause deve existir!")
		print("[PASS] Todos os botões virtuais (Left, Right, Run, Dash, Jump, Settings, Pause) existem!")
		
		assert(btn_run.action == "run", "BtnRun deve ter ação 'run'!")
		assert(btn_run.texture_normal != null, "BtnRun deve ter textura normal!")
		assert(btn_run.texture_pressed != null, "BtnRun deve ter textura pressionada!")
		assert(btn_settings.texture_normal != null, "BtnSettings deve ter textura normal!")
		print("[PASS] Texturas de corrida e configurações verificadas com sucesso!")
		
		# 3. Teste do Sistema de Configurações no GameManager
		GameManager.reset_touch_config()
		var default_cfg = GameManager.get_touch_config()
		assert(default_cfg["scale"] == 1.0)
		assert(default_cfg["opacity"] == 0.75)
		assert(default_cfg["run_mode"] == "hold")
		assert(default_cfg["handedness"] == "right")
		assert(GameManager.is_auto_run_active() == false)
		print("[PASS] Configuração padrão de controles inicializada!")
		
		# Teste de Modo de Corrida: Auto-Run
		GameManager.save_touch_config({"run_mode": "auto"})
		assert(GameManager.is_auto_run_active() == true, "Auto-run deve estar ativo!")
		print("[PASS] Modo Sempre Correr (Auto-Run) ativa velocidade máxima automaticamente!")
		
		# Teste de Modo de Corrida: Toggle Run
		GameManager.save_touch_config({"run_mode": "toggle"})
		assert(GameManager.is_auto_run_active() == false)
		GameManager.run_toggled_active = true
		assert(GameManager.is_auto_run_active() == true)
		GameManager.run_toggled_active = false
		assert(GameManager.is_auto_run_active() == false)
		print("[PASS] Modo Alternar Corrida (Toggle) funciona com ativação/desativação por toque!")
		
		# Teste de Escala, Opacidade e Ergonomia
		GameManager.save_touch_config({"scale": 1.2, "opacity": 0.55, "handedness": "left"})
		tc._apply_configuration()
		assert(is_equal_approx(tc.modulate.a, 0.55), "Opacidade deve ser aplicada!")
		assert(is_equal_approx(tc.left_pad.scale.x, 1.2), "Escala deve ser aplicada!")
		print("[PASS] Escala, opacidade e layout canhoto aplicados dinamicamente no TouchControls!")
		
		# 4. Teste do Dialog de Configuração
		var dlg_sc = load("res://scenes/ui/controls_config_dialog.tscn")
		assert(dlg_sc != null, "controls_config_dialog.tscn deve existir!")
		var dlg = dlg_sc.instantiate()
		add_child(dlg)
		dlg.open_dialog()
		assert(dlg.visible == true)
		assert(dlg.modal_card != null)
		dlg._set_scale(1.4)
		assert(is_equal_approx(GameManager.get_touch_config()["scale"], 1.4))
		dlg._set_run_mode("auto")
		assert(GameManager.get_touch_config()["run_mode"] == "auto")
		dlg._on_reset_pressed()
		assert(is_equal_approx(GameManager.get_touch_config()["scale"], 1.0))
		dlg.visible = false
		print("[PASS] ControlsConfigDialog interage perfeitamente com GameManager!")
		
		# 5. Validação no Player com a física de corrida
		var player_sc = load("res://scenes/player/player.tscn")
		var player = player_sc.instantiate()
		add_child(player)
		assert(player.RUN_SPEED > player.WALK_SPEED, "RUN_SPEED (360) deve ser maior que WALK_SPEED (220)!")
		assert(is_equal_approx(player.RUN_SPEED, 360.0))
		player.queue_free()
		print("[PASS] Física do player e velocidades de caminhada/corrida validadas!")
		
		# Limpeza
		tc.queue_free()
		dlg.queue_free()
		GameManager.reset_touch_config()
		
		print("\n=======================================================")
		print("=== TESTE DE CONTROLES MOBILE CONCLUÍDO COM SUCESSO! ===")
		print("=======================================================\n")
		get_tree().quit(0)
		return

	if "--screenshot-story" in OS.get_cmdline_args() or "--screenshot-story" in OS.get_cmdline_user_args():
		# 1. Modal da História do Nix no Menu
		_on_story_pressed()
		await get_tree().create_timer(0.4).timeout
		var tex_story = get_viewport().get_texture()
		if tex_story:
			var img_story = tex_story.get_image()
			if img_story:
				img_story.save_png("screenshot_story_intro.png")
				print("Story modal screenshot captured!")
		_on_close_story_pressed()

		# 2. In-game HUD com banner da missão do Nix
		$MenuCard.visible = false
		$TitleBox.visible = false
		$LinaContainer.visible = false
		$UniverseToast.visible = false
		$BackgroundSky.visible = false
		$MountainsFar.visible = false
		$MountainsMid.visible = false
		$TreesNear.visible = false
		$SnowParticles.visible = false
		$SnowGround.visible = false

		GameManager.current_level = 1
		GameManager.elapsed_time = 3.65
		GameManager.score = 4
		GameManager.total_crystals = 26
		var lvl1 = load("res://scenes/levels/level_1.tscn").instantiate()
		add_child(lvl1)
		await get_tree().create_timer(0.4).timeout
		var tex_hud = get_viewport().get_texture()
		if tex_hud:
			var img_hud = tex_hud.get_image()
			if img_hud:
				img_hud.save_png("screenshot_story_hud.png")
				print("In-game story HUD screenshot captured!")
		lvl1.queue_free()

		# 3. Tela de Vitória da Fase 12 com Nix Curado e Feliz!
		GameManager.current_level = 12
		GameManager.elapsed_time = 28.40
		GameManager.score = 25
		GameManager.total_crystals = 35
		var lvl12 = load("res://scenes/levels/level_12.tscn").instantiate()
		add_child(lvl12)
		var vic12 = lvl12.get_node_or_null("VictoryMenu")
		if vic12:
			GameManager.complete_level()
			await get_tree().create_timer(0.5).timeout
			var tex_cured = get_viewport().get_texture()
			if tex_cured:
				var img_cured = tex_cured.get_image()
				if img_cured:
					img_cured.save_png("screenshot_story_nix_cured.png")
					print("Nix cured victory screen screenshot captured!")
		lvl12.queue_free()

		get_tree().quit(0)
		return

	if "--screenshot-mobile" in OS.get_cmdline_args() or "--screenshot-mobile" in OS.get_cmdline_user_args():
		# 1. Foto dos Controles Touch In-Game com o novo Botão de Corrida e Botão de Configurações
		$MenuCard.visible = false
		$TitleBox.visible = false
		$LinaContainer.visible = false
		$UniverseToast.visible = false
		$BackgroundSky.visible = false
		$MountainsFar.visible = false
		$MountainsMid.visible = false
		$TreesNear.visible = false
		$SnowParticles.visible = false
		$SnowGround.visible = false
		if settings_top_btn: settings_top_btn.visible = false
		
		var lvl = load("res://scenes/levels/celestial/level_1.tscn").instantiate()
		add_child(lvl)
		
		var hud = lvl.get_node_or_null("HUD")
		if hud:
			var touch = hud.get_node_or_null("TouchControls")
			if touch:
				touch.visible = true
				touch._apply_configuration()
		
		var player = lvl.get_node_or_null("Player")
		if player:
			player.global_position = Vector2(380, 430)
			player.sprite.play("run")
			player.sprite.flip_h = false
			player.dust_particles.emitting = true
				
		await get_tree().create_timer(0.4).timeout
		var tex = get_viewport().get_texture()
		if tex:
			var img = tex.get_image()
			if img:
				img.save_png("screenshot_mobile_controls.png")
				print("[SCREENSHOT] screenshot_mobile_controls.png capturado!")
		
		# 2. Foto do Menu de Pausa com o novo botão '⚙️ Configurar Controles'
		var pause_menu = lvl.get_node_or_null("PauseMenu")
		if pause_menu:
			pause_menu.visible = true
			pause_menu._populate_pause_data()
			await get_tree().create_timer(0.3).timeout
			var tex_p = get_viewport().get_texture()
			if tex_p:
				var img_p = tex_p.get_image()
				if img_p:
					img_p.save_png("screenshot_pause_controls.png")
					print("[SCREENSHOT] screenshot_pause_controls.png capturado!")
			pause_menu.visible = false
		
		lvl.queue_free()
		
		# 3. Foto do Modal 'ControlsConfigDialog' com abas de Escala, Opacidade, Modos de Corrida e Lados
		var dlg_sc = load("res://scenes/ui/controls_config_dialog.tscn")
		var dlg = dlg_sc.instantiate()
		add_child(dlg)
		dlg.open_dialog()
		await get_tree().create_timer(0.4).timeout
		var tex_dlg = get_viewport().get_texture()
		if tex_dlg:
			var img_dlg = tex_dlg.get_image()
			if img_dlg:
				img_dlg.save_png("screenshot_controls_config.png")
				print("[SCREENSHOT] screenshot_controls_config.png capturado!")
		dlg.queue_free()
		
		get_tree().quit(0)
		return

	if "--screenshot-celestial-player" in OS.get_cmdline_args() or "--screenshot-celestial-player" in OS.get_cmdline_user_args():
		# 1. Main menu with celestial outfit
		GameManager.set_outfit("celestial")
		_apply_active_universe_ui(GameManager.get_current_outfit_data(), false)
		await get_tree().create_timer(0.4).timeout
		var tex_menu = get_viewport().get_texture()
		if tex_menu:
			var img_m = tex_menu.get_image()
			if img_m:
				img_m.save_png("screenshot_celestial_menu.png")
				print("[SCREENSHOT] screenshot_celestial_menu.png capturado!")
		
		# Hide UI for in-game capture
		$MenuCard.visible = false
		$TitleBox.visible = false
		$LinaContainer.visible = false
		$UniverseToast.visible = false
		$BackgroundSky.visible = false
		$MountainsFar.visible = false
		$MountainsMid.visible = false
		$TreesNear.visible = false
		$SnowParticles.visible = false
		$SnowGround.visible = false
		
		var lvl_sc = load("res://scenes/levels/celestial/level_1.tscn")
		var lvl = lvl_sc.instantiate()
		add_child(lvl)
		
		var player = lvl.get_node_or_null("Player")
		if player:
			player.global_position = Vector2(280, 480)
			var cam = player.get_node_or_null("Camera2D")
			if cam:
				cam.reset_smoothing()
				
		# 2. Celestial Idle in-game
		if player and player.sprite:
			player.sprite.play("idle")
		await get_tree().create_timer(0.4).timeout
		var tex_idle = get_viewport().get_texture()
		if tex_idle:
			var img_idle = tex_idle.get_image()
			if img_idle:
				img_idle.save_png("screenshot_celestial_idle.png")
				print("[SCREENSHOT] screenshot_celestial_idle.png capturado!")
				
		# 3. Celestial Run in-game
		if player and player.sprite:
			player.sprite.play("run")
		await get_tree().create_timer(0.4).timeout
		var tex_run = get_viewport().get_texture()
		if tex_run:
			var img_run = tex_run.get_image()
			if img_run:
				img_run.save_png("screenshot_celestial_run.png")
				print("[SCREENSHOT] screenshot_celestial_run.png capturado!")
				
		lvl.queue_free()
		get_tree().quit(0)
		return

	if "--screenshot-checkpoint-portal" in OS.get_cmdline_args() or "--screenshot-checkpoint-portal" in OS.get_cmdline_user_args():
		$MenuCard.visible = false
		$TitleBox.visible = false
		$LinaContainer.visible = false
		$UniverseToast.visible = false
		$BackgroundSky.visible = false
		$MountainsFar.visible = false
		$MountainsMid.visible = false
		$TreesNear.visible = false
		$SnowParticles.visible = false
		$SnowGround.visible = false
		
		var lvl_sc = load("res://scenes/levels/celestial/level_1.tscn")
		var lvl = lvl_sc.instantiate()
		add_child(lvl)
		
		var player = lvl.get_node_or_null("Player")
		var checkpoint = lvl.get_node_or_null("InteractiveObjects/Checkpoint_1")
		var portal = lvl.get_node_or_null("InteractiveObjects/Portal")
		
		# 1. Foto do Checkpoint com a plataforma estavel
		if player and checkpoint:
			player.global_position = checkpoint.global_position + Vector2(-90, 0)
			var cam = player.get_node_or_null("Camera2D")
			if cam:
				cam.reset_smoothing()
		await get_tree().create_timer(0.4).timeout
		var tex_cp = get_viewport().get_texture()
		if tex_cp:
			var img_cp = tex_cp.get_image()
			if img_cp:
				img_cp.save_png("screenshot_checkpoint_stable.png")
				print("[SCREENSHOT] screenshot_checkpoint_stable.png capturado!")
				
		# 2. Foto do Portal visivel e brilhante
		if player and portal:
			player.global_position = portal.global_position + Vector2(-130, 0)
			var cam = player.get_node_or_null("Camera2D")
			if cam:
				cam.reset_smoothing()
		await get_tree().create_timer(0.4).timeout
		var tex_pt = get_viewport().get_texture()
		if tex_pt:
			var img_pt = tex_pt.get_image()
			if img_pt:
				img_pt.save_png("screenshot_portal_visible.png")
				print("[SCREENSHOT] screenshot_portal_visible.png capturado!")
				
		lvl.queue_free()
		get_tree().quit(0)
		return

	if "--screenshot-ui" in OS.get_cmdline_args() or "--screenshot-ui" in OS.get_cmdline_user_args():
		print("\n=== CAPTURANDO SCREENSHOTS DA NOVA UI ===")
		
		# 1. ControlsPanel
		controls_panel.visible = true
		await get_tree().create_timer(0.3).timeout
		var tex_ctrl = get_viewport().get_texture()
		if tex_ctrl:
			var img_ctrl = tex_ctrl.get_image()
			if img_ctrl:
				img_ctrl.save_png("screenshot_ui_controls.png")
				print("[UI] screenshot_ui_controls.png salva!")
		controls_panel.visible = false
		
		# 2. In-game HUD
		$MenuCard.visible = false
		$TitleBox.visible = false
		$LinaContainer.visible = false
		$UniverseToast.visible = false
		$BackgroundSky.visible = false
		$MountainsFar.visible = false
		$MountainsMid.visible = false
		$TreesNear.visible = false
		$SnowParticles.visible = false
		$SnowGround.visible = false
		
		var lvl1_sc = load("res://scenes/levels/level_1.tscn")
		var lvl1 = lvl1_sc.instantiate()
		add_child(lvl1)
		GameManager.current_level = 1
		GameManager.score = 7
		GameManager.total_crystals = 25
		GameManager.elapsed_time = 12.45
		GameManager.trigger_powerup("turbo", 6.0)
		GameManager.trigger_powerup("magnet", 5.0)
		var hud = lvl1.get_node_or_null("HUD")
		if hud:
			hud._update_level_badge()
			hud._update_nix_quest_display()
			hud._update_powers_display()
			hud._on_score_changed(7, 25)
		await get_tree().create_timer(0.3).timeout
		var tex_hud = get_viewport().get_texture()
		if tex_hud:
			var img_hud = tex_hud.get_image()
			if img_hud:
				img_hud.save_png("screenshot_ui_hud.png")
				print("[UI] screenshot_ui_hud.png salva!")
				
		# 3. Pause Menu
		var pause_menu = lvl1.get_node_or_null("PauseMenu")
		if pause_menu:
			pause_menu.visible = true
			pause_menu._populate_pause_data()
			await get_tree().create_timer(0.3).timeout
			var tex_pause = get_viewport().get_texture()
			if tex_pause:
				var img_pause = tex_pause.get_image()
				if img_pause:
					img_pause.save_png("screenshot_ui_pause.png")
					print("[UI] screenshot_ui_pause.png salva!")
			pause_menu.visible = false
			
		# 4. Game Over Menu
		var game_over = lvl1.get_node_or_null("GameOverMenu")
		if game_over:
			game_over.visible = true
			game_over._populate_stats()
			await get_tree().create_timer(0.3).timeout
			var tex_gover = get_viewport().get_texture()
			if tex_gover:
				var img_gover = tex_gover.get_image()
				if img_gover:
					img_gover.save_png("screenshot_ui_gameover.png")
					print("[UI] screenshot_ui_gameover.png salva!")
			game_over.visible = false
		
		# 5. Victory Menu
		var victory_menu = lvl1.get_node_or_null("VictoryMenu")
		if victory_menu:
			victory_menu.visible = true
			victory_menu._on_level_completed()
			await get_tree().create_timer(0.5).timeout
			var tex_vic = get_viewport().get_texture()
			if tex_vic:
				var img_vic = tex_vic.get_image()
				if img_vic:
					img_vic.save_png("screenshot_ui_victory.png")
					print("[UI] screenshot_ui_victory.png salva!")
		
		lvl1.queue_free()
		print("=== CAPTURA DE TODAS AS TELAS DE UI CONCLUÍDA! ===\n")
		get_tree().quit(0)
		return

	if "--screenshot" in OS.get_cmdline_args() or "--screenshot" in OS.get_cmdline_user_args():

		await get_tree().create_timer(0.3).timeout
		var tex = get_viewport().get_texture()
		if tex:
			var img = tex.get_image()
			if img:
				img.save_png("screenshot_main_menu.png")
				print("Main menu screenshot captured at full resolution!")
		get_tree().quit()

	if "--screenshot-new-worlds" in OS.get_cmdline_args() or "--screenshot-new-worlds" in OS.get_cmdline_user_args():
		var sample_worlds = ["miku", "frieren", "agnes", "maomao", "sonserina", "tracen", "maid"]
		for u_id in sample_worlds:
			GameManager.set_outfit(u_id)
			$MenuCard.visible = false
			$TitleBox.visible = false
			$LinaContainer.visible = false
			$UniverseToast.visible = false
			$BackgroundSky.visible = false
			$MountainsFar.visible = false
			$MountainsMid.visible = false
			$TreesNear.visible = false
			$SnowParticles.visible = false
			$SnowGround.visible = false
			var lvl_path = GameManager.get_level_path(1, u_id)
			var lvl = load(lvl_path).instantiate()
			add_child(lvl)
			var pbg = lvl.get_node_or_null("ParallaxBackground")
			if pbg:
				pbg.apply_universe_theme(true)
			await get_tree().create_timer(0.4).timeout
			var tex2 = get_viewport().get_texture()
			if tex2:
				var img2 = tex2.get_image()
				if img2:
					img2.save_png("screenshot_world_%s.png" % u_id)
			lvl.queue_free()
		print("New worlds screenshots captured!")
		get_tree().quit(0)
		return

	if "--screenshot-multiverse" in OS.get_cmdline_args() or "--screenshot-multiverse" in OS.get_cmdline_user_args():
		var u_list = ["classic", "celestial", "valkyrie", "ninja", "royalty", "uniform"]
		for u_id in u_list:
			GameManager.set_outfit(u_id)
			_apply_active_universe_ui(GameManager.get_current_outfit_data(), false)
			await get_tree().create_timer(0.3).timeout
			var tex = get_viewport().get_texture()
			if tex:
				var img = tex.get_image()
				if img:
					img.save_png("screenshot_multiverse_menu_%s.png" % u_id)
		
		for u_id in ["classic", "celestial", "valkyrie", "ninja", "royalty", "uniform"]:
			GameManager.set_outfit(u_id)
			$MenuCard.visible = false
			$TitleBox.visible = false
			$LinaContainer.visible = false
			$UniverseToast.visible = false
			$BackgroundSky.visible = false
			$MountainsFar.visible = false
			$MountainsMid.visible = false
			$TreesNear.visible = false
			$SnowParticles.visible = false
			$SnowGround.visible = false
			var lvl = load("res://scenes/levels/level_1.tscn").instantiate()
			add_child(lvl)
			var pbg = lvl.get_node_or_null("ParallaxBackground")
			if pbg:
				pbg.apply_universe_theme(true)
			await get_tree().create_timer(0.4).timeout
			var tex2 = get_viewport().get_texture()
			if tex2:
				var img2 = tex2.get_image()
				if img2:
					img2.save_png("screenshot_multiverse_stage_%s.png" % u_id)
			lvl.queue_free()
			$MenuCard.visible = true
			$TitleBox.visible = true
			$LinaContainer.visible = true
			$BackgroundSky.visible = true
			$MountainsFar.visible = true
			$MountainsMid.visible = true
			$TreesNear.visible = true
			$SnowParticles.visible = true
			$SnowGround.visible = true
			await get_tree().create_timer(0.1).timeout
		print("All multiverse screenshots captured!")
		get_tree().quit(0)
		return

	if "--screenshot-wardrobe" in OS.get_cmdline_args() or "--screenshot-wardrobe" in OS.get_cmdline_user_args():
		_on_wardrobe_pressed()
		_preview_outfit("miku")
		await get_tree().create_timer(0.4).timeout
		var tex = get_viewport().get_texture()
		if tex:
			var img = tex.get_image()
			if img:
				img.save_png("screenshot_wardrobe_miku.png")
				print("Wardrobe Miku screenshot captured!")
		_preview_outfit("frieren")
		await get_tree().create_timer(0.4).timeout
		tex = get_viewport().get_texture()
		if tex:
			var img2 = tex.get_image()
			if img2:
				img2.save_png("screenshot_wardrobe_frieren.png")
				print("Wardrobe Frieren screenshot captured!")
		get_tree().quit()

	if "--screenshot-speedrun" in OS.get_cmdline_args() or "--screenshot-speedrun" in OS.get_cmdline_user_args():
		$MenuCard.visible = false
		$TitleBox.visible = false
		$LinaContainer.visible = false
		$UniverseToast.visible = false
		$BackgroundSky.visible = false
		$MountainsFar.visible = false
		$MountainsMid.visible = false
		$TreesNear.visible = false
		$SnowParticles.visible = false
		$SnowGround.visible = false

		GameManager.current_level = 6
		GameManager.elapsed_time = 8.42
		GameManager.score = 5
		GameManager.total_crystals = 18
		var lvl6 = load("res://scenes/levels/level_6.tscn").instantiate()
		add_child(lvl6)
		await get_tree().create_timer(0.4).timeout
		var tex_game = get_viewport().get_texture()
		if tex_game:
			var img_game = tex_game.get_image()
			if img_game:
				img_game.save_png("screenshot_speedrun_gameplay.png")
				print("Speedrun gameplay screenshot captured!")

		var vic = lvl6.get_node_or_null("VictoryMenu")
		if vic:
			GameManager.complete_level()
			await get_tree().create_timer(0.5).timeout
			var tex_vic = get_viewport().get_texture()
			if tex_vic:
				var img_vic = tex_vic.get_image()
				if img_vic:
					img_vic.save_png("screenshot_speedrun_victory.png")
					print("Speedrun victory screenshot captured!")
		lvl6.queue_free()

		GameManager.current_level = 12
		GameManager.elapsed_time = 14.15
		GameManager.score = 12
		GameManager.total_crystals = 35
		var lvl12 = load("res://scenes/levels/level_12.tscn").instantiate()
		add_child(lvl12)
		await get_tree().create_timer(0.4).timeout
		var tex_12 = get_viewport().get_texture()
		if tex_12:
			var img_12 = tex_12.get_image()
			if img_12:
				img_12.save_png("screenshot_speedrun_level12.png")
				print("Level 12 screenshot captured!")
		lvl12.queue_free()

		get_tree().quit(0)
		return

	if "--screenshot-powerups" in OS.get_cmdline_args() or "--screenshot-powerups" in OS.get_cmdline_user_args():
		$MenuCard.visible = false
		$TitleBox.visible = false
		$LinaContainer.visible = false
		$UniverseToast.visible = false
		$BackgroundSky.visible = false
		$MountainsFar.visible = false
		$MountainsMid.visible = false
		$TreesNear.visible = false
		$SnowParticles.visible = false
		$SnowGround.visible = false

		# 1. Fase 1 com Power-Up Dash e Boost Pad visíveis
		GameManager.current_level = 1
		GameManager.elapsed_time = 4.25
		GameManager.score = 2
		GameManager.total_crystals = 26
		GameManager.trigger_powerup("dash", 5.8)
		GameManager.trigger_powerup("magnet", 7.4)
		var lvl1 = load("res://scenes/levels/level_1.tscn").instantiate()
		add_child(lvl1)
		var p1 = lvl1.get_node_or_null("Player")
		if p1:
			p1.global_position = Vector2(610, 430)
		await get_tree().create_timer(0.4).timeout
		var tex1 = get_viewport().get_texture()
		if tex1:
			var img1 = tex1.get_image()
			if img1:
				img1.save_png("screenshot_powerups_stage1.png")
				print("Power-ups stage 1 screenshot captured!")
		lvl1.queue_free()

		# 2. Fase 2 com Corrente de Vento e Plataforma Quebradiça
		GameManager.reset_powers()
		GameManager.current_level = 2
		GameManager.elapsed_time = 9.15
		GameManager.trigger_powerup("chrono", 3.8)
		GameManager.trigger_powerup("wings", 6.2)
		var lvl2 = load("res://scenes/levels/level_2.tscn").instantiate()
		add_child(lvl2)
		var p2 = lvl2.get_node_or_null("Player")
		if p2:
			p2.global_position = Vector2(1750, 360)
		await get_tree().create_timer(0.4).timeout
		var tex2 = get_viewport().get_texture()
		if tex2:
			var img2 = tex2.get_image()
			if img2:
				img2.save_png("screenshot_chrono_freeze.png")
				print("Chrono freeze and wind current screenshot captured!")
		lvl2.queue_free()

		# 3. Fase 1 com Parede Quebrável e Dash
		GameManager.reset_powers()
		GameManager.current_level = 1
		GameManager.elapsed_time = 12.0
		var lvl3 = load("res://scenes/levels/level_1.tscn").instantiate()
		add_child(lvl3)
		var p3 = lvl3.get_node_or_null("Player")
		if p3:
			p3.global_position = Vector2(3100, 380)
			p3._execute_dash(1.0)
		await get_tree().create_timer(0.12).timeout
		var tex3 = get_viewport().get_texture()
		if tex3:
			var img3 = tex3.get_image()
			if img3:
				img3.save_png("screenshot_stage_mechanics.png")
				print("Dash and breakable wall screenshot captured!")
		lvl3.queue_free()

		get_tree().quit(0)
		return

	if "--test-outfits" in OS.get_cmdline_args() or "--test-outfits" in OS.get_cmdline_user_args():
		print("\n=== INICIANDO TESTE DO SISTEMA DE ROUPAS & SPRITES DA LINA ===")
		var outfits = GameManager.UNIVERSES
		var animations = ["idle", "walk", "run", "jump", "fall", "hurt"]
		for outfit_id in outfits:
			assert(GameManager.OUTFITS.has(outfit_id))
			var data = GameManager.OUTFITS[outfit_id]
			print("[OK] Traje cadastrado: %s (%s)" % [data["name"], outfit_id])
			
			var sprite_tex = GameManager.get_outfit_sprite(outfit_id)
			assert(sprite_tex != null, "Sprite nulo para " + outfit_id)
			
			var frames = GameManager.get_outfit_sprite_frames(outfit_id)
			assert(frames != null, "Frames nulos para " + outfit_id)
			
			for anim in animations:
				assert(frames.has_animation(anim))
				var frame_count = frames.get_frame_count(anim)
				assert(frame_count > 0)
				print("   - Animação '%s': %d frames [OK]" % [anim, frame_count])
		
		# Testar troca de roupa no GameManager e na Lina
		for outfit_id in outfits:
			GameManager.set_outfit(outfit_id)
			_preview_outfit(outfit_id)
			assert(lina.sprite_frames == GameManager.get_outfit_sprite_frames(outfit_id))
			print("[OK] Troca em tempo real para '%s' validada no menu!" % outfit_id)
			
		# Testar instanciação do Player
		var player_scene = load("res://scenes/player/player.tscn")
		var player = player_scene.instantiate()
		add_child(player)
		for outfit_id in outfits:
			GameManager.set_outfit(outfit_id)
			assert(player.sprite.sprite_frames == GameManager.get_outfit_sprite_frames(outfit_id))
			for anim in animations:
				player.sprite.play(anim)
				assert(player.sprite.animation == anim)
			print("[OK] Player in-game com '%s' executou todas as 6 animações perfeitamente!" % outfit_id)
		player.queue_free()
		
		print("\n=== TODOS OS TESTES PASSARAM COM 100% DE SUCESSO! ===\n")
		get_tree().quit(0)
		return

	if "--test-spawn" in OS.get_cmdline_args() or "--test-spawn" in OS.get_cmdline_user_args():
		print("\n=======================================================")
		print("=== TESTE AUTOMATIZADO: SPAWN ENTRE AS FASES (LINAVERSE) ===")
		print("=======================================================")
		
		# 1. Início do jogo (Fase 1)
		GameManager.start_game()
		assert(GameManager.current_level == 1)
		assert(GameManager.checkpoint_pos == Vector2(100, 460))
		print("[PASS] GameManager.start_game() inicializou Fase 1 em (100, 460)")
		
		# Instancia Fase 1 e valida spawn inicial do Player
		var l1 = load("res://scenes/levels/level_1.tscn").instantiate()
		add_child(l1)
		var p1 = l1.get_node("Player")
		assert(p1.global_position == Vector2(100, 460))
		assert(p1.scale == Vector2.ONE)
		assert(p1.rotation == 0.0)
		print("[PASS] Fase 1: Player spawnou perfeitamente em (100, 460) sobre a plataforma inicial!")
		
		# 2. Simula ativação de checkpoints na Fase 1
		GameManager.set_checkpoint(Vector2(2060, 436))
		assert(GameManager.checkpoint_pos == Vector2(2060, 436))
		GameManager.set_checkpoint(Vector2(3400, 356))
		assert(GameManager.checkpoint_pos == Vector2(3400, 356))
		print("[PASS] Checkpoints intermediários da Fase 1 ativados até (3400, 356)")
		
		# Simula portal e conclusão
		p1.scale = Vector2.ZERO
		p1.rotation = TAU * 2.0
		GameManager.complete_level()
		l1.free()
		
		# 3. Transição para Fase 2
		GameManager.current_level = 2
		GameManager.checkpoint_pos = GameManager.get_level_spawn_pos(2)
		assert(GameManager.checkpoint_pos == Vector2(100, 460))
		print("[PASS] Checkpoint resetado para (100, 460) antes da Fase 2!")
		
		var l2 = load("res://scenes/levels/level_2.tscn").instantiate()
		add_child(l2)
		var p2 = l2.get_node("Player")
		assert(p2.global_position == Vector2(100, 460))
		assert(p2.scale == Vector2.ONE)
		assert(p2.rotation == 0.0)
		assert(p2.velocity == Vector2.ZERO)
		print("[PASS] Fase 2: Player spawnou em (100, 460) e NÃO no checkpoint antigo da Fase 1!")
		
		# 4. Transição Fase 2 -> Fase 3
		GameManager.set_checkpoint(Vector2(3480, 316))
		assert(GameManager.checkpoint_pos == Vector2(3480, 316))
		l2.free()
		
		GameManager.current_level = 3
		GameManager.checkpoint_pos = GameManager.get_level_spawn_pos(3)
		assert(GameManager.checkpoint_pos == Vector2(100, 460))
		print("[PASS] Checkpoint resetado para (100, 460) antes da Fase 3!")
		
		var l3 = load("res://scenes/levels/level_3.tscn").instantiate()
		add_child(l3)
		var p3 = l3.get_node("Player")
		assert(p3.global_position == Vector2(100, 460))
		assert(p3.scale == Vector2.ONE)
		assert(p3.rotation == 0.0)
		print("[PASS] Fase 3: Player spawnou em (100, 460) em segurança sobre a plataforma inicial!")
		
		# 5. Transição Fase 3 -> Fase 4
		GameManager.set_checkpoint(Vector2(2640, 336))
		l3.free()
		
		GameManager.current_level = 4
		GameManager.checkpoint_pos = GameManager.get_level_spawn_pos(4)
		assert(GameManager.checkpoint_pos == Vector2(100, 460))
		
		var l4 = load("res://scenes/levels/level_4.tscn").instantiate()
		add_child(l4)
		var p4 = l4.get_node("Player")
		assert(p4.global_position == Vector2(100, 460))
		print("[PASS] Fase 4: Player spawnou em (100, 460) com sucesso!")
		
		# 6. Transição Fase 4 -> Fase 5
		GameManager.set_checkpoint(Vector2(3180, 376))
		l4.free()
		
		GameManager.current_level = 5
		GameManager.checkpoint_pos = GameManager.get_level_spawn_pos(5)
		assert(GameManager.checkpoint_pos == Vector2(100, 460))
		
		var l5 = load("res://scenes/levels/level_5.tscn").instantiate()
		add_child(l5)
		var p5 = l5.get_node("Player")
		assert(p5.global_position == Vector2(100, 460))
		print("[PASS] Fase 5: Player spawnou em (100, 460) com sucesso!")
		
		# 7. Teste de Reiniciar Fase
		GameManager.set_checkpoint(Vector2(3040, 356))
		GameManager.checkpoint_pos = GameManager.get_level_spawn_pos(5)
		assert(GameManager.checkpoint_pos == Vector2(100, 460))
		print("[PASS] Posição de reinício reseta para o início da fase (100, 460)!")
		
		# 8. Teste de Respawn no Abismo
		p5.global_position = Vector2(500, 700)
		p5._fall_out_of_world()
		assert(p5.global_position == Vector2(100, 460))
		assert(p5.scale == Vector2.ONE)
		assert(p5.rotation == 0.0)
		assert(p5.velocity == Vector2.ZERO)
		print("[PASS] _fall_out_of_world() reposiciona com escala, rotação e velocidade devidamente resetadas!")
		
		l5.free()
		print("\n=======================================================")
		print("=== TODOS OS TESTES DE SPAWN PASSARAM COM SUCESSO! ===")
		print("=======================================================\n")
		get_tree().quit(0)
		return

	if "--test-multiverse" in OS.get_cmdline_args() or "--test-multiverse" in OS.get_cmdline_user_args():
		print("\n=======================================================")
		print("=== TESTE AUTOMATIZADO: MUDANÇA DE UNIVERSO (LINAVERSE) ===")
		print("=======================================================")
		
		# 1. Validação de dados de todos os 13 universos
		var expected_universes = GameManager.UNIVERSES
		assert(GameManager.UNIVERSES.size() == 13)
		for u_id in expected_universes:
			assert(GameManager.OUTFITS.has(u_id))
			var u_data = GameManager.OUTFITS[u_id]
			assert(u_data.has("universe_name"), "Universo %s não tem universe_name" % u_id)
			assert(u_data.has("universe_subtitle"), "Universo %s não tem universe_subtitle" % u_id)
			assert(u_data.has("color"), "Universo %s não tem color" % u_id)
			assert(u_data.has("icon"), "Universo %s não tem icon" % u_id)
			print("[PASS] Universo validado: %s %s [%s]" % [u_data["icon"], u_data["universe_name"], u_id])
		
		# 2. Teste do ciclo de Salto Dimensional
		print("\n--- Testando ciclo do Salto Dimensional ---")
		var start_u = GameManager.current_outfit
		print("Universo inicial: %s" % start_u)
		for i in range(GameManager.UNIVERSES.size()):
			var before_u = GameManager.current_outfit
			var next_u = GameManager.shift_to_next_universe()
			assert(next_u != before_u, "Universo deve ter mudado!")
			assert(GameManager.current_outfit == next_u)
			print("[PASS] Salto %d: %s -> %s (%s)" % [i + 1, before_u, next_u, GameManager.OUTFITS[next_u]["universe_name"]])
		assert(GameManager.current_outfit == start_u, "Após 6 saltos, deve retornar ao universo de início")
		
		# 3. Teste de persistência e mudança ao abrir o jogo (shift_universe_on_startup)
		print("\n--- Testando persistência e mudança ao abrir o jogo ---")
		GameManager.set_outfit("classic")
		assert(GameManager._load_saved_universe() == "classic")
		GameManager.shift_universe_on_startup()
		assert(GameManager.current_outfit == "celestial", "Ao abrir após classic, deve mudar para celestial!")
		print("[PASS] shift_universe_on_startup(): classic -> celestial")
		
		GameManager.shift_universe_on_startup()
		assert(GameManager.current_outfit == "valkyrie", "Ao abrir após celestial, deve mudar para valkyrie!")
		print("[PASS] shift_universe_on_startup(): celestial -> valkyrie")
		
		# 4. Teste de UI no Menu Principal
		print("\n--- Testando UI do Menu Principal ---")
		_apply_active_universe_ui(GameManager.get_current_outfit_data(), true)
		assert(shift_universe_btn.text.contains("Valquíria"))
		assert(title_badge.text.contains("VALQUÍRIA"))
		assert(universe_toast.visible == true)
		print("[PASS] Menu Principal exibe título, botão e toast do universo ativo!")
		
		# 5. Teste da Lina in-game com o universo ativo
		print("\n--- Testando instanciação do Player no universo ativo ---")
		var p_scene = load("res://scenes/player/player.tscn").instantiate()
		add_child(p_scene)
		assert(p_scene.sprite.sprite_frames == GameManager.get_outfit_sprite_frames("valkyrie"))
		print("[PASS] Player in-game recebeu o SpriteFrames do universo Valquíria!")
		p_scene.queue_free()
		
		# 6. Teste de transformação do Cenário e Fases entre Universos
		print("\n--- Testando transformação dinâmica de Fase, Plataformas e Fundo ---")
		GameManager.equip_outfit("celestial")
		var lvl1 = load("res://scenes/levels/level_1.tscn").instantiate()
		add_child(lvl1)
		
		var pbg = lvl1.get_node_or_null("ParallaxBackground")
		assert(pbg != null, "Level 1 deve possuir ParallaxBackground!")
		assert(pbg.get_script() != null, "ParallaxBackground deve ter o script parallax_background.gd anexado!")
		pbg.apply_universe_theme(true)
		
		var cel_theme = GameManager.get_universe_theme("celestial")
		assert(pbg.sky_sprite.texture.resource_path.contains("celestial/sky.png"), "Textura personalizada do céu deve ser do Celestial!")
		assert(pbg.far_sprite.texture.resource_path.contains("celestial/far.png"), "Textura personalizada das montanhas distantes deve ser do Celestial!")
		assert(pbg.mid_sprite.texture.resource_path.contains("celestial/mid.png"), "Textura personalizada das montanhas médias deve ser do Celestial!")
		assert(pbg.trees_sprite.texture.resource_path.contains("celestial/trees.png"), "Textura personalizada das árvores/estruturas deve ser do Celestial!")
		assert(pbg.sky_sprite.modulate == cel_theme["sky_color"], "Céu deve assumir a cor do Universo Celestial!")
		assert(pbg.snow_particles.color == cel_theme["particles_color"], "Partículas devem assumir a cor estelar!")
		
		var ground_start = lvl1.get_node_or_null("Platforms/Ground_Start")
		assert(ground_start != null)
		assert(ground_start.modulate == cel_theme["platform_modulate"], "Plataforma de chão deve modular para o tema celestial!")
		
		var ice_step = lvl1.get_node_or_null("Platforms/Ice_Step1")
		assert(ice_step != null)
		assert(ice_step.modulate == cel_theme["ice_modulate"], "Plataforma de gelo deve modular para o tema celestial!")
		
		var lighting = lvl1.get_node_or_null("UniverseLighting")
		assert(lighting != null, "CanvasModulate UniverseLighting deve ser criado!")
		assert(lighting.color == cel_theme["ambient_modulate"], "Luz ambiente deve refletir o Universo Celestial!")
		
		# Verifica o HUD da fase com o universo ativo
		var hud_badge = lvl1.get_node_or_null("HUD/Control/MarginContainer/HBoxContainer/PlayerInfo/VBoxContainer/LevelBadge")
		assert(hud_badge != null)
		assert(hud_badge.text.contains("Celestial"), "HUD deve exibir o nome do Universo Celestial!")
		print("[PASS] Fase 1 inicializada com sucesso no Universo Celestial (Texturas personalizadas de Céu, Ilhas Flutuantes, Templos e Árvores Astrais)!")
		
		# 7. Teste de mudança em tempo real dentro da fase
		print("\n--- Testando Salto Dimensional em tempo real dentro da Fase ---")
		var next_id = GameManager.shift_to_next_universe()
		assert(next_id == "valkyrie")
		var valk_theme = GameManager.get_universe_theme("valkyrie")
		pbg.apply_universe_theme(true)
		assert(pbg.sky_sprite.texture.resource_path.contains("valkyrie/sky.png"), "Textura personalizada do céu deve ser da Valquíria!")
		assert(pbg.far_sprite.texture.resource_path.contains("valkyrie/far.png"), "Textura personalizada das montanhas distantes deve ser da Valquíria!")
		assert(pbg.mid_sprite.texture.resource_path.contains("valkyrie/mid.png"), "Textura personalizada das montanhas médias deve ser da Valquíria!")
		assert(pbg.trees_sprite.texture.resource_path.contains("valkyrie/trees.png"), "Textura personalizada das árvores/estruturas deve ser da Valquíria!")
		assert(pbg.sky_sprite.modulate == valk_theme["sky_color"], "Céu deve transicionar para Universo Valquíria!")
		assert(ground_start.modulate == valk_theme["platform_modulate"], "Plataformas devem transicionar para Universo Valquíria!")
		assert(ice_step.modulate == valk_theme["ice_modulate"], "Gelo deve transicionar para Universo Valquíria!")
		assert(hud_badge.text.contains("Valquíria"), "HUD deve atualizar para Universo Valquíria!")
		print("[PASS] Salto Dimensional em tempo real dentro da fase transformou cenário, texturas personalizadas e HUD para Valquíria!")
		
		lvl1.queue_free()
		
		# 8. Validação de 12 fases diferentes para cada um dos 13 universos (156 fases no total)
		print("\n--- Testando 12 Fases Diferentes para cada um dos 13 Universos (156 Fases no Total) ---")
		var all_universes = GameManager.UNIVERSES
		for u in all_universes:
			for lvl_idx in range(1, 13):
				var path_lvl = GameManager.get_level_path(lvl_idx, u)
				assert(ResourceLoader.exists(path_lvl), "Fase %d do universo '%s' não existe: %s" % [lvl_idx, u, path_lvl])
				var stage_inst = load(path_lvl).instantiate()
				assert(stage_inst != null, "Falha ao instanciar fase %d do universo '%s'" % [lvl_idx, u])
				add_child(stage_inst)
				
				assert(stage_inst.get_node_or_null("Player") != null, "Fase %d (%s) sem Player!" % [lvl_idx, u])
				assert(stage_inst.get_node_or_null("InteractiveObjects/Portal") != null, "Fase %d (%s) sem Portal!" % [lvl_idx, u])
				assert(stage_inst.get_node_or_null("HUD") != null, "Fase %d (%s) sem HUD!" % [lvl_idx, u])
				assert(stage_inst.get_node_or_null("Platforms") != null, "Fase %d (%s) sem Platforms!" % [lvl_idx, u])
				assert(stage_inst.get_node_or_null("ParallaxBackground") != null, "Fase %d (%s) sem ParallaxBackground!" % [lvl_idx, u])
				assert(stage_inst.get_node_or_null("Mechanics") != null, "Fase %d (%s) sem Mechanics!" % [lvl_idx, u])
				
				var st_name = GameManager.get_stage_name(lvl_idx, u)
				assert(st_name != "", "Fase %d (%s) sem nome personalizado!" % [lvl_idx, u])
				
				var st_story = GameManager.get_stage_story(lvl_idx, u)
				assert(st_story.has("ingredient"), "Fase %d (%s) sem ingrediente de história!" % [lvl_idx, u])
				
				stage_inst.queue_free()
			print("[PASS] Universo '%s': Todas as 12 fases exclusivas validadas com sucesso!" % u)
		
		print("\n=======================================================")
		print("=== TODOS OS TESTES DE UNIVERSO PASSARAM COM SUCESSO! ===")
		print("=======================================================\n")
		get_tree().quit(0)
		return

	if "--test-speedrun" in OS.get_cmdline_args() or "--test-speedrun" in OS.get_cmdline_user_args():
		print("\n=======================================================")
		print("=== TESTE AUTOMATIZADO: MODO SPEEDRUN & 12 FASES ===")
		print("=======================================================")
		
		# 1. Validação de MAX_LEVELS
		assert(GameManager.MAX_LEVELS == 12, "MAX_LEVELS deve ser 12!")
		print("[PASS] Total de fases configurado: 12 fases.")
		
		# 2. Validação dos Alvos de Speedrun (Ranks S, A, B)
		for lvl in range(1, 13):
			var target = GameManager.get_speedrun_target(lvl)
			assert(target.has("s") and target.has("a") and target.has("b"), "Fase %d sem metas de speedrun!" % lvl)
			assert(target["s"] < target["a"] and target["a"] < target["b"], "Tempos de rank inconsistentes na fase %d!" % lvl)
			print("[PASS] Fase %d '%s': Rank S <= %.1fs | Rank A <= %.1fs | Rank B <= %.1fs" % [lvl, target["name"], target["s"], target["a"], target["b"]])
		
		# 3. Teste de cálculo de Rank
		assert(GameManager.calculate_speedrun_rank(1, 15.2) == "S")
		assert(GameManager.calculate_speedrun_rank(1, 22.0) == "A")
		assert(GameManager.calculate_speedrun_rank(1, 35.0) == "B")
		assert(GameManager.calculate_speedrun_rank(1, 55.0) == "C")
		print("[PASS] Cálculo de Ranks S, A, B e C verificado!")
		
		# 4. Teste de salvamento de Personal Best (PB)
		var test_rec1 = GameManager.save_speedrun_record(99, 65.0, 5)
		assert(test_rec1["rank"] == "C")
		var test_rec2 = GameManager.save_speedrun_record(99, 20.0, 8)
		assert(test_rec2["is_new_pb"] == true)
		assert(test_rec2["best_time"] == 20.0)
		var test_rec3 = GameManager.save_speedrun_record(99, 30.0, 8)
		assert(test_rec3["is_new_pb"] == false)
		assert(test_rec3["best_time"] == 20.0)
		# Limpa chave de teste 99
		var recs = GameManager.get_speedrun_records()
		recs.erase("99")
		var f_clean = FileAccess.open(GameManager.SPEEDRUN_SAVE_FILE, FileAccess.WRITE)
		if f_clean:
			f_clean.store_string(JSON.stringify(recs))
			f_clean.close()
		print("[PASS] Gravação e detecção de PB (Personal Best) funcional!")
		
		# 5. Instanciação e verificação de integridade de todas as 12 fases
		for lvl in range(1, 13):
			var scene_path = "res://scenes/levels/level_%d.tscn" % lvl
			assert(ResourceLoader.exists(scene_path), "Cena da fase %d não existe: %s" % [lvl, scene_path])
			var inst = load(scene_path).instantiate()
			assert(inst != null, "Falha ao instanciar fase %d" % lvl)
			add_child(inst)
			
			var player_node = inst.get_node_or_null("Player")
			assert(player_node != null, "Fase %d não possui Player!" % lvl)
			
			var portal_node = inst.get_node_or_null("InteractiveObjects/Portal")
			assert(portal_node != null, "Fase %d não possui Portal!" % lvl)
			
			var hud_node = inst.get_node_or_null("HUD")
			assert(hud_node != null, "Fase %d não possui HUD!" % lvl)
			
			var platforms = inst.get_node_or_null("Platforms")
			assert(platforms != null, "Fase %d não possui nó Platforms!" % lvl)
			
			var pbg = inst.get_node_or_null("ParallaxBackground")
			assert(pbg != null, "Fase %d não possui ParallaxBackground!" % lvl)
			
			inst.queue_free()
			print("[PASS] Fase %d carregada com sucesso com Player, Portal, HUD, Plataformas e Background!" % lvl)
		
		print("\n=======================================================")
		print("=== TODOS OS TESTES DE SPEEDRUN (12 FASES) PASSARAM! ===")
		print("=======================================================\n")
		get_tree().quit(0)
		return

	if "--add-mechanics" in OS.get_cmdline_args() or "--add-mechanics" in OS.get_cmdline_user_args():
		print("\n=== DISTRIBUINDO POWER-UPS E NOVAS MECÂNICAS (FASES 1 A 15) ===")
		var powerup_sc = load("res://scenes/objects/powerup.tscn")
		var boost_sc = load("res://scenes/objects/boost_pad.tscn")
		var wind_sc = load("res://scenes/objects/wind_current.tscn")
		var crumble_sc = load("res://scenes/objects/crumbling_platform.tscn")
		var wall_sc = load("res://scenes/objects/breakable_wall.tscn")
		
		var stage_mechanics = {
			1: {
				"powerups": [[Vector2(650, 420), "dash"], [Vector2(2260, 320), "magnet"], [Vector2(3250, 300), "chrono"], [Vector2(4100, 180), "shield"]],
				"boosts": [[Vector2(1420, 528), 1.0, 96.0]],
				"winds": [[Vector2(2800, 480), -480.0, Vector2(70, 220)]],
				"crumbles": [[Vector2(1150, 440), Vector2(100, 24)]],
				"walls": [[Vector2(3200, 380), Vector2(32, 100)]]
			},
			2: {
				"powerups": [[Vector2(750, 360), "wings"], [Vector2(2000, 280), "dash"], [Vector2(3300, 220), "chrono"]],
				"boosts": [[Vector2(1200, 450), 1.0, 96.0], [Vector2(2900, 380), 1.0, 96.0]],
				"winds": [[Vector2(1750, 500), -520.0, Vector2(80, 240)]],
				"crumbles": [[Vector2(2450, 410), Vector2(110, 24)], [Vector2(2650, 360), Vector2(110, 24)]],
				"walls": [[Vector2(3600, 340), Vector2(36, 110)]]
			},
			3: {
				"powerups": [[Vector2(600, 420), "magnet"], [Vector2(1700, 260), "shield"], [Vector2(3400, 200), "chrono"]],
				"boosts": [[Vector2(2100, 460), 1.0, 96.0]],
				"winds": [[Vector2(1300, 520), -540.0, Vector2(80, 260)], [Vector2(3000, 480), -500.0, Vector2(70, 220)]],
				"crumbles": [[Vector2(1850, 380), Vector2(100, 24)], [Vector2(2750, 360), Vector2(100, 24)]],
				"walls": [[Vector2(2350, 370), Vector2(32, 100)]]
			},
			4: {
				"powerups": [[Vector2(680, 380), "dash"], [Vector2(1950, 240), "wings"], [Vector2(3600, 180), "chrono"]],
				"boosts": [[Vector2(1400, 420), 1.0, 96.0], [Vector2(2850, 360), 1.0, 96.0]],
				"winds": [[Vector2(2200, 460), -550.0, Vector2(80, 250)]],
				"crumbles": [[Vector2(1050, 420), Vector2(110, 24)], [Vector2(3200, 320), Vector2(110, 24)]],
				"walls": [[Vector2(2700, 330), Vector2(36, 110)]]
			},
			5: {
				"powerups": [[Vector2(850, 360), "shield"], [Vector2(2100, 260), "dash"], [Vector2(3500, 190), "chrono"]],
				"boosts": [[Vector2(1350, 440), 1.0, 96.0], [Vector2(3000, 360), 1.0, 96.0]],
				"winds": [[Vector2(1650, 480), -560.0, Vector2(80, 260)]],
				"crumbles": [[Vector2(2450, 370), Vector2(120, 24)], [Vector2(3700, 250), Vector2(120, 24)]],
				"walls": [[Vector2(3300, 290), Vector2(36, 120)]]
			},
			6: {
				"powerups": [[Vector2(620, 380), "dash"], [Vector2(1850, 160), "wings"], [Vector2(3650, 120), "chrono"]],
				"boosts": [[Vector2(950, 450), 1.0, 96.0]],
				"winds": [[Vector2(2400, 520), -500.0, Vector2(80, 240)]],
				"crumbles": [[Vector2(1500, 380), Vector2(110, 24)], [Vector2(2850, 340), Vector2(110, 24)]],
				"walls": [[Vector2(3100, 420), Vector2(32, 100)]]
			},
			7: {
				"powerups": [[Vector2(700, 340), "magnet"], [Vector2(2300, 320), "shield"], [Vector2(3850, 130), "chrono"]],
				"boosts": [[Vector2(1050, 500), 1.0, 96.0], [Vector2(3300, 440), 1.0, 96.0]],
				"winds": [[Vector2(1950, 480), -520.0, Vector2(80, 240)]],
				"crumbles": [[Vector2(2600, 360), Vector2(110, 24)]],
				"walls": [[Vector2(3500, 380), Vector2(36, 110)]]
			},
			8: {
				"powerups": [[Vector2(750, 340), "dash"], [Vector2(2200, 260), "wings"], [Vector2(3950, 140), "chrono"]],
				"boosts": [[Vector2(1250, 460), 1.0, 96.0]],
				"winds": [[Vector2(1800, 500), -540.0, Vector2(80, 250)]],
				"crumbles": [[Vector2(2750, 360), Vector2(110, 24)], [Vector2(3450, 320), Vector2(110, 24)]],
				"walls": [[Vector2(3000, 380), Vector2(32, 100)]]
			},
			9: {
				"powerups": [[Vector2(650, 360), "shield"], [Vector2(2100, 300), "magnet"], [Vector2(3650, 160), "chrono"]],
				"boosts": [[Vector2(950, 480), 1.0, 96.0], [Vector2(2850, 420), 1.0, 96.0]],
				"winds": [[Vector2(1600, 490), -530.0, Vector2(80, 240)]],
				"crumbles": [[Vector2(2400, 380), Vector2(110, 24)]],
				"walls": [[Vector2(3200, 360), Vector2(36, 110)]]
			},
			10: {
				"powerups": [[Vector2(750, 360), "dash"], [Vector2(2250, 250), "wings"], [Vector2(4000, 160), "chrono"]],
				"boosts": [[Vector2(1150, 460), 1.0, 96.0], [Vector2(3100, 400), 1.0, 96.0]],
				"winds": [[Vector2(1850, 480), -550.0, Vector2(80, 260)]],
				"crumbles": [[Vector2(2650, 360), Vector2(110, 24)], [Vector2(3500, 300), Vector2(110, 24)]],
				"walls": [[Vector2(2850, 360), Vector2(36, 110)]]
			},
			11: {
				"powerups": [[Vector2(800, 350), "magnet"], [Vector2(2300, 260), "shield"], [Vector2(4100, 140), "chrono"]],
				"boosts": [[Vector2(1300, 450), 1.0, 96.0]],
				"winds": [[Vector2(1900, 500), -560.0, Vector2(80, 260)], [Vector2(3400, 460), -520.0, Vector2(80, 240)]],
				"crumbles": [[Vector2(2800, 350), Vector2(110, 24)]],
				"walls": [[Vector2(3100, 360), Vector2(32, 100)]]
			},
			12: {
				"powerups": [[Vector2(700, 380), "dash"], [Vector2(2150, 280), "wings"], [Vector2(3800, 170), "chrono"]],
				"boosts": [[Vector2(1000, 480), 1.0, 96.0], [Vector2(2950, 420), 1.0, 96.0]],
				"winds": [[Vector2(1700, 490), -520.0, Vector2(80, 240)]],
				"crumbles": [[Vector2(2500, 370), Vector2(110, 24)], [Vector2(3400, 310), Vector2(110, 24)]],
				"walls": [[Vector2(3150, 370), Vector2(36, 110)]]
			},
			13: {
				"powerups": [[Vector2(850, 360), "shield"], [Vector2(2400, 270), "dash"], [Vector2(4200, 150), "chrono"]],
				"boosts": [[Vector2(1200, 480), 1.0, 96.0], [Vector2(3200, 420), 1.0, 96.0]],
				"winds": [[Vector2(1950, 510), -550.0, Vector2(80, 260)]],
				"crumbles": [[Vector2(2750, 370), Vector2(120, 24)], [Vector2(3700, 300), Vector2(120, 24)]],
				"walls": [[Vector2(3450, 370), Vector2(36, 120)]]
			},
			14: {
				"powerups": [[Vector2(700, 380), "dash"], [Vector2(2000, 290), "magnet"], [Vector2(3700, 180), "chrono"]],
				"boosts": [[Vector2(900, 480), 1.0, 96.0], [Vector2(2700, 420), 1.0, 96.0]],
				"winds": [[Vector2(1600, 490), -540.0, Vector2(80, 250)]],
				"crumbles": [[Vector2(2300, 380), Vector2(110, 24)]],
				"walls": [[Vector2(3000, 360), Vector2(32, 100)]]
			},
			15: {
				"powerups": [[Vector2(750, 360), "wings"], [Vector2(1600, 280), "dash"], [Vector2(2500, 260), "shield"], [Vector2(3400, 220), "magnet"], [Vector2(4200, 160), "chrono"]],
				"boosts": [[Vector2(1100, 480), 1.0, 96.0], [Vector2(3100, 420), 1.0, 96.0]],
				"winds": [[Vector2(1900, 520), -560.0, Vector2(80, 260)], [Vector2(3750, 480), -540.0, Vector2(80, 250)]],
				"crumbles": [[Vector2(2300, 370), Vector2(120, 24)], [Vector2(2850, 340), Vector2(120, 24)], [Vector2(3900, 280), Vector2(120, 24)]],
				"walls": [[Vector2(3200, 370), Vector2(36, 120)]]
			}
		}
		
		for lvl in range(1, 16):
			var scene_path = "res://scenes/levels/level_%d.tscn" % lvl
			var sc = load(scene_path)
			if not sc:
				continue
			var root = sc.instantiate()
			
			var mechanics = root.get_node_or_null("Mechanics")
			if mechanics:
				mechanics.free()
			
			mechanics = Node2D.new()
			mechanics.name = "Mechanics"
			root.add_child(mechanics)
			mechanics.owner = root
			
			var cfg = stage_mechanics.get(lvl, {})
			for p_data in cfg.get("powerups", []):
				var pup = powerup_sc.instantiate()
				pup.position = p_data[0]
				pup.set("powerup_type", p_data[1])
				mechanics.add_child(pup)
				pup.owner = root
				
			for b_data in cfg.get("boosts", []):
				var b = boost_sc.instantiate()
				b.position = b_data[0]
				b.set("boost_direction", b_data[1])
				b.set("pad_width", b_data[2])
				mechanics.add_child(b)
				b.owner = root
				
			for w_data in cfg.get("winds", []):
				var w = wind_sc.instantiate()
				w.position = w_data[0]
				w.set("updraft_force", w_data[1])
				w.set("current_size", w_data[2])
				mechanics.add_child(w)
				w.owner = root
				
			for c_data in cfg.get("crumbles", []):
				var c = crumble_sc.instantiate()
				c.position = c_data[0]
				c.set("platform_size", c_data[1])
				mechanics.add_child(c)
				c.owner = root
				
			for wl_data in cfg.get("walls", []):
				var wl = wall_sc.instantiate()
				wl.position = wl_data[0]
				wl.set("wall_size", wl_data[1])
				mechanics.add_child(wl)
				wl.owner = root
				
			var packed = PackedScene.new()
			if packed.pack(root) == OK:
				ResourceSaver.save(packed, scene_path)
				print("[OK] Fase %d salva com Power-Ups e Mecânicas!" % lvl)
			root.free()
			
		print("=== TODAS AS 15 FASES ATUALIZADAS COM SUCESSO! ===")
		get_tree().quit(0)
		return

	if "--test-mechanics" in OS.get_cmdline_args() or "--test-mechanics" in OS.get_cmdline_user_args():
		print("\n=======================================================")
		print("=== TESTE AUTOMATIZADO: POWER-UPS & NOVAS MECÂNICAS ===")
		print("=======================================================")
		
		# 1. Teste de Power-Ups no GameManager
		GameManager.reset_powers()
		assert(not GameManager.is_powerup_active("dash"))
		assert(not GameManager.is_chrono_active())
		
		GameManager.trigger_powerup("dash", 5.0)
		assert(GameManager.is_powerup_active("dash"))
		assert(GameManager.get_active_speed_multiplier() > 1.3)
		print("[PASS] Power-up 'dash' ativado com bônus de velocidade!")
		
		GameManager.trigger_powerup("chrono", 4.0)
		assert(GameManager.is_chrono_active())
		var time_before = GameManager.elapsed_time
		GameManager._process(0.5)
		assert(GameManager.elapsed_time == time_before)
		print("[PASS] Power-up 'chrono' congela o cronômetro com perfeição!")
		
		GameManager.trigger_powerup("wings", 6.0)
		assert(GameManager.get_effective_air_jumps() >= 3)
		print("[PASS] Power-up 'wings' concede saltos extras!")
		
		GameManager.trigger_powerup("magnet", 6.0)
		assert(GameManager.get_effective_magnet_radius() >= 450.0)
		print("[PASS] Power-up 'magnet' concede raio de atração expandido!")
		
		GameManager.trigger_powerup("shield")
		assert(GameManager.shield_active == true)
		assert(GameManager.consume_shield() == true)
		assert(GameManager.shield_active == false)
		print("[PASS] Power-up 'shield' absorve impacto e protege o jogador!")
		
		# 2. Teste do Dash no Player
		var player_sc = load("res://scenes/player/player.tscn")
		var player = player_sc.instantiate()
		add_child(player)
		assert(player.is_dashing == false)
		player._execute_dash(1.0)
		assert(player.is_dashing == true)
		assert(player.velocity.x == 750.0)
		assert(player.is_invulnerable == true)
		player.recharge_dash()
		assert(player.dash_cooldown == 0.0)
		print("[PASS] Mecânica de DASH testada com velocidade 750px/s, invulnerabilidade e recarga!")
		player.queue_free()
		
		# 3. Teste do Boost Pad
		var boost_pad = load("res://scenes/objects/boost_pad.tscn").instantiate()
		add_child(boost_pad)
		var test_p = player_sc.instantiate()
		add_child(test_p)
		boost_pad._on_body_entered(test_p)
		assert(test_p.velocity.x == 880.0)
		print("[PASS] Boost Pad lança o jogador com velocidade supersônica de 880px/s!")
		boost_pad.queue_free()
		test_p.queue_free()
		
		# 4. Teste da Corrente de Vento
		var wind = load("res://scenes/objects/wind_current.tscn").instantiate()
		add_child(wind)
		var test_p2 = player_sc.instantiate()
		add_child(test_p2)
		wind._on_body_entered(test_p2)
		wind._physics_process(0.1)
		assert(test_p2.velocity.y < 0.0)
		print("[PASS] Corrente de Vento impulsiona jogador verticalmente!")
		wind.queue_free()
		test_p2.queue_free()
		
		# 5. Teste da Plataforma Quebradiça
		var crumb = load("res://scenes/objects/crumbling_platform.tscn").instantiate()
		add_child(crumb)
		var test_p3 = player_sc.instantiate()
		add_child(test_p3)
		crumb._on_trigger_entered(test_p3)
		assert(crumb.is_crumbling == true)
		print("[PASS] Plataforma Quebradiça detecta jogador e inicia colapso!")
		crumb.queue_free()
		test_p3.queue_free()
		
		# 6. Teste da Parede Quebrável
		var wall = load("res://scenes/objects/breakable_wall.tscn").instantiate()
		add_child(wall)
		assert(wall.is_broken == false)
		wall.break_wall()
		assert(wall.is_broken == true)
		print("[PASS] Parede de Cristal Quebrável destruída revelando atalho secreto!")
		wall.queue_free()
		
		# 7. Validação das 12 fases com nó 'Mechanics'
		for lvl in range(1, 13):
			var l_path = "res://scenes/levels/level_%d.tscn" % lvl
			var l_inst = load(l_path).instantiate()
			var m_node = l_inst.get_node_or_null("Mechanics")
			assert(m_node != null, "Fase %d não tem nó Mechanics!" % lvl)
			assert(m_node.get_child_count() > 0, "Fase %d tem Mechanics vazio!" % lvl)
			l_inst.queue_free()
			print("[PASS] Fase %d validada com %d novos power-ups e mecanismos!" % [lvl, m_node.get_child_count()])
		
		print("\n=======================================================")
		print("=== TODOS OS TESTES DE MECÂNICAS E POWER-UPS PASSARAM! ===")
		print("=======================================================\n")
		get_tree().quit(0)
		return

func _process(delta: float) -> void:
	anim_time += delta
	
	# Efeito pulsante no texto guia
	if prompt_label:
		prompt_label.modulate.a = 0.55 + 0.45 * sin(anim_time * 3.5)
	
	# Brilho pulsante no selo do título (neon speedrun)
	if title_badge:
		title_badge.modulate.a = 0.85 + 0.15 * sin(anim_time * 2.5)
	
	# Flutuação suave do cristal decorativo
	if crystal_deco:
		crystal_deco.position.y = 510.0 + sin(anim_time * 2.5) * 8.0
		crystal_deco.rotation = sin(anim_time * 1.5) * 0.12
	
	# Movimento da Lina ao iniciar
	if is_starting and lina:
		lina.position.x += 420.0 * delta

func _setup_menu_btn_hover(btn: Button) -> void:
	btn.pivot_offset = btn.size / 2.0
	btn.mouse_entered.connect(func():
		var tw = create_tween()
		tw.tween_property(btn, "scale", Vector2(1.035, 1.035), 0.1).set_trans(Tween.TRANS_SINE)
		SoundManager.play_sfx("jump", 0.04)
	)
	btn.mouse_exited.connect(func():
		var tw = create_tween()
		tw.tween_property(btn, "scale", Vector2.ONE, 0.1)
	)
	btn.focus_entered.connect(func():
		var tw = create_tween()
		tw.tween_property(btn, "scale", Vector2(1.035, 1.035), 0.1).set_trans(Tween.TRANS_SINE)
		_on_btn_focused()
	)
	btn.focus_exited.connect(func():
		var tw = create_tween()
		tw.tween_property(btn, "scale", Vector2.ONE, 0.1)
	)

func _pop_in_modal(panel: Control) -> void:
	if not panel:
		return
	panel.pivot_offset = panel.size / 2.0
	panel.scale = Vector2(0.92, 0.92)
	var tw = create_tween()
	tw.tween_property(panel, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _unhandled_input(event: InputEvent) -> void:
	if is_starting:
		return
		
	if story_panel.visible:
		if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
			_on_close_story_pressed()
			get_viewport().set_input_as_handled()
		return

	if wardrobe_panel.visible:
		if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
			_on_close_wardrobe_pressed()
			get_viewport().set_input_as_handled()
		return
		
	if controls_panel.visible:
		if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel") or event.is_action_pressed("jump") or event.is_action_pressed("ui_accept"):
			_on_close_controls_pressed()
			get_viewport().set_input_as_handled()
		return
	
	if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		quit_btn.grab_focus()
		get_viewport().set_input_as_handled()
		return
	
	# Tecla U para Salto Dimensional instantâneo
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_U:
		_on_shift_universe_pressed()
		get_viewport().set_input_as_handled()
		return

func _on_btn_focused() -> void:
	SoundManager.play_sfx("land", 0.05)

func _on_story_pressed() -> void:
	SoundManager.play_sfx("jump", 0.08)
	story_panel.visible = true
	_pop_in_modal(story_panel)
	story_start_btn.grab_focus()

func _on_close_story_pressed() -> void:
	SoundManager.play_sfx("land", 0.08)
	story_panel.visible = false
	play_btn.grab_focus()

func _on_play_pressed() -> void:
	if is_starting:
		return
	is_starting = true
	
	SoundManager.play_sfx("jump", 0.15)
	
	if lina:
		lina.play("run")
	
	# Transição cinematográfica para a Cutscene da História
	var tween = create_tween().set_parallel(true)
	tween.tween_property(fade_rect, "modulate:a", 1.0, 0.45)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/ui/story_cutscene.tscn")


func _on_wardrobe_pressed() -> void:
	SoundManager.play_sfx("crystal")
	wardrobe_panel.visible = true
	_pop_in_modal(wardrobe_panel)
	_preview_outfit(GameManager.current_outfit)
	close_wardrobe_btn.grab_focus()

func _on_close_wardrobe_pressed() -> void:
	SoundManager.play_sfx("land", 0.08)
	wardrobe_panel.visible = false
	play_btn.grab_focus()
	# Restaura a roupa equipada se o jogador apenas pré-visualizou sem equipar
	_update_lina_character_outfit(GameManager.current_outfit)

func _preview_outfit(outfit_id: String) -> void:
	highlighted_outfit = outfit_id
	var data: Dictionary = GameManager.OUTFITS.get(outfit_id, GameManager.OUTFITS["classic"])
	
	_update_preview_image()
	_update_lina_character_outfit(outfit_id)
	
	outfit_title.text = "%s %s" % [data["icon"], data["name"]]
	outfit_title.modulate = data["color"]
	outfit_desc.text = data["desc"]
	rarity_badge.text = "[ %s • %s ]" % [data["badge"].to_upper(), data["theme"].to_upper()]
	rarity_badge.modulate = data["color"]
	
	# Atualiza estado do botão de equipar
	if GameManager.current_outfit == outfit_id:
		equip_btn.text = "✓ Traje Equipado"
		equip_btn.disabled = true
	else:
		equip_btn.text = "✨ Equipar este Traje"
		equip_btn.disabled = false
	
	# Animação de pulinho na pré-visualização
	preview_rect.pivot_offset = preview_rect.size / 2.0
	var tw = create_tween()
	preview_rect.scale = Vector2(1.1, 1.1)
	tw.tween_property(preview_rect, "scale", Vector2.ONE, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_toggle_view_mode() -> void:
	SoundManager.play_sfx("land", 0.06)
	if preview_mode == "portrait":
		preview_mode = "sprite"
		view_mode_btn.text = "🔄 Alternar p/ Retrato"
	else:
		preview_mode = "portrait"
		view_mode_btn.text = "🔄 Alternar p/ Sprite 2D"
	_update_view_mode_visibility()
	_update_preview_image()
	_update_lina_character_outfit(highlighted_outfit)

func _update_view_mode_visibility() -> void:
	if preview_mode == "portrait":
		preview_rect.visible = true
		preview_anim_container.visible = false
		anim_toggle_btn.visible = false
	else:
		preview_rect.visible = false
		preview_anim_container.visible = true
		anim_toggle_btn.visible = true

func _on_toggle_anim() -> void:
	SoundManager.play_sfx("jump", 0.08)
	current_anim_idx = (current_anim_idx + 1) % PREVIEW_ANIMS.size()
	var anim_info = PREVIEW_ANIMS[current_anim_idx]
	anim_toggle_btn.text = anim_info["label"]
	
	var anim_name = anim_info["name"]
	if preview_sprite and preview_sprite.sprite_frames and preview_sprite.sprite_frames.has_animation(anim_name):
		preview_sprite.play(anim_name)
	if lina and lina.sprite_frames and lina.sprite_frames.has_animation(anim_name):
		lina.play(anim_name)

func _update_preview_image() -> void:
	var data: Dictionary = GameManager.OUTFITS.get(highlighted_outfit, GameManager.OUTFITS["classic"])
	preview_rect.texture = load(data["portrait"])
	
	var frames: SpriteFrames = GameManager.get_outfit_sprite_frames(highlighted_outfit)
	if frames and preview_sprite:
		preview_sprite.sprite_frames = frames
		var anim_name = PREVIEW_ANIMS[current_anim_idx]["name"]
		if preview_sprite.sprite_frames.has_animation(anim_name):
			preview_sprite.play(anim_name)
		else:
			preview_sprite.play("idle")

func _update_lina_character_outfit(outfit_id: String) -> void:
	if not lina:
		return
	var frames: SpriteFrames = GameManager.get_outfit_sprite_frames(outfit_id)
	if frames:
		lina.sprite_frames = frames
		var anim_name = PREVIEW_ANIMS[current_anim_idx]["name"] if (preview_mode == "sprite" and wardrobe_panel.visible) else "idle"
		if lina.sprite_frames.has_animation(anim_name):
			lina.play(anim_name)
		else:
			lina.play("idle")

func _on_equip_pressed() -> void:
	GameManager.set_outfit(highlighted_outfit)
	_update_lina_character_outfit(highlighted_outfit)
	SoundManager.play_sfx("portal")
	
	equip_btn.text = "✓ Traje Equipado!"
	equip_btn.disabled = true
	
	var tw = create_tween()
	equip_btn.scale = Vector2(1.08, 1.08)
	tw.tween_property(equip_btn, "scale", Vector2.ONE, 0.2)

func _on_controls_pressed() -> void:
	SoundManager.play_sfx("crystal")
	var dlg = find_child("ControlsConfigDialog", true, false)
	if not dlg:
		var dlg_sc = load("res://scenes/ui/controls_config_dialog.tscn")
		dlg = dlg_sc.instantiate()
		add_child(dlg)
	if dlg and dlg.has_method("open_dialog"):
		dlg.open_dialog()

func _on_close_controls_pressed() -> void:
	SoundManager.play_sfx("land", 0.08)
	controls_panel.visible = false
	play_btn.grab_focus()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _apply_active_universe_ui(data: Dictionary, is_startup: bool = false) -> void:
	var u_name: String = data.get("universe_name", data.get("name", "Universo"))
	var u_sub: String = data.get("universe_subtitle", data.get("desc", ""))
	var icon: String = data.get("icon", "❄️")
	var badge: String = data.get("badge", "Normal")
	var color: Color = data.get("color", Color(0.4, 0.85, 1.0))
	
	# Atualiza o botão no MenuCard
	if shift_universe_btn:
		shift_universe_btn.text = "🌀  Mudar Universo: %s %s" % [icon, data.get("name", "")]
	
	# Atualiza o Badge e Subtítulo do TitleBox com tema e cor do universo
	if title_badge:
		title_badge.text = "🌌 DIMENSÃO: %s %s • [%s] 🌌" % [icon, u_name.to_upper(), badge.to_upper()]
		title_badge.modulate = color
	if title_subtitle:
		title_subtitle.text = "%s — %s" % [data.get("name", ""), u_sub]
	
	# Atualiza o sprite e animação da Lina no menu
	_update_lina_character_outfit(data.get("id", "classic"))
	
	# Transforma o fundo, atmosfera e partículas do Menu de acordo com o universo
	var bg_tex: Dictionary = GameManager.get_current_universe_bg_textures()
	if not bg_tex.is_empty():
		if bg_sky and bg_tex.has("sky") and ResourceLoader.exists(bg_tex["sky"]):
			bg_sky.texture = load(bg_tex["sky"])
		if bg_mountains_far and bg_tex.has("far") and ResourceLoader.exists(bg_tex["far"]):
			bg_mountains_far.texture = load(bg_tex["far"])
		if bg_mountains_mid and bg_tex.has("mid") and ResourceLoader.exists(bg_tex["mid"]):
			bg_mountains_mid.texture = load(bg_tex["mid"])
		if bg_trees_near and bg_tex.has("trees") and ResourceLoader.exists(bg_tex["trees"]):
			bg_trees_near.texture = load(bg_tex["trees"])
	
	var theme: Dictionary = GameManager.get_current_universe_theme()
	if not theme.is_empty():
		var tw = create_tween().set_parallel(true)
		if bg_sky:
			tw.tween_property(bg_sky, "modulate", theme.get("sky_color", Color.WHITE), 0.45)
		if bg_mountains_far:
			tw.tween_property(bg_mountains_far, "modulate", theme.get("mountains_far_color", Color.WHITE), 0.45)
		if bg_mountains_mid:
			tw.tween_property(bg_mountains_mid, "modulate", theme.get("mountains_mid_color", Color.WHITE), 0.45)
		if bg_trees_near:
			tw.tween_property(bg_trees_near, "modulate", theme.get("trees_color", Color.WHITE), 0.45)
		if crystal_deco:
			tw.tween_property(crystal_deco, "modulate", theme.get("crystal_modulate", Color.WHITE), 0.45)
		if lantern:
			tw.tween_property(lantern, "modulate", theme.get("ice_modulate", Color.WHITE), 0.45)
		
		# Partículas dinâmicas de neve/poeira estelar do Menu
		if bg_snow_particles:
			bg_snow_particles.color = theme.get("particles_color", Color.WHITE)
			bg_snow_particles.gravity = theme.get("particles_gravity", Vector2(20, 35))
			var spd: Vector2 = theme.get("particles_speed", Vector2(40, 90))
			bg_snow_particles.initial_velocity_min = spd.x
			bg_snow_particles.initial_velocity_max = spd.y
			bg_snow_particles.spread = theme.get("particles_spread", 20.0)
		
		# Chão com estilo e cor do universo ativo
		if bg_snow_ground:
			var sb = bg_snow_ground.get_theme_stylebox("panel")
			if sb is StyleBoxFlat:
				var new_sb = sb.duplicate() as StyleBoxFlat
				new_sb.bg_color = theme.get("ground_color", Color(0.07, 0.1, 0.18, 0.98))
				new_sb.border_color = theme.get("ground_border", Color(0.88, 0.96, 1.0, 1.0))
				bg_snow_ground.add_theme_stylebox_override("panel", new_sb)
	
	# Exibe o Toast com animação
	_show_universe_toast(data, is_startup)

func _show_universe_toast(data: Dictionary, is_startup: bool) -> void:
	if not universe_toast:
		return
	
	var u_name: String = data.get("universe_name", data.get("name", "Universo"))
	var icon: String = data.get("icon", "❄️")
	var color: Color = data.get("color", Color(0.4, 0.85, 1.0))
	
	if toast_icon:
		toast_icon.text = icon
	if toast_title:
		if is_startup:
			toast_title.text = "✦ SALTO DIMENSIONAL ATIVADO AO INICIAR! ✦"
		else:
			toast_title.text = "✦ SALTO DIMENSIONAL ATIVADO! ✦"
		toast_title.modulate = color
	if toast_desc:
		toast_desc.text = "Dimensão Atual: %s %s (%s)" % [icon, u_name, data.get("name", "")]
	
	# Efeito de pop-in no Toast
	universe_toast.visible = true
	universe_toast.modulate.a = 0.0
	universe_toast.position.y = -30.0
	
	var tw = create_tween().set_parallel(true)
	tw.tween_property(universe_toast, "modulate:a", 1.0, 0.25)
	tw.tween_property(universe_toast, "position:y", 10.0, 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	if not is_startup:
		SoundManager.play_sfx("portal")
	
	# Timer para esconder suavemente após 4 segundos
	var hide_tw = create_tween()
	hide_tw.tween_interval(4.0)
	hide_tw.tween_property(universe_toast, "modulate:a", 0.0, 0.6)
	hide_tw.tween_callback(func(): if universe_toast and universe_toast.modulate.a <= 0.05: universe_toast.visible = false)

func _on_shift_universe_pressed() -> void:
	if is_starting:
		return
	var _next_id = GameManager.shift_to_next_universe()
	
	# Pulinho alegre e squash & stretch da Lina ao saltar entre universos
	if lina:
		var tw = create_tween()
		tw.tween_property(lina, "scale", Vector2(2.15, 2.15), 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tw.tween_property(lina, "scale", Vector2(1.8, 1.8), 0.15).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
	_apply_active_universe_ui(GameManager.get_current_outfit_data(), false)

func _on_universe_shifted(data: Dictionary) -> void:
	if not wardrobe_panel.visible:
		_apply_active_universe_ui(data, false)
