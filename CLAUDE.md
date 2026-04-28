# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**Optaktics** — One Piece Tactical RPG, East Blue Saga. Godot 4.6, GDScript, GL Compatibility renderer. Fixed 1280×720 viewport.

## Running the Game

Open the project in **Godot 4.6** and press F5, or run from the CLI:

```bash
godot --path . scenes/battle/battle_scene.tscn
```

There is no build step, linter, or test suite — GDScript is interpreted at runtime. Validate code by running the scene and watching the Godot output panel for errors.

## Architecture

### Boot Sequence

`project.godot` registers three autoloads that initialize before any scene:

1. **`SaveManager`** (`scripts/progression/save_manager.gd`) — loads or creates `user://optaktics_save.json`. Tracks `current_arc`, `current_battle`, character levels/XP, skill nodes, stat bonuses (growth rolls), and talent points.
2. **`GameManager`** (`scripts/progression/game_manager.gd`) — registers the 6 East Blue arc factories and injects saved player levels into each `BattleConfig` via `get_current_battle()`. Also runs `BalanceCalculator.report_all()` in debug builds.
3. **`InventoryManager`** (`scripts/progression/inventory_manager.gd`) — manages the shared consumable item stock. Items are usable in combat via the `USE_ITEM` action.

The entry point is `scenes/ui/main_menu.tscn`. From there, starting a campaign loads `scenes/battle/battle_scene.tscn`, which instantiates **`BattleManager`**. After each battle, `GameManager.advance_to_next_battle()` navigates to the next battle or back to the main menu if the campaign is complete.

### BattleManager State Machine

`scripts/battle/battle_manager.gd` is the core orchestrator. States flow as:

```
INIT → PRE_BATTLE_DIALOGUE → CALC_NEXT_TURN
  → PLAYER_CHOOSING ←→ ENEMY_TURN
  → EXECUTING_ACTION → CALC_NEXT_TURN (loop)
  → POST_BATTLE_DIALOGUE → VICTORY | DEFEAT
```

Each `_change_state()` call updates the HUD via signals. `CALC_NEXT_TURN` pops the next unit from `TurnManager`; if the queue is empty a new round is built.

### Turn System

`scripts/battle/turn_manager.gd` sorts living units by `agi_stat + randf_range(0, 2)` at the start of each round. Each unit gets **2 actions per turn** (MOVE + one ACTION, in any order). After both actions are spent, the unit enters WAITING state.

### Data Flow: Stats → Combat

```
UnitData (base stats + growth %)
  → Unit.setup(level)               # computes stat_at_level()
  → DamageCalculator.resolve()      # physical vs technical formula
    applies immunities/vulnerabilities from UnitData
  → Unit.take_damage() / receive_heal()
```

`scripts/data/unit_data.gd` is a Resource subclass holding base stats (PV, FOR, TEC, DEF, RES, AGI, VOL), growth rates, damage tag immunities/vulnerabilities, and boss flags.

`scripts/data/ability_data.gd` defines each skill: NRJ cost, range, AOE radius, damage type (SLASH/BLUNT/PIERCE/NONE), target type, status effect to apply, and knockback.

### Campaign Data (data/east_blue/)

`characters_data.gd` and `abilities_data.gd` are plain GDScript files returning dictionaries — **not** Resource files. Each `arc_0X_*.gd` file is a factory that returns a list of `BattleConfig` objects with enemy rosters, tile overrides, and dialogue strings.

### Signal Contracts

Key signals to be aware of when modifying systems:

| Signal | Emitter | Consumer |
|--------|---------|---------|
| `state_changed(new_state)` | BattleManager | BattleUI |
| `hp_changed(new_hp, max_hp)` | Unit | BattleUI / HpBar |
| `nrj_changed(new_nrj, max_nrj)` | Unit | BattleUI |
| `unit_died(unit)` | Unit | BattleManager (removes from TurnManager) |
| `damage_dealt(target, amount, type)` | BattleManager | BattleUI (floating numbers) |
| `action_selected(action_type)` | ActionMenu | BattleManager |

### Boss Mechanics (already implemented)

- **Buggy** — SLASH immunity via `damage_immunities` in UnitData
- **Kuro** — `activate_mille_mains(2)` doubles AGI; AOE hits all adjacent tiles
- **Krieg** — `_trigger_armor_break()` at 50% HP: permanent WEAKENED + DEF halved
- **Arlong** — `water_regen()` at turn start on WATER tiles: +15 PV
- **Smoker** — 0.5× multiplier on all physical tags via `damage_vulnerabilities`

### Status Effects

Managed by `scripts/battle/status_manager.gd`. 7 effects: STUN (skip turn), BURN (5% max PV/turn), FROZEN (immobile + DEF×2), BLIND (−40% hit), WEAKENED (FOR −30%), BUFFED (FOR +30%), HASTED (AGI ×1.50). Duration ticks at end of each unit's turn.

## Current Priorities (from TODO.md)

**High:** Boss phase transitions (Buggy INVINCIBLE status, Kuro phase 2 at 60% HP, Arlong repositioning), skill tree system (files to create: `scripts/data/skill_tree_data.gd`, `scripts/data/skill_node.gd`, `scripts/progression/progression_manager.gd`, `scripts/ui/skill_tree_ui.gd`).

**Medium:** Interlude screen between arcs (Going Merry), equipment system (3 slots per character: Arme/Armure/Accessoire), Arc 01 B2 Base Marine + Morgan fight, git conflict markers still present in `scripts/ui/hp_bar.gd` (need cleanup).

## Conventions

- Stats use French abbreviations in data (PV, FOR, TEC, DEF, RES, AGI, VOL) — keep these consistent.
- Dialogue strings in arc data files are in French — new dialogue should match.
- Enemy rosters are built via `ArchetypeData` factory methods in `scripts/data/archetype_data.gd` — prefer those over hand-crafting stats for generic enemies. Available archetypes: `tank`, `dps_melee_slash`, `dps_melee_blunt`, `dps_ranged` (range 4, PIERCE), `healer`.
- XP formula: `ceil(80 × N^1.5)` XP required to go from level N to N+1. Talent points: 1 per arc cleared.
- Straw Hat stats are stored as `base + stat_bonuses` in the save file (probabilistic growth rolls). Enemy stats are computed on the fly via `UnitData.stat_at_level()` (deterministic).
