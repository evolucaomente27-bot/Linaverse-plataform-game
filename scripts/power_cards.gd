class_name PowerCards
extends RefCounted

# Catálogo oficial de Cartas de Poder do Linaverse

const ALL_CARDS: Array[Dictionary] = [
	{
		"id": "speed_boost",
		"name": "Passos do Vento",
		"icon": "👟",
		"rarity": "Comum",
		"rarity_color": Color(0.35, 0.75, 1.0),
		"type": "Mobilidade",
		"desc": "+30% velocidade de corrida e arrancada veloz com passos leves.",
		"badge": "+30% Velocidade",
		"unique": false
	},
	{
		"id": "triple_jump",
		"name": "Pulo Triplo Astral",
		"icon": "🪶",
		"rarity": "Épica",
		"rarity_color": Color(1.0, 0.82, 0.25),
		"type": "Acrobacia",
		"desc": "Concede um 3º salto no ar cercado por estrelas celestiais.",
		"badge": "+1 Pulo no Ar",
		"unique": true
	},
	{
		"id": "crystal_heart",
		"name": "Coração de Gelo",
		"icon": "💖",
		"rarity": "Rara",
		"rarity_color": Color(0.85, 0.45, 1.0),
		"type": "Sobrevivência",
		"desc": "+1 Coração permanente de vida máxima e restaura toda a vida.",
		"badge": "+1 Vida Máxima",
		"unique": false
	},
	{
		"id": "polar_magnet",
		"name": "Magnetismo Polar",
		"icon": "🧲",
		"rarity": "Rara",
		"rarity_color": Color(0.85, 0.45, 1.0),
		"type": "Coleta",
		"desc": "Atrai automaticamente cristais próximos em um raio de 240px.",
		"badge": "Ímã de Cristais",
		"unique": false
	},
	{
		"id": "aurora_shield",
		"name": "Escudo de Aurora",
		"icon": "🛡️",
		"rarity": "Épica",
		"rarity_color": Color(1.0, 0.82, 0.25),
		"type": "Proteção",
		"desc": "Absorve 1 dano gratuitamente por fase e dobra tempo invulnerável.",
		"badge": "1 Bloqueio / Fase",
		"unique": true
	},
	{
		"id": "frost_fortune",
		"name": "Sorte Glacial",
		"icon": "💎",
		"rarity": "Comum",
		"rarity_color": Color(0.35, 0.75, 1.0),
		"type": "Fortuna",
		"desc": "Cada cristal coletado rende pontuação dobrada no score final.",
		"badge": "Score em Dobro",
		"unique": true
	},
	{
		"id": "high_jump",
		"name": "Salto Lunar",
		"icon": "🦘",
		"rarity": "Comum",
		"rarity_color": Color(0.35, 0.75, 1.0),
		"type": "Mobilidade",
		"desc": "+25% altura em todos os saltos para alcançar topos distantes.",
		"badge": "+25% Altura Pulo",
		"unique": false
	},
	{
		"id": "feather_fall",
		"name": "Pena de Neve",
		"icon": "❄️",
		"rarity": "Rara",
		"rarity_color": Color(0.85, 0.45, 1.0),
		"type": "Controle",
		"desc": "Segure Pulo no ar para flutuar e planar suavemente na descida.",
		"badge": "Planeio Flutuante",
		"unique": true
	}
]

static func get_random_selection(owned_ids: Array[String], count: int = 3) -> Array[Dictionary]:
	var available: Array[Dictionary] = []
	for card in ALL_CARDS:
		# Se for carta única e o jogador já possui, não oferece novamente
		if card.get("unique", false) and card["id"] in owned_ids:
			continue
		available.append(card.duplicate(true))
	
	# Se sobrarem poucas opções, permite cartas não únicas repetidas
	if available.size() < count:
		for card in ALL_CARDS:
			if not card.get("unique", false):
				available.append(card.duplicate(true))
	
	available.shuffle()
	return available.slice(0, min(count, available.size()))
