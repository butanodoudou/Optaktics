# Optaktics — One Piece Tactics | TODO

## PRIORITÉ HAUTE

### Boss — Techniques uniques
Chaque boss doit avoir une mécanique de combat distincte, pas seulement des stats.

- [ ] **Buggy** — `Bara Bara no Mi` : immunité SLASH déjà en place, mais ajouter :
  - Technique `Bara Bara Festival` : se sépare en morceaux → devient intouchable 1 tour (Status INVINCIBLE à créer)
  - Déclencheur réaction : quand HP < 50%, active automatiquement Bara Bara Festival
- [ ] **Kuro** — `Mille Mains` déjà en place, mais ajouter :
  - Phase 1 (HP > 60%) : combattant normal avec Cat Claws (SLASH, portée 1)
  - Phase 2 (HP ≤ 60%) : active Mille Mains → AGI×2, attaque toutes les unités adjacentes chaque tour (AOE automatique)
  - À implémenter : `_check_phase_transition()` dans `unit.gd` ou `battle_manager.gd`
- [ ] **Krieg** — Cassure d'armure à 50% HP déjà en place, à compléter :
  - Avant cassure : DEF très haute (armure MH5), attaques BLUNT seulement lui font des vrais dégâts
  - Après cassure : WEAKENED permanent + vulnérabilité à tout
  - Ajouter technique `Bombe à Gaz` : AOE poison (WEAKENED 2 tours, portée 3)
  - Ajouter réaction `Épines Pearl` : riposte PIERCE quand frappé (déléguer à Pearl en sous-boss)
- [ ] **Arlong** — Régénération sur eau déjà en place, à compléter :
  - Technique `Kiribachi` : SLASH AOE en ligne, ignore DEF
  - Technique `Shark on Tooth` : téléporte Arlong sur une case eau adjacente à la cible (repositionnement tactique)
  - Stratégie clé : forcer Arlong hors des cases eau pour bloquer sa régénération
- [ ] **Smoker** — Corps Logia (résistances ×0.5) déjà en place, à compléter :
  - Technique `White Chase` : charge en ligne droite, pousse toutes les unités sur le chemin (knockback)
  - Immunité totale aux attaques PIERCE (Logia upgrade)
  - Seul Luffy (BLUNT / sans Haki mais corps caoutchouc) peut le blesser normalement → cas spécial à coder

---

### Système d'arbre de compétences
Progression des Straw Hats entre les arcs.

- [ ] **Design** : définir la structure de l'arbre
  - Nœuds = compétences débloquables (pas de progression par niveau, mais par victoire de combat / arc)
  - 2–3 branches par personnage (ex. Luffy : Puissance brute / Vitesse / Endurance)
  - Chaque arc débloque de nouveaux nœuds disponibles
  - Coût : Points de Talent gagnés après chaque arc (pas de grind, progression narrative)

- [ ] **Fichiers à créer** :
  - `scripts/data/skill_tree_data.gd` — Resource : nœuds, prérequis, coût, effet
  - `scripts/data/skill_node.gd` — Un nœud individuel (id, display_name, description, ability_unlocked, stat_bonus, prerequisite_ids)
  - `scripts/progression/progression_manager.gd` — Autoload : garde en mémoire les nœuds débloqués par run
  - `scripts/ui/skill_tree_ui.gd` — Écran entre les batailles

- [ ] **Arbres par personnage** *(à rédiger)*
  - Luffy : Gomu Gomu no Pistol → Bazooka → Gatling | Rubber Guard | Endurance (PV+)
  - Zoro : Oni Giri → Tora Giri | Dragon Twister | Santoryu (FOR+)
  - Nami : Climatact basique → Thunderbolt Tempo | Brume aveuglante | Clima-Tact amélioré
  - Usopp : Tir de base → Firebird Star → Kabuto Shot | Tir longue portée (AGI+)
  - Sanji : Collier Shoot → Mutton Shot | Flambage (réaction) | Diable Jambe (arc post-East Blue)

---

## PRIORITÉ MOYENNE

### Gameplay
- [x] **Système de sauvegarde** — `SaveManager` + `GameManager` autoloads, JSON persistant
- [ ] **Écran entre les batailles** — Sélection arbre de compétences + dialogue de transition narrative
- [ ] **Dialogue narratif** — Améliorer le système de dialogue pré/post bataille (portraits, boîte stylisée)
- [ ] **Caméra** — Zoom sur les unités qui agissent, suivi du combat
- [ ] **Animations de combat** — Sprites placeholder → animations directionnelles (idle, move, attack)
- [ ] **Sons / Musique** — Intégrer des pistes libres de droits One Piece-inspired

### Contenu
- [x] **Arc 01 Romance Dawn** — Rééquilibré : Pirates Rouges niv.20 vs 13 bandits niv.4, décor extérieur, dialogues lore-fidèles
- [ ] **Arc 07+** — Arabasta, Skypiea, Water 7 (hors scope East Blue mais prévoir la structure)
- [ ] **Sous-boss** — Ajouter Pearl (Baratie), Django (Syrup Village) comme combats intermédiaires

### UI / UX
- [ ] **Résoudre les conflits de fusion dans les fichiers UI** — `hp_bar.gd`, `battle_ui.gd` contiennent encore des marqueurs de conflit git (à nettoyer)
- [ ] **Aperçu des dégâts** — Afficher les dégâts estimés avant de confirmer une attaque
- [ ] **Indicateur de portée des compétences** — Overlay visuel distinct pour portée vs zone d'effet

---

### Graphismes — Asset packs (décision : packs modifiés, sprites custom plus tard)

- [ ] **Étape 1 — Tileset grille** — Télécharger Kenney Tiny Dungeon (kenney.nl/assets/tiny-dungeon, CC0, 16×16). Réécrire `GridManager` pour utiliser `TileMapLayer` au lieu des `ColorRect`. Mapper les tiles : herbe→NORMAL, eau→WATER, pierre→ELEVATED, etc.
- [ ] **Étape 2 — Icônes personnages** — Portraits 64×64 par personnage (game-icons.net pour les icônes pirates, ou dessin Krita). Remplacer le `Label` lettre dans `unit.gd/_build_visuals()` par un `Sprite2D`.
- [ ] **Étape 3 — UI** — Remplacer les `PanelContainer` gris par une `StyleBoxTexture` cadre parchemin marin (Kenney UI pack).

---

## PRIORITÉ BASSE / FUTUR

- [ ] **Mode histoire complet** — Rejouer depuis le début, arcs enchaînés
- [ ] **Difficulté ajustable** — Modificateur global sur stats ennemies
- [ ] **Export HTML5 / itch.io** — Tester et publier
- [ ] **Alabasta saga** — Grand Line commence
- [ ] **Localization** — Passer tout en français cohérent (certains dialogues encore en anglais)

---

## FAIT

- [x] Architecture de base Godot 4 (project.godot, autoload GameManager)
- [x] Système à 7 stats + taux de croissance (Fire Emblem style)
- [x] Système NRJ (remplace MP) + régénération par tour
- [x] 2 actions par tour (MOVE + ACTION dans n'importe quel ordre)
- [x] Formules de dégâts centralisées (DamageCalculator)
- [x] Effets de statut : STUN, BURN, FROZEN, BLIND, WEAKENED, BUFFED
- [x] Archetypes ennemis génériques (ArchetypeData : Tank, DPS Slash/Blunt/Ranged, Support)
- [x] Mécaniques de boss de base (immunités, armor break, water regen, Mille Mains)
- [x] 5 Straw Hats avec compétences East Blue (sans Gear/Diable Jambe/Clima-Tact)
- [x] 6 arcs East Blue configurés avec dialogues en français et niveaux par unité
- [x] Système de tour AGI-based avec variance aléatoire par round
