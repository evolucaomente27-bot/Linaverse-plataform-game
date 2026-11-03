extends Node

# SoundManager Autoload - Gerenciador central de áudio do Linaverse
var sfx_players: Array[AudioStreamPlayer] = []
var bgm_player: AudioStreamPlayer
const MAX_SFX_PLAYERS = 8

var sounds = {
	"jump": preload("res://assets/audio/sfx_jump.wav"),
	"double_jump": preload("res://assets/audio/sfx_double_jump.wav"),
	"land": preload("res://assets/audio/sfx_land.wav"),
	"crystal": preload("res://assets/audio/sfx_crystal.wav"),
	"stomp": preload("res://assets/audio/sfx_stomp.wav"),
	"bounce": preload("res://assets/audio/sfx_bounce.wav"),
	"hurt": preload("res://assets/audio/sfx_hurt.wav"),
	"checkpoint": preload("res://assets/audio/sfx_checkpoint.wav"),
	"portal": preload("res://assets/audio/sfx_portal.wav"),
	"win": preload("res://assets/audio/sfx_win.wav"),
	"game_over": preload("res://assets/audio/sfx_game_over.wav"),
	"bgm": preload("res://assets/audio/bgm_snowy_mountain.wav")
}

var sfx_muted: bool = false
var bgm_muted: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Inicializa pool de áudio SFX
	for i in range(MAX_SFX_PLAYERS):
		var p = AudioStreamPlayer.new()
		p.bus = "Master"
		add_child(p)
		sfx_players.append(p)
	
	# BGM player
	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = "Master"
	bgm_player.stream = sounds["bgm"]
	if bgm_player.stream is AudioStreamWAV:
		(bgm_player.stream as AudioStreamWAV).loop_mode = AudioStreamWAV.LOOP_FORWARD
	bgm_player.volume_db = -6.0
	add_child(bgm_player)
	bgm_player.finished.connect(_on_bgm_finished)
	play_bgm()

func play_sfx(sound_name: String, pitch_randomness: float = 0.0) -> void:
	if sfx_muted or not sounds.has(sound_name):
		return
	
	# Encontra player livre
	var player: AudioStreamPlayer = null
	for p in sfx_players:
		if not p.playing:
			player = p
			break
	if player == null:
		player = sfx_players[0]
	
	player.stream = sounds[sound_name]
	if pitch_randomness > 0.0:
		player.pitch_scale = randf_range(1.0 - pitch_randomness, 1.0 + pitch_randomness)
	else:
		player.pitch_scale = 1.0
	player.play()

func play_bgm() -> void:
	if bgm_muted:
		return
	if not bgm_player.playing:
		bgm_player.play()

func stop_bgm() -> void:
	bgm_player.stop()

func _on_bgm_finished() -> void:
	# Loop da trilha sonora
	if not bgm_muted:
		bgm_player.play()
