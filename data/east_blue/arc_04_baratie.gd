class_name Arc04Baratie

# ── Bataille 1 : Défense du Baratie ──────────────────────────────────────────
# Équipage complet (11-12) + Sanji (11) vs soldats Krieg
# Composition ÉQUILIBRÉ : 2 DPS Mêlée + 1 Tireur + 1 Tank + 1 Soutien
# cible eff ~0.95 — 5 joueurs vs 5 ennemis (ratio count 1.00)
static func battle_01_sea_restaurant() -> BattleConfig:
	var c := BattleConfig.new()
	c.battle_id   = "eb_04_01"
	c.battle_name = "Baratie — Défense du pont"
	c.arc_name    = "Baratie"
	c.grid_width  = 14
	c.grid_height = 10
	c.background_color = Color(0.10, 0.20, 0.40)

	for x in range(0, 14):
		c.set_tile(x, 0, BattleConfig.TileType.WATER)
		c.set_tile(x, 9, BattleConfig.TileType.WATER)
	for y in range(1, 9):
		c.set_tile(0, y, BattleConfig.TileType.WATER)
		c.set_tile(13, y, BattleConfig.TileType.WATER)
	for x in range(2, 12):
		for y in range(2, 8):
			c.set_tile(x, y, BattleConfig.TileType.WOOD)

	c.pre_battle_dialogue = [
		"Sanji : « Si vous voulez manger, vous mangez — même les ennemis. Mais attaquer MON restaurant ? »",
		"Soldat Krieg : « Don Krieg réclame ce navire ! »",
		"Luffy : « Hé, le cuisinier, aide-nous à te battre ! »",
		"Sanji : « …Ne me donne pas d'ordres. Je le fais parce que je veux bien. »",
	]
	c.post_battle_dialogue = [
		"Luffy : « T'es incroyable ! Viens avec nous ! »",
		"Sanji : « J'ai… quelque chose à régler d'abord. »",
	]

	c.add_unit(EastBlueCharacters.luffy(),  Vector2i(2, 4), true, 11)
	c.add_unit(EastBlueCharacters.zoro(),   Vector2i(2, 6), true, 11)
	c.add_unit(EastBlueCharacters.nami(),   Vector2i(3, 3), true, 10)
	c.add_unit(EastBlueCharacters.usopp(),  Vector2i(3, 7), true, 10)
	c.add_unit(EastBlueCharacters.sanji(),  Vector2i(4, 5), true, 11)

	c.add_unit(ArchetypeData.dps_melee_slash(UnitData.Faction.PIRATES),  Vector2i(8,  3), false, 10)
	c.add_unit(ArchetypeData.dps_melee_blunt(UnitData.Faction.PIRATES),  Vector2i(10, 3), false, 10)
	c.add_unit(ArchetypeData.dps_ranged(UnitData.Faction.PIRATES),       Vector2i(11, 5), false, 10)
	c.add_unit(ArchetypeData.tank(UnitData.Faction.PIRATES),             Vector2i(10, 7), false, 10)
	c.add_unit(ArchetypeData.support(UnitData.Faction.PIRATES),          Vector2i(9,  4), false, 9)
	return c


# ── Bataille 2 : Don Krieg ────────────────────────────────────────────────────
# Composition DIFFICILE : 3 DPS + 1 Tank + 1 Soutien + Krieg (armure qui casse)
static func battle_02_krieg_boss() -> BattleConfig:
	var c := BattleConfig.new()
	c.battle_id   = "eb_04_02"
	c.battle_name = "Baratie — Don Krieg"
	c.arc_name    = "Baratie"
	c.grid_width  = 14
	c.grid_height = 10
	c.background_color = Color(0.08, 0.15, 0.35)
	c.objective   = BattleConfig.Objective.DEFEAT_BOSS

	for x in range(0, 14):
		c.set_tile(x, 0, BattleConfig.TileType.WATER)
		c.set_tile(x, 9, BattleConfig.TileType.WATER)
	for y in range(0, 10):
		c.set_tile(0,  y, BattleConfig.TileType.WATER)
		c.set_tile(13, y, BattleConfig.TileType.WATER)
	for x in range(2, 12):
		for y in range(2, 8):
			c.set_tile(x, y, BattleConfig.TileType.WOOD)
	for x in range(9, 13):
		for y in range(1, 4):
			c.set_tile(x, y, BattleConfig.TileType.ELEVATED)

	c.pre_battle_dialogue = [
		"Krieg : « Idiots. J'ai 5 000 hommes et la flotte la plus puissante d'East Blue. »",
		"Luffy : « Je m'en fiche ! Je deviendrai Roi des Pirates ! »",
		"Krieg : « Alors vous mourrez ici. MH5 — FEU ! »",
		"Sanji : « Luffy — attention à la bombe à gaz ! »",
	]
	c.post_battle_dialogue = [
		"Krieg : « Cette armure… est impénétrable… »",
		"Luffy : « Gomu Gomu no Bazooka ! »",
		"Krieg : « Im-possible… »",
		"Sanji : « …Bien. Je rejoins ton équipage. »",
		"Luffy : « OUI ! Mon équipage devient de plus en plus fort ! »",
	]

	c.add_unit(EastBlueCharacters.luffy(),  Vector2i(2, 5), true, 13)
	c.add_unit(EastBlueCharacters.zoro(),   Vector2i(2, 7), true, 13)
	c.add_unit(EastBlueCharacters.nami(),   Vector2i(3, 3), true, 12)
	c.add_unit(EastBlueCharacters.usopp(),  Vector2i(1, 5), true, 12)
	c.add_unit(EastBlueCharacters.sanji(),  Vector2i(3, 6), true, 13)

	c.add_unit(EastBlueCharacters.krieg(),                               Vector2i(11, 3), false, 15)
	c.add_unit(ArchetypeData.dps_ranged(UnitData.Faction.PIRATES),       Vector2i(9,  2), false, 12)
	c.add_unit(ArchetypeData.dps_melee_blunt(UnitData.Faction.PIRATES),  Vector2i(10, 5), false, 12)
	c.add_unit(ArchetypeData.dps_melee_blunt(UnitData.Faction.PIRATES),  Vector2i(12, 6), false, 12)
	c.add_unit(ArchetypeData.tank(UnitData.Faction.PIRATES),             Vector2i(9,  7), false, 12)
	c.add_unit(ArchetypeData.support(UnitData.Faction.PIRATES),          Vector2i(8,  4), false, 11)
	return c
