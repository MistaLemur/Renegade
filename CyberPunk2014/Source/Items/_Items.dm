item
	parent_type = /obj
	var
		bigGraphic
		actor/humanoid/owner

		description

		useTimer
		useDelay

		deleteDelay = -1
		deleteTimer

		toShortcuts = 0

		canUse = 0

	canInteract = 1

	allowEnterTag = "actor"

	density = 1
	bound_width = 15
	bound_height = 15

	activeBool = 1

	interactDesc = "pick up"

	New()
		.=..()
		if(usr && ismob(usr)) loc = usr //OMG USR ABUSES
		if(ismob(loc)) owner = loc

		centerBounds()

	getInteractDesc()
		return "pick up [src]"

	interactEvent(actor/M)
		pickUp(M)

	tick()
		if(!owner && currentTime() > deleteTimer && deleteDelay >= 0) del src
		.=..()

		if(!owner)
			Accelerate(0,-gravity)
			Velocity()

	Del()
		if(owner) owner.inventory -= src
		.=..()

	Cross(atom/movable/A)
		if(istype(A, /item)) return 1
		.=..()

	proc
		canUse()
			if(currentTime() < useTimer) return 0

		use()

		centerBounds()
			var/icon/I = icon(icon,icon_state)
			pixel_x = -I.Width()/2
			pixel_y = -I.Height()/2

			bound_x = -bound_width/2
			bound_y = -bound_height/2

		pickUp(actor/humanoid/mob)
			if(owner != null)
				loc = owner
				return

			if(istype(mob))
				//play some pickup sound
				owner = mob
				owner.inventory += src
				loc = owner

				currentScreen.activeAtoms -= src
				Drag(1)

				if(mob == player.mob)
					if(toShortcuts)
						var/shortcuts[] = player.mob:hotKeyItems
						for(var/i=1;i<=shortcuts.len;i++)
							if(!shortcuts[i])
								shortcuts[i] = src
								break

					currentMission.missionEvent("tutorialItems")


		drop()
			if(!owner) return
			var/actor/M = owner
			owner = null
			if(istype(M, /actor/humanoid))
				if(src == M:equip)
					M:unEquipItem(src)

			if(M == player.mob)
				var/index = M:hotKeyItems.Find(src)
				if(index >= 1)
					M:hotKeyItems[index] = null

				player.updateAmmo = 1


			M.inventory -= src
			loc = M.loc
			step_x = M.step_x
			step_y = M.step_y
			var/vector/offset = M.pixelCenterVector()
			step_x += offset.x
			step_y += offset.y

			vx = 0
			vy = M.vy

			owner = null

			if(currentScreen) currentScreen.activeAtoms += src

			deleteTimer = deleteDelay + currentTime()





weapon //this just means anything that is equippable
	parent_type = /item
	toShortcuts = 1

	canUse = 1

	var
		//center coords
		//This is the offset to apply to the player's center
		center_x
		center_y

		//display radius
		dRadius

		//aesthetic variables
		//two possible hand positions
		hands = 1
		hand1_x
		hand1_y

		hand2_x
		hand2_y

		use_state //icon_state for use

		equipDelay
		equipSound
		equip_icon = 'smallGunOverlays.dmi'
		equip_state //this is the icon state of the equip overlay

		isReloading = 0
		reloadParticle = 0
		reloadParticleType

		//This is the offset where the reloading particles are created.
		reload_x
		reload_y


	proc
		getAmmoString()
			return ""

		getRemainingAmmunition()
			return 1

		equipped(actor/M)
			M<<equipSound
			owner = M
			useTimer = currentTime() + equipDelay

		unEquipped(actor/M)

		idle()

		rKey()

	gun

		New()
			.=..()
			randomAmmo(0.5)

		equipSound = 'smg_equip.wav'
		equipDelay = 0.6

		var
			ammo //this is the ammo currently loaded into the gun
			maxAmmo //this is the ammo capacity for the gun's magazine


			mags //# of magazines
			maxMags //maximum # of magazines

			ammoType

			fireSound
			reloadSound
			reloadDelay

			reloadTime //The time when reload was initiated
			reloadTimer //The time when reload will end


			isFullAuto = 1

			emptySound = 'emptyGun.ogg'

			brassParticleType
			muzzleParticleType

			inaccuracy = 0

			movingAccuracyMultiplier = 1.5
			aimingAccuracyMultiplier = 0.75

			damage
			armorPenetration

			projectileType = /projectile/bullet

			loudness = 3

			//These are the keyframes that make up this gun's reloading animation
			reloadKeyframes[0]

			dropMagDelay = 0
			reload_state

		getAmmoString()
			return "[ammo] / [mags*maxAmmo]"

		use(useEquip)
			if(useEquip & 1) return fire()
			else if(useEquip & 2) return secondary()

		rKey()
			return reload()

		pickUp(actor/humanoid/mob)
			if(!istype(mob)) return
			if(locate(src.type) in mob.inventory)
				//ammo it up
				var/weapon/gun/G = locate(src.type) in mob.inventory
				if(G.mags < G.maxMags)
					G.mags = min(G.maxMags, G.mags + 1)

					if(mob == player.mob)
						//play an ammo sound!
						player.updateAmmo = 1

				del src

			.=..()

		equipped(actor/M)
			owner = M
			M<<'primary_draw.wav'
			useTimer = currentTime() + 0.5 + equipDelay
			spawn(6)
				M<<equipSound

		//for the AI
		getRemainingAmmunition()
			return ammo + maxAmmo * mags

		proc
			fire()
				if(currentTime() < useTimer) return
				if(!owner.canUseWeapon() || currentTime() < owner.armlessTimer) return
				if(ammo == 0) return reload()

				//create the projectile here
				//compute the fucking center of the owner mob
				var/vector/offset = vec2(dRadius * cos(owner.drawAngle), dRadius * sin(owner.drawAngle))

				offset = offset.add(vec2(0, owner.getWeaponHeight()))

				var/fireAngle = owner.aimAngle
				var/drawAngle = owner.drawAngle

				new projectileType (owner, fireAngle, drawAngle, src, offset.x, offset.y)

				//make the sounds
				playSound(fireSound, owner.loc)
				useTimer = currentTime() + useDelay

				if(brassParticleType)
					new brassParticleType (owner, owner.displayDirection, offset, owner.aimAngle)

				if(muzzleParticleType)
					new muzzleParticleType (owner, owner.displayDirection, offset, owner.aimAngle)

				//flash the overlays
				if(use_state)
					var/Overlay/O = owner.getOverlay("gun")
					O.Flick(use_state, useDelay*10)

				ammo --

				alertAISound(owner, src.loudness)

				if(!isFullAuto)
					owner:useEquip = 0
					if(owner == player.mob)
						player.mouseButton = 0

				//set the update flags for ammo
				if(owner == player.mob) player.updateAmmo = 1


			secondary()

			refillAmmo()
				ammo = maxAmmo
				mags = maxMags
				if(player) if(owner == player.mob) player.updateAmmo = 1

			randomAmmo(mult=1)
				ammo = maxAmmo
				mags = rand(1,round(maxMags*mult))
				if(player && owner == player.mob) player.updateAmmo = 1

			reload()
				if(isReloading) return 0
				if(mags > 0 && ammo < maxAmmo)
					ammo = 0
					//set the update flags for ammo

					if(owner && owner == player.mob) mags --

					playSound(reloadSound, owner.loc)
					reloadTime = currentTime()
					useTimer = reloadTime + reloadDelay
					reloadTimer = useTimer

					reloadParticle = 0
					isReloading = 1

					//add the overlay to owner
					if(owner)
						var/Overlay/O = owner.overlay("reloadAnim")
						O.ShowTo(player)
						O.Icon('ReloadAnimation.png')
						O.Layer(EFFECTS_LAYER)
						O.Alpha(192)

						var/matrix/m = matrix()
						m.Scale(0.5)

						O.PixelX(6)
						O.PixelY(owner.getWeaponHeight() + 1)

						O.Transform(m)

					spawn()
						if(owner)
							var/Overlay/O = owner.getOverlay("reloadAnim")
							var/matrix/m = matrix()
							m.Scale(0.5)
							for(var/i=1; i <= reloadDelay*world.fps; i++)
								if(!owner) break

								if(owner.isDead) break

								m.Turn(10)
								O.Transform(m)
								O.PixelY(owner.getWeaponHeight() + 1)
								sleep(world.tick_lag)
								sleep(0)

						ammo = maxAmmo
						isReloading = 0
						if(owner == player.mob) player.updateAmmo = 1
						//set the updateFlags for ammo

						//remove the overlay from owner
						if(owner)
							var/Overlay/O = owner.getOverlay("reloadAnim")
							del O

				else if (!mags)
					owner<<emptySound
					useTimer = currentTime() + useDelay

				if(owner == player.mob) player.updateAmmo = 1

			getInaccuracy()
				var/inacc = inaccuracy * owner.inaccuracy

				if(owner && istype(owner,/actor/humanoid))
					var/vector/velocity = vec2(owner.vx, owner.vy)

					//now check the moving speed
					//if the moving speed is above a certain threshhold, *= movingAccuracyMultiplier
					if(velocity.magnitude() >= 50)
						inacc *= movingAccuracyMultiplier
						inacc *= owner:movingAccuracyMultiplier

					//if isCrouching, *= aimingInaccuracyMultiplier
					if(owner:isCrouching)
						inacc *= aimingAccuracyMultiplier
						inacc *= owner:aimingAccuracyMultiplier

				return inacc

			//These are getter functions for GUI stuff
			getDamageStat()
				return damage

			getPenetrationStat()
				return armorPenetration

			getCapacityStat()
				return maxAmmo

			getAmmoStat()
				return getAmmoString()

			getFireRateStat()
				return round(1/useDelay, 0.01)

			getAccuracyStat()
				return max(0, 10-inaccuracy)

			getPrecisionStat()
				return round(1/aimingAccuracyMultiplier * 2, 0.01)

			getHandlingStat()
				return round(1/movingAccuracyMultiplier * 2, 0.01)

	melee

	grenade
