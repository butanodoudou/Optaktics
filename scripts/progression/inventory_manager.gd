extends Node
# Autoload — gère l'inventaire de consommables de l'équipe.
# Les quantités persistent entre les combats via SaveManager (à brancher plus tard).
# Pour l'instant : inventaire en mémoire, pré-rempli pour les tests.

# item_id -> quantité
var _stock: Dictionary = {}

func _ready() -> void:
	# Stock de test — à remplacer par chargement SaveManager
	_stock = {
		"morceau_viande":   3,
		"repas_copieux":    2,
		"festin_baratie":   1,
		"biere":            3,
		"coupe_sake":       2,
		"giga_bol_sake":    1,
		"epices_pimentees": 2,
		"elixir_rapide":    1,
		"grenade_fumigene": 2,
		"poudre_epuisement": 1,
	}

# ── Lecture ───────────────────────────────────────────────────────────────────

func count(item_id: String) -> int:
	return _stock.get(item_id, 0)

func has_item(item_id: String) -> bool:
	return count(item_id) > 0

func get_available() -> Array[ItemData]:
	var result: Array[ItemData] = []
	for item_id in _stock:
		if _stock[item_id] > 0:
			var item := ItemsCatalog.get_by_id(item_id)
			if item != null:
				result.append(item)
	return result

# ── Modification ──────────────────────────────────────────────────────────────

func add(item_id: String, amount: int = 1) -> void:
	_stock[item_id] = _stock.get(item_id, 0) + amount

func consume(item_id: String) -> bool:
	if not has_item(item_id):
		return false
	_stock[item_id] -= 1
	if _stock[item_id] <= 0:
		_stock.erase(item_id)
	return true
