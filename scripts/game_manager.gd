extends Node

# GameManager Autoload - Controle de estado do jogo Linaverse

signal score_changed(current_score: int, total_crystals: int)
signal health_changed(current_hp: int, max_hp: int)
signal player_damaged()
signal player_died()
signal checkpoint_updated(pos: Vector2)
signal level_completed()
signal level_started(level_idx: int)
signal powers_updated()
signal shield_status_changed(active: bool)
signal outfit_changed(outfit_id: String)
signal universe_shifted(universe_data: Dictionary)
signal powerup_activated(type: String, duration: float, info: Dictionary)
signal powerup_ended(type: String)
signal dash_state_changed(is_ready: bool, cooldown_ratio: float)
signal touch_controls_changed()

var current_level: int = 1
const MAX_LEVELS: int = 12

var score: int = 0
var total_crystals: int = 26
var max_hp: int = 3
var current_hp: int = 3
var default_spawn_pos: Vector2 = Vector2(100, 460)
var checkpoint_pos: Vector2 = Vector2(100, 460)

const LEVEL_SPAWN_POSITIONS: Dictionary = {
	1: Vector2(100, 460),
	2: Vector2(100, 460),
	3: Vector2(100, 460),
	4: Vector2(100, 460),
	5: Vector2(100, 460),
	6: Vector2(100, 460),
	7: Vector2(100, 460),
	8: Vector2(100, 460),
	9: Vector2(100, 460),
	10: Vector2(100, 460),
	11: Vector2(100, 460),
	12: Vector2(100, 460)
}

func get_level_spawn_pos(lvl: int) -> Vector2:
	return LEVEL_SPAWN_POSITIONS.get(lvl, Vector2(100, 460))

# === Sistema de Speedrun & Metas de Tempo (Ranks S / A / B) por Universo ===
const SPEEDRUN_SAVE_FILE: String = "user://speedrun_records.json"

const UNIVERSE_SPEEDRUN_TARGETS: Dictionary = {
	"classic": {
		1: {"s": 18.0, "a": 26.0, "b": 38.0, "name": "Planície Serena"},
		2: {"s": 22.0, "a": 32.0, "b": 45.0, "name": "Caverna de Cristais"},
		3: {"s": 24.0, "a": 35.0, "b": 50.0, "name": "Vale dos Cogumelos"},
		4: {"s": 28.0, "a": 40.0, "b": 55.0, "name": "Pico da Nevasca"},
		5: {"s": 30.0, "a": 44.0, "b": 60.0, "name": "Palácio Celestial"},
		6: {"s": 20.0, "a": 30.0, "b": 42.0, "name": "Passagem das Estalactites"},
		7: {"s": 24.0, "a": 34.0, "b": 48.0, "name": "Ruínas Rúnicas"},
		8: {"s": 26.0, "a": 38.0, "b": 52.0, "name": "Abismo dos Ventos Cósmicos"},
		9: {"s": 22.0, "a": 32.0, "b": 45.0, "name": "Trilha dos Portais Ocultos"},
		10: {"s": 28.0, "a": 40.0, "b": 56.0, "name": "Geleira do Trovão"},
		11: {"s": 32.0, "a": 46.0, "b": 62.0, "name": "Santuário das Constelações"},
		12: {"s": 38.0, "a": 54.0, "b": 75.0, "name": "Coração do Linaverse"}
	},
	"celestial": {
		1: {"s": 18.0, "a": 26.0, "b": 38.0, "name": "Portal do Crepúsculo Cósmico"},
		2: {"s": 22.0, "a": 32.0, "b": 45.0, "name": "Ilhas Flutuantes de Safira"},
		3: {"s": 24.0, "a": 35.0, "b": 50.0, "name": "Nebulosa Luminescente"},
		4: {"s": 26.0, "a": 38.0, "b": 52.0, "name": "Templo da Estrela D'Alva"},
		5: {"s": 30.0, "a": 44.0, "b": 60.0, "name": "Ponte dos Cometas"},
		6: {"s": 22.0, "a": 32.0, "b": 44.0, "name": "Labirinto Solar"},
		7: {"s": 25.0, "a": 36.0, "b": 50.0, "name": "Cúpula Astral Arcana"},
		8: {"s": 28.0, "a": 40.0, "b": 55.0, "name": "Mar de Éter Estelar"},
		9: {"s": 24.0, "a": 34.0, "b": 48.0, "name": "Santuário das Galáxias"},
		10: {"s": 30.0, "a": 42.0, "b": 58.0, "name": "Vórtice de Supernova"},
		11: {"s": 32.0, "a": 46.0, "b": 62.0, "name": "Corredor das Plêiades"},
		12: {"s": 38.0, "a": 55.0, "b": 75.0, "name": "Trono Cósmico do Infinito"}
	},
	"valkyrie": {
		1: {"s": 18.0, "a": 26.0, "b": 38.0, "name": "Encosta dos Guerreiros"},
		2: {"s": 22.0, "a": 32.0, "b": 45.0, "name": "Floresta dos Pinheiros Rúnicos"},
		3: {"s": 24.0, "a": 35.0, "b": 50.0, "name": "Fiorde dos Ventos Uivantes"},
		4: {"s": 28.0, "a": 40.0, "b": 55.0, "name": "Caverna dos Gigantes de Gelo"},
		5: {"s": 30.0, "a": 44.0, "b": 60.0, "name": "Portões de Bifrost"},
		6: {"s": 20.0, "a": 30.0, "b": 42.0, "name": "Penhasco das Águias Nórdicas"},
		7: {"s": 25.0, "a": 36.0, "b": 50.0, "name": "Salão das Lanças Douradas"},
		8: {"s": 27.0, "a": 39.0, "b": 54.0, "name": "Abismo de Niflheim"},
		9: {"s": 23.0, "a": 33.0, "b": 46.0, "name": "Trilha das Valquírias Aladas"},
		10: {"s": 29.0, "a": 41.0, "b": 57.0, "name": "Fortaleza da Aurora Boreal"},
		11: {"s": 33.0, "a": 47.0, "b": 63.0, "name": "Cume de Yggdrasil"},
		12: {"s": 38.0, "a": 54.0, "b": 75.0, "name": "Santuário de Valhalla"}
	},
	"ninja": {
		1: {"s": 17.0, "a": 25.0, "b": 36.0, "name": "Vilarejo Oculto na Névoa"},
		2: {"s": 21.0, "a": 30.0, "b": 43.0, "name": "Bosque dos Bambus Congelados"},
		3: {"s": 23.0, "a": 33.0, "b": 48.0, "name": "Telhados da Vila Shinobi"},
		4: {"s": 26.0, "a": 38.0, "b": 52.0, "name": "Desfiladeiro das Kunais"},
		5: {"s": 28.0, "a": 40.0, "b": 56.0, "name": "Pagode das Sombras Glaciais"},
		6: {"s": 19.0, "a": 28.0, "b": 40.0, "name": "Túnel Subterrâneo do Clã"},
		7: {"s": 23.0, "a": 33.0, "b": 47.0, "name": "Jardim de Cerejeiras Noturnas"},
		8: {"s": 25.0, "a": 36.0, "b": 50.0, "name": "Ponte dos Corvos Furtivos"},
		9: {"s": 22.0, "a": 31.0, "b": 44.0, "name": "Fortaleza dos Mestres Ninjas"},
		10: {"s": 27.0, "a": 39.0, "b": 54.0, "name": "Câmara das Lâminas de Gelo"},
		11: {"s": 30.0, "a": 43.0, "b": 60.0, "name": "Covil do Dragão da Neve"},
		12: {"s": 36.0, "a": 52.0, "b": 72.0, "name": "Santuário do Olho da Noite"}
	},
	"royalty": {
		1: {"s": 19.0, "a": 27.0, "b": 39.0, "name": "Jardins do Palácio Imperial"},
		2: {"s": 23.0, "a": 33.0, "b": 46.0, "name": "Pátio das Fontes Cristalizadas"},
		3: {"s": 25.0, "a": 36.0, "b": 51.0, "name": "Galeria dos Espelhos de Prata"},
		4: {"s": 29.0, "a": 41.0, "b": 56.0, "name": "Terraço da Rainha do Gelo"},
		5: {"s": 31.0, "a": 45.0, "b": 62.0, "name": "Salão de Baile de Cristal"},
		6: {"s": 21.0, "a": 31.0, "b": 43.0, "name": "Torre do Relógio Real"},
		7: {"s": 26.0, "a": 37.0, "b": 52.0, "name": "Aposentos dos Diamantes"},
		8: {"s": 28.0, "a": 40.0, "b": 55.0, "name": "Ponte Suspensa de Veludo"},
		9: {"s": 24.0, "a": 34.0, "b": 48.0, "name": "Labirinto Imperial de Sebes"},
		10: {"s": 30.0, "a": 42.0, "b": 58.0, "name": "Grande Aqueduto de Safiras"},
		11: {"s": 34.0, "a": 48.0, "b": 65.0, "name": "Pináculo da Coroa Glacial"},
		12: {"s": 40.0, "a": 56.0, "b": 78.0, "name": "Salão Soberano do Trono Real"}
	},
	"uniform": {
		1: {"s": 17.0, "a": 25.0, "b": 35.0, "name": "Caminho Nevado da Escola"},
		2: {"s": 21.0, "a": 30.0, "b": 42.0, "name": "Portão Principal da Academia"},
		3: {"s": 23.0, "a": 33.0, "b": 47.0, "name": "Pátio de Recreio Congelado"},
		4: {"s": 27.0, "a": 39.0, "b": 53.0, "name": "Corredores do Segundo Andar"},
		5: {"s": 29.0, "a": 42.0, "b": 58.0, "name": "Sala do Grêmio Estudantil"},
		6: {"s": 19.0, "a": 28.0, "b": 40.0, "name": "Ginásio Coberto de Geada"},
		7: {"s": 23.0, "a": 33.0, "b": 47.0, "name": "Passarela Entre Prédios"},
		8: {"s": 26.0, "a": 37.0, "b": 51.0, "name": "Biblioteca dos Tomos Mágicos"},
		9: {"s": 22.0, "a": 31.0, "b": 44.0, "name": "Laboratório de Ciências Arcanas"},
		10: {"s": 27.0, "a": 39.0, "b": 54.0, "name": "Escadaria da Torre do Sino"},
		11: {"s": 31.0, "a": 44.0, "b": 60.0, "name": "Terraço Sob a Neve"},
		12: {"s": 37.0, "a": 52.0, "b": 72.0, "name": "Mirante das Lembranças de Lina"}
	},
	"agnes": {
		1: {"s": 17.0, "a": 25.0, "b": 35.0, "name": "Bancada de Centrifugação"},
		2: {"s": 20.0, "a": 29.0, "b": 41.0, "name": "Acelerador de Táquions"},
		3: {"s": 22.0, "a": 32.0, "b": 45.0, "name": "Destilaria de Éter Quântico"},
		4: {"s": 25.0, "a": 36.0, "b": 50.0, "name": "Corredores do Reator de Fusão"},
		5: {"s": 28.0, "a": 40.0, "b": 56.0, "name": "Câmara de Isolamento Barométrico"},
		6: {"s": 19.0, "a": 27.0, "b": 39.0, "name": "Arquivo de Fórmulas Secretas"},
		7: {"s": 23.0, "a": 33.0, "b": 47.0, "name": "Tubulações de Plasma Luminescente"},
		8: {"s": 25.0, "a": 36.0, "b": 51.0, "name": "Condensador de Matéria Escura"},
		9: {"s": 22.0, "a": 31.0, "b": 44.0, "name": "Plataforma de Eletroforese"},
		10: {"s": 27.0, "a": 39.0, "b": 54.0, "name": "Núcleo de Ressonância Temporal"},
		11: {"s": 31.0, "a": 44.0, "b": 61.0, "name": "Abismo do Vácuo Quântico"},
		12: {"s": 36.0, "a": 52.0, "b": 72.0, "name": "Pináculo da Síntese Tachyon"}
	},
	"frieren": {
		1: {"s": 18.0, "a": 26.0, "b": 37.0, "name": "Trilha da Floresta de Himmel"},
		2: {"s": 21.0, "a": 30.0, "b": 43.0, "name": "Colina dos Grimórios Esquecidos"},
		3: {"s": 24.0, "a": 34.0, "b": 48.0, "name": "Ponte de Pedra do Reino do Norte"},
		4: {"s": 27.0, "a": 39.0, "b": 54.0, "name": "Masmorra do Amanhecer"},
		5: {"s": 29.0, "a": 42.0, "b": 58.0, "name": "Desfiladeiro dos Golens Antigos"},
		6: {"s": 20.0, "a": 29.0, "b": 41.0, "name": "Torre da Barreira de Zoltraak"},
		7: {"s": 24.0, "a": 35.0, "b": 49.0, "name": "Planalto das Flores Lunares"},
		8: {"s": 27.0, "a": 39.0, "b": 53.0, "name": "Ruínas dos Magos da 1ª Classe"},
		9: {"s": 23.0, "a": 33.0, "b": 46.0, "name": "Santuário da Deusa da Criação"},
		10: {"s": 28.0, "a": 40.0, "b": 56.0, "name": "Vale dos Séculos de Neve"},
		11: {"s": 32.0, "a": 46.0, "b": 63.0, "name": "Corredores da Prova de Mana"},
		12: {"s": 38.0, "a": 54.0, "b": 75.0, "name": "Aureole: Limiar das Almas"}
	},
	"maid": {
		1: {"s": 17.0, "a": 25.0, "b": 36.0, "name": "Hall dos Lustres de Cristal"},
		2: {"s": 21.0, "a": 30.0, "b": 42.0, "name": "Corredores da Tapeçaria Real"},
		3: {"s": 23.0, "a": 33.0, "b": 47.0, "name": "Grande Sala de Chá da Tarde"},
		4: {"s": 26.0, "a": 38.0, "b": 52.0, "name": "Adegas dos Vinhos Aromáticos"},
		5: {"s": 29.0, "a": 42.0, "b": 58.0, "name": "Biblioteca dos Cerimoniais"},
		6: {"s": 19.0, "a": 28.0, "b": 40.0, "name": "Escadaria Monumental de Carvalho"},
		7: {"s": 23.0, "a": 33.0, "b": 46.0, "name": "Terraço dos Arbustos Podados"},
		8: {"s": 26.0, "a": 37.0, "b": 51.0, "name": "Salão do Relógio Vitoriano"},
		9: {"s": 22.0, "a": 32.0, "b": 45.0, "name": "Cozinha das Louças de Porcelana"},
		10: {"s": 28.0, "a": 40.0, "b": 55.0, "name": "Aposentos da Marquesa da Neve"},
		11: {"s": 31.0, "a": 44.0, "b": 61.0, "name": "Sótão dos Segredos da Mansão"},
		12: {"s": 37.0, "a": 53.0, "b": 73.0, "name": "Mirante das Rosas de Inverno"}
	},
	"maomao": {
		1: {"s": 18.0, "a": 26.0, "b": 37.0, "name": "Jardim Medicinal do Palácio"},
		2: {"s": 21.0, "a": 30.0, "b": 43.0, "name": "Pavilhão das Ervas Secas"},
		3: {"s": 23.0, "a": 33.0, "b": 47.0, "name": "Ponte de Lótus Imperial"},
		4: {"s": 27.0, "a": 39.0, "b": 54.0, "name": "Corredores da Corte Posterior"},
		5: {"s": 29.0, "a": 42.0, "b": 58.0, "name": "Canto dos Bambus da Serenidade"},
		6: {"s": 20.0, "a": 29.0, "b": 41.0, "name": "Armazém das Raízes Venenosas"},
		7: {"s": 24.0, "a": 35.0, "b": 49.0, "name": "Pagode dos Boticários Dinásticos"},
		8: {"s": 26.0, "a": 38.0, "b": 52.0, "name": "Riacho Sereno das Carpas Douradas"},
		9: {"s": 23.0, "a": 33.0, "b": 46.0, "name": "Santuário do Crisântemo Verde"},
		10: {"s": 28.0, "a": 40.0, "b": 56.0, "name": "Muralha do Dragão das Estações"},
		11: {"s": 32.0, "a": 45.0, "b": 62.0, "name": "Laboratório de Antídotos Reais"},
		12: {"s": 37.0, "a": 53.0, "b": 74.0, "name": "Pavilhão Dourado das Ervas"}
	},
	"miku": {
		1: {"s": 16.0, "a": 24.0, "b": 34.0, "name": "Palco Holográfico 39-Live"},
		2: {"s": 20.0, "a": 28.0, "b": 40.0, "name": "Autopista da Fibra Óptica"},
		3: {"s": 22.0, "a": 31.0, "b": 44.0, "name": "Passarela dos Equalizadores"},
		4: {"s": 25.0, "a": 36.0, "b": 51.0, "name": "Torre dos Alto-Falantes Neon"},
		5: {"s": 28.0, "a": 40.0, "b": 56.0, "name": "Plataforma dos Sintetizadores"},
		6: {"s": 18.0, "a": 27.0, "b": 38.0, "name": "Distrito Cyber-Shibuya 39"},
		7: {"s": 22.0, "a": 32.0, "b": 45.0, "name": "Mesa de Mixagem Estelar"},
		8: {"s": 25.0, "a": 36.0, "b": 50.0, "name": "Túnel do Vocoder Polifônico"},
		9: {"s": 21.0, "a": 30.0, "b": 43.0, "name": "Santuário dos Arquivos MIDI"},
		10: {"s": 26.0, "a": 38.0, "b": 53.0, "name": "Metrô Eletroacústico Neon"},
		11: {"s": 30.0, "a": 43.0, "b": 59.0, "name": "Domo Acústico dos Lasers"},
		12: {"s": 35.0, "a": 50.0, "b": 70.0, "name": "Grande Concerto Vocaloid Lina"}
	},
	"sonserina": {
		1: {"s": 18.0, "a": 26.0, "b": 37.0, "name": "Entrada das Criptas Abobadadas"},
		2: {"s": 21.0, "a": 30.0, "b": 43.0, "name": "Comunal Sob o Lago Negro"},
		3: {"s": 24.0, "a": 34.0, "b": 48.0, "name": "Tapeçarias da Serpente Prateada"},
		4: {"s": 27.0, "a": 39.0, "b": 54.0, "name": "Laboratório de Caldeirões Fumegantes"},
		5: {"s": 29.0, "a": 42.0, "b": 58.0, "name": "Cripta das Chamas Esmeraldas"},
		6: {"s": 20.0, "a": 29.0, "b": 41.0, "name": "Ponte Sobre o Fosso dos Basiliscos"},
		7: {"s": 24.0, "a": 35.0, "b": 49.0, "name": "Armário dos Frascos de Veneno"},
		8: {"s": 27.0, "a": 39.0, "b": 53.0, "name": "Galeria dos Retratos Falantes"},
		9: {"s": 23.0, "a": 33.0, "b": 46.0, "name": "Arquivo dos Tomos Proibidos"},
		10: {"s": 28.0, "a": 40.0, "b": 56.0, "name": "Pilares da Serpente de Prata"},
		11: {"s": 32.0, "a": 46.0, "b": 63.0, "name": "Abismo do Fogo Fátuo Noturno"},
		12: {"s": 38.0, "a": 54.0, "b": 75.0, "name": "Câmara Secreta do Lorde Alquimista"}
	},
	"tracen": {
		1: {"s": 16.0, "a": 23.0, "b": 33.0, "name": "Portão de Largada de Turf"},
		2: {"s": 19.0, "a": 28.0, "b": 39.0, "name": "Primeira Curva das Encostas"},
		3: {"s": 21.0, "a": 30.0, "b": 43.0, "name": "Reta Oposta de Arrancada Máxima"},
		4: {"s": 25.0, "a": 36.0, "b": 50.0, "name": "Obstáculo dos Saltos de Trilho"},
		5: {"s": 27.0, "a": 39.0, "b": 55.0, "name": "Pista de Terra Batida da Neve"},
		6: {"s": 18.0, "a": 26.0, "b": 37.0, "name": "Túnel dos Vestiários do Turf"},
		7: {"s": 22.0, "a": 31.0, "b": 44.0, "name": "Colina Íngreme dos Campeões"},
		8: {"s": 24.0, "a": 35.0, "b": 49.0, "name": "Última Curva da Glória"},
		9: {"s": 21.0, "a": 30.0, "b": 42.0, "name": "Passarela dos Cronômetros"},
		10: {"s": 25.0, "a": 37.0, "b": 51.0, "name": "Reta Final Sob Aplausos"},
		11: {"s": 29.0, "a": 42.0, "b": 58.0, "name": "Faixa de Chegada do Troféu de Ouro"},
		12: {"s": 34.0, "a": 49.0, "b": 69.0, "name": "Pódio Twinkle Series Linaverse"}
	}
}

const SPEEDRUN_TARGETS: Dictionary = UNIVERSE_SPEEDRUN_TARGETS["classic"]

func get_speedrun_target(lvl: int, universe_id: String = "") -> Dictionary:
	var u_id = universe_id if universe_id != "" else current_outfit
	var u_targets = UNIVERSE_SPEEDRUN_TARGETS.get(u_id, UNIVERSE_SPEEDRUN_TARGETS["classic"])
	return u_targets.get(lvl, {"s": 25.0, "a": 35.0, "b": 50.0, "name": "Fase %d" % lvl})

func get_stage_name(lvl: int, universe_id: String = "") -> String:
	return get_speedrun_target(lvl, universe_id).get("name", "Fase %d" % lvl)

# === Sistema de História & Lore de Nix (O Gatinho Doente) ===
const NIX_STORY_INTRO: Dictionary = {
	"title": "A Missão de Lina: Salvar o Gatinho Nix",
	"kitten_name": "Nix",
	"goal": "Reunir as 12 Essências Medicinais do Elixir Celestial",
	"summary": "O adorado gatinho da Lina, Nix, foi acometido por uma febre mágica misteriosa. Para curá-lo a tempo, Lina precisa correr em alta velocidade através de todos os 6 universos do Linaverse, recolhendo os 12 ingredientes curativos do Elixir Celestial antes que a enfermidade piore. Cada segundo conta nesta corrida de amor e amizade!"
}

const UNIVERSE_STORY_LORE: Dictionary = {
	"classic": {
		1: {"stage": 1, "ingredient": "Frasco Cristalino da Pureza", "icon": "🧪", "nix_status": "Nix está deitado na cestinha com febre alta e tossindo fraco...", "quote": "Aguente firme, Nix! Estou correndo o mais rápido que posso!", "reward_text": "Você resgatou o Frasco Cristalino! Agora temos onde preparar o Elixir Celestial do Nix!"},
		2: {"stage": 2, "ingredient": "Sal Estelar Luminescente", "icon": "🧂", "nix_status": "A febre de Nix continua alta, mas o cheiro do sal purificador começa a estabilizá-lo.", "quote": "Mais um ingrediente! Já estou a caminho do próximo portal, meu gatinho!", "reward_text": "Sal Estelar obtido! O poder deste cristal neutralizará as impurezas da febre mágica."},
		3: {"stage": 3, "ingredient": "Esporo de Cogumelo Brilhante", "icon": "🍄", "nix_status": "Nix respira com um pouco menos de esforço sob a mantinha de lã azul.", "quote": "Isso vai aliviar todas as suas dores, amigão!", "reward_text": "Esporo Calmante coletado! Propriedades relaxantes prontas para aliviar as dores do Nix."},
		4: {"stage": 4, "ingredient": "Flor de Neve Perene", "icon": "🌸", "nix_status": "A toalhinha úmida na testa do Nix ajuda a mantê-lo estável enquanto dorme.", "quote": "O vento gelado do cume não vai me parar, Nix!", "reward_text": "Flor de Neve Perene colhida! Sua essência refrescante vai quebrar a febre do gatinho."},
		5: {"stage": 5, "ingredient": "Gota de Luz da Aurora", "icon": "✨", "nix_status": "Um calor mágico reconfortante começa a proteger a cestinha do Nix.", "quote": "O remédio está tomando forma! Não vou desistir!", "reward_text": "Gota de Aurora Celestial pura capturada! A energia curativa das constelações já brilha no frasco."},
		6: {"stage": 6, "ingredient": "Seiva da Raiz Glacial", "icon": "🌿", "nix_status": "Nix mexe as orelhinhas ao sentir de longe a determinação de Lina.", "quote": "Passei pelos espinhos de gelo! Mais uma essência garantida!", "reward_text": "Seiva Glacial extraída! Ela fortalecerá o sistema imunológico debilitado do gatinho."},
		7: {"stage": 7, "ingredient": "Pó de Runa da Vitalidade", "icon": "📜", "nix_status": "Os batimentos cardíacos do Nix estão ficando mais calmos e ritmados.", "quote": "Os sábios antigos sabiam como curar! O remédio está quase na metade!", "reward_text": "Runa da Vitalidade decifrada! A força corporal do Nix começará a se recuperar."},
		8: {"stage": 8, "ingredient": "Vapor da Corrente Cósmica", "icon": "💨", "nix_status": "Nix sonha com as brincadeiras e novelos de lã na neve fofa.", "quote": "Voei pelas correntes astrais! Já passamos da metade, Nix!", "reward_text": "Vapor Cósmico condensado! Ele acelerará a absorção do medicamento quando Nix beber."},
		9: {"stage": 9, "ingredient": "Essência Dimensional de Safira", "icon": "💎", "nix_status": "A febre alta cedeu o primeiro grau! O remédio está agindo à distância.", "quote": "Os portais não me confundem quando sua saúde está em risco!", "reward_text": "Safira Dimensional recolhida! Estabiliza as energias mágicas no corpo do gatinho."},
		10: {"stage": 10, "ingredient": "Centelha de Plasma Polar", "icon": "⚡", "nix_status": "As patinhas de Nix estão quentinhas novamente na mantinha.", "quote": "Nem os relâmpagos da geleira me atrasaram! Logo estarei em casa!", "reward_text": "Centelha Polar segura! Devolve a energia e o calor vital que a enfermidade roubou."},
		11: {"stage": 11, "ingredient": "Poeira de Cometa Curador", "icon": "🌠", "nix_status": "Nix abriu os olhinhos azuis por um instante e ronronou bem baixinho! Falta apenas o ingrediente final!", "quote": "Você abriu os olhos! Falta só mais uma fase e o remédio estará completo, amigão!", "reward_text": "Poeira de Cometa recolhida! O elixir começa a cintilar em tons dourados e violetas, pronto para a cura!"},
		12: {"stage": 12, "ingredient": "Chama Eterna da Amizade", "icon": "💖", "nix_status": "CURA COMPLETA! Nix está 100% curado, pulando e ronronando com muito amor!", "quote": "NIX! NÓS CONSEGUIMOS! O remédio funcionou perfeitamente! 🐾✨", "reward_text": "O ELIXIR ESTÁ PRONTO E FOI ENTREGUE! Nix tomou o medicamento, a febre sumiu na hora e ele pulou nos braços da Lina com infinitos miados de felicidade!"}
	},
	"celestial": {
		1: {"stage": 1, "ingredient": "Cálice de Luz Estelar", "icon": "✨", "nix_status": "Nix repousa sob a luz tênue das primeiras constelações...", "quote": "O céu estrelado vai nos guiar até a sua cura total, Nix!", "reward_text": "Cálice de Luz Estelar recolhido! Um recipiente celestial radiante para a infusão mágica."},
		2: {"stage": 2, "ingredient": "Orvalho da Estrela Cadente", "icon": "🌠", "nix_status": "O brilho das estrelas alivia a febre cósmica do gatinho.", "quote": "Cada salto entre as ilhas astrais me aproxima de você!", "reward_text": "Orvalho Cadente capturado! Sua pureza celestial acalma a tempestade no corpinho do Nix."},
		3: {"stage": 3, "ingredient": "Néctar de Lótus Astral", "icon": "🪷", "nix_status": "A respiração de Nix fica suave com o perfume das flores cósmicas.", "quote": "Sinta esse aroma doce, amigão! Já estou com o terceiro ingrediente!", "reward_text": "Néctar Astral colhido nas alturas! Propriedades restauradoras lendárias garantidas."},
		4: {"stage": 4, "ingredient": "Cristal de Nebulosa Arcana", "icon": "🔮", "nix_status": "As cores da nebulosa envolvem a cestinha de Nix em proteção.", "quote": "Os cometas não são páreo para a nossa velocidade!", "reward_text": "Cristal Arcano absorvido! Ele estabiliza as correntes de energia cósmica no remédio."},
		5: {"stage": 5, "ingredient": "Pó de Sol Nascente", "icon": "☀️", "nix_status": "O calor dourado do sol dissipa o frio cortante da enfermidade.", "quote": "Um novo amanhecer está chegando para você, Nix!", "reward_text": "Pó Solar obtido! Traz o calor da vida de volta às patinhas do gatinho."},
		6: {"stage": 6, "ingredient": "Seiva da Árvore das Plêiades", "icon": "🌿", "nix_status": "Nix mexe a pontinha do rabo sonhando com os saltos no espaço.", "quote": "Cheguei ao coração do labirinto solar! Mais uma essência pra conta!", "reward_text": "Seiva das Plêiades destilada! Acelera o fortalecimento das defesas mágicas."},
		7: {"stage": 7, "ingredient": "Fita de Aurora Cósmica", "icon": "🌌", "nix_status": "As ondas de luz violeta criam uma barreira curativa ao redor de Nix.", "quote": "Cruzamos a metade da jornada astral! Falta pouco!", "reward_text": "Fita de Aurora entrelaçada no elixir! Uma bênção de cura pura e reconfortante."},
		8: {"stage": 8, "ingredient": "Éter do Mar Estelar", "icon": "💧", "nix_status": "A febre de Nix finalmente começa a ceder graus visíveis!", "quote": "Naveguei pelo mar de estrelas e consegui!", "reward_text": "Éter Estelar puro! Torna o remédio leve e de absorção mágica imediata."},
		9: {"stage": 9, "ingredient": "Lágrima de Fênix Solar", "icon": "🔥", "nix_status": "Nix abre os olhinhos azuis e fita o brilho dourado no horizonte.", "quote": "Seus olhinhos brilharam! O remédio está quase pronto, meu amor!", "reward_text": "Lágrima de Fênix colhida! Poder de renascimento e vitalidade inextinguível."},
		10: {"stage": 10, "ingredient": "Essência de Supernova Curativa", "icon": "⚡", "nix_status": "As forças de Nix estão retornando a passos largos!", "quote": "Nem as tempestades espaciais vão me deter!", "reward_text": "Supernova Curativa capturada! Uma explosão de saúde vital para aniquilar a febre."},
		11: {"stage": 11, "ingredient": "Centelha do Infinito", "icon": "🪐", "nix_status": "Nix dá um miado fraquinho porém doce, chamando por Lina!", "quote": "Ouvi seu miadinho através do portal! Só falta o ingrediente final!", "reward_text": "Centelha do Infinito garantida! O Elixir Celestial brilha como uma galáxia inteira!"},
		12: {"stage": 12, "ingredient": "Chama Astral da Amizade", "icon": "💖", "nix_status": "CURA COMPLETA! Nix está 100% curado, pulando e ronronando com muito amor!", "quote": "NIX! NÓS CONSEGUIMOS! As estrelas nos abençoaram! 🐾✨", "reward_text": "O ELIXIR ASTRAL FOI ENTREGUE! Nix bebeu a infusão estelar e a febre desapareceu num instante! Ele saltou no colo da Lina ronronando sob as constelações!"}
	},
	"valkyrie": {
		1: {"stage": 1, "ingredient": "Chifre Rúnico de Nevasca", "icon": "📯", "nix_status": "Nix dorme protegido sob mantos nórdicos enquanto a tempestade ruge...", "quote": "O sopro dos guerreiros do norte vai salvar meu pequeno Nix!", "reward_text": "Chifre Rúnico consagrado! Recipiente forjado no gelo eterno pronto para o remédio."},
		2: {"stage": 2, "ingredient": "Flor da Geada de Niflheim", "icon": "❄️", "nix_status": "A brisa perfumada de Niflheim acalma a febre ardente do gatinho.", "quote": "Nenhum abismo nórdico me impedirá de voltar com seu remédio!", "reward_text": "Flor da Geada colhida! Sua essência glacial diminui o ardor da febre mágica."},
		3: {"stage": 3, "ingredient": "Musgo Sagrado de Yggdrasil", "icon": "🍃", "nix_status": "A essência da grande árvore nutre a vitalidade enfraquecida de Nix.", "quote": "A Grande Árvore nos abençoou! Mais um ingrediente em mãos!", "reward_text": "Musgo da Árvore da Vida obtido! Propriedades regenerativas imbatíveis."},
		4: {"stage": 4, "ingredient": "Lágrima da Valquíria Protetora", "icon": "🛡️", "nix_status": "Nix respira tranquilo sob a guarda invisível das asas de Valquíria.", "quote": "As lanças das valquírias abrem caminho para a sua salvação!", "reward_text": "Lágrima Protetora recolhida! Cria um escudo de imunidade contra recaídas."},
		5: {"stage": 5, "ingredient": "Sal Glacial de Bifrost", "icon": "🌈", "nix_status": "O brilho da ponte dos deuses colore os sonhos do pequeno Nix.", "quote": "Corri sobre o arco-íris de gelo! Já temos cinco essências!", "reward_text": "Sal de Bifrost cristalizado! Purifica as impurezas dimensionais da enfermidade."},
		6: {"stage": 6, "ingredient": "Seiva do Pinheiro Ancestral", "icon": "🌲", "nix_status": "Nix se aconchega melhor e a respiração pesada desaparece.", "quote": "Os espinhos das montanhas foram superados com facilidade!", "reward_text": "Seiva Ancestral extraída! Fortalece os músculos e o apetite do gatinho."},
		7: {"stage": 7, "ingredient": "Hidromel Medicinal dos Deuses", "icon": "🍯", "nix_status": "O aroma doce do hidromel atrai a atenção curiosa de Nix.", "quote": "Passamos da metade da trilha das guerreiras! Aguente firme!", "reward_text": "Hidromel Divino conquistado! Adoça o medicamento e acelera o vigor."},
		8: {"stage": 8, "ingredient": "Centelha de Trovão Polar", "icon": "⚡", "nix_status": "As patinhas frias de Nix voltam a receber calor e circulação.", "quote": "O poder dos relâmpagos está a favor da sua cura!", "reward_text": "Centelha de Trovão domada! Devolve a eletricidade vital ao organismo de Nix."},
		9: {"stage": 9, "ingredient": "Pó de Diamante Glacial", "icon": "💎", "nix_status": "A febre de Nix caiu dois graus completos! O alívio é evidente!", "quote": "Seu focinho já está úmido e saudável de novo!", "reward_text": "Diamante Glacial moído! Cristalização defensiva contra venenos mágicos."},
		10: {"stage": 10, "ingredient": "Pluma da Águia de Asgard", "icon": "🦅", "nix_status": "Nix levanta a cabecinha e solta um miadinho de esperança!", "quote": "A águia sagrada voou comigo! Estamos quase no fim da missão!", "reward_text": "Pluma Sagrada incorporada ao elixir! Concede leveza e rápida recuperação."},
		11: {"stage": 11, "ingredient": "Gota da Fonte de Mimir", "icon": "💧", "nix_status": "Nix já tenta se erguer sobre as patinhas dianteiras!", "quote": "A sabedoria ancestral revelou a receita final! Falta só uma fase!", "reward_text": "Gota de Mimir colhida! O elixir transborda poder e cura definitiva!"},
		12: {"stage": 12, "ingredient": "Chama Valquíria da Amizade", "icon": "💖", "nix_status": "CURA COMPLETA! Nix está 100% curado, pulando e ronronando com muito amor!", "quote": "VALHALLA CELEBRA! NIX ESTÁ COMPLETAMENTE CURADO! 🐾⚔️", "reward_text": "O REMÉDIO DAS VALQUÍRIAS FOI ENTREGUE! Nix tomou a poção e num piscar de olhos saltou da cestinha cheio de energia, ronronando feliz no abraço da Lina!"}
	},
	"ninja": {
		1: {"stage": 1, "ingredient": "Frasco de Bambu Oculto", "icon": "🎋", "nix_status": "Nix repousa em silêncio no tatame sob a proteção dos ninjas...", "quote": "Os passos leves da shinobi levarão o alívio até você, Nix!", "reward_text": "Frasco de Bambu artesanal resgatado! Protegido por selos antigos para manter o remédio puro."},
		2: {"stage": 2, "ingredient": "Orvalho da Cerejeira Noturna", "icon": "🌸", "nix_status": "Pétalas suaves cobrem o gatinho e acalmam seus tremores de febre.", "quote": "Saltei sobre os telhados congelados! Já estou com a segunda essência!", "reward_text": "Orvalho da Sakura recolhido! Propriedades anti-inflamatórias imediatas."},
		3: {"stage": 3, "ingredient": "Raiz da Lótus das Sombras", "icon": "🪷", "nix_status": "A respiração de Nix encontra um ritmo tranquilo e sereno.", "quote": "A escuridão da floresta de bambu não escondeu o remédio de mim!", "reward_text": "Raiz de Lótus colhida! Erva medicinal suprema do clã shinobi."},
		4: {"stage": 4, "ingredient": "Pó de Escama do Dragão da Neve", "icon": "🐉", "nix_status": "Um calor interno protetor neutraliza o veneno da febre cósmica.", "quote": "O dragão da montanha me concedeu sua bênção curativa!", "reward_text": "Pó de Escama recolhido! Confere imunidade duradoura contra doenças."},
		5: {"stage": 5, "ingredient": "Erva Medicinal Secreta", "icon": "🌿", "nix_status": "Nix sonha com caminhadas furtivas e caça a pequenos novelos.", "quote": "Escalei os pagodes mais íngremes por você, meu amigão!", "reward_text": "Erva Secreta encontrada! O cheiro mentolado refresca e desobstrui os pulmões."},
		6: {"stage": 6, "ingredient": "Seiva do Pinheiro Negro", "icon": "🌲", "nix_status": "Nix abre os olhinhos castanhos e fareja a proximidade de Lina.", "quote": "Os túneis subterrâneos não me atrasaram um segundo!", "reward_text": "Seiva Negra extraída! Tonifica os batimentos cardíacos debilitados."},
		7: {"stage": 7, "ingredient": "Essência da Névoa Silenciosa", "icon": "🌫️", "nix_status": "A febre de Nix abaixa gradualmente enquanto o elixir toma forma.", "quote": "Sete essências no cinto de shurikens! Metade do caminho vencida!", "reward_text": "Névoa Silenciosa condensada! Traz alívio indolor e sono restaurador."},
		8: {"stage": 8, "ingredient": "Cristal de Shuriken Glacial", "icon": "💠", "nix_status": "As patinhas dianteiras de Nix se esticam procurando carinho.", "quote": "Minhas kunais abriram atalhos velozes pelos desfiladeiros!", "reward_text": "Cristal Glacial lapidado! Elimina as toxinas remanescentes no sangue."},
		9: {"stage": 9, "ingredient": "Centelha de Fogo Fátuo Noturno", "icon": "🏮", "nix_status": "Nix tenta ronronar bem baixinho sob a coberta quentinha.", "quote": "Você ronronou! Isso me dá asas para correr ainda mais rápido!", "reward_text": "Fogo Fátuo capturado! Devolve a alegria e vivacidade ao pequeno felino."},
		10: {"stage": 10, "ingredient": "Chá Ancestral do Grande Mestre", "icon": "🍵", "nix_status": "Nix bebeu algumas gotinhas da borda do frasco e sentiu alívio!", "quote": "Os mestres shinobis preparam a infusão sagrada! Logo estarei aí!", "reward_text": "Chá Ancestral infusionado! Combinação milenar de cura total em andamento."},
		11: {"stage": 11, "ingredient": "Resina da Noite Eterna", "icon": "🌑", "nix_status": "Nix já senta na caminha esperando o retorno triunfal de Lina!", "quote": "O covil do dragão ficou para trás! Só falta a última relíquia!", "reward_text": "Resina da Noite sintetizada! A poção atinge o ponto mágico perfeito!"},
		12: {"stage": 12, "ingredient": "Chama Shinobi da Amizade", "icon": "💖", "nix_status": "CURA COMPLETA! Nix está 100% curado, pulando e ronronando com muito amor!", "quote": "MISSÃO CUMPRIDA! NIX ESTÁ TOTALMENTE CURADO E SAUDÁVEL! 🐾🥷", "reward_text": "O REMÉDIO SHINOBI FOI ENTREGUE COM SUCESSO! Nix tomou a infusão, lambeu o focinho e pulou com agilidade ninja nos ombros da Lina, miando de pura felicidade!"}
	},
	"royalty": {
		1: {"stage": 1, "ingredient": "Frasco Imperial de Cristal Lapidado", "icon": "👑", "nix_status": "Nix repousa em uma almofada real de veludo azul-safira...", "quote": "A coroa do inverno não tem valor sem a sua saúde, Nix!", "reward_text": "Frasco Imperial de Cristal garantido! Uma obra-prima real digna do remédio de Nix."},
		2: {"stage": 2, "ingredient": "Essência de Rosa de Diamante", "icon": "💎", "nix_status": "O brilho suave dos diamantes ilumina e acalma os tremores do Nix.", "quote": "Os jardins de inverno foram rápidos de atravessar! Já levo a segunda rosa!", "reward_text": "Rosa de Diamante colhida! Sua fragrância nobre desacelera a febre."},
		3: {"stage": 3, "ingredient": "Néctar Imperial de Safira", "icon": "🔷", "nix_status": "A respiração de Nix torna-se suave sob a manta de arminho.", "quote": "As galerias de espelhos não me confundiram! Mais um ingrediente!", "reward_text": "Néctar de Safira purificado! Rico em nutrientes curativos de alta realeza."},
		4: {"stage": 4, "ingredient": "Orvalho das Fontes Palacianas", "icon": "⛲", "nix_status": "O gatinho mexe os bigodes ao sentir a água fresca das fontes reais.", "quote": "As fontes sagradas do palácio darão forças para você!", "reward_text": "Orvalho Palaciano colhido! Hidratação mágica que revigora as forças vitais."},
		5: {"stage": 5, "ingredient": "Bálsamo de Menta Real", "icon": "🍃", "nix_status": "A febre de Nix perde força sob o frescor da menta nobre.", "quote": "Dancei pelos salões de cristal no ritmo do speedrun!", "reward_text": "Bálsamo Real extraído! Desobstrui as vias respiratórias do bichinho."},
		6: {"stage": 6, "ingredient": "Pó de Pérola Glacial", "icon": "⚪", "nix_status": "Nix abre os olhinhos azuis e observa o brilho suave das pérolas.", "quote": "Os relógios do castelo correm a nosso favor, amigão!", "reward_text": "Pó de Pérola misturado! Acelera a cicatrização de todo o corpo."},
		7: {"stage": 7, "ingredient": "Tintura da Flor da Soberania", "icon": "🌺", "nix_status": "Nix solta um ronronar real e estica as patinhas na almofada.", "quote": "Mais da metade do tesouro medicinal está garantido!", "reward_text": "Flor da Soberania destilada! A imunidade do gatinho se fortalece."},
		8: {"stage": 8, "ingredient": "Gotas de Ouro Branco Curativo", "icon": "✨", "nix_status": "O calor suave do ouro nobre traz cor rosada ao narizinho do Nix.", "quote": "Passei pela ponte de veludo voando como o vento!", "reward_text": "Ouro Branco curativo infundido! Energia duradoura contra fraquezas."},
		9: {"stage": 9, "ingredient": "Xarope de Amora Real das Neves", "icon": "🫐", "nix_status": "Nix lambe os bigodes sentindo o sabor doce que se aproxima.", "quote": "Esse xarope vai deixar seu remédio delicioso e doce!", "reward_text": "Xarope de Amora colhido! O sabor adocicado favorito do gatinho."},
		10: {"stage": 10, "ingredient": "Centelha da Coroa Imperial", "icon": "⚡", "nix_status": "Nix já tenta apoiar o corpinho e olhar para a porta do salão!", "quote": "O aqueduto de safiras ficou para trás! Logo estarei de volta!", "reward_text": "Centelha Imperial resgatada! Desperta o ânimo jovial do gatinho real."},
		11: {"stage": 11, "ingredient": "Elixir Sagrado dos Reis", "icon": "🧪", "nix_status": "Nix mia de forma audível e alegre chamando por Lina!", "quote": "Desci dos pináculos mais altos do reino! Falta só uma fase!", "reward_text": "Elixir dos Reis preparado! O frasco reluz como o sol do meio-dia!"},
		12: {"stage": 12, "ingredient": "Chama Soberana da Amizade", "icon": "💖", "nix_status": "CURA COMPLETA! Nix está 100% curado, pulando e ronronando com muito amor!", "quote": "TRIUNFO REAL! NIX ESTÁ RADIANTE, CURADO E FELIZ! 🐾👑", "reward_text": "O MEDICAMENTO REAL FOI ENTREGUE! Nix tomou as últimas gotas do néctar imperial e pulou com alegria no manto de veludo da Lina, enchendo o salão de ronronados reais!"}
	},
	"uniform": {
		1: {"stage": 1, "ingredient": "Garrafinha Térmica da Saúde", "icon": "🧴", "nix_status": "Nix está enroladinho no cachecol escolar da Lina com febre...", "quote": "Vou correr todo o caminho da escola para salvar você, Nix!", "reward_text": "Garrafinha Térmica encontrada! Vai manter o chá medicinal quentinho e fresco."},
		2: {"stage": 2, "ingredient": "Chá Quente de Camomila Escolar", "icon": "☕", "nix_status": "O cheirinho de camomila acalma a tosse do pequeno felino.", "quote": "Passei pelos portões correndo no primeiro toque do sinal!", "reward_text": "Chá de Camomila pronto! Efeito calmante imediato para o descanso do Nix."},
		3: {"stage": 3, "ingredient": "Gotas de Sakura Congelada", "icon": "🌸", "nix_status": "As gotinhas de sakura gelada diminuem a quentura da febre na testa.", "quote": "O pátio nevado virou pista de corrida pelo meu melhor amigo!", "reward_text": "Gotas de Sakura colhidas! Reduz a temperatura e traz paz ao gatinho."},
		4: {"stage": 4, "ingredient": "Biscoito Calmante de Canela e Mel", "icon": "🍪", "nix_status": "Nix fareja o biscoitinho doce e lambe os lábios sob a manta.", "quote": "Peguei o lanche especial no grêmio! Ele vai te dar muita energia!", "reward_text": "Biscoito de Mel amassado na infusão! Nutrição reconfortante para o estômago."},
		5: {"stage": 5, "ingredient": "Infusão de Hortelã do Clube de Botânica", "icon": "🌿", "nix_status": "O peitinho de Nix respira com muito mais ar e leveza.", "quote": "Os colegas do clube ajudaram a selecionar a melhor hortelã!", "reward_text": "Hortelã fresca adicionada! Alívio pulmonar e frescor garantidos."},
		6: {"stage": 6, "ingredient": "Geleia Curativa de Frutas do Inverno", "icon": "🍓", "nix_status": "Nix abre os olhinhos azuis e acompanha o balanço da mantinha.", "quote": "Pulei as arquibancadas do ginásio como uma verdadeira atleta!", "reward_text": "Geleia de Frutas misturada! Uma dose poderosa de vitamina mágica C."},
		7: {"stage": 7, "ingredient": "Compressinha Mágica Aquecida", "icon": "🧣", "nix_status": "O calor acolhedor espalha-se suave pelas patinhas do gatinho.", "quote": "Cruzamos a passarela entre os prédios! Já passamos da metade!", "reward_text": "Compressa Aquecida pronta! Mantém a temperatura estável e aconchegante."},
		8: {"stage": 8, "ingredient": "Essência de Flor de Neve da Biblioteca", "icon": "❄️", "nix_status": "A febre de Nix cedeu dois graus! Ele já ensaia um ronronar.", "quote": "Encontrei a receita secreta nos livros da biblioteca!", "reward_text": "Flor de Neve catalogada e extraída! Restauração acelerada das energias."},
		9: {"stage": 9, "ingredient": "Xarope Suave de Limão e Gengibre", "icon": "🍋", "nix_status": "Nix mexe as orelhas ao ouvir a voz de Lina chegando perto.", "quote": "Preparei o xarope no laboratório de ciências! Está quase pronto!", "reward_text": "Xarope de Limão infusionado! Elimina as últimas bactérias da enfermidade."},
		10: {"stage": 10, "ingredient": "Talismã da Amizade do Grêmio Estudantil", "icon": "⭐", "nix_status": "Nix já tenta ficar em pé sobre as patinhas na cestinha!", "quote": "Subi as escadarias da torre do sino em tempo recorde!", "reward_text": "Talismã da Amizade ativado! O poder da união e amor cura qualquer dor."},
		11: {"stage": 11, "ingredient": "Elixir da Promessa Eterna", "icon": "🔮", "nix_status": "Nix mia bem alto em resposta à corrida veloz de Lina!", "quote": "Eu prometi que cuidaria de você para sempre! Falta só uma fase!", "reward_text": "Elixir da Promessa destilado! O remédio atinge 99% de eficácia total!"},
		12: {"stage": 12, "ingredient": "Chama Colegial da Amizade", "icon": "💖", "nix_status": "CURA COMPLETA! Nix está 100% curado, pulando e ronronando com muito amor!", "quote": "CONSEGUIMOS! NIX ESTÁ SAUDÁVEL, FORTE E CHEIO DE ENERGIA! 🐾🎒", "reward_text": "O REMÉDIO ESCOLAR FOI ENTREGUE! Nix tomou todo o xarope quentinho na garrafa térmica, se espreguiçou e saltou na mochila da Lina, pronto para ir à aula com ela todos os dias!"}
	},
	"agnes": {
		1: {"stage": 1, "ingredient": "Catalisador de Táquions Líquido", "icon": "🧪", "nix_status": "Nix treme com febre na cestinha, respirando devagar...", "quote": "Aguente firme, Nix! Estou acelerando ao máximo no laboratório!", "reward_text": "Catalisador Quântico obtido! Permite estabilizar as reações celulares febris."},
		2: {"stage": 2, "ingredient": "Reagente de Frequência Cardíaca", "icon": "⚡", "nix_status": "O monitor cardíaco do Nix mostra batimentos mais ritmados.", "quote": "Segundo reagente garantido! A fórmula está tomando forma!", "reward_text": "Reagente Cardíaco sintetizado! Restaura a pressão e ritmo do gatinho."},
		3: {"stage": 3, "ingredient": "Soro de Estabilização Quântica", "icon": "🧬", "nix_status": "Nix abre os olhinhos de leve ao sentir o calor da mistura.", "quote": "Destilei o éter a tempo! Nix, já estou chegando!", "reward_text": "Soro Quântico infusionado! Impede que a febre afete os órgãos vitais."},
		4: {"stage": 4, "ingredient": "Infuso de Fosfato Luminescente", "icon": "💡", "nix_status": "O corpinho de Nix começa a absorver a energia revigorante.", "quote": "Passei pelo reator de fusão voando! Nada vai nos deter!", "reward_text": "Fosfato Luminescente purificado! Clareia a consciência do felino."},
		5: {"stage": 5, "ingredient": "Bálsamo de Hipertermia Controlada", "icon": "🌡️", "nix_status": "A febre de Nix finalmente cai 1 grau e meio!", "quote": "A temperatura está cedendo! Falta pouco mais da metade!", "reward_text": "Bálsamo de Hipertermia aplicado com sucesso na testa do Nix!"},
		6: {"stage": 6, "ingredient": "Fórmula Antipirética Concentrada", "icon": "💊", "nix_status": "Nix emite um miado fraquinho porém dócil de agradecimento.", "quote": "Encontrei a fórmula nos arquivos secretos! Funcionou!", "reward_text": "Antipirético Quântico ativo! As toxinas começam a ser expelidas."},
		7: {"stage": 7, "ingredient": "Solução de Eletrólitos Cromáticos", "icon": "🌈", "nix_status": "Nix bebe algumas gotinhas da solução e se aconchega melhor.", "quote": "Ele bebeu os eletrólitos! A hidratação está perfeita agora!", "reward_text": "Eletrólitos Cromáticos absorvidos! Força muscular voltando aos poucos."},
		8: {"stage": 8, "ingredient": "Composto Anti-Toxina Molecular", "icon": "🛡️", "nix_status": "A respiração de Nix agora é calma, contínua e serena.", "quote": "Neutralizei a toxina molecular! Estamos vencendo a doença!", "reward_text": "Anti-Toxina aplicada! Todas as bactérias invasoras foram eliminadas."},
		9: {"stage": 9, "ingredient": "Ampola de Bio-Cinética Pura", "icon": "⚡", "nix_status": "Nix mexe o rabinho alegremente na almofadinha de veludo.", "quote": "Consegui a ampola de energia! Nix já está abanando o rabo!", "reward_text": "Bio-Cinética integrada! O metabolismo do gatinho voltou à velocidade ideal."},
		10: {"stage": 10, "ingredient": "Polímero de Regeneração Celular", "icon": "🔬", "nix_status": "Nix se apoia nas patinhas dianteiras e olha para o portal!", "quote": "As células estão 100% regeneradas! Só mais duas fases!", "reward_text": "Regeneração Celular concluída! O organismo de Nix está revitalizado."},
		11: {"stage": 11, "ingredient": "Plasma de Vitalidade Quântica", "icon": "✨", "nix_status": "Nix se espreguiça e solta um miado limpo e saudável!", "quote": "QUASE LÁ! O plasma da vitória já está em minhas mãos!", "reward_text": "Plasma Quântico injetado no frasco! Falta apenas o selo final!"},
		12: {"stage": 12, "ingredient": "Elixir Supremo Tachyon de Cura", "icon": "🏆", "nix_status": "CURA COMPLETA! Nix está pulando, ronronando e correndo pelo laboratório!", "quote": "VITÓRIA DA CIÊNCIA E DO AMOR! NIX ESTÁ TOTALMENTE CURADO! 🧪🐾", "reward_text": "O REMÉDIO TACHYON CUROU NIX! O gatinho saltou no colo da Lina com ronronados supercarregados, pronto para novas descobertas científicas juntos!"}
	},
	"frieren": {
		1: {"stage": 1, "ingredient": "Flor Azul de Himmel da Lembrança", "icon": "🪻", "nix_status": "Nix dorme na cestinha élfica, envolto pelo perfume da flor azul.", "quote": "Uma flor que floresce uma vez por milênio... pela vida de Nix!", "reward_text": "Flor de Himmel colhida! Sua fragrância tranquiliza o espírito febril."},
		2: {"stage": 2, "ingredient": "Folha da Árvore Milenar Sagrada", "icon": "🍃", "nix_status": "O orvalho da folha alivia o focinho ressecado do gatinho.", "quote": "A magia antiga da natureza protegerá meu pequeno companheiro!", "reward_text": "Folha Milenar consagrada! A febre mágica começa a perder força."},
		3: {"stage": 3, "ingredient": "Gota de Orvalho da Barreira Mágica", "icon": "💧", "nix_status": "Nix bebe a gota e seu pelo branco ganha um brilho perolado.", "quote": "Esta água pura purifica qualquer maldição antiga!", "reward_text": "Orvalho da Barreira absorvido! As impurezas são lavadas do sangue."},
		4: {"stage": 4, "ingredient": "Semente de Erva Curativa Élfica", "icon": "🌱", "nix_status": "Nix descansa o queixinho na pata com olhar calmo e sereno.", "quote": "Uma semente que germina saúde instantânea! Cruzando o desfiladeiro!", "reward_text": "Semente Élfica moída e preparada no caldeirão de viagem!"},
		5: {"stage": 5, "ingredient": "Pó de Asas da Fada da Neve", "icon": "🧚", "nix_status": "O pó brilhante envolve a cestinha como uma redoma protetora.", "quote": "As fadas me concederam sua bênção! Correndo pelos céus!", "reward_text": "Bênção das Fadas ativa! Protege Nix contra qualquer recaída de frio."},
		6: {"stage": 6, "ingredient": "Cristal de Mana Tranquila de Zoltraak", "icon": "💎", "nix_status": "Nix já tenta esticar as patas e ensaia um ronrom baixinho.", "quote": "Mana purificada da destruição em força de cura e paz!", "reward_text": "Cristal de Mana equilibrado! O fluxo vital de Nix estabiliza."},
		7: {"stage": 7, "ingredient": "Raiz de Ginseng de Trezentos Anos", "icon": "🪵", "nix_status": "O calor suave da raiz penetra as almofadinhas das patas.", "quote": "Mais um remédio milenar resgatado das montanhas do norte!", "reward_text": "Ginseng Ancestral infusionado! A imunidade de Nix quadruplica."},
		8: {"stage": 8, "ingredient": "Essência de Mel da Abelha Astral", "icon": "🍯", "nix_status": "Nix lambe os bigodes com o docinho do néctar celestial.", "quote": "Glicose mágica pura! A energia está voltando rápido!", "reward_text": "Mel Astral digerido! O gatinho ganha novo apetite e ânimo."},
		9: {"stage": 9, "ingredient": "Água Pura da Fonte da Deusa", "icon": "🌊", "nix_status": "A respiração de Nix agora é tão leve quanto a brisa da floresta.", "quote": "A água sagrada da Deusa lavou a última chama da febre!", "reward_text": "Fonte da Deusa reverenciada! Todos os órgãos estão sadios."},
		10: {"stage": 10, "ingredient": "Fragmento do Sino dos Tempos Antigos", "icon": "🔔", "nix_status": "O som cristalino do sino acalma o sono reparador de Nix.", "quote": "O sino tocou a sinfonia da recuperação! Só faltam dois passos!", "reward_text": "Sino dos Tempos despertou o vigor adormecido do felino!"},
		11: {"stage": 11, "ingredient": "Feitiço de Respiração Tranquila", "icon": "🪄", "nix_status": "Nix abre bem os olhos, reconhece Lina e mia com afeto!", "quote": "Ele me reconheceu! Falta apenas o último feitiço de Aureole!", "reward_text": "Encantamento de Respiração concluído! O pulmãozinho está 100% puro."},
		12: {"stage": 12, "ingredient": "Magia Suprema do Despertar Saudável", "icon": "🌟", "nix_status": "CURA COMPLETA! Nix está são e salvo, pulando nos braços de Lina!", "quote": "A MAGIA DO AMOR TRIUNFOU SOBRE O TEMPO! NIX ESTÁ VIVO E FELIZ! 🪄🐾", "reward_text": "O REMÉDIO MILENAR ÉLFICO CUROU NIX! Frieren-Lina sorri com ternura ao ver Nix pular em seu báculo e enrolar o rabinho carinhoso em seu pescoço!"}
	},
	"maid": {
		1: {"stage": 1, "ingredient": "Chá de Camomila e Camélia Suave", "icon": "🫖", "nix_status": "Nix descansa na almofada de veludo, inalando o vapor aromático do chá.", "quote": "Servirei ao senhor Nix o chá medicinal mais refinado da mansão!", "reward_text": "Chá de Camomila servido com etiqueta real! O gatinho relaxa."},
		2: {"stage": 2, "ingredient": "Biscoito de Ervas Quentes Medicinais", "icon": "🍪", "nix_status": "Nix fareja o biscoito quentinho com carinho e lambe as pontas.", "quote": "Receita secreta do chef da mansão para acalmar estômagos felinos!", "reward_text": "Biscoito Medicinal alimentado! A fraqueza física é combatida."},
		3: {"stage": 3, "ingredient": "Manta de Lã Térmica Aveludada", "icon": "🧣", "nix_status": "Nix fica enroladinho como um bolinho de lã quentinho.", "quote": "Aconchego e calor constantes são o segredo da recuperação!", "reward_text": "Manta de Lã estendida! A hipotermia pós-febre é impedida."},
		4: {"stage": 4, "ingredient": "Xarope de Groselha e Mel Nobre", "icon": "🍯", "nix_status": "Nix toma a colherzinha de xarope e estala a língua com gosto.", "quote": "Um remédio doce que desce suave pela garganta do Nix!", "reward_text": "Xarope de Groselha administrado! A tosse mágica silenciou."},
		5: {"stage": 5, "ingredient": "Infuso de Flor de Laranjeira", "icon": "🍊", "nix_status": "O coraçãozinho de Nix bate calmo ao aroma da laranjeira.", "quote": "Subindo as escadarias com a bandeja impecável e veloz!", "reward_text": "Infuso aromático borrifado no ambiente! Paz absoluta no quarto."},
		6: {"stage": 6, "ingredient": "Extrato de Menta da Horta Privada", "icon": "🌿", "nix_status": "Nix respira fundo sem qualquer chiado no peito!", "quote": "Menta fresca colhida à mão na horta da mansão!", "reward_text": "Menta refrescante aplicada! As vias respiratórias estão limpas."},
		7: {"stage": 7, "ingredient": "Vaporizador de Eucalipto Real", "icon": "💨", "nix_status": "Nix dorme um sono tranquilo como um bebê bem cuidado.", "quote": "O vapor perfumado limpa o ar de todo o aposento!", "reward_text": "Vaporizador Real aceso! O ambiente atinge a umidade ideal."},
		8: {"stage": 8, "ingredient": "Geleia de Sabugueiro Revitalizante", "icon": "🍇", "nix_status": "Nix acorda, lambe a patinha e começa a limpar o focinho!", "quote": "Ele está se lambendo! O instinto saudável do gato voltou!", "reward_text": "Sabugueiro absorvido! A vitalidade foi restabelecida em 80%."},
		9: {"stage": 9, "ingredient": "Almofada de Plumas de Seda", "icon": "🛋️", "nix_status": "Nix afunda as patinhas na pluma com ronronadas suaves.", "quote": "O melhor leito da mansão para o rei da casa, Nix!", "reward_text": "Almofada de Seda entregue! O sono reparador acelera a cura."},
		10: {"stage": 10, "ingredient": "Pó de Baunilha Refinada Curativa", "icon": "🍨", "nix_status": "Nix levanta as duas orelhinhas ao ouvir os passos da Lina-Maid!", "quote": "A baunilha fecha o ciclo dos remédios vitamínicos!", "reward_text": "Baunilha Curativa misturada ao leite desnatado especial!"},
		11: {"stage": 11, "ingredient": "Bolsa Térmica de Água Quente", "icon": "♨️", "nix_status": "Nix ronrona alto e empurra a cabeça na mão da Lina!", "quote": "Só mais um serviço impecável e Nix estará 100% curado!", "reward_text": "Bolsa Térmica aconchegada junto ao corpinho de Nix!"},
		12: {"stage": 12, "ingredient": "Banquete Fino Restaurador de Nix", "icon": "🧁", "nix_status": "CURA COMPLETA! Nix comeu todo o prato, se espreguiçou e pulou no colo!", "quote": "MISSÃO CUMPRIDA COM PERFEIÇÃO! O SENHOR NIX ESTÁ RADIANTE! ☕🐾", "reward_text": "O BANQUETE DE CURA DA MANSÃO FOI UM SUCESSO! Nix tomou todo o caldo nutritivo, deu três cambalhotas na almofada e ronrona no avental de Lina!"}
	},
	"maomao": {
		1: {"stage": 1, "ingredient": "Raiz de Alcaçuz Selvagem Imperial", "icon": "🎋", "nix_status": "Nix repousa no cesto de palha imperial, com febre alta e olhos fechados.", "quote": "Esta febre é uma intoxicação mágica! Como boticária, sei o antídoto!", "reward_text": "Alcaçuz moído no almofariz! Princípio ativo neutralizador obtido."},
		2: {"stage": 2, "ingredient": "Flor Seca de Crisântemo das Neves", "icon": "🌼", "nix_status": "O cheiro do chá de crisântemo reduz o calor nas orelhas de Nix.", "quote": "O crisântemo dissipa o calor interno do fígado e pulmão!", "reward_text": "Crisântemo infusionado! A febre diminui gradativamente."},
		3: {"stage": 3, "ingredient": "Fruto Seco de Goji Antioxidante", "icon": "🍒", "nix_status": "Nix aceita a gota do suco de goji e pisca para Lina com afeto.", "quote": "Goji nutre o sangue e fortalece a visão e sentidos do gatinho!", "reward_text": "Goji Imperial concentrado! Suporte vitamínico completo."},
		4: {"stage": 4, "ingredient": "Semente de Lótus Aliviadora de Febre", "icon": "🪷", "nix_status": "A agitação de Nix diminui e ele dorme com respiração fluida.", "quote": "Lótus acalma o coração e remove o fogo das vísceras!", "reward_text": "Semente de Lótus fervida em fogo brando no caldeirão!"},
		5: {"stage": 5, "ingredient": "Erva Gafanhoto Neutralizadora", "icon": "🦗", "nix_status": "O veneno mágico no sangue de Nix começa a se decompor.", "quote": "Conhecer venenos é a melhor forma de criar os antídotos perfeitos!", "reward_text": "Erva Gafanhoto dosada com extrema precisão boticária!"},
		6: {"stage": 6, "ingredient": "Extrato de Reishi da Longevidade", "icon": "🍄", "nix_status": "Nix abre os dois olhos e lambe a mãozinha da Maomao-Lina.", "quote": "Cogumelo sagrado dos imperadores para o melhor gatinho do mundo!", "reward_text": "Reishi Milenar destilado! O sistema imunológico ganha força invencível."},
		7: {"stage": 7, "ingredient": "Gota de Orvalho do Bambu Noturno", "icon": "🎍", "nix_status": "O focinho de Nix volta a ficar úmido e saudável como deve ser.", "quote": "Colhi o orvalho antes do amanhecer na floresta proibida!", "reward_text": "Orvalho Puro equilibrado! A hidratação de Nix está normalizada."},
		8: {"stage": 8, "ingredient": "Pó de Pérola Moída Purificante", "icon": "🦪", "nix_status": "Nix mexe as patinhas sonhando com passeios pelos jardins.", "quote": "Pérola moída acalma a mente e repara tecidos internos!", "reward_text": "Pó de Pérola dissolvido na poção boticária!"},
		9: {"stage": 9, "ingredient": "Casca de Canela Revigorante", "icon": "🪵", "nix_status": "O sangue circula quente e vigoroso pelas veias do gatinho.", "quote": "A canela aquece o meridiano e afasta o frio remanescente!", "reward_text": "Canela fina dosada com maestria no remédio!"},
		10: {"stage": 10, "ingredient": "Geleia Real das Colmeias Imperiais", "icon": "🐝", "nix_status": "Nix se espreguiça no cesto e fica de pé sobre as quatro patinhas!", "quote": "Ele já consegue ficar de pé! A receita imperial é infalível!", "reward_text": "Geleia Real deglutida! A energia muscular foi 95% restaurada."},
		11: {"stage": 11, "ingredient": "Bálsamo Verde de Jade Cicatrizante", "icon": "🍵", "nix_status": "Nix solta um ronrom vigoroso e dá um pulinho na beirada do cesto!", "quote": "Só falta a última decocção de ouro do palácio!", "reward_text": "Bálsamo de Jade aplicado com massagem relaxante nas patinhas."},
		12: {"stage": 12, "ingredient": "Decocção das Cem Ervas de Nix", "icon": "🏺", "nix_status": "CURA COMPLETA! Nix bebeu todo o antídoto e ronrona esfregando a cabeça!", "quote": "DIAGNÓSTICO FINAL: CURADO COM 100% DE SUCESSO BOTICÁRIO! 🌿🐾", "reward_text": "O ANTÍDOTO DAS CEM ERVAS SALVOU NIX! Maomao-Lina sorri satisfeita com a própria fórmula enquanto Nix brinca com as fitas de seu hanfu imperial!"}
	},
	"miku": {
		1: {"stage": 1, "ingredient": "Microfone de Frequência Sonora Calmante", "icon": "🎤", "nix_status": "Nix ouve a canção de ninar ciano e fecha os olhinhos descansando.", "quote": "Vou cantar a frequência perfeita de cura para você, Nix!", "reward_text": "Microfone de Frequência sintonizado em 432Hz! Ondas calmantes ativas."},
		2: {"stage": 2, "ingredient": "Batida Rítmica Estabilizadora de Pulso", "icon": "🥁", "nix_status": "O pulso de Nix se sincroniza com a batida suave de 60 BPM.", "quote": "A música harmoniza o fluxo cardíaco! O ritmo está estável!", "reward_text": "Batida Rítmica injetada no transmissor sonoro! Pulso estabilizado."},
		3: {"stage": 3, "ingredient": "Fita Magnética de Ondas Delta do Sono", "icon": "📼", "nix_status": "Nix entra no sono regenerativo mais profundo e curativo.", "quote": "O sono delta é o momento onde o corpo se cura por completo!", "reward_text": "Fita de Ondas Delta rodando no gravador analógico com sucesso."},
		4: {"stage": 4, "ingredient": "Acorde Ciano Curativo em Lá Maior", "icon": "🎹", "nix_status": "A pele e pelagem de Nix vibram com harmonia luminosa.", "quote": "Cada nota dissipa uma partícula da febre mágica!", "reward_text": "Acorde Ciano ecoa pelos circuitos! Febre neutralizada em 40%."},
		5: {"stage": 5, "ingredient": "Vitamina de Eletro-Glicose Neon", "icon": "⚡", "nix_status": "Nix lambe o bastonete nutritivo de glicose e ganha vigor.", "quote": "Energia pura sintetizada diretamente da batida eletrônica!", "reward_text": "Eletro-Glicose neon absorvida pelas células do felino!"},
		6: {"stage": 6, "ingredient": "Sintetizador de Ronrom Harmônico", "icon": "🎧", "nix_status": "O ronrom de Nix começa a acompanhar a melodia de Miku!", "quote": "Ele está cantando comigo! Que coisa mais fofa do multiverso!", "reward_text": "Sintetizador de Ronrom sintonizou o dueto perfeito de cura!"},
		7: {"stage": 7, "ingredient": "Filtro Passa-Baixas Anti-Stress", "icon": "🎛️", "nix_status": "Todos os ruídos externos que incomodavam Nix são silenciados.", "quote": "Apenas frequências de pura tranquilidade chegam até o Nix!", "reward_text": "Filtro Ativo! O estresse físico foi 100% eliminado."},
		8: {"stage": 8, "ingredient": "Bateria Recarregável de Bio-Vida", "icon": "🔋", "nix_status": "Nix mexe a patinha no compasso da música pop!", "quote": "A bateria da vida de Nix está recarregando para o nível máximo!", "reward_text": "Bio-Bateria conectada à coleira mágica de Nix!"},
		9: {"stage": 9, "ingredient": "Partitura Holográfica da Serenidade", "icon": "🎼", "nix_status": "Notas musicais luminosas dançam ao redor da cestinha de Nix.", "quote": "A sinfonia da saúde está quase completa no domo digital!", "reward_text": "Partitura Holográfica desdobrada em 360 graus!"},
		10: {"stage": 10, "ingredient": "Eco Reverberante de Carinho Digital", "icon": "🔊", "nix_status": "Nix se levanta, espreguiça as quatro patas e solta um miau sonoro!", "quote": "Ouvi esse miado límpido! Nix está quase pronto para o show!", "reward_text": "Reverberação carinhosa aplicada! Respiração 100% desobstruída."},
		11: {"stage": 11, "ingredient": "Alho-Poró Verde da Vitalidade", "icon": "🌱", "nix_status": "Nix brinca batendo a patinha no talo de alho-poró de Miku!", "quote": "Ele está brincando! A alegria de Nix voltou por inteiro!", "reward_text": "Alho-Poró da Sorte agitado ao ritmo do refrão de cura!"},
		12: {"stage": 12, "ingredient": "Melodia Perfeita 39 de Cura de Nix", "icon": "🎶", "nix_status": "CURA COMPLETA! Nix está pulando, dançando e ronronando com fones neon!", "quote": "SHOW INESQUECÍVEL! NIX ESTÁ RADIANTE, CURADO E CHEIO DE RITMO! 🎵🐾", "reward_text": "A MELODIA VOCALOID SALVOU NIX! O gatinho deu um salto acrobático e agora usa fonezinhos ciano combinando com a Lina-Miku, cantando juntos para a multidão!"}
	},
	"sonserina": {
		1: {"stage": 1, "ingredient": "Escama de Serpente de Prata Reluzente", "icon": "🐍", "nix_status": "Nix descansa sobre o veludo esmeralda da sala comunal, respirando fraco.", "quote": "A magia das masmorras tem a cura mais poderosa contra feitiços arcanos!", "reward_text": "Escama de Serpente moída! Dissipa a maldição que gerou a febre."},
		2: {"stage": 2, "ingredient": "Gota de Poção Wiggenweld Concentrada", "icon": "🧪", "nix_status": "A gota verde cura o calor excessivo nas orelhinhas de Nix.", "quote": "A poção regenerativa Wiggenweld é insuperável na medicina bruxa!", "reward_text": "Wiggenweld administrada! A vitalidade começa a ascender."},
		3: {"stage": 3, "ingredient": "Folha de Mandrágora Suavizada", "icon": "🪴", "nix_status": "Nix solta um suspiro relaxado enquanto a mandrágora acalma a dor.", "quote": "Mandrágora adormecida restaura forças esgotadas por magia negra!", "reward_text": "Mandrágora destilada sem o grito! Relaxamento profundo."},
		4: {"stage": 4, "ingredient": "Pó de Chifre de Bicórnio Restaurador", "icon": "🦄", "nix_status": "O batimento cardíaco de Nix volta ao compasso forte e seguro.", "quote": "Ingrediente raro das masmorras mais profundas para salvar meu Nix!", "reward_text": "Pó de Bicórnio infusionado no caldeirão de cobre!"},
		5: {"stage": 5, "ingredient": "Bálsamo de Pele de Araramboia", "icon": "✨", "nix_status": "A febre de Nix baixa consideravelmente sob o feitiço do bálsamo.", "quote": "A troca de pele simboliza o renascimento da saúde pura!", "reward_text": "Bálsamo esmeralda aplicado! Temperatura corporal estabilizada."},
		6: {"stage": 6, "ingredient": "Secreção Purificada de Ditamno", "icon": "🌿", "nix_status": "Nix abre os olhinhos dourados e pisca calmo para Lina.", "quote": "O ditamno fecha qualquer ferida e purifica qualquer enfermidade!", "reward_text": "Ditamno purificado! O sistema imunológico ganha escudo impenetrável."},
		7: {"stage": 7, "ingredient": "Caldeirão de Cobre com Fogo Suave", "icon": "🫕", "nix_status": "Nix bebe o xarope morno e ronrona fraquinho pela primeira vez!", "quote": "Ele ronronou! O caldeirão das masmorras cozinhou a cura perfeita!", "reward_text": "Xarope do Caldeirão engarrafado e consumido com sucesso!"},
		8: {"stage": 8, "ingredient": "Bétula da Floresta Proibida Aquecida", "icon": "🪵", "nix_status": "O calor mágico constante mantém Nix livre de qualquer calafrio.", "quote": "A madeira mágica queima com chama esmeralda sem queimar!", "reward_text": "Lareira de Chama Esmeralda aquecendo a cestinha do Nix."},
		9: {"stage": 9, "ingredient": "Soro Verde Antídoto Universal", "icon": "🔮", "nix_status": "Nix senta-se na almofada e lambe as patas da frente!", "quote": "O antídoto universal neutralizou 100% da febre residual!", "reward_text": "Antídoto Universal agiu no organismo com perfeição alquímica."},
		10: {"stage": 10, "ingredient": "Orvalho sob Lua Nova das Criptas", "icon": "🌙", "nix_status": "Nix mexe a cauda feliz e mia bem alto chamando por Lina!", "quote": "Ele me chamou! As masmorras ecoam a voz saudável de Nix!", "reward_text": "Orvalho Lunar absorvido! As energias mágicas estão equilibradas."},
		11: {"stage": 11, "ingredient": "Pena de Coruja Noturna da Lealdade", "icon": "🪶", "nix_status": "Nix brinca com a pontinha da pena como o gatinho ágil que é!", "quote": "O instinto brincalhão de caça voltou! Falta apenas o selo supremo!", "reward_text": "Pena de Coruja encantada com o feitiço da amizade eterna."},
		12: {"stage": 12, "ingredient": "Elixir da Serpente de Cura de Nix", "icon": "🏆", "nix_status": "CURA COMPLETA! Nix está pulando pelas masmorras, forte, saudável e astuto!", "quote": "TRIUNFO DA ASTÚCIA E DO AMOR! NIX ESTÁ TOTALMENTE SALVO! 🐍🐾", "reward_text": "A POÇÃO SUPREMA DA SONSERINA RESTAUROU NIX! O gatinho veste agora uma fitinha prata e verde no pescoço, ronronando triunfante nos ombros de Lina!"}
	},
	"tracen": {
		1: {"stage": 1, "ingredient": "Ferradura da Sorte Dourada", "icon": "🧲", "nix_status": "Nix descansa na toalha felpuda do vestiário de Tracen, exausto da febre.", "quote": "Nesta corrida pela sua vida, Nix, serei a corredora mais veloz de todas!", "reward_text": "Ferradura de Ouro instalada na cestinha! Traz bênção e força para a largada."},
		2: {"stage": 2, "ingredient": "Isotônico Energético de Cenoura Doce", "icon": "🥕", "nix_status": "Nix bebe algumas gotas do isotônico e sua respiração desacelera suave.", "quote": "A hidratação dos atletas de turf é perfeita para curar fraqueza!", "reward_text": "Isotônico doce digerido! A febre mágica começa a ceder."},
		3: {"stage": 3, "ingredient": "Toalha Quente de Algodão Hidrofílico", "icon": "🧣", "nix_status": "O corpinho de Nix relaxa com a compressa quentinha e macia.", "quote": "Mantendo os músculos e patinhas aquecidos contra o vento da pista!", "reward_text": "Toalha Hidrofílica absorve o suor febril! Nix respira aliviado."},
		4: {"stage": 4, "ingredient": "Pomada de Aquecimento Muscular Suave", "icon": "🧴", "nix_status": "Nix estica as perninhas traseiras sentindo o alívio das dores.", "quote": "Saltando os obstáculos de trilho para garantir o alívio muscular de Nix!", "reward_text": "Pomada Tracen massageada com cuidado nas articulações do gatinho."},
		5: {"stage": 5, "ingredient": "Fita de Chegada da Corrida Invicta", "icon": "🎗️", "nix_status": "Nix apoia o queixo na fita azul e branca e ronrona baixinho.", "quote": "Cruzando a meia pista na liderança absoluta! O remédio está perto!", "reward_text": "Fita da Vitória enrolada no cobertorzinho! Eleva a moral e a força vital."},
		6: {"stage": 6, "ingredient": "Proteína Pura para Vitalidade de Turf", "icon": "🥛", "nix_status": "Nix toma todo o leite enriquecido com proteína e lambe os bigodes.", "quote": "Nutrição de primeira classe para recompor o peso e energia do gatinho!", "reward_text": "Proteína de Turf absorvida! Os músculos ganham novo tônus."},
		7: {"stage": 7, "ingredient": "Água Mineral Glacial da Fonte Tracen", "icon": "💧", "nix_status": "Nix olha para a pista através da janela do camarote com olhos vivos.", "quote": "Subindo a colina dos campeões com fôlego de ouro pelo meu Nix!", "reward_text": "Água Glacial purificada! Limpeza total das toxinas da febre."},
		8: {"stage": 8, "ingredient": "Cenoura Mágica de Glicose Rápida", "icon": "🥕", "nix_status": "Nix mordisca a cenourinha mágica e se apoia nas quatro patas!", "quote": "Glicose natural de altíssimo rendimento! Nix já está em pé!", "reward_text": "Cenoura Mágica consumida! Glicose e energia restabelecidas."},
		9: {"stage": 9, "ingredient": "Cronômetro de Recuperação de Fôlego", "icon": "⏱️", "nix_status": "O fôlego de Nix atinge a taxa perfeita de 24 respirações por minuto.", "quote": "Tempo recorde em cada volta da pista! A vitória é certa!", "reward_text": "Cronômetro aponta: Todos os sinais vitais retornaram ao padrão campeão!"},
		10: {"stage": 10, "ingredient": "Manto Térmico dos Campeões", "icon": "🏆", "nix_status": "Nix se enrola na capa de veludo azul com orgulho felino.", "quote": "Reta final! A torcida inteira de Tracen está aplaudindo nossa corrida!", "reward_text": "Manto dos Campeões colocado! Proteção térmica máxima contra qualquer vento."},
		11: {"stage": 11, "ingredient": "Laço de Crina de Amizade Indestrutível", "icon": "🎀", "nix_status": "Nix pula para fora da cesta e dá passos firmes na direção da Lina!", "quote": "Ele está correndo! Nix está vindo ao meu encontro na pista!", "reward_text": "Laço da Amizade atado à patinha! Conexão de amor inquebrantável."},
		12: {"stage": 12, "ingredient": "Taça da Imunidade Invicta do Nix", "icon": "🥇", "nix_status": "CURA COMPLETA! Nix cruzou a linha de chegada no colo da Lina sob chuva de confetes!", "quote": "GRANDE VITÓRIA NO LINAVERSE TWINKLE SERIES! NIX É O CAMPEÃO DA VIDA! 🏇🐾", "reward_text": "O TROFÉU DE TRACEN CUROU NIX! O gatinho pulou no degrau mais alto do pódio ao lado da Lina-Tracen, recebendo a medalha de ouro e muito carinho de toda a torcida!"}
	}
}

const STAGE_STORY_LORE: Dictionary = UNIVERSE_STORY_LORE["classic"]

func get_stage_story(lvl: int, universe_id: String = "") -> Dictionary:
	var u_id = universe_id if universe_id != "" else current_outfit
	var u_lore = UNIVERSE_STORY_LORE.get(u_id, UNIVERSE_STORY_LORE["classic"])
	return u_lore.get(lvl, STAGE_STORY_LORE.get(lvl, {
		"stage": lvl,
		"ingredient": "Essência Curativa Mágica",
		"icon": "✨",
		"nix_status": "Nix repousa aguardando Lina voltar com o remédio...",
		"quote": "Aguente firme, Nix!",
		"reward_text": "Mais um ingrediente precioso garantido para o remédio do Nix!"
	}))

func calculate_speedrun_rank(lvl: int, time_taken: float) -> String:
	var t = get_speedrun_target(lvl)
	if time_taken <= t["s"]:
		return "S"
	elif time_taken <= t["a"]:
		return "A"
	elif time_taken <= t["b"]:
		return "B"
	return "C"

func get_speedrun_records() -> Dictionary:
	if FileAccess.file_exists(SPEEDRUN_SAVE_FILE):
		var f = FileAccess.open(SPEEDRUN_SAVE_FILE, FileAccess.READ)
		if f:
			var json = JSON.new()
			if json.parse(f.get_as_text()) == OK and json.data is Dictionary:
				f.close()
				return json.data
			f.close()
	return {}

func get_speedrun_record_for_level(lvl: int) -> Dictionary:
	var all_recs = get_speedrun_records()
	return all_recs.get(str(lvl), {})

func save_speedrun_record(lvl: int, time_taken: float, crystals: int) -> Dictionary:
	var all_recs = get_speedrun_records()
	var key = str(lvl)
	var prev_rec = all_recs.get(key, {})
	var prev_best_time = prev_rec.get("best_time", 999999.0)
	var is_new_pb = time_taken < prev_best_time
	var best_time = min(time_taken, prev_best_time)
	var rank = calculate_speedrun_rank(lvl, time_taken)
	var best_rank = calculate_speedrun_rank(lvl, best_time)
	
	all_recs[key] = {
		"best_time": best_time,
		"best_rank": best_rank,
		"crystals": max(crystals, prev_rec.get("crystals", 0)),
		"last_time": time_taken,
		"last_rank": rank
	}
	
	var f = FileAccess.open(SPEEDRUN_SAVE_FILE, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(all_recs))
		f.close()
		
	return {
		"rank": rank,
		"best_rank": best_rank,
		"is_new_pb": is_new_pb,
		"time_taken": time_taken,
		"best_time": best_time,
		"prev_best": prev_best_time if prev_best_time < 999999.0 else 0.0
	}

func get_level_path(lvl: int, universe_id: String = "") -> String:
	var u_id = universe_id if universe_id != "" else current_outfit
	var path_u = "res://scenes/levels/%s/level_%d.tscn" % [u_id, lvl]
	if ResourceLoader.exists(path_u):
		return path_u
	return "res://scenes/levels/level_%d.tscn" % lvl

func restart_level() -> void:
	reset_active_powerups()
	score = 0
	max_hp = 3 + bonus_max_hp
	current_hp = max_hp
	default_spawn_pos = get_level_spawn_pos(current_level)
	checkpoint_pos = default_spawn_pos
	elapsed_time = 0.0
	is_game_over = false
	is_level_completed = false
	timer_active = true
	get_tree().paused = false
	if has_aurora_shield:
		shield_active = true
		shield_status_changed.emit(true)
	get_tree().change_scene_to_file(get_level_path(current_level))
var elapsed_time: float = 0.0
var timer_active: bool = false
var is_game_over: bool = false
var is_level_completed: bool = false

# === Sistema de Cartas de Poder ===
var active_powers: Array[Dictionary] = []
var speed_mult: float = 1.0
var jump_mult: float = 1.0
var bonus_max_hp: int = 0
var max_air_jumps: int = 1 # 1 = duplo salto, 2 = triplo salto
var magnet_radius: float = 0.0
var has_aurora_shield: bool = false
var shield_active: bool = false
var invulnerable_mult: float = 1.0
var frost_fortune_active: bool = false
var feather_fall_active: bool = false

# === Sistema de Power-Ups Coletáveis na Fase ===
var active_powerups: Dictionary = {}

const POWERUP_DEFS: Dictionary = {
	"dash": {
		"name": "Hiper Dash Turbo",
		"icon": "⚡",
		"duration": 6.0,
		"color": Color(1.0, 0.88, 0.15),
		"desc": "Velocidade acelerada e recarga de Dash instantânea!"
	},
	"magnet": {
		"name": "Ímã Astral",
		"icon": "🧲",
		"duration": 8.0,
		"color": Color(0.2, 0.9, 1.0),
		"desc": "Atrai todos os cristais do mapa diretamente para Lina!"
	},
	"chrono": {
		"name": "Ampulheta Temporal",
		"icon": "⏳",
		"duration": 4.0,
		"color": Color(1.0, 0.65, 0.2),
		"desc": "Congela o cronômetro do speedrun por 4 segundos!"
	},
	"shield": {
		"name": "Escudo de Aurora",
		"icon": "🛡️",
		"duration": 0.0,
		"color": Color(0.35, 0.85, 1.0),
		"desc": "Barreira protetora que absorve 1 dano de inimigo ou espinhos!"
	},
	"wings": {
		"name": "Asas Celestiais",
		"icon": "🪶",
		"duration": 8.0,
		"color": Color(0.85, 0.7, 1.0),
		"desc": "Concede +2 saltos no ar e planeio suave nas alturas!"
	},
	"heal": {
		"name": "Coração Estelar",
		"icon": "💖",
		"duration": 0.0,
		"color": Color(1.0, 0.35, 0.55),
		"desc": "Restaura 1 ponto de vida da Lina imediatamente!"
	}
}

# === Sistema de Roupas / Trajes da Lina ===
var current_outfit: String = "classic"

const UNIVERSES: Array[String] = ["classic", "celestial", "valkyrie", "ninja", "royalty", "uniform", "agnes", "frieren", "maid", "maomao", "miku", "sonserina", "tracen"]
const UNIVERSE_SAVE_FILE: String = "user://current_universe.txt"

const OUTFITS: Dictionary = {
	"classic": {
		"id": "classic",
		"name": "Exploradora do Inverno",
		"icon": "❄️",
		"universe_name": "Universo Glacial Clássico",
		"universe_subtitle": "O Reino dos Ventos Polares e Encostas Nevadas",
		"portrait": "res://assets/sprites/ui/outfit_classic.png",
		"sprite": "res://assets/sprites/player/lina_sprite_classic.png",
		"sprite_frames": "res://scenes/player/player_frames_classic.tres",
		"theme": "Clássico",
		"desc": "O casaco acolchoado branco e cachecol azul icônicos de Lina, perfeito para explorar as colinas de neve.",
		"badge": "Padrão",
		"color": Color(0.4, 0.85, 1.0),
		"bg_textures": {
			"sky": "res://assets/sprites/background/classic/sky.png",
			"far": "res://assets/sprites/background/classic/far.png",
			"mid": "res://assets/sprites/background/classic/mid.png",
			"trees": "res://assets/sprites/background/classic/trees.png"
		},
		"theme_data": {
			"sky_color": Color(1.0, 1.0, 1.0),
			"mountains_far_color": Color(1.0, 1.0, 1.0),
			"mountains_mid_color": Color(1.0, 1.0, 1.0),
			"trees_color": Color(1.0, 1.0, 1.0),
			"ground_color": Color(0.07, 0.1, 0.18, 0.98),
			"ground_border": Color(0.88, 0.96, 1.0, 1.0),
			"ambient_modulate": Color(1.0, 1.0, 1.0),
			"platform_modulate": Color(1.0, 1.0, 1.0),
			"ice_modulate": Color(0.85, 0.95, 1.0),
			"crystal_modulate": Color(0.7, 0.9, 1.0),
			"particles_color": Color(1.0, 1.0, 1.0, 0.85),
			"particles_gravity": Vector2(25, 45),
			"particles_speed": Vector2(40, 90),
			"particles_spread": 20.0,
			"stage_atmosphere_name": "Inverno Polar Clássico"
		}
	},
	"celestial": {
		"id": "celestial",
		"name": "Maga Celestial",
		"icon": "⭐",
		"universe_name": "Universo Astral Celestial",
		"universe_subtitle": "A Dimensão Astral das Constelações e Feitiços Estelares",
		"portrait": "res://assets/sprites/ui/outfit_celestial.png",
		"sprite": "res://assets/sprites/player/lina_sprite_celestial.png",
		"sprite_frames": "res://scenes/player/player_frames_celestial.tres",
		"theme": "Magia Astral",
		"desc": "Túnica de veludo azul-meia-noite e violeta com constelações bordadas em ouro e broche de cristal estelar.",
		"badge": "Épico",
		"color": Color(1.0, 0.82, 0.25),
		"bg_textures": {
			"sky": "res://assets/sprites/background/celestial/sky.png",
			"far": "res://assets/sprites/background/celestial/far.png",
			"mid": "res://assets/sprites/background/celestial/mid.png",
			"trees": "res://assets/sprites/background/celestial/trees.png"
		},
		"theme_data": {
			"sky_color": Color(1.0, 1.0, 1.0),
			"mountains_far_color": Color(1.0, 1.0, 1.0),
			"mountains_mid_color": Color(1.0, 1.0, 1.0),
			"trees_color": Color(1.0, 1.0, 1.0),
			"ground_color": Color(0.08, 0.05, 0.18, 0.98),
			"ground_border": Color(1.0, 0.85, 0.4, 1.0),
			"ambient_modulate": Color(0.95, 0.88, 1.1),
			"platform_modulate": Color(0.9, 0.75, 1.2),
			"ice_modulate": Color(1.0, 0.85, 0.4),
			"crystal_modulate": Color(1.0, 0.88, 0.25),
			"particles_color": Color(1.0, 0.9, 0.35, 0.9),
			"particles_gravity": Vector2(10, 25),
			"particles_speed": Vector2(20, 50),
			"particles_spread": 40.0,
			"stage_atmosphere_name": "Noite Astral com Poeira Estelar"
		}
	},
	"valkyrie": {
		"id": "valkyrie",
		"name": "Valquíria Glacial",
		"icon": "⚔️",
		"universe_name": "Universo Valquíria Glacial",
		"universe_subtitle": "O Reino Mitológico Nórdico de Prata e Asas Místicas",
		"portrait": "res://assets/sprites/ui/outfit_valkyrie.png",
		"sprite": "res://assets/sprites/player/lina_sprite_valkyrie.png",
		"sprite_frames": "res://scenes/player/player_frames_valkyrie.tres",
		"theme": "Guerreira Nórdica",
		"desc": "Armadura reluzente de placas prateadas com runas nórdicas gravadas, asas de prata e gola de pele.",
		"badge": "Lendário",
		"color": Color(0.5, 0.95, 1.0),
		"bg_textures": {
			"sky": "res://assets/sprites/background/valkyrie/sky.png",
			"far": "res://assets/sprites/background/valkyrie/far.png",
			"mid": "res://assets/sprites/background/valkyrie/mid.png",
			"trees": "res://assets/sprites/background/valkyrie/trees.png"
		},
		"theme_data": {
			"sky_color": Color(1.0, 1.0, 1.0),
			"mountains_far_color": Color(1.0, 1.0, 1.0),
			"mountains_mid_color": Color(1.0, 1.0, 1.0),
			"trees_color": Color(1.0, 1.0, 1.0),
			"ground_color": Color(0.05, 0.12, 0.2, 0.98),
			"ground_border": Color(0.5, 1.0, 1.0, 1.0),
			"ambient_modulate": Color(0.92, 1.05, 1.1),
			"platform_modulate": Color(0.7, 1.05, 1.15),
			"ice_modulate": Color(0.4, 1.0, 1.0),
			"crystal_modulate": Color(0.45, 1.0, 0.95),
			"particles_color": Color(0.7, 1.0, 1.0, 0.9),
			"particles_gravity": Vector2(40, 65),
			"particles_speed": Vector2(60, 130),
			"particles_spread": 15.0,
			"stage_atmosphere_name": "Nevasca Rúnica das Valquírias"
		}
	},
	"ninja": {
		"id": "ninja",
		"name": "Ninja da Neve",
		"icon": "🥷",
		"universe_name": "Universo Shinobi da Neve",
		"universe_subtitle": "A Dimensão Oculta Shinobi dos Bosques de Gelo",
		"portrait": "res://assets/sprites/ui/outfit_ninja.png",
		"sprite": "res://assets/sprites/player/lina_sprite_ninja.png",
		"sprite_frames": "res://scenes/player/player_frames_ninja.tres",
		"theme": "Shinobi Furtiva",
		"desc": "Uniforme acrobático shinobi azul-escuro com ombreiras leves, protetor de testa de neve e fitas esvoaçantes.",
		"badge": "Raro",
		"color": Color(0.4, 0.7, 0.95),
		"bg_textures": {
			"sky": "res://assets/sprites/background/ninja/sky.png",
			"far": "res://assets/sprites/background/ninja/far.png",
			"mid": "res://assets/sprites/background/ninja/mid.png",
			"trees": "res://assets/sprites/background/ninja/trees.png"
		},
		"theme_data": {
			"sky_color": Color(1.0, 1.0, 1.0),
			"mountains_far_color": Color(1.0, 1.0, 1.0),
			"mountains_mid_color": Color(1.0, 1.0, 1.0),
			"trees_color": Color(1.0, 1.0, 1.0),
			"ground_color": Color(0.04, 0.05, 0.1, 0.98),
			"ground_border": Color(0.4, 0.7, 0.95, 1.0),
			"ambient_modulate": Color(0.8, 0.85, 0.98),
			"platform_modulate": Color(0.55, 0.62, 0.8),
			"ice_modulate": Color(0.5, 0.7, 0.95),
			"crystal_modulate": Color(0.4, 0.75, 1.0),
			"particles_color": Color(0.65, 0.78, 0.95, 0.6),
			"particles_gravity": Vector2(15, 30),
			"particles_speed": Vector2(30, 65),
			"particles_spread": 25.0,
			"stage_atmosphere_name": "Penumbra Silenciosa Shinobi"
		}
	},
	"royalty": {
		"id": "royalty",
		"name": "Princesa do Inverno",
		"icon": "👑",
		"universe_name": "Universo Real do Inverno",
		"universe_subtitle": "O Palácio Soberano dos Cristais de Safira",
		"portrait": "res://assets/sprites/ui/outfit_royalty.png",
		"sprite": "res://assets/sprites/player/lina_sprite_royalty.png",
		"sprite_frames": "res://scenes/player/player_frames_royalty.tres",
		"theme": "Realeza Glacial",
		"desc": "Vestido nobre de veludo azul-safira com tiara de cristais reluzentes, gargantilha real e manto de arminho.",
		"badge": "Mítico",
		"color": Color(0.85, 0.5, 1.0),
		"bg_textures": {
			"sky": "res://assets/sprites/background/royalty/sky.png",
			"far": "res://assets/sprites/background/royalty/far.png",
			"mid": "res://assets/sprites/background/royalty/mid.png",
			"trees": "res://assets/sprites/background/royalty/trees.png"
		},
		"theme_data": {
			"sky_color": Color(1.0, 1.0, 1.0),
			"mountains_far_color": Color(1.0, 1.0, 1.0),
			"mountains_mid_color": Color(1.0, 1.0, 1.0),
			"trees_color": Color(1.0, 1.0, 1.0),
			"ground_color": Color(0.1, 0.04, 0.16, 0.98),
			"ground_border": Color(0.9, 0.55, 1.0, 1.0),
			"ambient_modulate": Color(1.08, 0.92, 1.15),
			"platform_modulate": Color(1.1, 0.85, 1.15),
			"ice_modulate": Color(0.85, 0.5, 1.0),
			"crystal_modulate": Color(0.95, 0.45, 1.0),
			"particles_color": Color(0.95, 0.65, 1.0, 0.85),
			"particles_gravity": Vector2(18, 35),
			"particles_speed": Vector2(25, 60),
			"particles_spread": 35.0,
			"stage_atmosphere_name": "Aura de Diamante do Palácio Real"
		}
	},
	"uniform": {
		"id": "uniform",
		"name": "Uniforme Colegial",
		"icon": "🎒",
		"universe_name": "Universo Colegial Moderno",
		"universe_subtitle": "O Mundo Moderno Conectado ao Multiverso Cósmico",
		"portrait": "res://assets/sprites/ui/outfit_uniform.png",
		"sprite": "res://assets/sprites/player/lina_sprite_uniform.png",
		"sprite_frames": "res://scenes/player/player_frames_uniform.tres",
		"theme": "Colegial",
		"desc": "O uniforme escolar japonês com blazer azul-marinho, saia plissada xadrez e laço vermelho de Lina.",
		"badge": "Especial",
		"color": Color(0.35, 0.7, 1.0),
		"bg_textures": {
			"sky": "res://assets/sprites/background/uniform/sky.png",
			"far": "res://assets/sprites/background/uniform/far.png",
			"mid": "res://assets/sprites/background/uniform/mid.png",
			"trees": "res://assets/sprites/background/uniform/trees.png"
		},
		"theme_data": {
			"sky_color": Color(1.0, 1.0, 1.0),
			"mountains_far_color": Color(1.0, 1.0, 1.0),
			"mountains_mid_color": Color(1.0, 1.0, 1.0),
			"trees_color": Color(1.0, 1.0, 1.0),
			"ground_color": Color(0.06, 0.09, 0.16, 0.98),
			"ground_border": Color(0.5, 0.85, 1.0, 1.0),
			"ambient_modulate": Color(1.05, 1.02, 1.0),
			"platform_modulate": Color(1.05, 0.95, 0.88),
			"ice_modulate": Color(0.5, 0.85, 1.0),
			"crystal_modulate": Color(0.35, 0.8, 1.0),
			"particles_color": Color(1.0, 0.98, 1.0, 0.9),
			"particles_gravity": Vector2(20, 40),
			"particles_speed": Vector2(35, 80),
			"particles_spread": 20.0,
			"stage_atmosphere_name": "Manhã de Inverno Vibrante"
		}
	},
	"agnes": {
		"id": "agnes",
		"name": "Cientista Quântica",
		"icon": "🧪",
		"universe_name": "Universo Laboratório Quântico",
		"universe_subtitle": "O Centro de Pesquisa Temporal e Fórmulas de Alta Velocidade",
		"portrait": "res://assets/sprites/ui/outfit_agnes.png",
		"sprite": "res://assets/sprites/player/lina_sprite_agnes.png",
		"sprite_frames": "res://scenes/player/player_frames_agnes.tres",
		"theme": "Alquimia Tachyon",
		"desc": "Jaleco científico sobre traje moderno de pesquisadora, frascos de reagentes e visor de telemetria quântica de Lina.",
		"badge": "Mítico",
		"color": Color(0.85, 0.45, 1.0),
		"bg_textures": {
			"sky": "res://assets/sprites/background/agnes/sky.png",
			"far": "res://assets/sprites/background/agnes/far.png",
			"mid": "res://assets/sprites/background/agnes/mid.png",
			"trees": "res://assets/sprites/background/agnes/trees.png"
		},
		"theme_data": {
			"sky_color": Color(1.0, 1.0, 1.0),
			"mountains_far_color": Color(1.0, 1.0, 1.0),
			"mountains_mid_color": Color(1.0, 1.0, 1.0),
			"trees_color": Color(1.0, 1.0, 1.0),
			"ground_color": Color(0.08, 0.05, 0.14, 0.98),
			"ground_border": Color(0.9, 0.4, 1.0, 1.0),
			"ambient_modulate": Color(1.05, 0.9, 1.15),
			"platform_modulate": Color(0.95, 0.8, 1.1),
			"ice_modulate": Color(0.85, 0.45, 1.0),
			"crystal_modulate": Color(0.9, 0.5, 1.0),
			"particles_color": Color(0.95, 0.5, 1.0, 0.85),
			"particles_gravity": Vector2(15, 30),
			"particles_speed": Vector2(30, 70),
			"particles_spread": 30.0,
			"stage_atmosphere_name": "Vapor Alquímico & Reações Tachyon"
		}
	},
	"frieren": {
		"id": "frieren",
		"name": "Maga Élfica",
		"icon": "🪄",
		"universe_name": "Universo Mágico Milenar",
		"universe_subtitle": "A Era Antiga da Magia Esquecida e Céus Élficos",
		"portrait": "res://assets/sprites/ui/outfit_frieren.png",
		"sprite": "res://assets/sprites/player/lina_sprite_frieren.png",
		"sprite_frames": "res://scenes/player/player_frames_frieren.tres",
		"theme": "Magia Ancestral",
		"desc": "Manto élfico alvo com listras douradas, botinas de viagem e báculo de magia pura carregado de mana milenar.",
		"badge": "Lendário",
		"color": Color(0.65, 0.9, 1.0),
		"bg_textures": {
			"sky": "res://assets/sprites/background/frieren/sky.png",
			"far": "res://assets/sprites/background/frieren/far.png",
			"mid": "res://assets/sprites/background/frieren/mid.png",
			"trees": "res://assets/sprites/background/frieren/trees.png"
		},
		"theme_data": {
			"sky_color": Color(1.0, 1.0, 1.0),
			"mountains_far_color": Color(1.0, 1.0, 1.0),
			"mountains_mid_color": Color(1.0, 1.0, 1.0),
			"trees_color": Color(1.0, 1.0, 1.0),
			"ground_color": Color(0.06, 0.1, 0.14, 0.98),
			"ground_border": Color(0.7, 0.95, 1.0, 1.0),
			"ambient_modulate": Color(0.95, 1.02, 1.08),
			"platform_modulate": Color(0.85, 0.98, 1.05),
			"ice_modulate": Color(0.7, 0.95, 1.0),
			"crystal_modulate": Color(0.8, 1.0, 0.95),
			"particles_color": Color(0.85, 0.95, 1.0, 0.9),
			"particles_gravity": Vector2(10, 25),
			"particles_speed": Vector2(20, 50),
			"particles_spread": 35.0,
			"stage_atmosphere_name": "Pétalas Mágicas e Brisa Élfica"
		}
	},
	"maid": {
		"id": "maid",
		"name": "Camareira Graciosa",
		"icon": "☕",
		"universe_name": "Universo Mansão Vitoriana",
		"universe_subtitle": "Os Salões Nobres de Chá, Tapeçarias e Serventia Fiel",
		"portrait": "res://assets/sprites/ui/outfit_maid.png",
		"sprite": "res://assets/sprites/player/lina_sprite_maid.png",
		"sprite_frames": "res://scenes/player/player_frames_maid.tres",
		"theme": "Elegância Vitoriana",
		"desc": "Vestido clássico de maid preto e branco, avental engomado com babados finos e tiara com laço bordado à mão.",
		"badge": "Raro",
		"color": Color(0.95, 0.8, 0.85),
		"bg_textures": {
			"sky": "res://assets/sprites/background/maid/sky.png",
			"far": "res://assets/sprites/background/maid/far.png",
			"mid": "res://assets/sprites/background/maid/mid.png",
			"trees": "res://assets/sprites/background/maid/trees.png"
		},
		"theme_data": {
			"sky_color": Color(1.0, 1.0, 1.0),
			"mountains_far_color": Color(1.0, 1.0, 1.0),
			"mountains_mid_color": Color(1.0, 1.0, 1.0),
			"trees_color": Color(1.0, 1.0, 1.0),
			"ground_color": Color(0.12, 0.08, 0.1, 0.98),
			"ground_border": Color(1.0, 0.85, 0.9, 1.0),
			"ambient_modulate": Color(1.05, 0.98, 1.02),
			"platform_modulate": Color(1.02, 0.92, 0.95),
			"ice_modulate": Color(0.95, 0.8, 0.85),
			"crystal_modulate": Color(1.0, 0.85, 0.7),
			"particles_color": Color(1.0, 0.9, 0.95, 0.85),
			"particles_gravity": Vector2(15, 30),
			"particles_speed": Vector2(25, 55),
			"particles_spread": 25.0,
			"stage_atmosphere_name": "Aroma de Chá Earl Grey e Veludo"
		}
	},
	"maomao": {
		"id": "maomao",
		"name": "Boticária Imperial",
		"icon": "🌿",
		"universe_name": "Universo Imperial das Ervas",
		"universe_subtitle": "O Palácio das Dinastias, Plantas Medicinais e Antídotos",
		"portrait": "res://assets/sprites/ui/outfit_maomao.png",
		"sprite": "res://assets/sprites/player/lina_sprite_maomao.png",
		"sprite_frames": "res://scenes/player/player_frames_maomao.tres",
		"theme": "Medicina Herbal",
		"desc": "Hanfu tradicional verde-esmeralda com xale claro, coque duplo preso com grampos e bolsa de ervas boticárias.",
		"badge": "Mítico",
		"color": Color(0.45, 0.95, 0.55),
		"bg_textures": {
			"sky": "res://assets/sprites/background/maomao/sky.png",
			"far": "res://assets/sprites/background/maomao/far.png",
			"mid": "res://assets/sprites/background/maomao/mid.png",
			"trees": "res://assets/sprites/background/maomao/trees.png"
		},
		"theme_data": {
			"sky_color": Color(1.0, 1.0, 1.0),
			"mountains_far_color": Color(1.0, 1.0, 1.0),
			"mountains_mid_color": Color(1.0, 1.0, 1.0),
			"trees_color": Color(1.0, 1.0, 1.0),
			"ground_color": Color(0.05, 0.12, 0.08, 0.98),
			"ground_border": Color(0.5, 0.95, 0.6, 1.0),
			"ambient_modulate": Color(0.92, 1.08, 0.96),
			"platform_modulate": Color(0.8, 1.05, 0.85),
			"ice_modulate": Color(0.5, 0.95, 0.65),
			"crystal_modulate": Color(0.4, 0.9, 0.5),
			"particles_color": Color(0.6, 1.0, 0.7, 0.85),
			"particles_gravity": Vector2(18, 32),
			"particles_speed": Vector2(30, 65),
			"particles_spread": 28.0,
			"stage_atmosphere_name": "Pólen de Jade e Orvalho Medicinal"
		}
	},
	"miku": {
		"id": "miku",
		"name": "Diva Sintetizadora",
		"icon": "🎵",
		"universe_name": "Universo Sintetizador Neon",
		"universe_subtitle": "A Metrópole Cyberpunk dos Beats Eletrônicos e Hologramas",
		"portrait": "res://assets/sprites/ui/outfit_miku.png",
		"sprite": "res://assets/sprites/player/lina_sprite_miku.png",
		"sprite_frames": "res://scenes/player/player_frames_miku.tres",
		"theme": "Vocaloid Cyberpunk",
		"desc": "Colete futurista cinza-metálico, gravata ciano neon, mangas flutuantes digitais e marias-chiquinhas turquesa vibrantes.",
		"badge": "Mítico",
		"color": Color(0.2, 0.95, 0.9),
		"bg_textures": {
			"sky": "res://assets/sprites/background/miku/sky.png",
			"far": "res://assets/sprites/background/miku/far.png",
			"mid": "res://assets/sprites/background/miku/mid.png",
			"trees": "res://assets/sprites/background/miku/trees.png"
		},
		"theme_data": {
			"sky_color": Color(1.0, 1.0, 1.0),
			"mountains_far_color": Color(1.0, 1.0, 1.0),
			"mountains_mid_color": Color(1.0, 1.0, 1.0),
			"trees_color": Color(1.0, 1.0, 1.0),
			"ground_color": Color(0.04, 0.08, 0.14, 0.98),
			"ground_border": Color(0.2, 0.95, 0.9, 1.0),
			"ambient_modulate": Color(0.9, 1.05, 1.15),
			"platform_modulate": Color(0.6, 0.95, 1.1),
			"ice_modulate": Color(0.25, 0.95, 0.9),
			"crystal_modulate": Color(0.2, 0.95, 0.85),
			"particles_color": Color(0.3, 1.0, 0.9, 0.9),
			"particles_gravity": Vector2(20, 45),
			"particles_speed": Vector2(40, 100),
			"particles_spread": 35.0,
			"stage_atmosphere_name": "Pulsos Neon e Equalizador Visual 39Hz"
		}
	},
	"sonserina": {
		"id": "sonserina",
		"name": "Bruxa Sonserina",
		"icon": "🐍",
		"universe_name": "Universo Masmorras de Esmeralda",
		"universe_subtitle": "As Catacumbas Arcanas, Poções Proibidas e Chama Verde",
		"portrait": "res://assets/sprites/ui/outfit_sonserina.png",
		"sprite": "res://assets/sprites/player/lina_sprite_sonserina.png",
		"sprite_frames": "res://scenes/player/player_frames_sonserina.tres",
		"theme": "Feitiçaria das Masmorras",
		"desc": "Capa negra com forro verde-esmeralda, suéter com listras prata e verde, cachecol de serpente e varinha mágica refinada.",
		"badge": "Lendário",
		"color": Color(0.3, 0.85, 0.45),
		"bg_textures": {
			"sky": "res://assets/sprites/background/sonserina/sky.png",
			"far": "res://assets/sprites/background/sonserina/far.png",
			"mid": "res://assets/sprites/background/sonserina/mid.png",
			"trees": "res://assets/sprites/background/sonserina/trees.png"
		},
		"theme_data": {
			"sky_color": Color(1.0, 1.0, 1.0),
			"mountains_far_color": Color(1.0, 1.0, 1.0),
			"mountains_mid_color": Color(1.0, 1.0, 1.0),
			"trees_color": Color(1.0, 1.0, 1.0),
			"ground_color": Color(0.04, 0.09, 0.06, 0.98),
			"ground_border": Color(0.4, 0.9, 0.5, 1.0),
			"ambient_modulate": Color(0.85, 1.05, 0.92),
			"platform_modulate": Color(0.65, 0.95, 0.75),
			"ice_modulate": Color(0.4, 0.88, 0.52),
			"crystal_modulate": Color(0.35, 0.9, 0.45),
			"particles_color": Color(0.4, 0.95, 0.55, 0.8),
			"particles_gravity": Vector2(20, 38),
			"particles_speed": Vector2(30, 75),
			"particles_spread": 22.0,
			"stage_atmosphere_name": "Fogo Fátuo Esmeralda e Sombras Arcanas"
		}
	},
	"tracen": {
		"id": "tracen",
		"name": "Corredora Tracen",
		"icon": "🏇",
		"universe_name": "Universo Academia Tracen",
		"universe_subtitle": "A Pista de Turf de Alta Velocidade e Espírito Competitivo",
		"portrait": "res://assets/sprites/ui/outfit_tracen.png",
		"sprite": "res://assets/sprites/player/lina_sprite_tracen.png",
		"sprite_frames": "res://scenes/player/player_frames_tracen.tres",
		"theme": "Corrida & Atletismo Turf",
		"desc": "Uniforme esportivo oficial da Academia Tracen com gola de marinheira, listras de pista e sapatilhas de arrancada explosiva.",
		"badge": "Lendário",
		"color": Color(0.3, 0.65, 1.0),
		"bg_textures": {
			"sky": "res://assets/sprites/background/tracen/sky.png",
			"far": "res://assets/sprites/background/tracen/far.png",
			"mid": "res://assets/sprites/background/tracen/mid.png",
			"trees": "res://assets/sprites/background/tracen/trees.png"
		},
		"theme_data": {
			"sky_color": Color(1.0, 1.0, 1.0),
			"mountains_far_color": Color(1.0, 1.0, 1.0),
			"mountains_mid_color": Color(1.0, 1.0, 1.0),
			"trees_color": Color(1.0, 1.0, 1.0),
			"ground_color": Color(0.06, 0.1, 0.16, 0.98),
			"ground_border": Color(0.4, 0.75, 1.0, 1.0),
			"ambient_modulate": Color(1.02, 1.02, 1.08),
			"platform_modulate": Color(0.9, 0.95, 1.05),
			"ice_modulate": Color(0.4, 0.75, 1.0),
			"crystal_modulate": Color(0.35, 0.7, 1.0),
			"particles_color": Color(0.9, 0.95, 1.0, 0.85),
			"particles_gravity": Vector2(25, 50),
			"particles_speed": Vector2(45, 110),
			"particles_spread": 20.0,
			"stage_atmosphere_name": "Vento das Retas Finais e Gramado Turf"
		}
	}
}

func get_universe_bg_textures(universe_id: String) -> Dictionary:
	if OUTFITS.has(universe_id):
		return OUTFITS[universe_id].get("bg_textures", {})
	return {}

func get_current_universe_bg_textures() -> Dictionary:
	return get_universe_bg_textures(current_outfit)

func set_outfit(outfit_id: String) -> void:
	if OUTFITS.has(outfit_id):
		current_outfit = outfit_id
		_save_current_universe(outfit_id)
		outfit_changed.emit(outfit_id)
		universe_shifted.emit(get_current_outfit_data())

func equip_outfit(outfit_id: String) -> void:
	set_outfit(outfit_id)

func shift_universe_on_startup() -> void:
	var last_id: String = _load_saved_universe()
	var next_id: String = _get_next_universe(last_id)
	set_outfit(next_id)
	print("[Linaverse] 🌌 Salto Dimensional ao abrir o jogo: %s (%s)" % [OUTFITS[next_id]["universe_name"], next_id])

func shift_to_next_universe() -> String:
	var next_id: String = _get_next_universe(current_outfit)
	set_outfit(next_id)
	return next_id

func shift_to_random_universe() -> String:
	var candidates: Array[String] = []
	for u in UNIVERSES:
		if u != current_outfit:
			candidates.append(u)
	if candidates.is_empty():
		candidates = UNIVERSES.duplicate()
	var next_id: String = candidates[randi() % candidates.size()]
	set_outfit(next_id)
	return next_id

func _get_next_universe(from_id: String) -> String:
	var idx = UNIVERSES.find(from_id)
	if idx == -1:
		return UNIVERSES[0]
	return UNIVERSES[(idx + 1) % UNIVERSES.size()]

func _load_saved_universe() -> String:
	if FileAccess.file_exists(UNIVERSE_SAVE_FILE):
		var file = FileAccess.open(UNIVERSE_SAVE_FILE, FileAccess.READ)
		if file:
			var txt = file.get_as_text().strip_edges()
			file.close()
			if OUTFITS.has(txt):
				return txt
	return "classic"

func _save_current_universe(id: String) -> void:
	var file = FileAccess.open(UNIVERSE_SAVE_FILE, FileAccess.WRITE)
	if file:
		file.store_string(id)
		file.close()

func get_current_outfit_data() -> Dictionary:
	return OUTFITS.get(current_outfit, OUTFITS["classic"])

func get_universe_theme(universe_id: String) -> Dictionary:
	var outfit = OUTFITS.get(universe_id, OUTFITS["classic"])
	return outfit.get("theme_data", {})

func get_current_universe_theme() -> Dictionary:
	return get_universe_theme(current_outfit)

func get_current_outfit_portrait() -> Texture2D:
	var path: String = OUTFITS.get(current_outfit, OUTFITS["classic"])["portrait"]
	return load(path)

func get_outfit_sprite_frames(outfit_id: String) -> SpriteFrames:
	var outfit_data: Dictionary = OUTFITS.get(outfit_id, OUTFITS["classic"])
	var path: String = outfit_data.get("sprite_frames", "res://scenes/player/player_frames_classic.tres")
	if ResourceLoader.exists(path):
		return load(path)
	return load("res://scenes/player/player_frames.tres")

func get_current_outfit_sprite_frames() -> SpriteFrames:
	return get_outfit_sprite_frames(current_outfit)

func get_outfit_sprite(outfit_id: String) -> Texture2D:
	var outfit_data: Dictionary = OUTFITS.get(outfit_id, OUTFITS["classic"])
	var path: String = outfit_data.get("sprite", "res://assets/sprites/player/lina_sprite_classic.png")
	if ResourceLoader.exists(path):
		return load(path)
	return null

func get_current_outfit_sprite() -> Texture2D:
	return get_outfit_sprite(current_outfit)

# === Sistema de Configuração de Controles (Mobile & Touch) ===
const CONTROLS_SAVE_FILE: String = "user://controls_config.json"

var touch_config: Dictionary = {
	"scale": 1.0,           # 0.85, 1.0, 1.2, 1.4
	"opacity": 0.75,        # 0.35, 0.55, 0.75, 1.0
	"run_mode": "hold",     # "hold", "toggle", "auto"
	"handedness": "right",  # "right", "left"
	"margin": 24.0,         # 12.0, 24.0, 48.0
	"custom_positions": false,
	"left_pad_offset_x": 36.0,
	"left_pad_offset_y": -140.0,
	"right_pad_offset_x": -310.0,
	"right_pad_offset_y": -170.0,
}

var run_toggled_active: bool = false

func is_auto_run_active() -> bool:
	return touch_config.get("run_mode", "hold") == "auto" or run_toggled_active

func get_touch_config() -> Dictionary:
	return touch_config.duplicate()

func save_touch_config(new_cfg: Dictionary) -> void:
	for k in new_cfg.keys():
		touch_config[k] = new_cfg[k]
	var f = FileAccess.open(CONTROLS_SAVE_FILE, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(touch_config, "  "))
		f.close()
	touch_controls_changed.emit()

func load_touch_config() -> void:
	if FileAccess.file_exists(CONTROLS_SAVE_FILE):
		var f = FileAccess.open(CONTROLS_SAVE_FILE, FileAccess.READ)
		if f:
			var txt = f.get_as_text()
			f.close()
			var json = JSON.new()
			if json.parse(txt) == OK and json.data is Dictionary:
				for k in json.data.keys():
					touch_config[k] = json.data[k]
	touch_controls_changed.emit()

func reset_touch_config() -> void:
	touch_config = {
		"scale": 1.0,
		"opacity": 0.75,
		"run_mode": "hold",
		"handedness": "right",
		"margin": 24.0,
		"custom_positions": false,
		"left_pad_offset_x": 36.0,
		"left_pad_offset_y": -140.0,
		"right_pad_offset_x": -310.0,
		"right_pad_offset_y": -170.0,
	}
	run_toggled_active = false
	save_touch_config(touch_config)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Força orientação Paisagem (Landscape) em dispositivos móveis e touch
	if OS.has_feature("mobile") or OS.has_feature("android") or OS.has_feature("ios"):
		DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	load_touch_config()
	shift_universe_on_startup()

func _process(delta: float) -> void:
	if timer_active and not is_game_over and not is_level_completed and not get_tree().paused:
		if not is_chrono_active():
			elapsed_time += delta
	_update_active_powerups(delta)

func _update_active_powerups(delta: float) -> void:
	if active_powerups.is_empty():
		return
	
	var to_remove: Array[String] = []
	for p_type in active_powerups.keys():
		var data = active_powerups[p_type]
		data["time_left"] -= delta
		if data["time_left"] <= 0.0:
			to_remove.append(p_type)
	
	for p_type in to_remove:
		active_powerups.erase(p_type)
		powerup_ended.emit(p_type)
		powers_updated.emit()

func trigger_powerup(type: String, custom_duration: float = -1.0) -> Dictionary:
	var def = POWERUP_DEFS.get(type, {
		"name": "Power-Up",
		"icon": "✦",
		"duration": 5.0,
		"color": Color.WHITE,
		"desc": ""
	})
	var duration = custom_duration if custom_duration >= 0.0 else def["duration"]
	
	if type == "heal":
		heal_player(1)
		SoundManager.play_sfx("win", 0.1)
		powerup_activated.emit("heal", 0.0, def)
		return def
	
	if type == "shield":
		shield_active = true
		shield_status_changed.emit(true)
		SoundManager.play_sfx("portal", 0.1)
		powerup_activated.emit("shield", 0.0, def)
		return def
	
	active_powerups[type] = {
		"time_left": duration,
		"duration": duration,
		"name": def["name"],
		"icon": def["icon"],
		"color": def["color"]
	}
	
	SoundManager.play_sfx("win", 0.15)
	powerup_activated.emit(type, duration, def)
	powers_updated.emit()
	return def

func is_powerup_active(type: String) -> bool:
	if type == "shield":
		return shield_active
	return active_powerups.has(type) and active_powerups[type]["time_left"] > 0.0

func get_powerup_time_left(type: String) -> float:
	if active_powerups.has(type):
		return active_powerups[type]["time_left"]
	return 0.0

func is_chrono_active() -> bool:
	return is_powerup_active("chrono")

func get_active_speed_multiplier() -> float:
	var mult = speed_mult
	if is_powerup_active("dash"):
		mult *= 1.45
	return mult

func get_effective_air_jumps() -> int:
	var jumps = max_air_jumps
	if is_powerup_active("wings"):
		jumps += 2
	return jumps

func get_effective_magnet_radius() -> float:
	var rad = magnet_radius
	if is_powerup_active("magnet"):
		rad = max(rad, 480.0)
	return rad

func reset_active_powerups() -> void:
	var keys = active_powerups.keys()
	active_powerups.clear()
	for k in keys:
		powerup_ended.emit(k)
	powers_updated.emit()

func reset_powers() -> void:
	reset_active_powerups()
	active_powers.clear()
	speed_mult = 1.0
	jump_mult = 1.0
	bonus_max_hp = 0
	max_hp = 3
	max_air_jumps = 1
	magnet_radius = 0.0
	has_aurora_shield = false
	shield_active = false
	invulnerable_mult = 1.0
	frost_fortune_active = false
	feather_fall_active = false
	powers_updated.emit()
	shield_status_changed.emit(false)

func get_owned_power_ids() -> Array[String]:
	var ids: Array[String] = []
	for p in active_powers:
		ids.append(p["id"])
	return ids

func apply_power_card(card: Dictionary) -> void:
	active_powers.append(card)
	match card["id"]:
		"speed_boost":
			speed_mult += 0.3
		"triple_jump":
			max_air_jumps = 2
		"crystal_heart":
			bonus_max_hp += 1
			max_hp = 3 + bonus_max_hp
			current_hp = max_hp
			health_changed.emit(current_hp, max_hp)
		"polar_magnet":
			magnet_radius += 240.0
		"aurora_shield":
			has_aurora_shield = true
			shield_active = true
			invulnerable_mult = 1.8
			shield_status_changed.emit(true)
		"frost_fortune":
			frost_fortune_active = true
		"high_jump":
			jump_mult += 0.25
		"feather_fall":
			feather_fall_active = true
	
	powers_updated.emit()

func consume_shield() -> bool:
	if shield_active:
		shield_active = false
		shield_status_changed.emit(false)
		SoundManager.play_sfx("portal")
		return true # Dano absorvido com sucesso!
	return false

func start_game() -> void:
	current_level = 1
	reset_powers()
	score = 0
	max_hp = 3 + bonus_max_hp
	current_hp = max_hp
	default_spawn_pos = get_level_spawn_pos(1)
	checkpoint_pos = default_spawn_pos
	elapsed_time = 0.0
	is_game_over = false
	is_level_completed = false
	timer_active = true
	get_tree().paused = false
	score_changed.emit(score, total_crystals)
	health_changed.emit(current_hp, max_hp)

func start_level(lvl: int, spawn_pos: Vector2, crystals: int) -> void:
	reset_active_powerups()
	current_level = lvl
	default_spawn_pos = spawn_pos
	checkpoint_pos = spawn_pos
	score = 0
	total_crystals = crystals
	max_hp = 3 + bonus_max_hp
	current_hp = max_hp
	elapsed_time = 0.0
	is_game_over = false
	is_level_completed = false
	timer_active = true
	get_tree().paused = false
	
	# Recarrega o Escudo de Aurora no início de cada fase
	if has_aurora_shield:
		shield_active = true
		shield_status_changed.emit(true)
		
	score_changed.emit(score, total_crystals)
	health_changed.emit(current_hp, max_hp)
	powers_updated.emit()
	level_started.emit(lvl)

func has_next_level() -> bool:
	return current_level < MAX_LEVELS

func get_next_level_path() -> String:
	if has_next_level():
		return get_level_path(current_level + 1)
	return ""

func go_to_next_level() -> void:
	if has_next_level():
		current_level += 1
		default_spawn_pos = get_level_spawn_pos(current_level)
		checkpoint_pos = default_spawn_pos
		get_tree().change_scene_to_file(get_level_path(current_level))
	else:
		current_level = 1
		default_spawn_pos = get_level_spawn_pos(1)
		checkpoint_pos = default_spawn_pos
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func add_crystal(amount: int = 1) -> void:
	var final_amount: int = amount * 2 if frost_fortune_active else amount
	score += final_amount
	SoundManager.play_sfx("crystal", 0.08)
	score_changed.emit(score, total_crystals)

func damage_player(amount: int = 1) -> void:
	if is_game_over or is_level_completed:
		return
	
	# Se o Escudo de Aurora estiver ativo, absorve o dano totalmente
	if consume_shield():
		player_damaged.emit()
		return
	
	current_hp = max(0, current_hp - amount)
	SoundManager.play_sfx("hurt")
	player_damaged.emit()
	health_changed.emit(current_hp, max_hp)
	
	if current_hp <= 0:
		trigger_game_over()

func heal_player(amount: int = 1) -> void:
	current_hp = min(max_hp, current_hp + amount)
	health_changed.emit(current_hp, max_hp)

func set_checkpoint(pos: Vector2) -> void:
	checkpoint_pos = pos
	SoundManager.play_sfx("checkpoint")
	checkpoint_updated.emit(pos)

func trigger_game_over() -> void:
	is_game_over = true
	timer_active = false
	SoundManager.play_sfx("game_over")
	player_died.emit()

func complete_level() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	timer_active = false
	SoundManager.play_sfx("win")
	level_completed.emit()

func restart_current_level() -> void:
	score = 0
	max_hp = 3 + bonus_max_hp
	current_hp = max_hp
	default_spawn_pos = get_level_spawn_pos(current_level)
	checkpoint_pos = default_spawn_pos
	elapsed_time = 0.0
	is_game_over = false
	is_level_completed = false
	timer_active = true
	get_tree().paused = false
	if has_aurora_shield:
		shield_active = true
		shield_status_changed.emit(true)
	get_tree().change_scene_to_file(get_level_path(current_level))
