class_name StatusManager

# All possible status effects in East Blue
enum Status {
	NONE      = 0,
	STUN      = 1,   # loses its turn
	BURN      = 2,   # loses burn_pct% of max PV per turn
	FROZEN    = 3,   # cannot move, DEF doubled
	BLIND     = 4,   # hit rate -40%
	WEAKENED  = 5,   # FOR -30%
	BUFFED    = 6,   # FOR +30%
}

const NAMES: Dictionary = {
	Status.STUN:     "ÉTOURDI",
	Status.BURN:     "BRÛLÉ",
	Status.FROZEN:   "GELÉ",
	Status.BLIND:    "AVEUGLE",
	Status.WEAKENED: "AFFAIBLI",
	Status.BUFFED:   "RENFORCÉ",
}

const COLORS: Dictionary = {
	Status.STUN:     Color(1.0, 0.9, 0.1),
	Status.BURN:     Color(1.0, 0.3, 0.0),
	Status.FROZEN:   Color(0.5, 0.8, 1.0),
	Status.BLIND:    Color(0.5, 0.5, 0.5),
	Status.WEAKENED: Color(0.8, 0.2, 0.8),
	Status.BUFFED:   Color(0.2, 1.0, 0.5),
}

# Burn damage per turn: % of max PV
const BURN_PERCENT: float = 0.05

# ── ActiveStatus ───────────────────────────────────────────────────────────────
class ActiveStatus:
	var effect: Status = Status.NONE
	var duration: int = 2   # turns remaining; -1 = permanent
	var source_id: String = ""

	func _init(e: Status, d: int, src: String = "") -> void:
		effect = e
		duration = d
		source_id = src

	func is_permanent() -> bool:
		return duration == -1

	func tick() -> void:
		if duration > 0:
			duration -= 1

	func is_expired() -> bool:
		return duration == 0


# ── Helpers (static, operate on a unit's status array) ─────────────────────────

static func has(statuses: Array, effect: Status) -> bool:
	for s in statuses:
		if s.effect == effect:
			return true
	return false

static func apply(statuses: Array, effect: Status, duration: int, src: String = "") -> void:
	# Don't stack — refresh duration if already present
	for s in statuses:
		if s.effect == effect:
			if not s.is_permanent():
				s.duration = max(s.duration, duration)
			return
	statuses.append(ActiveStatus.new(effect, duration, src))

static func remove(statuses: Array, effect: Status) -> void:
	for i in range(statuses.size() - 1, -1, -1):
		if statuses[i].effect == effect:
			statuses.remove_at(i)

static func tick_all(statuses: Array) -> void:
	for s in statuses:
		s.tick()
	# Purge expired
	for i in range(statuses.size() - 1, -1, -1):
		if statuses[i].is_expired():
			statuses.remove_at(i)

static func get_for_multiplier(statuses: Array) -> float:
	var mult := 1.0
	if has(statuses, Status.WEAKENED): mult *= 0.70
	if has(statuses, Status.BUFFED):   mult *= 1.30
	return mult

static func get_def_multiplier(statuses: Array) -> float:
	if has(statuses, Status.FROZEN): return 2.0
	return 1.0

static func get_hit_penalty(statuses: Array) -> float:
	if has(statuses, Status.BLIND): return -0.40
	return 0.0

static func label_string(statuses: Array) -> String:
	var parts: Array[String] = []
	for s in statuses:
		parts.append(NAMES.get(s.effect, "?"))
	return ", ".join(parts)
