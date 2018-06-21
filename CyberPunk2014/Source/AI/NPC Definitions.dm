/*
Author: Miguel SuVasquez
March 2014

This file provides database-like definitions for the different enemies in the game.
Behaviors are not defined here; only attributes and stats.
*/
Enemy
	isHostile = 1
	parent_type = /actor/humanoid/AI
	//enemies
	Guard
		armor = 0

		health = 30
		maxHealth = 30

		bound_x = -10
		bound_width = 20
		bound_height = 50

		pixel_x = -25
		pixel_y = -1

		icon = 'Guard.dmi'
		armGraphic = 'GuardArms.dmi'

		loot = list(/item/healing/adrenophin)
		lootRate = 15

		attackDelayMin = 0.75
		attackDelayMax = 2

		Pistol
			inventory = list(new /weapon/gun/pistol/Raptor)

		SMG
			inventory = list(new /weapon/gun/smg/SMG142)


	Sentinel
		armor = 3

		health = 30
		maxHealth = 30

		bound_x = -10
		bound_width = 20
		bound_height = 50

		pixel_x = -25
		pixel_y = -1

		reactionDelay = 0

		icon = 'Sentinel.dmi'
		armGraphic = 'SentinelArms.dmi'

		loot = list(/item/healing/adrenophin)
		lootRate = 25

		patrolUnEquip = 0

		aimCrouches = 1

		attackDelayMin = 0.5
		attackDelayMax = 1.50

		KomodoPistol
			inventory = list(new /weapon/gun/pistol/Komodo)

		SMG
			inventory = list(new /weapon/gun/smg/SMG142)

		AR
			inventory = list(new /weapon/gun/ar/KRK104)
