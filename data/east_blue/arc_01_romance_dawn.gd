class_name Arc01RomanceDawn

# ── Bataille 1 : La Taverne de Fushia ─ Tutoriel ──────────────────────────────
# Pirates aux Cheveux Rouges (Shanks, Beckmann, Lucky Roo, Yassop) vs bandits Higuma
# Tutoriel : 4 unités aux styles variés pour apprendre les mécaniques
# Composition ennemis : 3 DPS + 2 Tank + Higuma — MOYEN
static func battle_01_tutorial() -> BattleConfig:
	var c := BattleConfig.new()
	c.battle_id   = "eb_01_01"
	c.battle_name = "La Taverne de Fushia"
	c.arc_name    = "Romance Dawn"
	c.grid_width  = 14
	c.grid_height = 9
	c.background_color = Color(0.10, 0.20, 0.10)

	# Extérieur du village de Fushia — rochers et arbres comme obstacles
	for pos in [Vector2i(4,0), Vector2i(5,0), Vector2i(8,0), Vector2i(9,0),
				Vector2i(4,8), Vector2i(5,8), Vector2i(8,8), Vector2i(9,8)]:
		c.set_tile(pos.x, pos.y, BattleConfig.TileType.BLOCKED)
	for pos in [Vector2i(3,2), Vector2i(3,6), Vector2i(6,4),
				Vector2i(10,1), Vector2i(10,7), Vector2i(12,3), Vector2i(12,5)]:
		c.set_tile(pos.x, pos.y, BattleConfig.TileType.ELEVATED)
	for y in range(0, 9):
		c.set_tile(13, y, BattleConfig.TileType.BLOCKED)

	c.pre_battle_dialogue = [
		"Higuma : « Lâchez-moi ! LÂCHEZ-MOI ! »",
		"Luffy : « Tu m'as insulté Shanks ! Je vais pas te laisser faire ça ! »",
		"Higuma : « La ferme, gamin ! *jette Luffy à ses pieds* »",
		"Higuma : « Parfait. Les pirates aux cheveux rouges arrivent… qu'ils viennent. »",
		"Shanks : *apparaît au bout du chemin, sourire calme* « Tu vas bien, Luffy ? »",
		"Luffy : « SHANKS ! »",
		"Higuma : « Tuez-les ! Tuez-les TOUS ! »",
		"Beckmann : *allume sa pipe* « Mauvaise décision. »",
	]
	c.post_battle_dialogue = [
		"Higuma : « Im… possible… »",
		"Shanks : *s'agenouille devant Luffy* « Je t'avais dit de ne pas te battre. »",
		"Luffy : « C'est toi qui m'avais appris à pas fuir ! »",
		"Shanks : *rit* « T'as raison. Pardon. »",
		"Lucky Roo : *finit sa cuisse de poulet tranquillement*",
		"Yassop : « Chef… vous saignez. »",
		"Shanks : « Rien de grave. Ce gamin a de l'œil — il ira loin. »",
	]

	# Pirates aux Cheveux Rouges — niveau 20, clairement hors catégorie
	c.add_unit(EastBlueCharacters.shanks(),    Vector2i(2, 4), true, 20)
	c.add_unit(EastBlueCharacters.beckmann(),  Vector2i(2, 2), true, 20)
	c.add_unit(EastBlueCharacters.lucky_roo(), Vector2i(2, 6), true, 20)
	c.add_unit(EastBlueCharacters.yassop(),    Vector2i(1, 4), true, 20)

	# 13 bandits de Higuma — nombreux mais faibles (niveau 4)
	# Vague avant — mêlée
	c.add_unit(ArchetypeData.dps_melee_slash(UnitData.Faction.BANDITS), Vector2i(6, 2), false, 4)
	c.add_unit(ArchetypeData.dps_melee_slash(UnitData.Faction.BANDITS), Vector2i(6, 4), false, 4)
	c.add_unit(ArchetypeData.dps_melee_slash(UnitData.Faction.BANDITS), Vector2i(6, 6), false, 4)
	c.add_unit(ArchetypeData.dps_melee_blunt(UnitData.Faction.BANDITS), Vector2i(7, 3), false, 4)
	c.add_unit(ArchetypeData.dps_melee_blunt(UnitData.Faction.BANDITS), Vector2i(7, 5), false, 4)
	# Vague milieu — tanks et archers
	c.add_unit(ArchetypeData.tank(UnitData.Faction.BANDITS),            Vector2i(8, 2), false, 4)
	c.add_unit(ArchetypeData.tank(UnitData.Faction.BANDITS),            Vector2i(8, 6), false, 4)
	c.add_unit(ArchetypeData.dps_ranged(UnitData.Faction.BANDITS),      Vector2i(9, 1), false, 4)
	c.add_unit(ArchetypeData.dps_ranged(UnitData.Faction.BANDITS),      Vector2i(9, 7), false, 4)
	# Vague arrière
	c.add_unit(ArchetypeData.dps_melee_slash(UnitData.Faction.BANDITS), Vector2i(10, 3), false, 4)
	c.add_unit(ArchetypeData.dps_melee_slash(UnitData.Faction.BANDITS), Vector2i(10, 5), false, 4)
	c.add_unit(ArchetypeData.tank(UnitData.Faction.BANDITS),            Vector2i(11, 2), false, 4)
	# Higuma — légèrement au-dessus de ses hommes, mais toujours hors catégorie
	c.add_unit(EastBlueCharacters.higuma(),                             Vector2i(11, 4), false, 6)
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
