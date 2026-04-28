class_name Arc01RomanceDawn

# ── Bataille 1 : La Taverne de Fushia ─ Tutoriel ──────────────────────────────
# Pirates aux Cheveux Rouges (Shanks, Beckmann, Lucky Roo, Yassop) vs bandits Higuma
# Tutoriel : 4 unités aux styles variés pour apprendre les mécaniques
# Composition ennemis : 3 DPS + 2 Tank + Higuma — TROP FACILE (intentionnel)
static func battle_01_tutorial() -> BattleConfig:
	var c := BattleConfig.new()
	c.battle_id   = "eb_01_01"
	c.battle_name = "La Taverne de Fushia"
	c.arc_name    = "Romance Dawn"
	c.grid_width  = 14
	c.grid_height = 9
	c.background_color = Color(0.25, 0.18, 0.10)

	# Comptoir au fond, tables sur les flancs
	for x in range(4, 10):
		c.set_tile(x, 1, BattleConfig.TileType.WOOD)
	for x in [2, 3, 10, 11]:
		c.set_tile(x, 4, BattleConfig.TileType.WOOD)
	for y in range(0, 9):
		c.set_tile(13, y, BattleConfig.TileType.BLOCKED)

	c.pre_battle_dialogue = [
		"Higuma : « Vous appelez ça du service ?! Ce saké est de la pisse ! »",
		"Shanks : « Hmm… Dommage pour ce saké. »",
		"Higuma : « Ce pirate de pacotille me fait la morale ?! TUEZ-LES ! »",
		"Lucky Roo : *continue de manger tranquillement*",
		"Beckmann : *allume sa pipe* « Dernière chance de partir. »",
		"Yassop : « Ha ! Ça va être marrant… »",
	]
	c.post_battle_dialogue = [
		"Higuma : « Im… possible… des pirates ordinaires… »",
		"Shanks : « Soyez plus prudents la prochaine fois. »",
		"Lucky Roo : *reprend une cuisse de poulet*",
		"Luffy : « WAAAH C'ÉTAIT TROP FORT ! »",
		"Shanks : *rit* « Ce gamin a de l'œil. »",
	]

	# Pirates aux Cheveux Rouges
	c.add_unit(EastBlueCharacters.shanks(),    Vector2i(2, 4), true,  8)
	c.add_unit(EastBlueCharacters.beckmann(),  Vector2i(2, 2), true,  8)
	c.add_unit(EastBlueCharacters.lucky_roo(), Vector2i(2, 6), true,  8)
	c.add_unit(EastBlueCharacters.yassop(),    Vector2i(1, 4), true,  8)

	# Bandits de Higuma
	c.add_unit(EastBlueCharacters.higuma(),                              Vector2i(10, 4), false, 7)
	c.add_unit(ArchetypeData.dps_melee_slash(UnitData.Faction.BANDITS),  Vector2i(8,  2), false, 6)
	c.add_unit(ArchetypeData.dps_melee_slash(UnitData.Faction.BANDITS),  Vector2i(9,  6), false, 6)
	c.add_unit(ArchetypeData.dps_melee_blunt(UnitData.Faction.BANDITS),  Vector2i(7,  4), false, 6)
	c.add_unit(ArchetypeData.tank(UnitData.Faction.BANDITS),             Vector2i(8,  5), false, 6)
	c.add_unit(ArchetypeData.tank(UnitData.Faction.BANDITS),             Vector2i(11, 3), false, 6)
	return c


# ── Bataille 2 : Base Marine ─ Sauvetage de Zoro ─────────────────────────────
# Luffy (Niv.4) + Zoro (Niv.4) vs patrouille marine
# Composition : 2 DPS Mêlée + 1 Tireur — FACILE (cible eff ~0.70)
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

	c.add_unit(ArchetypeData.dps_melee_slash(UnitData.Faction.MARINES), Vector2i(9,  2), false, 3)
	c.add_unit(ArchetypeData.dps_melee_blunt(UnitData.Faction.MARINES), Vector2i(10, 6), false, 3)
	c.add_unit(ArchetypeData.dps_ranged(UnitData.Faction.MARINES),      Vector2i(11, 4), false, 2)
	return c
