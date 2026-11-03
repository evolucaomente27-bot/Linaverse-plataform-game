import os

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GM_PATH = os.path.join(BASE_DIR, "scripts", "game_manager.gd")

with open(GM_PATH, "r", encoding="utf-8") as f:
    content = f.read()

# Define the multiverse speedrun targets
universe_speedrun_code = '''# === Sistema de Speedrun & Metas de Tempo (Ranks S / A / B) por Universo ===
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
	}
}

const SPEEDRUN_TARGETS: Dictionary = UNIVERSE_SPEEDRUN_TARGETS["classic"]

func get_speedrun_target(lvl: int, universe_id: String = "") -> Dictionary:
	var u_id = universe_id if universe_id != "" else current_outfit
	var u_targets = UNIVERSE_SPEEDRUN_TARGETS.get(u_id, UNIVERSE_SPEEDRUN_TARGETS["classic"])
	return u_targets.get(lvl, {"s": 25.0, "a": 35.0, "b": 50.0, "name": "Fase %d" % lvl})

func get_stage_name(lvl: int, universe_id: String = "") -> String:
	return get_speedrun_target(lvl, universe_id).get("name", "Fase %d" % lvl)'''

# Replace old SPEEDRUN_TARGETS block up to NIX_STORY_INTRO
old_speedrun_start = '# === Sistema de Speedrun & Metas de Tempo (Ranks S / A / B) ==='
nix_intro_marker = '# === Sistema de História & Lore de Nix (O Gatinho Doente) ==='

idx1 = content.find(old_speedrun_start)
idx2 = content.find(nix_intro_marker)
assert idx1 != -1 and idx2 != -1, "Markers not found for speedrun"

content = content[:idx1] + universe_speedrun_code + "\n\n" + content[idx2:]

# Now replace STAGE_STORY_LORE
universe_story_code = '''const UNIVERSE_STORY_LORE: Dictionary = {
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
	}))'''

old_story_start = 'const STAGE_STORY_LORE: Dictionary = {'
old_story_end_func = 'func calculate_speedrun_rank(lvl: int, time_taken: float) -> String:'

idx3 = content.find(old_story_start)
idx4 = content.find(old_story_end_func)
assert idx3 != -1 and idx4 != -1, "Markers not found for story lore"

content = content[:idx3] + universe_story_code + "\n\n" + content[idx4:]

# Add get_level_path and update restart/next level
level_path_helpers = '''func get_level_path(lvl: int, universe_id: String = "") -> String:
	var u_id = universe_id if universe_id != "" else current_outfit
	var path_u = "res://scenes/levels/%s/level_%d.tscn" % [u_id, lvl]
	if ResourceLoader.exists(path_u):
		return path_u
	return "res://scenes/levels/level_%d.tscn" % lvl
'''

# Add get_level_path before restart_level
rl_idx = content.find('func restart_level() -> void:')
assert rl_idx != -1, "restart_level not found"
content = content[:rl_idx] + level_path_helpers + "\n" + content[rl_idx:]

# Update restart_level scene change
content = content.replace(
    'get_tree().change_scene_to_file("res://scenes/levels/level_%d.tscn" % current_level)',
    'get_tree().change_scene_to_file(get_level_path(current_level))'
)

# Update get_next_level_path
content = content.replace(
    'return "res://scenes/levels/level_%d.tscn" % (current_level + 1)',
    'return get_level_path(current_level + 1)'
)

# Update go_to_next_level
content = content.replace(
    'get_tree().change_scene_to_file("res://scenes/levels/level_%d.tscn" % current_level)',
    'get_tree().change_scene_to_file(get_level_path(current_level))'
)

# Update restart_current_level
content = content.replace(
    'get_tree().reload_current_scene()',
    'get_tree().change_scene_to_file(get_level_path(current_level))'
)

with open(GM_PATH, "w", encoding="utf-8") as f:
    f.write(content)

print("[OK] scripts/game_manager.gd successfully updated with multiverse levels, targets, lore and scene path resolution!")
