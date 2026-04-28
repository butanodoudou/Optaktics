# Optaktics — One Piece Tactics | Design Document

**Moteur :** Godot 4  
**Genre :** RPG tactique au tour par tour (Fire Emblem / Final Fantasy Tactics)  
**Scope actuel :** East Blue (6 arcs, 11 batailles)  
**Langue :** Français

---

## Vue d'ensemble

Optaktics est un RPG tactique sur fond de One Piece. Le joueur commande les Straw Hats case par case sur des grilles de combat, en progressant à travers les arcs de l'East Blue. Chaque arc introduit un nouvel équipier et se termine par un boss à mécanique unique.

Le rythme est **combat → décision (interlude) → combat**. Pas d'exploration libre. Le focus est exclusivement tactique.

---

## Campagne

### Structure

11 batailles sur 6 arcs. Progression linéaire, difficulté croissante de ×0.40 (tutoriel) à ×1.38 (boss final).

| Arc | Batailles | Boss | Équipier introduit |
|-----|-----------|------|-------------------|
| 01 — Romance Dawn   | B1 Taverne (tutoriel), B2 Base Marine | — | Zoro |
| 02 — Orange Town    | B1 Entrée, B2 Buggy          | Buggy       | Nami  |
| 03 — Syrup Village  | B1 Colline, B2 Kuro          | Kuro        | Usopp |
| 04 — Baratie        | B1 Restaurant, B2 Krieg      | Don Krieg   | Sanji |
| 05 — Arlong Park    | B1 Portail, B2 Arlong        | Arlong      | —     |
| 06 — Loguetown      | B1 Smoker                    | Smoker      | —     |

---

## Statistiques

7 stats par unité + 1 stat de déplacement :

| Stat | Rôle |
|------|------|
| **PV** | Points de vie |
| **FOR** | Force physique — dégâts PHYSICAL |
| **TEC** | Technique — dégâts TECHNICAL |
| **DEF** | Défense physique — réduit les dégâts PHYSICAL (÷2) |
| **RES** | Résistance — réduit les dégâts TECHNICAL (÷2) |
| **AGI** | Agilité — ordre de tour + taux de toucher/esquive |
| **VOL** | Volonté — NRJ max = ceil(VOL ÷ 2) |
| **MOV** | Cases de déplacement par tour |

---

## Système de combat

### Tour par tour (AGI-based)

L'ordre de passage est calculé par `TurnManager` via un score AGI avec variance aléatoire par round. Une unité agit quand son score de charge dépasse le seuil. Les unités rapides peuvent agir plusieurs fois avant les lentes.

### 2 actions par tour

Chaque unité peut **MOVE** et **ACT** dans n'importe quel ordre. Une fois les deux faites (ou l'action "Attendre" choisie), l'unité est WAITING jusqu'au prochain round.

### Formules de dégâts

```
# Physique
raw      = FOR × multiplicateur_skill
mitigation = DEF ÷ 2
base_dmg = max(1, raw − mitigation)
dégâts   = max(1, round(base_dmg × variance[0.92–1.08] × tag_mult))

# Technique
idem mais TEC vs RES

# Soin
soin = max(1, round(VOL × multiplicateur × variance[0.92–1.08]))
```

**Tags de dégâts** : SLASH / BLUNT / PIERCE / NONE — chaque unité peut avoir des immunités ou vulnérabilités par tag.

### Taux de toucher

```
taux = 0.85 + (AGI_attaquant − AGI_défenseur) × 0.03
taux clampé : [0.10 – 0.99]
```

BLIND applique un malus supplémentaire sur le taux.

### Énergie (NRJ)

Remplace les MP. Régénère de +3 par début de tour. Les skills coûtent 1–4 NRJ. NRJ max = `ceil(VOL ÷ 2)`. L'attaque basique est toujours gratuite (0 NRJ, n'épuise pas l'action).

---

## Effets de statut

| Statut | Effet |
|--------|-------|
| STUN     | Passe le tour entier |
| BURN     | Dégâts en fin de tour (`max(1, PV_max × BURN_PERCENT)`) |
| FROZEN   | Impossible de se déplacer ce tour ; DEF ×2 |
| BLIND    | Malus taux de toucher |
| WEAKENED | FOR et TEC réduits |
| BUFFED   | FOR et TEC augmentés |
| HASTED   | AGI ×1.50 |

---

## Progression des personnages

### Niveaux et XP

**Courbe XP :** `ceil(80 × N^1.5)` pour passer du niveau N à N+1.

| Niveau → | 2   | 5    | 10    | 15     | 20      |
|----------|-----|------|-------|--------|---------|
| XP requis | 80  | 450  | 1 270 | 2 330  | 3 578   |
| Cumul    | 80  | 6 680 | 38 670 | 108 800 | 218 000 |

**Distribution XP :** Chaque personnage présent en combat reçoit le **pool complet** (somme des `exp_reward` de tous les ennemis tués), modulé par :

```
score_combat = kills × 40 + dégâts_infligés × 0.4 + dégâts_reçus × 0.2
             + soins × 0.4 + statuts_appliqués × 20

ratio        = score_propre / score_max_équipe    # 0.0 → 1.0
facteur_contrib = lerp(0.70, 1.30, ratio)         # clampé 0.70–1.30
facteur_survie  = 1.0 (vivant) | 0.0 (mort à la fin)

XP final = round(pool × facteur_contrib × facteur_survie)
```

### Growth rates (progression probabiliste)

À chaque niveau gagné, chaque stat a X% de chance de gagner +1. Résultat unique par partie.

| Personnage | PV | FOR | TEC | DEF | RES | AGI | VOL | Profil |
|-----------|-----|-----|-----|-----|-----|-----|-----|--------|
| Luffy     | 70% | 65% | 20% | 45% | 25% | 60% | 40% | Bruiser explosif |
| Zoro      | 50% | 75% | 35% | 65% | 20% | 45% | 30% | Offensif/défensif pur |
| Nami      | 30% | 15% | 70% | 25% | 35% | 55% | 65% | Support tactique |
| Usopp     | 50% | 30% | 55% | 25% | 40% | 55% | 50% | Tireur polyvalent |
| Sanji     | 60% | 65% | 25% | 40% | 30% | 60% | 40% | DPS mobile |

Les stats réelles sont stockées en save file (`base_stat + bonuses_accumulés`). Les ennemis utilisent toujours la formule déterministe.

### Niveaux de départ (nouvelle partie)

- **Luffy, Zoro** : L3 (déjà entraînés avant Arc 01)
- **Autres Straw Hats** : L1, progressent naturellement jusqu'à leur arc d'introduction

---

## Équilibre des batailles

### BalanceCalculator

Score de Puissance de Combat (PC) par unité :

```
durabilité  = PV × (1 + (DEF + RES) / 30)
offense     = max(FOR, TEC) × meilleur_multiplicateur_skill
tempo       = 1 + AGI / 40
bonus_range = ×1.0 (portée 1) | ×1.15 (portée 2–3) | ×1.30 (portée ≥4)
PC          = (durabilité × offense × tempo × bonus_range) / 1000

ratio_effectif = (ΣPC_ennemis / ΣPC_joueurs) × √(nb_ennemis / nb_joueurs)
```

Le `√ratio_count` capture l'avantage d'économie d'action sans l'exagérer.

**Verdicts :**

| Ratio eff | Verdict |
|-----------|---------|
| < 0.60    | TROP FACILE |
| < 0.80    | Facile |
| ≤ 1.10    | Équilibré |
| ≤ 1.35    | Difficile |
| > 1.35    | TROP DUR |

### Cibles de difficulté

| Bataille | Ratio cible | Verdict |
|----------|-------------|---------|
| Romance Dawn B1 (tutoriel) | ~0.40 | TROP FACILE |
| Romance Dawn B2 | ~0.70 | Facile |
| Orange Town B1  | ~0.80 | Facile |
| Orange Town B2 (Buggy)   | ~1.00 | Équilibré |
| Syrup Village B1 | ~1.00 | Équilibré |
| Syrup Village B2 (Kuro)  | ~1.15 | Difficile |
| Baratie B1       | ~0.95 | Équilibré |
| Baratie B2 (Krieg)       | ~1.20 | Difficile |
| Arlong Park B1   | ~1.20 | Difficile |
| Arlong Park B2 (Arlong)  | ~1.30 | Difficile |
| Loguetown (Smoker)       | ~1.38 | TROP DUR |

---

## Mécaniques des boss

Chaque boss a une mécanique unique qui force une stratégie différente.

| Boss | Mécanique |
|------|-----------|
| **Buggy**  | Immunité SLASH. Bara Bara Festival : invincible 1 tour si HP < 50% |
| **Kuro**   | Mille Mains : AGI×2, attaque toutes les unités adjacentes chaque tour. Transition à 60% HP |
| **Krieg**  | Cassure d'armure à 50% HP : DEF divisée par 2, WEAKENED permanent |
| **Arlong** | Régénère 15 PV/tour sur case eau. Stratégie : le forcer hors de l'eau |
| **Smoker** | Corps Logia : dégâts PHYSICAL ×0.5. Seul Luffy (BLUNT) le blesse normalement |

---

## Système d'objets

### Consommables (implémenté)

Utilisés en combat, coûtent 1 action. Inventaire commun (pas par personnage).

- **Nourriture** : soigne PV (Viande > Bento > Ration)
- **Alcool** : restaure NRJ
- **Boosts** : applique BUFFED ou HASTED
- **Débuffs offensifs** : applique BLIND ou STUN sur ennemis

### Équipements (à venir)

3 slots par personnage : Arme / Armure / Accessoire. Modificateurs additifs sur stats, équipés dans l'interlude.

---

## Entre les combats — Écran d'interlude

Accessible après chaque arc, sur le Going Merry :

- **Dialogue** : échange court entre 2 personnages, reflet de l'arc passé
- **Arbre de compétences** : dépenser les Points de Talent gagnés après l'arc
- **Boutique** : acheter consommables et équipements (Berrys gagnés en combat)
- **Carte du monde** : vue East Blue non-interactive, position actuelle mise en avant

Entre deux batailles du même arc : pas d'écran d'interlude, juste les dialogues pré/post bataille.

---

## Arbre de compétences

Points de Talent : 1 gagné par arc terminé. Pas de grind — progression narrative.

### Branches par personnage (esquisse)

| Personnage | Branche 1 | Branche 2 | Branche 3 |
|-----------|-----------|-----------|-----------|
| Luffy  | Puissance (Gomu Bazooka → Gatling) | Vitesse (Gear 2 partiel) | Endurance (PV+) |
| Zoro   | Tranchant (Oni Giri → Tora Giri) | Défense (Dragon Twister réaction) | Santoryu (FOR+) |
| Nami   | Climatact (Thunderbolt → Tempo amélioré) | Brume (area control) | Soin |
| Usopp  | Précision (portée+) | Étoiles spéciales (Firebird, Smoke) | Kabuto |
| Sanji  | Jambe (Collier → Mutton Shot) | Flambage réaction | Diable Jambe |
