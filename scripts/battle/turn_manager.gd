class_name TurnManager
extends RefCounted

# AGI-based round system.
# At the start of each round, all living units are sorted by AGI + small random
# variance to break ties. Units act in that order until the queue is exhausted,
# then a new round begins.

var units: Array[Unit] = []
var _queue: Array[Unit] = []
var round_number: int = 0

func register(unit: Unit) -> void:
	if unit not in units:
		units.append(unit)

func unregister(unit: Unit) -> void:
	units.erase(unit)
	_queue.erase(unit)

func get_next_unit() -> Unit:
	# Rebuild queue when it's empty (new round)
	while _queue.is_empty():
		_build_round()

	# Pop first alive unit; skip dead ones
	while not _queue.is_empty():
		var u: Unit = _queue.pop_front()
		if u.is_alive():
			return u

	return null  # no living unit — battle is over

func _build_round() -> void:
	round_number += 1
	var living := _living()
	if living.is_empty():
		return

	# Assign each unit a score = AGI + uniform random [0, 2)
	# Score is fixed once per round (not re-rolled each comparison).
	var scored: Array = []
	for u in living:
		scored.append({ "unit": u, "score": u.effective_agi() + randf_range(0.0, 2.0) })

	scored.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return a["score"] > b["score"]
	)

	_queue = scored.map(func(e: Dictionary) -> Unit: return e["unit"])

func peek_order(count: int = 10) -> Array[Unit]:
	# Non-destructive preview: current queue + simulated future rounds
	var result: Array[Unit] = []
	var remaining := _queue.duplicate()

	while result.size() < count:
		# Drain current remaining queue
		while not remaining.is_empty() and result.size() < count:
			var u: Unit = remaining.pop_front()
			if u.is_alive():
				result.append(u)

		if result.size() >= count:
			break

		# Simulate next round
		var living := _living()
		if living.is_empty():
			break
		var scored: Array = []
		for u in living:
			scored.append({ "unit": u, "score": u.effective_agi() + randf_range(0.0, 2.0) })
		scored.sort_custom(func(a, b) -> bool: return a["score"] > b["score"])
		remaining = scored.map(func(e) -> Unit: return e["unit"])

	return result

func _living() -> Array[Unit]:
	return units.filter(func(u: Unit) -> bool: return u.is_alive())

func reset() -> void:
	units.clear()
	_queue.clear()
	round_number = 0
