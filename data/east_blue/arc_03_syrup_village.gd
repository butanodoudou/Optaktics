class_name Arc03SyrupVillage

# ── Bataille 1 : Embuscade sur la colline ─────────────────────────────────────
# Luffy(9) + Zoro(9) + Usopp(8)  vs Pirates du Chat Noir
# Composition MOYEN : 2 DPS + 1 Tank + 1 Soutien
static func battle_01_hillside_ambush() -> BattleConfig:
	var c := BattleConfig.new()
	c.battle_id   = "eb_03_01"
	c.battle_name = "Village de Sirop — Colline"
	c.arc_name    = "Syrup Village"
	c.grid_width  = 14
	c.grid_height = 10
	c.background_color = Color(0.20, 0.35, 0.15)

	for x in range(7, 12):
		for y in range(2, 5):
			c.set_tile(x, y, BattleConfig.TileType.ELEVATED)

	c.pre_battle_dialogue = [
		"Usopp : « Je suis le grand Capitaine Usopp ! C'est MON village ! »",
		"Luffy : « Je t'aime bien ! Rejoins mon équipage ! »",
		"Usopp : « Q-Quoi ?! Je te connais même pas ! »",
		"Pirate du Chat Noir : « Ordres de Jango — éliminez tous les témoins ! »",
	]
	c.post_battle_dialogue = [
		"Usopp : « On a… on a gagné ?! »",
		"Luffy : « Bien sûr ! Alors — tu nous rejoins ? »",
		"Usopp : « …D'accord. Mais je suis un guerrier courageux, pas un lâche ! »",
		"Zoro : « Bien sûr que oui. »",
	]

	c.add_unit(EastBlueCharacters.luffy(),  Vector2i(1, 4), true, 9)
	c.add_unit(EastBlueCharacters.zoro(),   Vector2i(1, 6), true, 9)
	c.add_unit(EastBlueCharacters.usopp(),  Vector2i(2, 5), true, 8)

	c.add_unit(ArchetypeData.dps_melee_slash(UnitData.Faction.PIRATES), Vector2i(9,  2), false, 7)
	c.add_unit(ArchetypeData.dps_melee_slash(UnitData.Faction.PIRATES), Vector2i(10, 5), false, 7)
	c.add_unit(ArchetypeData.tank(UnitData.Faction.PIRATES),            Vector2i(11, 3), false, 7)
	c.add_unit(ArchetypeData.support(UnitData.Faction.PIRATES),         Vector2i(12, 6), false, 6)
	return c


# ── Bataille 2 : Les Lames de Kuro ───────────────────────────────────────────
# Composition DIFFICILE : 3 DPS + 1 Tank + 1 Soutien + Kuro (boss, Mille Mains)
static func battle_02_kuro_final() -> BattleConfig:
	var c := BattleConfig.new()
	c.battle_id   = "eb_03_02"
	c.battle_name = "Village de Sirop — Les Lames de Kuro"
	c.arc_name    = "Syrup Village"
	c.grid_width  = 14
	c.grid_height = 10
	c.background_color = Color(0.15, 0.30, 0.12)
	c.objective   = BattleConfig.Objective.DEFEAT_BOSS

	for x in range(0, 14):
		c.set_tile(x, 8, BattleConfig.TileType.SAND)
		c.set_tile(x, 9, BattleConfig.TileType.WATER)
	for x in range(5, 9):
		c.set_tile(x, 7, BattleConfig.TileType.SAND)

	c.pre_battle_dialogue = [
		"Kuro : « Trois ans de planification… et vous GAMINS gâchez tout. »",
		"Usopp : « Kaya… elle avait confiance en toi ! »",
		"Kuro : « Le sentiment est une faiblesse. Shakushi ! »",
		"Luffy : « Vous ne pouvez pas blesser mon équipage ! Allons-y ! »",
	]
	c.post_battle_dialogue = [
		"Kuro : « …Battu par… des pirates comme vous… »",
		"Usopp : « Parfaitement ! Parce que je protège ce village ! »",
		"Luffy : « Je vous avais dit qu'on gagnerait ! »",
		"Nami : « On peut ENFIN avoir un vrai bateau maintenant ? »",
	]

	c.add_unit(EastBlueCharacters.luffy(),  Vector2i(1, 5), true, 10)
	c.add_unit(EastBlueCharacters.zoro(),   Vector2i(1, 7), true, 10)
	c.add_unit(EastBlueCharacters.usopp(),  Vector2i(2, 4), true, 9)
	c.add_unit(EastBlueCharacters.nami(),   Vector2i(1, 3), true, 9)

	c.add_unit(EastBlueCharacters.kuro(),                                Vector2i(11, 4), false, 12)
	c.add_unit(ArchetypeData.dps_melee_slash(UnitData.Faction.PIRATES),  Vector2i(9,  3), false, 9)
	c.add_unit(ArchetypeData.dps_melee_slash(UnitData.Faction.PIRATES),  Vector2i(10, 6), false, 9)
	c.add_unit(ArchetypeData.dps_ranged(UnitData.Faction.PIRATES),       Vector2i(12, 2), false, 8)
	c.add_unit(ArchetypeData.tank(UnitData.Faction.PIRATES),             Vector2i(9,  6), false, 9)
	c.add_unit(ArchetypeData.support(UnitData.Faction.PIRATES),          Vector2i(8,  7), false, 8)
	return c
