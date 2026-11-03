GAME_MANAGER_PATH = "scripts/game_manager.gd"

with open(GAME_MANAGER_PATH, "r", encoding="utf-8") as f:
    code = f.read()

# 1. Update UNIVERSE_SPEEDRUN_TARGETS
speedrun_addition = """\t"agnes": {
\t\t1: {"s": 17.0, "a": 25.0, "b": 35.0, "name": "Bancada de Centrifugação"},
\t\t2: {"s": 20.0, "a": 29.0, "b": 41.0, "name": "Acelerador de Táquions"},
\t\t3: {"s": 22.0, "a": 32.0, "b": 45.0, "name": "Destilaria de Éter Quântico"},
\t\t4: {"s": 25.0, "a": 36.0, "b": 50.0, "name": "Corredores do Reator de Fusão"},
\t\t5: {"s": 28.0, "a": 40.0, "b": 56.0, "name": "Câmara de Isolamento Barométrico"},
\t\t6: {"s": 19.0, "a": 27.0, "b": 39.0, "name": "Arquivo de Fórmulas Secretas"},
\t\t7: {"s": 23.0, "a": 33.0, "b": 47.0, "name": "Tubulações de Plasma Luminescente"},
\t\t8: {"s": 25.0, "a": 36.0, "b": 51.0, "name": "Condensador de Matéria Escura"},
\t\t9: {"s": 22.0, "a": 31.0, "b": 44.0, "name": "Plataforma de Eletroforese"},
\t\t10: {"s": 27.0, "a": 39.0, "b": 54.0, "name": "Núcleo de Ressonância Temporal"},
\t\t11: {"s": 31.0, "a": 44.0, "b": 61.0, "name": "Abismo do Vácuo Quântico"},
\t\t12: {"s": 36.0, "a": 52.0, "b": 72.0, "name": "Pináculo da Síntese Tachyon"}
\t},
\t"frieren": {
\t\t1: {"s": 18.0, "a": 26.0, "b": 37.0, "name": "Trilha da Floresta de Himmel"},
\t\t2: {"s": 21.0, "a": 30.0, "b": 43.0, "name": "Colina dos Grimórios Esquecidos"},
\t\t3: {"s": 24.0, "a": 34.0, "b": 48.0, "name": "Ponte de Pedra do Reino do Norte"},
\t\t4: {"s": 27.0, "a": 39.0, "b": 54.0, "name": "Masmorra do Amanhecer"},
\t\t5: {"s": 29.0, "a": 42.0, "b": 58.0, "name": "Desfiladeiro dos Golens Antigos"},
\t\t6: {"s": 20.0, "a": 29.0, "b": 41.0, "name": "Torre da Barreira de Zoltraak"},
\t\t7: {"s": 24.0, "a": 35.0, "b": 49.0, "name": "Planalto das Flores Lunares"},
\t\t8: {"s": 27.0, "a": 39.0, "b": 53.0, "name": "Ruínas dos Magos da 1ª Classe"},
\t\t9: {"s": 23.0, "a": 33.0, "b": 46.0, "name": "Santuário da Deusa da Criação"},
\t\t10: {"s": 28.0, "a": 40.0, "b": 56.0, "name": "Vale dos Séculos de Neve"},
\t\t11: {"s": 32.0, "a": 46.0, "b": 63.0, "name": "Corredores da Prova de Mana"},
\t\t12: {"s": 38.0, "a": 54.0, "b": 75.0, "name": "Aureole: Limiar das Almas"}
\t},
\t"maid": {
\t\t1: {"s": 17.0, "a": 25.0, "b": 36.0, "name": "Hall dos Lustres de Cristal"},
\t\t2: {"s": 21.0, "a": 30.0, "b": 42.0, "name": "Corredores da Tapeçaria Real"},
\t\t3: {"s": 23.0, "a": 33.0, "b": 47.0, "name": "Grande Sala de Chá da Tarde"},
\t\t4: {"s": 26.0, "a": 38.0, "b": 52.0, "name": "Adegas dos Vinhos Aromáticos"},
\t\t5: {"s": 29.0, "a": 42.0, "b": 58.0, "name": "Biblioteca dos Cerimoniais"},
\t\t6: {"s": 19.0, "a": 28.0, "b": 40.0, "name": "Escadaria Monumental de Carvalho"},
\t\t7: {"s": 23.0, "a": 33.0, "b": 46.0, "name": "Terraço dos Arbustos Podados"},
\t\t8: {"s": 26.0, "a": 37.0, "b": 51.0, "name": "Salão do Relógio Vitoriano"},
\t\t9: {"s": 22.0, "a": 32.0, "b": 45.0, "name": "Cozinha das Louças de Porcelana"},
\t\t10: {"s": 28.0, "a": 40.0, "b": 55.0, "name": "Aposentos da Marquesa da Neve"},
\t\t11: {"s": 31.0, "a": 44.0, "b": 61.0, "name": "Sótão dos Segredos da Mansão"},
\t\t12: {"s": 37.0, "a": 53.0, "b": 73.0, "name": "Mirante das Rosas de Inverno"}
\t},
\t"maomao": {
\t\t1: {"s": 18.0, "a": 26.0, "b": 37.0, "name": "Jardim Medicinal do Palácio"},
\t\t2: {"s": 21.0, "a": 30.0, "b": 43.0, "name": "Pavilhão das Ervas Secas"},
\t\t3: {"s": 23.0, "a": 33.0, "b": 47.0, "name": "Ponte de Lótus Imperial"},
\t\t4: {"s": 27.0, "a": 39.0, "b": 54.0, "name": "Corredores da Corte Posterior"},
\t\t5: {"s": 29.0, "a": 42.0, "b": 58.0, "name": "Canto dos Bambus da Serenidade"},
\t\t6: {"s": 20.0, "a": 29.0, "b": 41.0, "name": "Armazém das Raízes Venenosas"},
\t\t7: {"s": 24.0, "a": 35.0, "b": 49.0, "name": "Pagode dos Boticários Dinásticos"},
\t\t8: {"s": 26.0, "a": 38.0, "b": 52.0, "name": "Riacho Sereno das Carpas Douradas"},
\t\t9: {"s": 23.0, "a": 33.0, "b": 46.0, "name": "Santuário do Crisântemo Verde"},
\t\t10: {"s": 28.0, "a": 40.0, "b": 56.0, "name": "Muralha do Dragão das Estações"},
\t\t11: {"s": 32.0, "a": 45.0, "b": 62.0, "name": "Laboratório de Antídotos Reais"},
\t\t12: {"s": 37.0, "a": 53.0, "b": 74.0, "name": "Pavilhão Dourado das Ervas"}
\t},
\t"miku": {
\t\t1: {"s": 16.0, "a": 24.0, "b": 34.0, "name": "Palco Holográfico 39-Live"},
\t\t2: {"s": 20.0, "a": 28.0, "b": 40.0, "name": "Autopista da Fibra Óptica"},
\t\t3: {"s": 22.0, "a": 31.0, "b": 44.0, "name": "Passarela dos Equalizadores"},
\t\t4: {"s": 25.0, "a": 36.0, "b": 51.0, "name": "Torre dos Alto-Falantes Neon"},
\t\t5: {"s": 28.0, "a": 40.0, "b": 56.0, "name": "Plataforma dos Sintetizadores"},
\t\t6: {"s": 18.0, "a": 27.0, "b": 38.0, "name": "Distrito Cyber-Shibuya 39"},
\t\t7: {"s": 22.0, "a": 32.0, "b": 45.0, "name": "Mesa de Mixagem Estelar"},
\t\t8: {"s": 25.0, "a": 36.0, "b": 50.0, "name": "Túnel do Vocoder Polifônico"},
\t\t9: {"s": 21.0, "a": 30.0, "b": 43.0, "name": "Santuário dos Arquivos MIDI"},
\t\t10: {"s": 26.0, "a": 38.0, "b": 53.0, "name": "Metrô Eletroacústico Neon"},
\t\t11: {"s": 30.0, "a": 43.0, "b": 59.0, "name": "Domo Acústico dos Lasers"},
\t\t12: {"s": 35.0, "a": 50.0, "b": 70.0, "name": "Grande Concerto Vocaloid Lina"}
\t},
\t"sonserina": {
\t\t1: {"s": 18.0, "a": 26.0, "b": 37.0, "name": "Entrada das Criptas Abobadadas"},
\t\t2: {"s": 21.0, "a": 30.0, "b": 43.0, "name": "Comunal Sob o Lago Negro"},
\t\t3: {"s": 24.0, "a": 34.0, "b": 48.0, "name": "Tapeçarias da Serpente Prateada"},
\t\t4: {"s": 27.0, "a": 39.0, "b": 54.0, "name": "Laboratório de Caldeirões Fumegantes"},
\t\t5: {"s": 29.0, "a": 42.0, "b": 58.0, "name": "Cripta das Chamas Esmeraldas"},
\t\t6: {"s": 20.0, "a": 29.0, "b": 41.0, "name": "Ponte Sobre o Fosso dos Basiliscos"},
\t\t7: {"s": 24.0, "a": 35.0, "b": 49.0, "name": "Armário dos Frascos de Veneno"},
\t\t8: {"s": 27.0, "a": 39.0, "b": 53.0, "name": "Galeria dos Retratos Falantes"},
\t\t9: {"s": 23.0, "a": 33.0, "b": 46.0, "name": "Arquivo dos Tomos Proibidos"},
\t\t10: {"s": 28.0, "a": 40.0, "b": 56.0, "name": "Pilares da Serpente de Prata"},
\t\t11: {"s": 32.0, "a": 46.0, "b": 63.0, "name": "Abismo do Fogo Fátuo Noturno"},
\t\t12: {"s": 38.0, "a": 54.0, "b": 75.0, "name": "Câmara Secreta do Lorde Alquimista"}
\t},
\t"tracen": {
\t\t1: {"s": 16.0, "a": 23.0, "b": 33.0, "name": "Portão de Largada de Turf"},
\t\t2: {"s": 19.0, "a": 28.0, "b": 39.0, "name": "Primeira Curva das Encostas"},
\t\t3: {"s": 21.0, "a": 30.0, "b": 43.0, "name": "Reta Oposta de Arrancada Máxima"},
\t\t4: {"s": 25.0, "a": 36.0, "b": 50.0, "name": "Obstáculo dos Saltos de Trilho"},
\t\t5: {"s": 27.0, "a": 39.0, "b": 55.0, "name": "Pista de Terra Batida da Neve"},
\t\t6: {"s": 18.0, "a": 26.0, "b": 37.0, "name": "Túnel dos Vestiários do Turf"},
\t\t7: {"s": 22.0, "a": 31.0, "b": 44.0, "name": "Colina Íngreme dos Campeões"},
\t\t8: {"s": 24.0, "a": 35.0, "b": 49.0, "name": "Última Curva da Glória"},
\t\t9: {"s": 21.0, "a": 30.0, "b": 42.0, "name": "Passarela dos Cronômetros"},
\t\t10: {"s": 25.0, "a": 37.0, "b": 51.0, "name": "Reta Final Sob Aplausos"},
\t\t11: {"s": 29.0, "a": 42.0, "b": 58.0, "name": "Faixa de Chegada do Troféu de Ouro"},
\t\t12: {"s": 34.0, "a": 49.0, "b": 69.0, "name": "Pódio Twinkle Series Linaverse"}
\t}"""

target_marker_speedrun = '\t\t12: {"s": 37.0, "a": 52.0, "b": 72.0, "name": "Mirante das Lembranças de Lina"}\n\t}\n}'
replacement_speedrun = '\t\t12: {"s": 37.0, "a": 52.0, "b": 72.0, "name": "Mirante das Lembranças de Lina"}\n\t},\n' + speedrun_addition + '\n}'

if target_marker_speedrun not in code:
    raise Exception("Target marker for speedrun not found")
code = code.replace(target_marker_speedrun, replacement_speedrun, 1)

# 2. Update UNIVERSE_STORY_LORE
lore_addition = """\t"agnes": {
\t\t1: {"stage": 1, "ingredient": "Catalisador de Táquions Líquido", "icon": "🧪", "nix_status": "Nix treme com febre na cestinha, respirando devagar...", "quote": "Aguente firme, Nix! Estou acelerando ao máximo no laboratório!", "reward_text": "Catalisador Quântico obtido! Permite estabilizar as reações celulares febris."},
\t\t2: {"stage": 2, "ingredient": "Reagente de Frequência Cardíaca", "icon": "⚡", "nix_status": "O monitor cardíaco do Nix mostra batimentos mais ritmados.", "quote": "Segundo reagente garantido! A fórmula está tomando forma!", "reward_text": "Reagente Cardíaco sintetizado! Restaura a pressão e ritmo do gatinho."},
\t\t3: {"stage": 3, "ingredient": "Soro de Estabilização Quântica", "icon": "🧬", "nix_status": "Nix abre os olhinhos de leve ao sentir o calor da mistura.", "quote": "Destilei o éter a tempo! Nix, já estou chegando!", "reward_text": "Soro Quântico infusionado! Impede que a febre afete os órgãos vitais."},
\t\t4: {"stage": 4, "ingredient": "Infuso de Fosfato Luminescente", "icon": "💡", "nix_status": "O corpinho de Nix começa a absorver a energia revigorante.", "quote": "Passei pelo reator de fusão voando! Nada vai nos deter!", "reward_text": "Fosfato Luminescente purificado! Clareia a consciência do felino."},
\t\t5: {"stage": 5, "ingredient": "Bálsamo de Hipertermia Controlada", "icon": "🌡️", "nix_status": "A febre de Nix finalmente cai 1 grau e meio!", "quote": "A temperatura está cedendo! Falta pouco mais da metade!", "reward_text": "Bálsamo de Hipertermia aplicado com sucesso na testa do Nix!"},
\t\t6: {"stage": 6, "ingredient": "Fórmula Antipirética Concentrada", "icon": "💊", "nix_status": "Nix emite um miado fraquinho porém dócil de agradecimento.", "quote": "Encontrei a fórmula nos arquivos secretos! Funcionou!", "reward_text": "Antipirético Quântico ativo! As toxinas começam a ser expelidas."},
\t\t7: {"stage": 7, "ingredient": "Solução de Eletrólitos Cromáticos", "icon": "🌈", "nix_status": "Nix bebe algumas gotinhas da solução e se aconchega melhor.", "quote": "Ele bebeu os eletrólitos! A hidratação está perfeita agora!", "reward_text": "Eletrólitos Cromáticos absorvidos! Força muscular voltando aos poucos."},
\t\t8: {"stage": 8, "ingredient": "Composto Anti-Toxina Molecular", "icon": "🛡️", "nix_status": "A respiração de Nix agora é calma, contínua e serena.", "quote": "Neutralizei a toxina molecular! Estamos vencendo a doença!", "reward_text": "Anti-Toxina aplicada! Todas as bactérias invasoras foram eliminadas."},
\t\t9: {"stage": 9, "ingredient": "Ampola de Bio-Cinética Pura", "icon": "⚡", "nix_status": "Nix mexe o rabinho alegremente na almofadinha de veludo.", "quote": "Consegui a ampola de energia! Nix já está abanando o rabo!", "reward_text": "Bio-Cinética integrada! O metabolismo do gatinho voltou à velocidade ideal."},
\t\t10: {"stage": 10, "ingredient": "Polímero de Regeneração Celular", "icon": "🔬", "nix_status": "Nix se apoia nas patinhas dianteiras e olha para o portal!", "quote": "As células estão 100% regeneradas! Só mais duas fases!", "reward_text": "Regeneração Celular concluída! O organismo de Nix está revitalizado."},
\t\t11: {"stage": 11, "ingredient": "Plasma de Vitalidade Quântica", "icon": "✨", "nix_status": "Nix se espreguiça e solta um miado limpo e saudável!", "quote": "QUASE LÁ! O plasma da vitória já está em minhas mãos!", "reward_text": "Plasma Quântico injetado no frasco! Falta apenas o selo final!"},
\t\t12: {"stage": 12, "ingredient": "Elixir Supremo Tachyon de Cura", "icon": "🏆", "nix_status": "CURA COMPLETA! Nix está pulando, ronronando e correndo pelo laboratório!", "quote": "VITÓRIA DA CIÊNCIA E DO AMOR! NIX ESTÁ TOTALMENTE CURADO! 🧪🐾", "reward_text": "O REMÉDIO TACHYON CUROU NIX! O gatinho saltou no colo da Lina com ronronados supercarregados, pronto para novas descobertas científicas juntos!"}
\t},
\t"frieren": {
\t\t1: {"stage": 1, "ingredient": "Flor Azul de Himmel da Lembrança", "icon": "🪻", "nix_status": "Nix dorme na cestinha élfica, envolto pelo perfume da flor azul.", "quote": "Uma flor que floresce uma vez por milênio... pela vida de Nix!", "reward_text": "Flor de Himmel colhida! Sua fragrância tranquiliza o espírito febril."},
\t\t2: {"stage": 2, "ingredient": "Folha da Árvore Milenar Sagrada", "icon": "🍃", "nix_status": "O orvalho da folha alivia o focinho ressecado do gatinho.", "quote": "A magia antiga da natureza protegerá meu pequeno companheiro!", "reward_text": "Folha Milenar consagrada! A febre mágica começa a perder força."},
\t\t3: {"stage": 3, "ingredient": "Gota de Orvalho da Barreira Mágica", "icon": "💧", "nix_status": "Nix bebe a gota e seu pelo branco ganha um brilho perolado.", "quote": "Esta água pura purifica qualquer maldição antiga!", "reward_text": "Orvalho da Barreira absorvido! As impurezas são lavadas do sangue."},
\t\t4: {"stage": 4, "ingredient": "Semente de Erva Curativa Élfica", "icon": "🌱", "nix_status": "Nix descansa o queixinho na pata com olhar calmo e sereno.", "quote": "Uma semente que germina saúde instantânea! Cruzando o desfiladeiro!", "reward_text": "Semente Élfica moída e preparada no caldeirão de viagem!"},
\t\t5: {"stage": 5, "ingredient": "Pó de Asas da Fada da Neve", "icon": "🧚", "nix_status": "O pó brilhante envolve a cestinha como uma redoma protetora.", "quote": "As fadas me concederam sua bênção! Correndo pelos céus!", "reward_text": "Bênção das Fadas ativa! Protege Nix contra qualquer recaída de frio."},
\t\t6: {"stage": 6, "ingredient": "Cristal de Mana Tranquila de Zoltraak", "icon": "💎", "nix_status": "Nix já tenta esticar as patas e ensaia um ronrom baixinho.", "quote": "Mana purificada da destruição em força de cura e paz!", "reward_text": "Cristal de Mana equilibrado! O fluxo vital de Nix estabiliza."},
\t\t7: {"stage": 7, "ingredient": "Raiz de Ginseng de Trezentos Anos", "icon": "🪵", "nix_status": "O calor suave da raiz penetra as almofadinhas das patas.", "quote": "Mais um remédio milenar resgatado das montanhas do norte!", "reward_text": "Ginseng Ancestral infusionado! A imunidade de Nix quadruplica."},
\t\t8: {"stage": 8, "ingredient": "Essência de Mel da Abelha Astral", "icon": "🍯", "nix_status": "Nix lambe os bigodes com o docinho do néctar celestial.", "quote": "Glicose mágica pura! A energia está voltando rápido!", "reward_text": "Mel Astral digerido! O gatinho ganha novo apetite e ânimo."},
\t\t9: {"stage": 9, "ingredient": "Água Pura da Fonte da Deusa", "icon": "🌊", "nix_status": "A respiração de Nix agora é tão leve quanto a brisa da floresta.", "quote": "A água sagrada da Deusa lavou a última chama da febre!", "reward_text": "Fonte da Deusa reverenciada! Todos os órgãos estão sadios."},
\t\t10: {"stage": 10, "ingredient": "Fragmento do Sino dos Tempos Antigos", "icon": "🔔", "nix_status": "O som cristalino do sino acalma o sono reparador de Nix.", "quote": "O sino tocou a sinfonia da recuperação! Só faltam dois passos!", "reward_text": "Sino dos Tempos despertou o vigor adormecido do felino!"},
\t\t11: {"stage": 11, "ingredient": "Feitiço de Respiração Tranquila", "icon": "🪄", "nix_status": "Nix abre bem os olhos, reconhece Lina e mia com afeto!", "quote": "Ele me reconheceu! Falta apenas o último feitiço de Aureole!", "reward_text": "Encantamento de Respiração concluído! O pulmãozinho está 100% puro."},
\t\t12: {"stage": 12, "ingredient": "Magia Suprema do Despertar Saudável", "icon": "🌟", "nix_status": "CURA COMPLETA! Nix está são e salvo, pulando nos braços de Lina!", "quote": "A MAGIA DO AMOR TRIUNFOU SOBRE O TEMPO! NIX ESTÁ VIVO E FELIZ! 🪄🐾", "reward_text": "O REMÉDIO MILENAR ÉLFICO CUROU NIX! Frieren-Lina sorri com ternura ao ver Nix pular em seu báculo e enrolar o rabinho carinhoso em seu pescoço!"}
\t},
\t"maid": {
\t\t1: {"stage": 1, "ingredient": "Chá de Camomila e Camélia Suave", "icon": "🫖", "nix_status": "Nix descansa na almofada de veludo, inalando o vapor aromático do chá.", "quote": "Servirei ao senhor Nix o chá medicinal mais refinado da mansão!", "reward_text": "Chá de Camomila servido com etiqueta real! O gatinho relaxa."},
\t\t2: {"stage": 2, "ingredient": "Biscoito de Ervas Quentes Medicinais", "icon": "🍪", "nix_status": "Nix fareja o biscoito quentinho com carinho e lambe as pontas.", "quote": "Receita secreta do chef da mansão para acalmar estômagos felinos!", "reward_text": "Biscoito Medicinal alimentado! A fraqueza física é combatida."},
\t\t3: {"stage": 3, "ingredient": "Manta de Lã Térmica Aveludada", "icon": "🧣", "nix_status": "Nix fica enroladinho como um bolinho de lã quentinho.", "quote": "Aconchego e calor constantes são o segredo da recuperação!", "reward_text": "Manta de Lã estendida! A hipotermia pós-febre é impedida."},
\t\t4: {"stage": 4, "ingredient": "Xarope de Groselha e Mel Nobre", "icon": "🍯", "nix_status": "Nix toma a colherzinha de xarope e estala a língua com gosto.", "quote": "Um remédio doce que desce suave pela garganta do Nix!", "reward_text": "Xarope de Groselha administrado! A tosse mágica silenciou."},
\t\t5: {"stage": 5, "ingredient": "Infuso de Flor de Laranjeira", "icon": "🍊", "nix_status": "O coraçãozinho de Nix bate calmo ao aroma da laranjeira.", "quote": "Subindo as escadarias com a bandeja impecável e veloz!", "reward_text": "Infuso aromático borrifado no ambiente! Paz absoluta no quarto."},
\t\t6: {"stage": 6, "ingredient": "Extrato de Menta da Horta Privada", "icon": "🌿", "nix_status": "Nix respira fundo sem qualquer chiado no peito!", "quote": "Menta fresca colhida à mão na horta da mansão!", "reward_text": "Menta refrescante aplicada! As vias respiratórias estão limpas."},
\t\t7: {"stage": 7, "ingredient": "Vaporizador de Eucalipto Real", "icon": "💨", "nix_status": "Nix dorme um sono tranquilo como um bebê bem cuidado.", "quote": "O vapor perfumado limpa o ar de todo o aposento!", "reward_text": "Vaporizador Real aceso! O ambiente atinge a umidade ideal."},
\t\t8: {"stage": 8, "ingredient": "Geleia de Sabugueiro Revitalizante", "icon": "🍇", "nix_status": "Nix acorda, lambe a patinha e começa a limpar o focinho!", "quote": "Ele está se lambendo! O instinto saudável do gato voltou!", "reward_text": "Sabugueiro absorvido! A vitalidade foi restabelecida em 80%."},
\t\t9: {"stage": 9, "ingredient": "Almofada de Plumas de Seda", "icon": "🛋️", "nix_status": "Nix afunda as patinhas na pluma com ronronadas suaves.", "quote": "O melhor leito da mansão para o rei da casa, Nix!", "reward_text": "Almofada de Seda entregue! O sono reparador acelera a cura."},
\t\t10: {"stage": 10, "ingredient": "Pó de Baunilha Refinada Curativa", "icon": "🍨", "nix_status": "Nix levanta as duas orelhinhas ao ouvir os passos da Lina-Maid!", "quote": "A baunilha fecha o ciclo dos remédios vitamínicos!", "reward_text": "Baunilha Curativa misturada ao leite desnatado especial!"},
\t\t11: {"stage": 11, "ingredient": "Bolsa Térmica de Água Quente", "icon": "♨️", "nix_status": "Nix ronrona alto e empurra a cabeça na mão da Lina!", "quote": "Só mais um serviço impecável e Nix estará 100% curado!", "reward_text": "Bolsa Térmica aconchegada junto ao corpinho de Nix!"},
\t\t12: {"stage": 12, "ingredient": "Banquete Fino Restaurador de Nix", "icon": "🧁", "nix_status": "CURA COMPLETA! Nix comeu todo o prato, se espreguiçou e pulou no colo!", "quote": "MISSÃO CUMPRIDA COM PERFEIÇÃO! O SENHOR NIX ESTÁ RADIANTE! ☕🐾", "reward_text": "O BANQUETE DE CURA DA MANSÃO FOI UM SUCESSO! Nix tomou todo o caldo nutritivo, deu três cambalhotas na almofada e ronrona no avental de Lina!"}
\t},
\t"maomao": {
\t\t1: {"stage": 1, "ingredient": "Raiz de Alcaçuz Selvagem Imperial", "icon": "🎋", "nix_status": "Nix repousa no cesto de palha imperial, com febre alta e olhos fechados.", "quote": "Esta febre é uma intoxicação mágica! Como boticária, sei o antídoto!", "reward_text": "Alcaçuz moído no almofariz! Princípio ativo neutralizador obtido."},
\t\t2: {"stage": 2, "ingredient": "Flor Seca de Crisântemo das Neves", "icon": "🌼", "nix_status": "O cheiro do chá de crisântemo reduz o calor nas orelhas de Nix.", "quote": "O crisântemo dissipa o calor interno do fígado e pulmão!", "reward_text": "Crisântemo infusionado! A febre diminui gradativamente."},
\t\t3: {"stage": 3, "ingredient": "Fruto Seco de Goji Antioxidante", "icon": "🍒", "nix_status": "Nix aceita a gota do suco de goji e pisca para Lina com afeto.", "quote": "Goji nutre o sangue e fortalece a visão e sentidos do gatinho!", "reward_text": "Goji Imperial concentrado! Suporte vitamínico completo."},
\t\t4: {"stage": 4, "ingredient": "Semente de Lótus Aliviadora de Febre", "icon": "🪷", "nix_status": "A agitação de Nix diminui e ele dorme com respiração fluida.", "quote": "Lótus acalma o coração e remove o fogo das vísceras!", "reward_text": "Semente de Lótus fervida em fogo brando no caldeirão!"},
\t\t5: {"stage": 5, "ingredient": "Erva Gafanhoto Neutralizadora", "icon": "🦗", "nix_status": "O veneno mágico no sangue de Nix começa a se decompor.", "quote": "Conhecer venenos é a melhor forma de criar os antídotos perfeitos!", "reward_text": "Erva Gafanhoto dosada com extrema precisão boticária!"},
\t\t6: {"stage": 6, "ingredient": "Extrato de Reishi da Longevidade", "icon": "🍄", "nix_status": "Nix abre os dois olhos e lambe a mãozinha da Maomao-Lina.", "quote": "Cogumelo sagrado dos imperadores para o melhor gatinho do mundo!", "reward_text": "Reishi Milenar destilado! O sistema imunológico ganha força invencível."},
\t\t7: {"stage": 7, "ingredient": "Gota de Orvalho do Bambu Noturno", "icon": "🎍", "nix_status": "O focinho de Nix volta a ficar úmido e saudável como deve ser.", "quote": "Colhi o orvalho antes do amanhecer na floresta proibida!", "reward_text": "Orvalho Puro equilibrado! A hidratação de Nix está normalizada."},
\t\t8: {"stage": 8, "ingredient": "Pó de Pérola Moída Purificante", "icon": "🦪", "nix_status": "Nix mexe as patinhas sonhando com passeios pelos jardins.", "quote": "Pérola moída acalma a mente e repara tecidos internos!", "reward_text": "Pó de Pérola dissolvido na poção boticária!"},
\t\t9: {"stage": 9, "ingredient": "Casca de Canela Revigorante", "icon": "🪵", "nix_status": "O sangue circula quente e vigoroso pelas veias do gatinho.", "quote": "A canela aquece o meridiano e afasta o frio remanescente!", "reward_text": "Canela fina dosada com maestria no remédio!"},
\t\t10: {"stage": 10, "ingredient": "Geleia Real das Colmeias Imperiais", "icon": "🐝", "nix_status": "Nix se espreguiça no cesto e fica de pé sobre as quatro patinhas!", "quote": "Ele já consegue ficar de pé! A receita imperial é infalível!", "reward_text": "Geleia Real deglutida! A energia muscular foi 95% restaurada."},
\t\t11: {"stage": 11, "ingredient": "Bálsamo Verde de Jade Cicatrizante", "icon": "🍵", "nix_status": "Nix solta um ronrom vigoroso e dá um pulinho na beirada do cesto!", "quote": "Só falta a última decocção de ouro do palácio!", "reward_text": "Bálsamo de Jade aplicado com massagem relaxante nas patinhas."},
\t\t12: {"stage": 12, "ingredient": "Decocção das Cem Ervas de Nix", "icon": "🏺", "nix_status": "CURA COMPLETA! Nix bebeu todo o antídoto e ronrona esfregando a cabeça!", "quote": "DIAGNÓSTICO FINAL: CURADO COM 100% DE SUCESSO BOTICÁRIO! 🌿🐾", "reward_text": "O ANTÍDOTO DAS CEM ERVAS SALVOU NIX! Maomao-Lina sorri satisfeita com a própria fórmula enquanto Nix brinca com as fitas de seu hanfu imperial!"}
\t},
\t"miku": {
\t\t1: {"stage": 1, "ingredient": "Microfone de Frequência Sonora Calmante", "icon": "🎤", "nix_status": "Nix ouve a canção de ninar ciano e fecha os olhinhos descansando.", "quote": "Vou cantar a frequência perfeita de cura para você, Nix!", "reward_text": "Microfone de Frequência sintonizado em 432Hz! Ondas calmantes ativas."},
\t\t2: {"stage": 2, "ingredient": "Batida Rítmica Estabilizadora de Pulso", "icon": "🥁", "nix_status": "O pulso de Nix se sincroniza com a batida suave de 60 BPM.", "quote": "A música harmoniza o fluxo cardíaco! O ritmo está estável!", "reward_text": "Batida Rítmica injetada no transmissor sonoro! Pulso estabilizado."},
\t\t3: {"stage": 3, "ingredient": "Fita Magnética de Ondas Delta do Sono", "icon": "📼", "nix_status": "Nix entra no sono regenerativo mais profundo e curativo.", "quote": "O sono delta é o momento onde o corpo se cura por completo!", "reward_text": "Fita de Ondas Delta rodando no gravador analógico com sucesso."},
\t\t4: {"stage": 4, "ingredient": "Acorde Ciano Curativo em Lá Maior", "icon": "🎹", "nix_status": "A pele e pelagem de Nix vibram com harmonia luminosa.", "quote": "Cada nota dissipa uma partícula da febre mágica!", "reward_text": "Acorde Ciano ecoa pelos circuitos! Febre neutralizada em 40%."},
\t\t5: {"stage": 5, "ingredient": "Vitamina de Eletro-Glicose Neon", "icon": "⚡", "nix_status": "Nix lambe o bastonete nutritivo de glicose e ganha vigor.", "quote": "Energia pura sintetizada diretamente da batida eletrônica!", "reward_text": "Eletro-Glicose neon absorvida pelas células do felino!"},
\t\t6: {"stage": 6, "ingredient": "Sintetizador de Ronrom Harmônico", "icon": "🎧", "nix_status": "O ronrom de Nix começa a acompanhar a melodia de Miku!", "quote": "Ele está cantando comigo! Que coisa mais fofa do multiverso!", "reward_text": "Sintetizador de Ronrom sintonizou o dueto perfeito de cura!"},
\t\t7: {"stage": 7, "ingredient": "Filtro Passa-Baixas Anti-Stress", "icon": "🎛️", "nix_status": "Todos os ruídos externos que incomodavam Nix são silenciados.", "quote": "Apenas frequências de pura tranquilidade chegam até o Nix!", "reward_text": "Filtro Ativo! O estresse físico foi 100% eliminado."},
\t\t8: {"stage": 8, "ingredient": "Bateria Recarregável de Bio-Vida", "icon": "🔋", "nix_status": "Nix mexe a patinha no compasso da música pop!", "quote": "A bateria da vida de Nix está recarregando para o nível máximo!", "reward_text": "Bio-Bateria conectada à coleira mágica de Nix!"},
\t\t9: {"stage": 9, "ingredient": "Partitura Holográfica da Serenidade", "icon": "🎼", "nix_status": "Notas musicais luminosas dançam ao redor da cestinha de Nix.", "quote": "A sinfonia da saúde está quase completa no domo digital!", "reward_text": "Partitura Holográfica desdobrada em 360 graus!"},
\t\t10: {"stage": 10, "ingredient": "Eco Reverberante de Carinho Digital", "icon": "🔊", "nix_status": "Nix se levanta, espreguiça as quatro patas e solta um miau sonoro!", "quote": "Ouvi esse miado límpido! Nix está quase pronto para o show!", "reward_text": "Reverberação carinhosa aplicada! Respiração 100% desobstruída."},
\t\t11: {"stage": 11, "ingredient": "Alho-Poró Verde da Vitalidade", "icon": "🌱", "nix_status": "Nix brinca batendo a patinha no talo de alho-poró de Miku!", "quote": "Ele está brincando! A alegria de Nix voltou por inteiro!", "reward_text": "Alho-Poró da Sorte agitado ao ritmo do refrão de cura!"},
\t\t12: {"stage": 12, "ingredient": "Melodia Perfeita 39 de Cura de Nix", "icon": "🎶", "nix_status": "CURA COMPLETA! Nix está pulando, dançando e ronronando com fones neon!", "quote": "SHOW INESQUECÍVEL! NIX ESTÁ RADIANTE, CURADO E CHEIO DE RITMO! 🎵🐾", "reward_text": "A MELODIA VOCALOID SALVOU NIX! O gatinho deu um salto acrobático e agora usa fonezinhos ciano combinando com a Lina-Miku, cantando juntos para a multidão!"}
\t},
\t"sonserina": {
\t\t1: {"stage": 1, "ingredient": "Escama de Serpente de Prata Reluzente", "icon": "🐍", "nix_status": "Nix descansa sobre o veludo esmeralda da sala comunal, respirando fraco.", "quote": "A magia das masmorras tem a cura mais poderosa contra feitiços arcanos!", "reward_text": "Escama de Serpente moída! Dissipa a maldição que gerou a febre."},
\t\t2: {"stage": 2, "ingredient": "Gota de Poção Wiggenweld Concentrada", "icon": "🧪", "nix_status": "A gota verde cura o calor excessivo nas orelhinhas de Nix.", "quote": "A poção regenerativa Wiggenweld é insuperável na medicina bruxa!", "reward_text": "Wiggenweld administrada! A vitalidade começa a ascender."},
\t\t3: {"stage": 3, "ingredient": "Folha de Mandrágora Suavizada", "icon": "🪴", "nix_status": "Nix solta um suspiro relaxado enquanto a mandrágora acalma a dor.", "quote": "Mandrágora adormecida restaura forças esgotadas por magia negra!", "reward_text": "Mandrágora destilada sem o grito! Relaxamento profundo."},
\t\t4: {"stage": 4, "ingredient": "Pó de Chifre de Bicórnio Restaurador", "icon": "🦄", "nix_status": "O batimento cardíaco de Nix volta ao compasso forte e seguro.", "quote": "Ingrediente raro das masmorras mais profundas para salvar meu Nix!", "reward_text": "Pó de Bicórnio infusionado no caldeirão de cobre!"},
\t\t5: {"stage": 5, "ingredient": "Bálsamo de Pele de Araramboia", "icon": "✨", "nix_status": "A febre de Nix baixa consideravelmente sob o feitiço do bálsamo.", "quote": "A troca de pele simboliza o renascimento da saúde pura!", "reward_text": "Bálsamo esmeralda aplicado! Temperatura corporal estabilizada."},
\t\t6: {"stage": 6, "ingredient": "Secreção Purificada de Ditamno", "icon": "🌿", "nix_status": "Nix abre os olhinhos dourados e pisca calmo para Lina.", "quote": "O ditamno fecha qualquer ferida e purifica qualquer enfermidade!", "reward_text": "Ditamno purificado! O sistema imunológico ganha escudo impenetrável."},
\t\t7: {"stage": 7, "ingredient": "Caldeirão de Cobre com Fogo Suave", "icon": "🫕", "nix_status": "Nix bebe o xarope morno e ronrona fraquinho pela primeira vez!", "quote": "Ele ronronou! O caldeirão das masmorras cozinhou a cura perfeita!", "reward_text": "Xarope do Caldeirão engarrafado e consumido com sucesso!"},
\t\t8: {"stage": 8, "ingredient": "Bétula da Floresta Proibida Aquecida", "icon": "🪵", "nix_status": "O calor mágico constante mantém Nix livre de qualquer calafrio.", "quote": "A madeira mágica queima com chama esmeralda sem queimar!", "reward_text": "Lareira de Chama Esmeralda aquecendo a cestinha do Nix."},
\t\t9: {"stage": 9, "ingredient": "Soro Verde Antídoto Universal", "icon": "🔮", "nix_status": "Nix senta-se na almofada e lambe as patas da frente!", "quote": "O antídoto universal neutralizou 100% da febre residual!", "reward_text": "Antídoto Universal agiu no organismo com perfeição alquímica."},
\t\t10: {"stage": 10, "ingredient": "Orvalho sob Lua Nova das Criptas", "icon": "🌙", "nix_status": "Nix mexe a cauda feliz e mia bem alto chamando por Lina!", "quote": "Ele me chamou! As masmorras ecoam a voz saudável de Nix!", "reward_text": "Orvalho Lunar absorvido! As energias mágicas estão equilibradas."},
\t\t11: {"stage": 11, "ingredient": "Pena de Coruja Noturna da Lealdade", "icon": "🪶", "nix_status": "Nix brinca com a pontinha da pena como o gatinho ágil que é!", "quote": "O instinto brincalhão de caça voltou! Falta apenas o selo supremo!", "reward_text": "Pena de Coruja encantada com o feitiço da amizade eterna."},
\t\t12: {"stage": 12, "ingredient": "Elixir da Serpente de Cura de Nix", "icon": "🏆", "nix_status": "CURA COMPLETA! Nix está pulando pelas masmorras, forte, saudável e astuto!", "quote": "TRIUNFO DA ASTÚCIA E DO AMOR! NIX ESTÁ TOTALMENTE SALVO! 🐍🐾", "reward_text": "A POÇÃO SUPREMA DA SONSERINA RESTAUROU NIX! O gatinho veste agora uma fitinha prata e verde no pescoço, ronronando triunfante nos ombros de Lina!"}
\t},
\t"tracen": {
\t\t1: {"stage": 1, "ingredient": "Ferradura da Sorte Dourada", "icon": "🧲", "nix_status": "Nix descansa na toalha felpuda do vestiário de Tracen, exausto da febre.", "quote": "Nesta corrida pela sua vida, Nix, serei a corredora mais veloz de todas!", "reward_text": "Ferradura de Ouro instalada na cestinha! Traz bênção e força para a largada."},
\t\t2: {"stage": 2, "ingredient": "Isotônico Energético de Cenoura Doce", "icon": "🥕", "nix_status": "Nix bebe algumas gotas do isotônico e sua respiração desacelera suave.", "quote": "A hidratação dos atletas de turf é perfeita para curar fraqueza!", "reward_text": "Isotônico doce digerido! A febre mágica começa a ceder."},
\t\t3: {"stage": 3, "ingredient": "Toalha Quente de Algodão Hidrofílico", "icon": "🧣", "nix_status": "O corpinho de Nix relaxa com a compressa quentinha e macia.", "quote": "Mantendo os músculos e patinhas aquecidos contra o vento da pista!", "reward_text": "Toalha Hidrofílica absorve o suor febril! Nix respira aliviado."},
\t\t4: {"stage": 4, "ingredient": "Pomada de Aquecimento Muscular Suave", "icon": "🧴", "nix_status": "Nix estica as perninhas traseiras sentindo o alívio das dores.", "quote": "Saltando os obstáculos de trilho para garantir o alívio muscular de Nix!", "reward_text": "Pomada Tracen massageada com cuidado nas articulações do gatinho."},
\t\t5: {"stage": 5, "ingredient": "Fita de Chegada da Corrida Invicta", "icon": "🎗️", "nix_status": "Nix apoia o queixo na fita azul e branca e ronrona baixinho.", "quote": "Cruzando a meia pista na liderança absoluta! O remédio está perto!", "reward_text": "Fita da Vitória enrolada no cobertorzinho! Eleva a moral e a força vital."},
\t\t6: {"stage": 6, "ingredient": "Proteína Pura para Vitalidade de Turf", "icon": "🥛", "nix_status": "Nix toma todo o leite enriquecido com proteína e lambe os bigodes.", "quote": "Nutrição de primeira classe para recompor o peso e energia do gatinho!", "reward_text": "Proteína de Turf absorvida! Os músculos ganham novo tônus."},
\t\t7: {"stage": 7, "ingredient": "Água Mineral Glacial da Fonte Tracen", "icon": "💧", "nix_status": "Nix olha para a pista através da janela do camarote com olhos vivos.", "quote": "Subindo a colina dos campeões com fôlego de ouro pelo meu Nix!", "reward_text": "Água Glacial purificada! Limpeza total das toxinas da febre."},
\t\t8: {"stage": 8, "ingredient": "Cenoura Mágica de Glicose Rápida", "icon": "🥕", "nix_status": "Nix mordisca a cenourinha mágica e se apoia nas quatro patas!", "quote": "Glicose natural de altíssimo rendimento! Nix já está em pé!", "reward_text": "Cenoura Mágica consumida! Glicose e energia restabelecidas."},
\t\t9: {"stage": 9, "ingredient": "Cronômetro de Recuperação de Fôlego", "icon": "⏱️", "nix_status": "O fôlego de Nix atinge a taxa perfeita de 24 respirações por minuto.", "quote": "Tempo recorde em cada volta da pista! A vitória é certa!", "reward_text": "Cronômetro aponta: Todos os sinais vitais retornaram ao padrão campeão!"},
\t\t10: {"stage": 10, "ingredient": "Manto Térmico dos Campeões", "icon": "🏆", "nix_status": "Nix se enrola na capa de veludo azul com orgulho felino.", "quote": "Reta final! A torcida inteira de Tracen está aplaudindo nossa corrida!", "reward_text": "Manto dos Campeões colocado! Proteção térmica máxima contra qualquer vento."},
\t\t11: {"stage": 11, "ingredient": "Laço de Crina de Amizade Indestrutível", "icon": "🎀", "nix_status": "Nix pula para fora da cesta e dá passos firmes na direção da Lina!", "quote": "Ele está correndo! Nix está vindo ao meu encontro na pista!", "reward_text": "Laço da Amizade atado à patinha! Conexão de amor inquebrantável."},
\t\t12: {"stage": 12, "ingredient": "Taça da Imunidade Invicta do Nix", "icon": "🥇", "nix_status": "CURA COMPLETA! Nix cruzou a linha de chegada no colo da Lina sob chuva de confetes!", "quote": "GRANDE VITÓRIA NO LINAVERSE TWINKLE SERIES! NIX É O CAMPEÃO DA VIDA! 🏇🐾", "reward_text": "O TROFÉU DE TRACEN CUROU NIX! O gatinho pulou no degrau mais alto do pódio ao lado da Lina-Tracen, recebendo a medalha de ouro e muito carinho de toda a torcida!"}
\t}"""

target_marker_lore = '12: {"stage": 12, "ingredient": "Chama Colegial da Amizade", "icon": "💖", "nix_status": "CURA COMPLETA! Nix está 100% curado, pulando e ronronando com muito amor!", "quote": "CONSEGUIMOS! NIX ESTÁ SAUDÁVEL, FORTE E CHEIO DE ENERGIA! 🐾🎒", "reward_text": "O REMÉDIO ESCOLAR FOI ENTREGUE! Nix tomou todo o xarope quentinho na garrafa térmica, se espreguiçou e saltou na mochila da Lina, pronto para ir à aula com ela todos os dias!"}\n\t}\n}'
replacement_lore = '12: {"stage": 12, "ingredient": "Chama Colegial da Amizade", "icon": "💖", "nix_status": "CURA COMPLETA! Nix está 100% curado, pulando e ronronando com muito amor!", "quote": "CONSEGUIMOS! NIX ESTÁ SAUDÁVEL, FORTE E CHEIO DE ENERGIA! 🐾🎒", "reward_text": "O REMÉDIO ESCOLAR FOI ENTREGUE! Nix tomou todo o xarope quentinho na garrafa térmica, se espreguiçou e saltou na mochila da Lina, pronto para ir à aula com ela todos os dias!"}\n\t},\n' + lore_addition + '\n}'

if target_marker_lore not in code:
    raise Exception("Target marker for lore not found")
code = code.replace(target_marker_lore, replacement_lore, 1)

# 3. Update UNIVERSES array
old_universes = 'const UNIVERSES: Array[String] = ["classic", "celestial", "valkyrie", "ninja", "royalty", "uniform"]'
new_universes = 'const UNIVERSES: Array[String] = ["classic", "celestial", "valkyrie", "ninja", "royalty", "uniform", "agnes", "frieren", "maid", "maomao", "miku", "sonserina", "tracen"]'
if old_universes not in code:
    raise Exception("old_universes not found")
code = code.replace(old_universes, new_universes)

# 4. Update OUTFITS dictionary
outfits_addition = """\t"agnes": {
\t\t"id": "agnes",
\t\t"name": "Cientista Quântica",
\t\t"icon": "🧪",
\t\t"universe_name": "Universo Laboratório Quântico",
\t\t"universe_subtitle": "O Centro de Pesquisa Temporal e Fórmulas de Alta Velocidade",
\t\t"portrait": "res://assets/sprites/ui/outfit_agnes.png",
\t\t"sprite": "res://assets/sprites/player/lina_sprite_agnes.png",
\t\t"sprite_frames": "res://scenes/player/player_frames_agnes.tres",
\t\t"theme": "Alquimia Tachyon",
\t\t"desc": "Jaleco científico sobre traje moderno de pesquisadora, frascos de reagentes e visor de telemetria quântica de Lina.",
\t\t"badge": "Mítico",
\t\t"color": Color(0.85, 0.45, 1.0),
\t\t"bg_textures": {
\t\t\t"sky": "res://assets/sprites/background/agnes/sky.png",
\t\t\t"far": "res://assets/sprites/background/agnes/far.png",
\t\t\t"mid": "res://assets/sprites/background/agnes/mid.png",
\t\t\t"trees": "res://assets/sprites/background/agnes/trees.png"
\t\t},
\t\t"theme_data": {
\t\t\t"sky_color": Color(1.0, 1.0, 1.0),
\t\t\t"mountains_far_color": Color(1.0, 1.0, 1.0),
\t\t\t"mountains_mid_color": Color(1.0, 1.0, 1.0),
\t\t\t"trees_color": Color(1.0, 1.0, 1.0),
\t\t\t"ground_color": Color(0.08, 0.05, 0.14, 0.98),
\t\t\t"ground_border": Color(0.9, 0.4, 1.0, 1.0),
\t\t\t"ambient_modulate": Color(1.05, 0.9, 1.15),
\t\t\t"platform_modulate": Color(0.95, 0.8, 1.1),
\t\t\t"ice_modulate": Color(0.85, 0.45, 1.0),
\t\t\t"crystal_modulate": Color(0.9, 0.5, 1.0),
\t\t\t"particles_color": Color(0.95, 0.5, 1.0, 0.85),
\t\t\t"particles_gravity": Vector2(15, 30),
\t\t\t"particles_speed": Vector2(30, 70),
\t\t\t"particles_spread": 30.0,
\t\t\t"stage_atmosphere_name": "Vapor Alquímico & Reações Tachyon"
\t\t}
\t},
\t"frieren": {
\t\t"id": "frieren",
\t\t"name": "Maga Élfica",
\t\t"icon": "🪄",
\t\t"universe_name": "Universo Mágico Milenar",
\t\t"universe_subtitle": "A Era Antiga da Magia Esquecida e Céus Élficos",
\t\t"portrait": "res://assets/sprites/ui/outfit_frieren.png",
\t\t"sprite": "res://assets/sprites/player/lina_sprite_frieren.png",
\t\t"sprite_frames": "res://scenes/player/player_frames_frieren.tres",
\t\t"theme": "Magia Ancestral",
\t\t"desc": "Manto élfico alvo com listras douradas, botinas de viagem e báculo de magia pura carregado de mana milenar.",
\t\t"badge": "Lendário",
\t\t"color": Color(0.65, 0.9, 1.0),
\t\t"bg_textures": {
\t\t\t"sky": "res://assets/sprites/background/frieren/sky.png",
\t\t\t"far": "res://assets/sprites/background/frieren/far.png",
\t\t\t"mid": "res://assets/sprites/background/frieren/mid.png",
\t\t\t"trees": "res://assets/sprites/background/frieren/trees.png"
\t\t},
\t\t"theme_data": {
\t\t\t"sky_color": Color(1.0, 1.0, 1.0),
\t\t\t"mountains_far_color": Color(1.0, 1.0, 1.0),
\t\t\t"mountains_mid_color": Color(1.0, 1.0, 1.0),
\t\t\t"trees_color": Color(1.0, 1.0, 1.0),
\t\t\t"ground_color": Color(0.06, 0.1, 0.14, 0.98),
\t\t\t"ground_border": Color(0.7, 0.95, 1.0, 1.0),
\t\t\t"ambient_modulate": Color(0.95, 1.02, 1.08),
\t\t\t"platform_modulate": Color(0.85, 0.98, 1.05),
\t\t\t"ice_modulate": Color(0.7, 0.95, 1.0),
\t\t\t"crystal_modulate": Color(0.8, 1.0, 0.95),
\t\t\t"particles_color": Color(0.85, 0.95, 1.0, 0.9),
\t\t\t"particles_gravity": Vector2(10, 25),
\t\t\t"particles_speed": Vector2(20, 50),
\t\t\t"particles_spread": 35.0,
\t\t\t"stage_atmosphere_name": "Pétalas Mágicas e Brisa Élfica"
\t\t}
\t},
\t"maid": {
\t\t"id": "maid",
\t\t"name": "Camareira Graciosa",
\t\t"icon": "☕",
\t\t"universe_name": "Universo Mansão Vitoriana",
\t\t"universe_subtitle": "Os Salões Nobres de Chá, Tapeçarias e Serventia Fiel",
\t\t"portrait": "res://assets/sprites/ui/outfit_maid.png",
\t\t"sprite": "res://assets/sprites/player/lina_sprite_maid.png",
\t\t"sprite_frames": "res://scenes/player/player_frames_maid.tres",
\t\t"theme": "Elegância Vitoriana",
\t\t"desc": "Vestido clássico de maid preto e branco, avental engomado com babados finos e tiara com laço bordado à mão.",
\t\t"badge": "Raro",
\t\t"color": Color(0.95, 0.8, 0.85),
\t\t"bg_textures": {
\t\t\t"sky": "res://assets/sprites/background/maid/sky.png",
\t\t\t"far": "res://assets/sprites/background/maid/far.png",
\t\t\t"mid": "res://assets/sprites/background/maid/mid.png",
\t\t\t"trees": "res://assets/sprites/background/maid/trees.png"
\t\t},
\t\t"theme_data": {
\t\t\t"sky_color": Color(1.0, 1.0, 1.0),
\t\t\t"mountains_far_color": Color(1.0, 1.0, 1.0),
\t\t\t"mountains_mid_color": Color(1.0, 1.0, 1.0),
\t\t\t"trees_color": Color(1.0, 1.0, 1.0),
\t\t\t"ground_color": Color(0.12, 0.08, 0.1, 0.98),
\t\t\t"ground_border": Color(1.0, 0.85, 0.9, 1.0),
\t\t\t"ambient_modulate": Color(1.05, 0.98, 1.02),
\t\t\t"platform_modulate": Color(1.02, 0.92, 0.95),
\t\t\t"ice_modulate": Color(0.95, 0.8, 0.85),
\t\t\t"crystal_modulate": Color(1.0, 0.85, 0.7),
\t\t\t"particles_color": Color(1.0, 0.9, 0.95, 0.85),
\t\t\t"particles_gravity": Vector2(15, 30),
\t\t\t"particles_speed": Vector2(25, 55),
\t\t\t"particles_spread": 25.0,
\t\t\t"stage_atmosphere_name": "Aroma de Chá Earl Grey e Veludo"
\t\t}
\t},
\t"maomao": {
\t\t"id": "maomao",
\t\t"name": "Boticária Imperial",
\t\t"icon": "🌿",
\t\t"universe_name": "Universo Imperial das Ervas",
\t\t"universe_subtitle": "O Palácio das Dinastias, Plantas Medicinais e Antídotos",
\t\t"portrait": "res://assets/sprites/ui/outfit_maomao.png",
\t\t"sprite": "res://assets/sprites/player/lina_sprite_maomao.png",
\t\t"sprite_frames": "res://scenes/player/player_frames_maomao.tres",
\t\t"theme": "Medicina Herbal",
\t\t"desc": "Hanfu tradicional verde-esmeralda com xale claro, coque duplo preso com grampos e bolsa de ervas boticárias.",
\t\t"badge": "Mítico",
\t\t"color": Color(0.45, 0.95, 0.55),
\t\t"bg_textures": {
\t\t\t"sky": "res://assets/sprites/background/maomao/sky.png",
\t\t\t"far": "res://assets/sprites/background/maomao/far.png",
\t\t\t"mid": "res://assets/sprites/background/maomao/mid.png",
\t\t\t"trees": "res://assets/sprites/background/maomao/trees.png"
\t\t},
\t\t"theme_data": {
\t\t\t"sky_color": Color(1.0, 1.0, 1.0),
\t\t\t"mountains_far_color": Color(1.0, 1.0, 1.0),
\t\t\t"mountains_mid_color": Color(1.0, 1.0, 1.0),
\t\t\t"trees_color": Color(1.0, 1.0, 1.0),
\t\t\t"ground_color": Color(0.05, 0.12, 0.08, 0.98),
\t\t\t"ground_border": Color(0.5, 0.95, 0.6, 1.0),
\t\t\t"ambient_modulate": Color(0.92, 1.08, 0.96),
\t\t\t"platform_modulate": Color(0.8, 1.05, 0.85),
\t\t\t"ice_modulate": Color(0.5, 0.95, 0.65),
\t\t\t"crystal_modulate": Color(0.4, 0.9, 0.5),
\t\t\t"particles_color": Color(0.6, 1.0, 0.7, 0.85),
\t\t\t"particles_gravity": Vector2(18, 32),
\t\t\t"particles_speed": Vector2(30, 65),
\t\t\t"particles_spread": 28.0,
\t\t\t"stage_atmosphere_name": "Pólen de Jade e Orvalho Medicinal"
\t\t}
\t},
\t"miku": {
\t\t"id": "miku",
\t\t"name": "Diva Sintetizadora",
\t\t"icon": "🎵",
\t\t"universe_name": "Universo Sintetizador Neon",
\t\t"universe_subtitle": "A Metrópole Cyberpunk dos Beats Eletrônicos e Hologramas",
\t\t"portrait": "res://assets/sprites/ui/outfit_miku.png",
\t\t"sprite": "res://assets/sprites/player/lina_sprite_miku.png",
\t\t"sprite_frames": "res://scenes/player/player_frames_miku.tres",
\t\t"theme": "Vocaloid Cyberpunk",
\t\t"desc": "Colete futurista cinza-metálico, gravata ciano neon, mangas flutuantes digitais e marias-chiquinhas turquesa vibrantes.",
\t\t"badge": "Mítico",
\t\t"color": Color(0.2, 0.95, 0.9),
\t\t"bg_textures": {
\t\t\t"sky": "res://assets/sprites/background/miku/sky.png",
\t\t\t"far": "res://assets/sprites/background/miku/far.png",
\t\t\t"mid": "res://assets/sprites/background/miku/mid.png",
\t\t\t"trees": "res://assets/sprites/background/miku/trees.png"
\t\t},
\t\t"theme_data": {
\t\t\t"sky_color": Color(1.0, 1.0, 1.0),
\t\t\t"mountains_far_color": Color(1.0, 1.0, 1.0),
\t\t\t"mountains_mid_color": Color(1.0, 1.0, 1.0),
\t\t\t"trees_color": Color(1.0, 1.0, 1.0),
\t\t\t"ground_color": Color(0.04, 0.08, 0.14, 0.98),
\t\t\t"ground_border": Color(0.2, 0.95, 0.9, 1.0),
\t\t\t"ambient_modulate": Color(0.9, 1.05, 1.15),
\t\t\t"platform_modulate": Color(0.6, 0.95, 1.1),
\t\t\t"ice_modulate": Color(0.25, 0.95, 0.9),
\t\t\t"crystal_modulate": Color(0.2, 0.95, 0.85),
\t\t\t"particles_color": Color(0.3, 1.0, 0.9, 0.9),
\t\t\t"particles_gravity": Vector2(20, 45),
\t\t\t"particles_speed": Vector2(40, 100),
\t\t\t"particles_spread": 35.0,
\t\t\t"stage_atmosphere_name": "Pulsos Neon e Equalizador Visual 39Hz"
\t\t}
\t},
\t"sonserina": {
\t\t"id": "sonserina",
\t\t"name": "Bruxa Sonserina",
\t\t"icon": "🐍",
\t\t"universe_name": "Universo Masmorras de Esmeralda",
\t\t"universe_subtitle": "As Catacumbas Arcanas, Poções Proibidas e Chama Verde",
\t\t"portrait": "res://assets/sprites/ui/outfit_sonserina.png",
\t\t"sprite": "res://assets/sprites/player/lina_sprite_sonserina.png",
\t\t"sprite_frames": "res://scenes/player/player_frames_sonserina.tres",
\t\t"theme": "Feitiçaria das Masmorras",
\t\t"desc": "Capa negra com forro verde-esmeralda, suéter com listras prata e verde, cachecol de serpente e varinha mágica refinada.",
\t\t"badge": "Lendário",
\t\t"color": Color(0.3, 0.85, 0.45),
\t\t"bg_textures": {
\t\t\t"sky": "res://assets/sprites/background/sonserina/sky.png",
\t\t\t"far": "res://assets/sprites/background/sonserina/far.png",
\t\t\t"mid": "res://assets/sprites/background/sonserina/mid.png",
\t\t\t"trees": "res://assets/sprites/background/sonserina/trees.png"
\t\t},
\t\t"theme_data": {
\t\t\t"sky_color": Color(1.0, 1.0, 1.0),
\t\t\t"mountains_far_color": Color(1.0, 1.0, 1.0),
\t\t\t"mountains_mid_color": Color(1.0, 1.0, 1.0),
\t\t\t"trees_color": Color(1.0, 1.0, 1.0),
\t\t\t"ground_color": Color(0.04, 0.09, 0.06, 0.98),
\t\t\t"ground_border": Color(0.4, 0.9, 0.5, 1.0),
\t\t\t"ambient_modulate": Color(0.85, 1.05, 0.92),
\t\t\t"platform_modulate": Color(0.65, 0.95, 0.75),
\t\t\t"ice_modulate": Color(0.4, 0.88, 0.52),
\t\t\t"crystal_modulate": Color(0.35, 0.9, 0.45),
\t\t\t"particles_color": Color(0.4, 0.95, 0.55, 0.8),
\t\t\t"particles_gravity": Vector2(20, 38),
\t\t\t"particles_speed": Vector2(30, 75),
\t\t\t"particles_spread": 22.0,
\t\t\t"stage_atmosphere_name": "Fogo Fátuo Esmeralda e Sombras Arcanas"
\t\t}
\t},
\t"tracen": {
\t\t"id": "tracen",
\t\t"name": "Corredora Tracen",
\t\t"icon": "🏇",
\t\t"universe_name": "Universo Academia Tracen",
\t\t"universe_subtitle": "A Pista de Turf de Alta Velocidade e Espírito Competitivo",
\t\t"portrait": "res://assets/sprites/ui/outfit_tracen.png",
\t\t"sprite": "res://assets/sprites/player/lina_sprite_tracen.png",
\t\t"sprite_frames": "res://scenes/player/player_frames_tracen.tres",
\t\t"theme": "Corrida & Atletismo Turf",
\t\t"desc": "Uniforme esportivo oficial da Academia Tracen com gola de marinheira, listras de pista e sapatilhas de arrancada explosiva.",
\t\t"badge": "Lendário",
\t\t"color": Color(0.3, 0.65, 1.0),
\t\t"bg_textures": {
\t\t\t"sky": "res://assets/sprites/background/tracen/sky.png",
\t\t\t"far": "res://assets/sprites/background/tracen/far.png",
\t\t\t"mid": "res://assets/sprites/background/tracen/mid.png",
\t\t\t"trees": "res://assets/sprites/background/tracen/trees.png"
\t\t},
\t\t"theme_data": {
\t\t\t"sky_color": Color(1.0, 1.0, 1.0),
\t\t\t"mountains_far_color": Color(1.0, 1.0, 1.0),
\t\t\t"mountains_mid_color": Color(1.0, 1.0, 1.0),
\t\t\t"trees_color": Color(1.0, 1.0, 1.0),
\t\t\t"ground_color": Color(0.06, 0.1, 0.16, 0.98),
\t\t\t"ground_border": Color(0.4, 0.75, 1.0, 1.0),
\t\t\t"ambient_modulate": Color(1.02, 1.02, 1.08),
\t\t\t"platform_modulate": Color(0.9, 0.95, 1.05),
\t\t\t"ice_modulate": Color(0.4, 0.75, 1.0),
\t\t\t"crystal_modulate": Color(0.35, 0.7, 1.0),
\t\t\t"particles_color": Color(0.9, 0.95, 1.0, 0.85),
\t\t\t"particles_gravity": Vector2(25, 50),
\t\t\t"particles_speed": Vector2(45, 110),
\t\t\t"particles_spread": 20.0,
\t\t\t"stage_atmosphere_name": "Vento das Retas Finais e Gramado Turf"
\t\t}
\t}"""

target_marker_outfit = '\t\t\t"stage_atmosphere_name": "Manhã de Inverno Vibrante"\n\t\t}\n\t}\n}'
replacement_outfit = '\t\t\t"stage_atmosphere_name": "Manhã de Inverno Vibrante"\n\t\t}\n\t},\n' + outfits_addition + '\n}'

if target_marker_outfit not in code:
    raise Exception("Target marker for outfit not found")
code = code.replace(target_marker_outfit, replacement_outfit, 1)

with open(GAME_MANAGER_PATH, "w", encoding="utf-8") as f:
    f.write(code)

print("[SUCESSO] game_manager.gd atualizado com os 7 novos universos com sucesso!")
