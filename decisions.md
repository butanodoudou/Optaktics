# Optaktics — Décisions de design

Ce fichier documente les choix structurants du projet : ce qui a été retenu, ce qui a été rejeté, et pourquoi.

---

## Système de stats

### Décision : 7 stats (PV / FOR / TEC / DEF / RES / AGI / VOL)

**Retenu** plutôt que le classique 5-stats (PV / ATK / DEF / SPD / MAG).

**Pourquoi :**
- Séparation FOR/TEC permet des unités hybrides et des skills qui contournent la défense physique (TEC ignore DEF, attaque RES)
- Séparation DEF/RES permet de différencier les types de menace (guerriers vs mages)
- VOL alimente le NRJ max → la volonté des personnages est narrative ET mécanique
- AGI fait deux choses (ordre de tour + précision) sans ajouter une 8e stat

**Rejeté :** STR/MAG séparés avec une stat SPEED indépendante → trop de stats à gérer pour un scope East Blue.

---

## Système de tour

### Décision : AGI-based avec variance aléatoire par round

**Retenu** plutôt qu'un ordre CTB pur (Final Fantasy X) ou un ordre fixe par round (Fire Emblem).

**Pourquoi :**
- CTB pur = les unités rapides dominent mécaniquement, difficulté à équilibrer
- Ordre fixe = prévisible, aucune surprise tactique
- AGI + variance = les unités rapides passent en premier **la plupart du temps**, mais pas toujours. Crée de la tension sans trahir l'attente du joueur

---

## Système NRJ

### Décision : NRJ qui régénère (+3/tour) plutôt que MP fixes

**Retenu** plutôt que MP à usage limité avec régénération hors combat.

**Pourquoi :**
- Dans un jeu tactique sans repos entre les batailles, les MP fixes punissent trop sévèrement l'usage des skills
- NRJ qui régénère force le joueur à décider *quand* utiliser les skills forts (pic offensif vs conservation)
- Thématiquement cohérent avec la Volonté comme ressource narrative

**Contrainte retenue :** l'attaque basique est toujours gratuite (0 NRJ, ne consomme pas l'action). Garantit qu'une unité à 0 NRJ reste toujours utile.

---

## Progression des personnages

### Décision : growth rates probabilistes par personnage

**Retenu** plutôt qu'une formule déterministe `base + ceil(growth/100 * N * scale)`.

**Pourquoi :**
- Formule déterministe = chaque run identique, aucune variété
- Probabiliste = chaque run légèrement différent (Luffy peut finir FOR-heavy ou AGI-heavy), sentiment de personnage vivant
- Fire Emblem utilise ce système pour la même raison

**Implémentation :** les stats réelles des Straw Hats sont stockées en save file (base + bonuses accumulés). Les ennemis gardent la formule déterministe (pas besoin de variance côté ennemi).

**Stats ennemis non-probabilistes :** délibéré — les ennemis sont équilibrés selon la formule ; les rendre aléatoires casserait le BalanceCalculator.

---

### Décision : XP = pool complet par personnage (pas de division)

**Retenu** plutôt que XP divisée entre les survivants.

**Pourquoi :**
- Division punit les petites équipes et encourage le "kill-stealing"
- Pool complet = chaque personnage est récompensé pour sa participation, même faible
- Les multiplicateurs de contribution (×0.70–1.30) créent quand même de la différenciation entre un tank et un DPS actif
- Référence : Fire Emblem, où chaque unité reçoit son XP indépendamment

**Contrainte retenue :** facteur survie = 0.0 si mort à la fin du combat. Mourir a des conséquences concrètes sur la progression, sans être punitif en terme de session (pas de permadeath).

---

### Décision : courbe XP `ceil(80 × N^1.5)` 

**Retenu** plutôt que linéaire (`50 × N`) ou exponentielle pure (`A × B^N`).

**Pourquoi :**
- Linéaire : trop douce, les derniers niveaux arrivent aussi vite que les premiers
- Exponentielle pure : explose au-delà de L15 pour un scope 20 niveaux
- `N^1.5` : premiers niveaux rapides (récompense précoce), derniers niveaux demandent plusieurs combats. Standard Fire Emblem / RPG moderne

---

### Décision : Luffy et Zoro démarrent à L3

**Pourquoi :** Arc 01 B2 est calibré pour ~L4. Initialiser à L1 laisse un gap de progression perceptible dès la première bataille. Luffy et Zoro ont déjà "combattu et voyagé" avant le début de la campagne.

Les autres Straw Hats démarrent à L1 et montent naturellement jusqu'à leur arc d'introduction.

---

## Équilibre des batailles

### Décision : BalanceCalculator avec ratio effectif = ratio_stats × √ratio_count

**Retenu** plutôt que ratio_stats seul ou ratio_count seul.

**Pourquoi :**
- `ratio_stats` seul ignore que 4 ennemis faibles agissent 4 fois pour 2 joueurs qui agissent 2 fois → sous-estime l'avantage numérique
- `ratio_count` linéaire exagère : avoir 6 ennemis vs 2 joueurs n'est pas 3× plus dur (le joueur place et focus bien)
- `√ratio_count` capture l'avantage d'action economy sans l'exagérer. Calibré empiriquement contre les ratios cibles

---

## Structure de la campagne

### Décision : écran d'interlude simple (Going Merry) entre les arcs

**Retenu** plutôt que monde semi-ouvert ou carte FFT en nœuds.

**Monde semi-ouvert rejeté :**
- Exploration libre, collisions, PNJ, boutiques, transitions → scope ×3
- Dilue le focus tactique qui est le cœur du jeu
- Fire Emblem Three Houses a montré que le hub peut devenir une charge narrative à maintenir

**Carte FFT en nœuds rejeté (pour East Blue) :**
- Combats aléatoires optionnels = feature à part entière (génération procédurale ou pool de configs)
- Valeur ajoutée réelle, mais hors scope pour un premier arc
- À réévaluer si on étend à Arabasta+

**Interlude retenu :** 3 zones cliquables (dialogue Going Merry, arbre de compétences, boutique) + carte non-interactive. Suffit pour l'East Blue.

**Entre deux batailles du même arc :** pas d'écran. Les dialogues pré/post bataille suffisent pour la narration. Ajouter un écran créerait une friction inutile.

---

## Objets

### Décision : deux catégories (consommables + équipements)

**Pourquoi :**
- Consommables en combat = décisions tactiques en session (utiliser maintenant ou économiser ?)
- Équipements hors combat = décisions de build entre les arcs
- Séparer les deux évite de saturer le menu combat avec de la gestion d'équipement

**Contrainte retenue :** aucun combat ne doit être impossible sans équipement spécifique. Les équipements sont un bonus, pas une requirement.

---

## Mécaniques de boss

### Décision : une mécanique unique par boss (pas seulement des stats plus hautes)

**Pourquoi :**
- Un boss avec juste des stats ×2 n'enseigne rien de nouveau
- Chaque mécanique force une stratégie différente ET reflète le lore :
  - Buggy : invincible aux slashes (corps séparable) → forcer les dégâts techniques
  - Kuro : AGI ×2 et AOE automatique → gérer les positions, ne pas se regrouper
  - Krieg : cassure d'armure à 50% PV → transition de phase, changer de stratégie mid-combat
  - Arlong : regen sur l'eau → contrôle du terrain, le forcer hors des cases eau
  - Smoker : corps Logia, dégâts physiques ×0.5 → seul Luffy peut le blesser normalement (cas spécial)

---

## Navigation / Flux de scènes

### Décision : `main_menu.tscn` comme point d'entrée (pas `battle_scene.tscn`)

**Retenu** plutôt que démarrer directement en combat.

**Pourquoi :**
- Démarrer directement en combat était pratique en dev early-stage, mais le joueur n'a aucun contexte (pas de menu, pas de nouvelle partie, pas de continue)
- Le menu principal est le seul endroit logique pour initialiser le save ou charger une partie existante avant toute scène de jeu
- `advance_to_next_battle()` renvoie au menu si la campagne est terminée — cohérent avec le menu comme ancre de navigation

**Flux complet :** `main_menu.tscn` → (nouvelle partie / continuer) → `battle_scene.tscn` → (victoire/défaite) → `battle_scene.tscn` suivante ou retour `main_menu.tscn`.

---

## Technique / Architecture

### Décision : stats ennemis calculées à la volée vs stats joueurs sauvegardées

**Stats ennemis :** calculées à la volée via `UnitData.stat_at_level(base, growth, level)` — formule déterministe. Pas de save nécessaire, parfaitement reproductible.

**Stats joueurs :** stockées en save file comme `base_stat + stat_bonuses` (bonuses accumulés par les growth rolls probabilistes). Nécessaire pour préserver la variance entre les runs.

**Pourquoi ne pas tout calculer à la volée :** les growth rolls probabilistes sont aléatoires au moment du level-up. Sans save, relancer le jeu recalculerait des valeurs différentes → incohérence.

---

### Décision : `SaveManager` et `GameManager` comme Autoloads séparés

- `SaveManager` : I/O pure (JSON, pas de logique de jeu)
- `GameManager` : logique de campagne (ordre des arcs, injection des niveaux sauvegardés dans les configs)

**Pourquoi séparés :** `GameManager` a besoin de `SaveManager`, mais pas l'inverse. La séparation permet de tester la sauvegarde sans instancier la campagne, et vice versa.

---

### Décision : `BalanceCalculator` s'exécute automatiquement en debug build

```gdscript
if OS.is_debug_build():
    BalanceCalculator.report_all(_arcs)
```

Chaque lancement en mode debug affiche le rapport d'équilibre complet dans la console. Zéro friction pour vérifier l'impact d'un changement de stats ou de niveau.
