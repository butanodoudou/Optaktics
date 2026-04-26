class_name Arc01RomanceDawn

# ── Bataille 1 : Village de Fushia ─ Tutoriel ─────────────────────────────────
# Luffy seul (Niv.3) vs bandits de Higuma
# Composition : 3 DPS + 1 boss — FACILE
static func battle_01_tutorial() -> BattleConfig:
	var c := BattleConfig.new()
	c.battle_id   = "eb_01_01"
	c.battle_name = "Village de Fushia"
	c.arc_name    = "Romance Dawn"
	c.grid_width  = 12
	c.grid_height = 8
	c.background_color = Color(0.12, 0.28, 0.12)

	for x in range(3, 9):
		c.set_tile(x, 2, BattleConfig.TileType.WOOD)
	c.set_tile(0,  0, BattleConfig.TileType.BLOCKED)
	c.set_tile(11, 0, BattleConfig.TileType.BLOCKED)

	c.pre_battle_dialogue = [
		"Shanks : « Hey Luffy, t'es sûr de toi ? »",
		"Luffy : « Vous insultez Shanks ! Je ne vous laisserai pas faire ! »",
		"Higuma : « Tuez ce gamin ! »",
	]
	c.post_battle_dialogue = [
		"Luffy : « C'est ce que vous méritez pour vous en prendre à Shanks ! »",
		"Shanks : « Ha ! Ce gamin a du caractère ! »",
	]

	# Joueurs
	c.add_unit(EastBlueCharacters.luffy(), Vector2i(2, 4), true, 3)

	# Ennemis : 2 DPS Tranchant + 1 Tank + Higuma (boss)
	c.add_unit(ArchetypeData.dps_melee_slash(UnitData.Faction.BANDITS), Vector2i(7, 2), false, 2)
	c.add_unit(ArchetypeData.dps_melee_slash(UnitData.Faction.BANDITS), Vector2i(8, 4), false, 2)
	c.add_unit(ArchetypeData.tank(UnitData.Faction.BANDITS),            Vector2i(7, 5), false, 2)
	c.add_unit(EastBlueCharacters.higuma(),                             Vector2i(9, 3), false, 5)
	return c


# ── Bataille 2 : Base Marine ─ Sauvetage de Zoro ─────────────────────────────
# Luffy (Niv.4) + Zoro (Niv.4) vs patrouille marine
# Composition : 3 DPS Distance + 2 Tank — MOYEN
static func battle_02_zoro_rescue() -> BattleConfig:
	var c := BattleConfig.new()
	c.battle_id   = "eb_01_02"
	c.battle_name = "Base Marine — Évasion"
	c.arc_name    = "Romance Dawn"
	c.grid_width  = 14
	c.grid_height = 10

	for x in range(0, 14):
		c.set_tile(x, 0, BattleConfig.TileType.BLOCKED)
		c.set_tile(x, 9, BattleConfig.TileType.BLOCKED)
	for y in range(1, 9):
		c.set_tile(0, y, BattleConfig.TileType.BLOCKED)
		c.set_tile(13, y, BattleConfig.TileType.BLOCKED)
	for x in range(9, 13):
		for y in range(2, 5):
			c.set_tile(x, y, BattleConfig.TileType.ELEVATED)

	c.pre_battle_dialogue = [
		"Zoro : « T'es le gamin qui veut devenir Roi des Pirates ? »",
		"Luffy : « Ouais ! Et toi tu vas rejoindre mon équipage ! »",
		"Zoro : « …Juste cette fois. »",
		"Marine : « Arrêtez ! Personne ne s'échappe de cette base ! »",
	]
	c.post_battle_dialogue = [
		"Zoro : « Hm. Pas mal… pour quelqu'un qui n'utilise pas de sabre. »",
		"Luffy : « Voir ? Je te disais qu'on s'en sortirait ! »",
	]

	c.add_unit(EastBlueCharacters.luffy(), Vector2i(2, 4), true, 4)
	c.add_unit(EastBlueCharacters.zoro(),  Vector2i(2, 6), true, 4)

	c.add_unit(ArchetypeData.dps_ranged(UnitData.Faction.MARINES),     Vector2i(9, 2),  false, 3)
	c.add_unit(ArchetypeData.dps_ranged(UnitData.Faction.MARINES),     Vector2i(11, 2), false, 3)
	c.add_unit(ArchetypeData.tank(UnitData.Faction.MARINES),           Vector2i(8, 5),  false, 3)
	c.add_unit(ArchetypeData.dps_ranged(UnitData.Faction.MARINES),     Vector2i(10, 7), false, 3)
	c.add_unit(ArchetypeData.tank(UnitData.Faction.MARINES),           Vector2i(12, 5), false, 3)
	return c
