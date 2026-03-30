# TapeQuest

## Description:
Players control a character navigating a fixed arena, surviving escalating waves of AI enemies. The game is the foundational prototype for a larger RPG featuring tape-based crafting, gacha character collection, and open-world combat.

Features thus far: Implemented crafting UI and inventory. Added bosses and different loot types and swords.

Work in Progress: UML Document, UI Layout (some ui elements are blocking others on the screen), graphics, and gameplay polish.

Ran via Processing.

## Year 2 concepts:

Collections — ArrayList<Enemy>

Enhanced for loop — for (Enemy e : enemies)

Exception handling — try/catch in ScoreManager

Multiple classes with logical responsibilities

Inheritance — Player extends Entity, Enemy extends Entity

## What player and enemy inherits from Entity:

### x, y — position on screen

### radius — size of the circle

### bx, by, bw, bh — the map boundary values used for clamping

Abstract class — Entity

Interface — Drawable (guarantees a display method for every class that implements it)

## Class Diagram (NOT UPDATED):

![Gameplay Screenshot](./Image/Classdiagram.png)

## Gameplay:

![Gameplay Screenshot](./Image/Gameplay.png)

## Start Screen:

![Gameplay Screenshot](./Image/Startscreen.png)

## Crafting UI

![Gameplay Screenshot](./Image/Craftui.png)
