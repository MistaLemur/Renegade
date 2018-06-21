/*
Author: Miguel SuVasquez
March 2014

This file has all attribute and function definitions relating to damage events and damage computation.
*/
actor
	var
		armor
		damageMult = 1
		isDead

		deathDeleteDelay = 1.5

		hitParticleType

		deathSounds[0]
		hurtSounds[0]

	Hit(projectile/O)
		var/particles = damage(O.damage, O.armorPenetration)
		//hit particles

		if(hitParticleType && particles >= 1)
			new hitParticleType(O, particles/2)
			.=1


	proc
		damage(damage, armorPen)
			var/armorReduction = max(0, armor - armorPen)
			damage = max(0.5, damage - armorReduction)
			damage *= damageMult

			health -= damage

			.=damage

			if(hurtSounds.len)
				playSound(pick(hurtSounds),loc)

			//flash red
			var/oldColor = color
			color = rgb(255,0,0)
			animate(src, color=oldColor, time=0.2)

			new/particleEmitter/particleText (src, "<b><font color=red>[damage]")

			if(health <=0) death()

		death()
			if(isDead) return
			isDead = 1

			canGetHit = 0

			if(deathSounds.len)
				playSound(pick(deathSounds),loc)

			//dieing animation here

			//inventory drop!
			dropInventory()

			spawn(deathDeleteDelay * 10)
				del src

	humanoid
		hitParticleType = /particleEmitter/quadratic/bloodProjectile

		deathSounds = list('death1.wav', 'death2.wav')
		hurtSounds = list('hurt1.wav', 'hurt2.wav')

		death()
			if(isDead) return
			if(equip) unEquipItem()

			.=..()

			new/particleEmitter/quadratic/deathBlood(src)
			//make the fucker jump
			jump((dir & 4)? -150: 150, jumpingAcceleration/2)

		player
			deathDeleteDelay = 2

			damage()
				.=..()
				player.updateHealth = 1

			death()
				if(isDead) return
				isDead = 1

				if(deathSounds.len)
					playSound(pick(deathSounds),loc)

				if(equip) unEquipItem()

				//dieing animation here
				new/particleEmitter/quadratic/deathBlood(src, 40)

				//jump
				jump((dir & 4)? -150: 150, jumpingAcceleration/2)

				spawn(deathDeleteDelay * 10)
					//world reboot!
					player.FadeOut()

					sleep(10)

					if(currentMission)
						currentMission.missionEvent("Death")
