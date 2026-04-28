# Optaktics — One Piece Tactics | TODO

---

## DESIGN — Courbe de difficulté

### Principe
11 batailles sur 6 arcs, progression linéaire de TROP FACILE à TROP DUR.
Les batailles B1 de chaque arc sont des introductions ; les B2 montent la pression.
Chaque arc introduit un nouvel équipier → le joueur apprend ses mécaniques dans la B1.

### Système BalanceCalculator
Score PC d'une unité au niveau N :

```
durabilité  = PV × (1 + (DEF + RES) / 30)
offense     = max(FOR, TEC) × meilleur_multiplicateur_skill
tempo       = 1 + AGI / 40
bonus_range = ×1.0 (portée 1) | ×1.15 (portée 2-3) | ×1.30 (portée ≥4)
PC          = (durabilité × offense × tempo × bonus_range) / 1000

ratio_stats   = Σ PC_ennemis / Σ PC_joueurs
ratio_count   = nb_ennemis / nb_joueurs
ratio_effectif = ratio_stats × √(ratio_count)
```

`BalanceCalculator.report_all()` s'exécute au démarrage en debug build.

### Cibles par bataille

| #  | Arc — Bataille                     | Ratio eff cible | Verdict cible |
|----|------------------------------------|-----------------|---------------|
| 01 | Romance Dawn — Taverne (tutoriel)  | ~0.40           | TROP FACILE   |
| 02 | Romance Dawn — Base Marine         | ~0.70           | Facile        |
| 03 | Orange Town — Entrée               | ~0.80           | Facile        |
| 04 | Orange Town — Buggy (boss 1)       | ~1.00           | Équilibré     |
| 05 | Syrup Village — Colline            | ~1.00           | Équilibré     |
| 06 | Syrup Village — Kuro (boss 2)      | ~1.15           | Difficile     |
| 07 | Baratie — Défense du pont          | ~0.95           | Équilibré     |
| 08 | Baratie — Krieg (boss 3)           | ~1.20           | Difficile     |
| 09 | Arlong Park — Portail              | ~1.20           | Difficile     |
| 10 | Arlong Park — Arlong (boss 4)      | ~1.30           | Difficile     |
| 11 | Loguetown — Smoker (boss final)    | ~1.38           | TROP DUR      |

### Leviers d'ajustement
1. **Nombre d'ennemis** — levier principal (impacte ratio_count via √)
2. **Niveau des ennemis** — ajustement fin des stats
3. **Composition typologique** — Tireurs (range ×1.30) > DPS mêlée > Tanks

---

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

#### Arc 01 — Romance Dawn (révisions futures)
- [ ] **Base Marine — Redesign philosophie** : beaucoup d'ennemis faibles plutôt que peu d'ennemis forts
  - L'idée : le joueur apprend à gérer les positions et l'économie d'actions face à un nombre supérieur
  - Concept : 6–7 marines L1 très faibles (PV bas, pas de skill) vs Luffy+Zoro L4
  - Chaque marine seul est non-menaçant, mais en groupe ils submergent si mal géré
  - Ajuster les taux de croissance des archétypes ou créer un archétype "Recrue Marine" avec stats minimales
- [ ] **Combat contre Morgan** — Ajouter un 3e combat à Arc 01 (ou boss de B2 après avoir défait les marines)
  - Morgan : Capitaine de la base, hache géante, bras métallique (BLUNT, portée 1 étendue)
  - Mécanique possible : après avoir battu les marines, Morgan arrive en renfort → vague 2
  - Stats suggérées : HP moyen, FOR très élevée, DEF haute, AGI faible (boss tanky mais lent)
  - Cible difficulté : FACILE-ÉQUILIBRÉ pour clôturer Arc 01 proprement

#### Autres arcs
- [ ] **Arc 07+** — Arabasta, Skypiea, Water 7 (hors scope East Blue mais prévoir la structure)
- [ ] **Sous-boss** — Ajouter Pearl (Baratie), Django (Syrup Village) comme combats intermédiaires

#### Entre les combats — Écran d'interlude *(voir section DESIGN)*

### UI / UX
- [ ] **Résoudre les conflits de fusion dans les fichiers UI** — `hp_bar.gd`, `battle_ui.gd` contiennent encore des marqueurs de conflit git (à nettoyer)
- [ ] **Aperçu des dégâts** — Afficher les dégâts estimés avant de confirmer une attaque
- [ ] **Indicateur de portée des compétences** — Overlay visuel distinct pour portée vs zone d'effet

---

## DESIGN — Entre les combats

### Décision : écran d'interlude sur le Going Merry

**Rejeté :** monde semi-ouvert (trop coûteux, hors scope, risque de diluer le focus tactique)

**Retenu :** écran d'interlude narratif entre chaque arc, avec 3 zones cliquables :

```
┌─────────────────────────────────────────────┐
│  [Carte du monde] — position de l'équipage  │
│                                             │
│  [Going Merry — pont]                       │
│    → Dialogue court entre 2 personnages     │
│    → Reflet de l'arc qui vient de se passer │
│                                             │
│  [Arbre de compétences]                     │
│    → Dépenser les Points de Talent gagnés   │
│                                             │
│  [Boutique / Objets] ← à concevoir          │
│    → Acheter/gérer les objets               │
│                                             │
│  [Continuer] → prochain arc                 │
└─────────────────────────────────────────────┘
```

### Option FFT — Carte en nœuds + combats aléatoires
*(À évaluer — scope plus large mais apport réel)*

FFT utilise une carte monde en nœuds (pas d'exploration libre) :
- Nœuds fixes : villes (boutique, recrutement) + lieux de bataille scénarisés
- Routes entre nœuds : combats aléatoires optionnels pour grinder
- Narration 100% dans les cutscenes pré/post combat (PNJ muets en ville)

**Apport pour Optaktics :** les combats aléatoires donneraient du grind optionnel
sans forcer — le joueur sous-leveled peut rattraper. Procédural ou pool de configs
prédéfinies (plus simple).

**Coût :** carte interactive, système de déplacement, génération de combats → feature à part entière, pas un ajout mineur.

**Décision provisoire :** garder l'interlude simple pour le scope East Blue,
réévaluer si on étend à Arabasta+.

**Entre deux batailles d'un même arc** : pas d'écran, juste les dialogues post/pré bataille existants — suffit pour la narration.

**Carte du monde** : vue simplifiée East Blue (pas interactive), montre juste la route Fushia → Loguetown. Pas de déplacement libre, pas de PNJ. Simple image avec position actuelle mise en avant.

**Pourquoi pas le monde semi-ouvert :**
- Nécessiterait exploration, collisions, PNJ, boutiques, transitions de scène → scope ×3
- Le rythme tactique (combat → décision → combat) est le cœur du jeu
- Fire Emblem Three Houses a prouvé que le hub peut devenir une charge narrative — à éviter pour un premier scope

**Fichiers à créer :**
- `scripts/ui/interlude_screen.gd` — scène Godot entre les arcs
- `data/east_blue/interludes.gd` — dialogues des interludes par arc
- Image/scène Going Merry (placeholder acceptable)

---

## DESIGN — Système d'objets

### Décisions arrêtées

**Deux catégories :**

**Consommables** — utilisés en combat, coûtent 1 action
- Exemples : Viande (+PV), Potion (+PV moindre), Antidote (retire statut négatif), Étoile fumée (BLIND zone), Coup de fouet (BUFFED 2 tours)
- Stockés dans un inventaire commun (pas par personnage)
- Usage : action `USE_ITEM` dans le menu combat, cible selon l'objet (soi-même / allié / ennemi)

**Équipements** — passifs, boostent les stats, équipés hors combat dans l'interlude
- 3 slots par personnage : Arme, Armure, Accessoire
- **Arme** : booste FOR ou TEC (+X flat)
- **Armure** : booste DEF et/ou RES (+X flat)
- **Accessoire** : bonus spécial (AGI+, PV max+, résistance statut, portée+1…)
- Exemples thématiques : Épée de Zoro (FOR+), Climatact de Nami (TEC+, portée+1), Cuissardes de Sanji (AGI+)

**Acquisition :**
- Drop de combat (% sur certains ennemis, surtout boss)
- Boutique dans l'interlude (Berrys gagnés après victoires)

### Consommables — Implémenté
- [x] `item_data.gd` — Resource (heal HP, restore NRJ, apply status, target SELF/ALLY/ENEMY)
- [x] `items_catalog.gd` — 11 objets : 4 nourritures, 3 alcools, 2 boosts (BUFFED/HASTED), 2 débuffs
- [x] `inventory_manager.gd` — Autoload (stock mémoire, stock de test pré-rempli)
- [x] `status_manager.gd` — Nouveau status HASTED (AGI ×1.50)
- [x] `unit.gd` — `restore_nrj()` + `effective_agi()` HASTED-aware
- [x] `action_menu.gd` — Bouton "Objet" + sous-menu quantités
- [x] `battle_manager.gd` — État PLAYER_SELECT_ITEM_TARGET + résolution d'objet
- [x] `project.godot` — InventoryManager autoload

### Consommables — Suite
- [ ] Brancher sur SaveManager (persistance inventaire entre combats)
- [ ] Gain de Berrys à la fin des combats + drop aléatoire sur ennemis
- [ ] Intégrer dans l'interlude screen (boutique + inventaire)

### Équipements — À faire
- [ ] `unit.gd` — 3 slots (ARME/ARMURE/ACCESSOIRE), modificateurs additifs sur stats
- [ ] Exemples : Épée de Zoro (FOR+), Climatact de Nami (TEC+, portée+1), Cuissardes de Sanji (AGI+)
- [ ] Interlude screen — onglet équipements par personnage
- [ ] `BalanceCalculator` — intégrer bonus équipements dans le score PC

### Risques
- Les équipements doivent rester optionnels : aucun combat ne doit être impossible sans équipement spécifique

### Graphismes — Asset packs (décision : packs modifiés, sprites custom plus tard)

- [ ] **Étape 1 — Tileset grille** — Télécharger Kenney Tiny Dungeon (kenney.nl/assets/tiny-dungeon, CC0, 16×16). Réécrire `GridManager` pour utiliser `TileMapLayer` au lieu des `ColorRect`. Mapper les tiles : herbe→NORMAL, eau→WATER, pierre→ELEVATED, etc.
- [ ] **Étape 2 — Icônes personnages** — Portraits 64×64 par personnage (game-icons.net pour les icônes pirates, ou dessin Krita). Remplacer le `Label` lettre dans `unit.gd/_build_visuals()` par un `Sprite2D`.
- [ ] **Étape 3 — UI** — Remplacer les `PanelContainer` gris par une `StyleBoxTexture` cadre parchemin marin (Kenney UI pack).

---

## PRIORITÉ BASSE / FUTUR

- [ ] **Mode histoire complet** — Rejouer depuis le début, arcs enchaînés
- [ ] **Difficulté ajustable** — Modificateur global sur stats ennemies (×0.8 Facile / ×1.0 Normal / ×1.2 Difficile)
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
- [x] **BalanceCalculator** — score PC par unité + ratio effectif (stats × √count) + rapport console au démarrage debug
- [x] **Courbe de difficulté définie** — 11 cibles de ratio eff de ~0.40 (tutoriel) à ~1.38 (boss final)
- [x] **Compositions de batailles rééquilibrées** — Arc01-B2, Arc02-B2, Arc04-B1, Arc05-B1 ajustés
