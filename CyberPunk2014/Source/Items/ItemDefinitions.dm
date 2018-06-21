/*
Author: Miguel SuVasquez
March 2014

This file contains definitions for the different items in the game.
For example, all of the different pistols or the different healing syringes.
*/
weapon/gun

	icon = 'SmallGuns.dmi'
	brassParticleType = /particleEmitter/quadratic/pistolBrass
	reload_x = 0
	reload_y = 0

	pistol
		dRadius = 13
		hands = 1
		hand1_x = 0
		hand1_y = 0

		equip_state = "pistol"
		use_state = "pistol -fire"
		reload_state = "pistol"

		useDelay = 0.25
		reloadSound = 'pistol_reload.wav'
		reloadDelay = 1.1


		isFullAuto = 0

		icon_state = "pistol"

		reloadParticleType = /particleEmitter/quadratic/droppedMagazine/Pistol


		Raptor
			name = "Raptor Light Pistol"

			ammo = 16//this is the ammo currently loaded into the gun
			maxAmmo = 16//this is the ammo capacity for the gun's magazine

			mags = 5 //# of magazines
			maxMags = 5//maximum # of magazines

			bigGraphic = 'Raptor_big.png'
			fireSound = 'Raptor.wav'

			inaccuracy = 6
			movingAccuracyMultiplier = 1.25
			aimingAccuracyMultiplier = 1


			damage = 8
			armorPenetration = 0

			description = "The Raptor light pistol is favored by street thugs.\n\
				It features a simple operating mechanism and can lay down good firepower against soft targets."

			loudness = 2.5

			reloadSound = 'pistol_reload.wav'
			reloadDelay = 1.1

			hands = 1
			hand1_x = 0
			hand1_y = 0
			hand2_x = 0
			hand2_y = 0
			reloadKeyframes = list(	new/keyframe(0, 0, 0, 0), \
									new/keyframe(0, -4, 0.1, 1), \
									new/keyframe(0, -4, 0.3, "C"), \
									new/keyframe(0, -4, 0.4, "C"), \
									new/keyframe(0, -4, 0.5, 1), \
									new/keyframe(0, 0, 0.7, 1), \
									new/keyframe(0, 0, 0.8, 1), \
									new/keyframe(0, 0, 1.1, null))

			dropMagDelay = 0.1
			reload_x = 1
			reload_y = -2

			equip_state = "pistol"
			use_state = "pistol -fire"
			reload_state = "pistol -reload"



		Komodo
			name = "Komodo .50"

			icon_state = "komodo"

			ammo = 7//this is the ammo currently loaded into the gun
			maxAmmo = 7//this is the ammo capacity for the gun's magazine

			mags = 5 //# of magazines
			maxMags = 5//maximum # of magazines

			bigGraphic = 'Komodo60_big.png'

			equip_state = "komodo"
			use_state = "komodo -fire"
			reload_state = "komodo"

			useDelay = 0.5

			fireSound = 'Komodo.wav'
			reloadSound = 'komodo_reload.wav'
			reloadDelay = 1.6

			inaccuracy = 3
			movingAccuracyMultiplier = 5
			aimingAccuracyMultiplier = 0.5

			damage = 20
			armorPenetration = 10

			description = "The Komodo .50 is a notorious handgun, known for its high accuracy and \n\
				armor-piercing capabilities. However, its large size makes it difficult to handle while moving."

			loudness = 10

			hands = 1
			hand1_x = 0
			hand1_y = 0
			hand2_x = 0
			hand2_y = 0
			reloadKeyframes = list(	new/keyframe(0, 0, 0, 0), \
									new/keyframe(0, -6, 0.1, 1), \
									new/keyframe(0, -5, 0.4, "C"), \
									new/keyframe(0, -5, 0.6, "C"), \
									new/keyframe(0, -6, 0.8, 1), \
									new/keyframe(0, 0, 1.1, 1), \
									new/keyframe(0, 0, 1.4, 1), \
									new/keyframe(0, 0, 1.6, null))

			dropMagDelay = 0.1
			reload_x = 1
			reload_y = -2
			reload_state = "komodo -reload"


	smg
		dRadius = 11
		hands = 1
		hand1_x = 0
		hand1_y = 0

		icon_state = "smg"
		equip_state = "smg"
		use_state = "smg -fire"

		useDelay = 0.25
		reloadSound = 'SMG142_reload.wav'
		reloadDelay = 1.6

		isFullAuto = 1

		reloadParticleType = /particleEmitter/quadratic/droppedMagazine/SMG

		SMG142
			name = "SMG142"
			useDelay = 0.075

			ammo = 25//this is the ammo currently loaded into the gun
			maxAmmo = 25//this is the ammo capacity for the gun's magazine

			mags = 4 //# of magazines
			maxMags = 4//maximum # of magazines

			bigGraphic = 'SMG142_big.png'

			fireSound = 'SMG142.wav'
			reloadSound = 'SMG142_reload.wav'


			inaccuracy = 9
			movingAccuracyMultiplier = 1.1
			aimingAccuracyMultiplier = 0.9

			damage = 5
			armorPenetration = 0
			description = "The SMG142 is common amongst bronzes and coppers. \n\
			Who can blame them? It shoots cheap ammo and is easy to use."

			loudness = 3.5

			hands = 2
			hand1_x = -2
			hand1_y = -1
			hand2_x = 8
			hand2_y = 1
			reloadKeyframes = list(	new/keyframe(8, 1, 0, null), \
									new/keyframe(6, -1, 0.1, null), \
									new/keyframe(6, -6, 0.2, null), \
									new/keyframe(8, -5, 0.4, "C"), \
									new/keyframe(8, -5, 0.5, "C"), \
									new/keyframe(6, -6, 0.65, 1), \
									new/keyframe(6, -1, 0.775, null), \
									new/keyframe(6, 5, 1.05, null), \
									new/keyframe(0, 5, 1.15, null), \
									new/keyframe(0, 5, 1.30, null), \
									new/keyframe(6, 5, 1.35, null), \
									new/keyframe(8, 1, 1.6, null))

			dropMagDelay = 0.1
			reload_x = 4
			reload_y = -7
			reload_state = "smg -reload"

	ar
		dRadius = 14
		hands = 2
		hand1_x = -5
		hand1_y = 0

		hand2_x = 7
		hand2_y = 1

		equip_icon = 'largeGunOverlays.dmi'

		icon_state = "ar"
		equip_state = "ar"
		use_state = "ar -fire"

		useDelay = 0.1

		reloadDelay = 1.6

		isFullAuto = 1

		reloadParticleType = /particleEmitter/quadratic/droppedMagazine/AR

		KRK104
			name = "KRK104"

			useDelay = 0.15

			ammo = 30//this is the ammo currently loaded into the gun
			maxAmmo = 30//this is the ammo capacity for the gun's magazine

			mags = 4 //# of magazines
			maxMags = 4//maximum # of magazines

			bigGraphic = 'KRK104.png'

			fireSound = 'KRK104.wav'
			reloadSound = 'KRK104_reload.wav'
			equipSound = 'boltpull.wav'

			inaccuracy = 7
			movingAccuracyMultiplier = 2
			aimingAccuracyMultiplier = 0.75

			damage = 10
			armorPenetration = 2
			description = ""

			loudness = 5

			description = "The KRK104 was designed with front line troops and elite units in mind, \
			with a good balance in stopping power, fire rate, and accuracy."

			hands = 2
			hand1_x = -5
			hand1_y = 0
			hand2_x = 7
			hand2_y = 1

			reloadKeyframes = list(	new/keyframe(7, 1, 0, null), \
									new/keyframe(4, -2, 0.1, null), \
									new/keyframe(4, -6, 0.2, null), \
									new/keyframe(8, -5, 0.35, "C"), \
									new/keyframe(8, -5, 0.4, "C"), \
									new/keyframe(4, -6, 0.57, 1), \
									new/keyframe(4, -2, 0.75, null), \
									new/keyframe(6, 5, 1.05, null), \
									new/keyframe(0, 5, 1.15, null), \
									new/keyframe(0, 5, 1.25, null), \
									new/keyframe(6, 5, 1.3, null), \
									new/keyframe(7, 1, 1.6, null))

			dropMagDelay = 0.1
			reload_state = "ar -reload"
			reload_x = 3
			reload_y = -7



item
	icon = 'SmallGuns.dmi'

	healing
		toShortcuts = 1
		canUse = 1
		var
			healAmount
			useSound = 'inject.wav'

		use()
			.=..()
			owner.health = min(owner.maxHealth, owner.health + healAmount)
			owner.inventory -= src

			new/particleEmitter/particleText (owner, "<b><font color=green>+[healAmount]")

			if(owner == player.mob)
				player.updateHealth = 1
				owner << useSound

			del src

		adrenophin
			name = "Adrenophin 10cc"
			bigGraphic = 'Adrenophin.png'

			healAmount = 25

			description = "Heals 35 health. \n\n\
			An injection of Adrenaline and some other stimulants.\n\n\
			'Nah I aint looking for a wigly, but this does come in handy.'"
