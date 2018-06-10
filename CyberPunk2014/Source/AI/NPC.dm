
actor/humanoid/AI

	inaccuracy = 2

	jumpBoost = 1

	var
		atom/alertLocation
		resetLocationThreshhold = 5

		isHostile = 1 //hostile to the player

		isAlerted = 0
		alertTimer
		alertDuration = 15

		state
		stateTimer

		processStateTimer
		processStateDelay = 0.06

		lastLoS
		crouchLoS
		LoSTimer
		LoSDelay = 0.3

		healthThreshhold = 0
		evaluateStateX = 26
		evaluateStateY = 17


		actionDir
		changeState = 0

		//these are in tiles.
		minAttackRange = 1
		maxAttackRangeX = 15
		disengageRangeX = 16

		maxAttackRangeY = 9
		disengageRangeY = 10

		aimCrouches = 0

		fireStates = 7 //bit flags
		//Determines which parts of the body this NPC will aim at if he sees it
		//1 for head
		//2 for center
		//4 for legs

		soundReaction = 1

		loot[0] //This should be filled with type paths
		lootRate = 50
		lootAmount = 1

		//Equipment behavior flags
		patrolEquip = 0 //Should equip weapon when patrolling?
		patrolUnEquip = 1 //Should unequip weapon when patrolling?
		patrolAlertEquip = 1 //Should equip weapon when alerted and patrolling?
		idleEquip = 0 //Should equip weapon when standing around?

		//Pixel range for detection
		feelingDistThreshhold = 9

		reactionTimer
		reactionDelay = 0.1

		aimSpeed = 180 //degrees per second
		aimThreshhold = 5

		lastState

		NPCPushing = 50

		jumpKeyTimer
		jumpDelay = 0.1

		useInteractTimer
		useInteractDelay = 0.5

		standTimer
		standDelay = 1
		standRate = 0.1 //for aimCrouchers

		crouchTimer
		crouchDelay = 0.5

		forceActive = 0

		attackTimer
		attackDelayMin = 0.25
		attackDelayMax = 1.50

		vector/attackCoords

		sprayRand = 20



	runningSpeed = 150
	runningAcceleration = 500
	runningDrag = 0.5

	allowEnterTag = "actor"

	tick(screenTime)
		if(player.mob)
			var/mob/mob = player.mob
			if((abs(mob.x - x) > evaluateStateX || abs(mob.y - y) > evaluateStateY) && !(forceActive))
				return

		if(screenTime >= processStateTimer && !isDead)
			processStateTimer = screenTime + processStateDelay

			//evaluate state conditions
			evaluateState(screenTime)

			//process state behaviors
			stateBehaviors(screenTime)

		//process mob physics and etc

		processInputs()

		pushOutOtherHumanoid()

		processMovement()

		if(useEquip && equip)
			equip.use(useEquip)



	Hit(projectile/O)

		.=..()

		if(O.owner)
			alertLocation(O.owner.loc)
			state = "attack"

			attackTimer = max(attackTimer, currentTime() + rand(attackDelayMin*100, attackDelayMax*100)/100)

			attackCoords = O.owner.pixelCoordsVector()
			if(istype(O.owner, /actor))
				attackCoords.y += O.owner:getWeaponHeight()

			attackCoords.x += rand(-sprayRand, sprayRand)
			attackCoords.y += rand(-sprayRand, sprayRand)

	dropInventory()
		.=..()

		if(!loot.len) return
		for(var/i = 1; i <= lootAmount; i++)
			if(prob(lootRate))
				var/lootType = pick(loot)
				var/item/I = new lootType ()
				I.owner = src
				I.drop()

	Cross(atom/movable/A)
		if(isDead) return 1
		if(allowEnterTag == A.attemptEnterTag && allowEnterTag)
			if(A == player.mob && isHostile) return 0
			else return 1
		.=..()

	proc
		evaluateState(screenTime)
			var/actor/mob = player.mob
			changeState = 0

			var/distX = abs(src.x - player.mob.x)
			var/distY = abs(src.y - player.mob.y)

			var/shouldDisengage = 0
			if(distX >= disengageRangeX || distY >= disengageRangeY)
				shouldDisengage = 1


			if(state == "attack" && shouldDisengage) state = null
			if(screenTime < alertTimer && mob.health <= 0) alertTimer = 0

			if(screenTime < alertTimer && isHostile && mob.health > 0)
				//If I'm alerted, scan for the player
				if(LoSTimer < screenTime)
					LoSTimer = screenTime + LoSDelay
					lastLoS = LoS(src, mob, /actor/humanoid/AI, 7)

				//	If I can find the player

				if((lastLoS || screenTime < attackTimer) && mob.health > 0 && !shouldDisengage && screenTime >= reactionTimer)
				//	Update the alert timer
					alertTimer = screenTime + alertDuration
					if(lastLoS) alertLocation = mob.loc
					state = "attack"
					changeState = 1

				if((!lastLoS && screenTime >= attackTimer) || shouldDisengage)
					//If I'm alerted and I can't find the player, then patrol
					changeState = 0
					state = "patrol"

				if(health/maxHealth < healthThreshhold || (equip && equip.getRemainingAmmunition() <=0))
					changeState = 1
					state = "flee"

			if(screenTime >= alertTimer)
				if(LoSTimer < screenTime && isHostile && mob.health > 0 && (src.dir & get_dir(src,mob)))
					LoSTimer = screenTime + LoSDelay// + rand(0,2)/10
					lastLoS = LoS(src, mob, /actor/humanoid/AI, 3)

					if(lastLoS)
						isAlerted = 1
						alertTimer = screenTime + alertDuration
						if(screenTime >= reactionTimer) reactionTimer = screenTime + reactionDelay

			if(screenTime >= stateTimer && screenTime >= alertTimer)
				isAlerted = 0
				alertLocation = null

				if(LoSTimer < screenTime && isHostile && mob.health > 0 && (src.dir & get_dir(src,mob)))
					LoSTimer = screenTime + LoSDelay// + rand(0,2)/10
					lastLoS = LoS(src, mob, /actor/humanoid/AI, 3)

					if(lastLoS)
						isAlerted = 1
						alertTimer = screenTime + alertDuration
						if(screenTime >= reactionTimer) reactionTimer = screenTime + reactionDelay

				//if I'm not alerted, then patrol a bit.
				if(state == "patrol")
					state = "idle"
					stateTimer = screenTime + rand(10,30)/10
				else
					state = "patrol"
					stateTimer = screenTime + rand(5,15)/10

				changeState = 1

			if(isHostile && mob.health > 0 && bounds_dist(src,mob) <= feelingDistThreshhold)
				lastLoS = 7
				isAlerted = 1
				alertTimer = screenTime + alertDuration
				if(screenTime >= reactionTimer) reactionTimer = screenTime + reactionDelay


		stateBehaviors(screenTime)
			useEquip = 0
			moveKeys = 0
			if(screenTime >= jumpKeyTimer && spaceKey) spaceKey = 0

			if(!state && screenTime >= stateTimer)
				isAlerted = 0
				alertLocation = null

				//if I'm not alerted, then patrol a bit.
				state = pick("patrol", "patrol", "idle")
				stateTimer = screenTime + rand(5,20)/10

				changeState = 1

			if(state == "attack")
				//	Make sure I have a gun out as well
				if(!equip) equipAnyWeapon()

				actionDir = get_dir(src, player.mob)

				var/shouldMove = 0
				var/dist = get_dist(src, player.mob)

				var/distX = abs(player.mob.x - src.x)
				var/distY = abs(player.mob.y - src.y)

				var/inAttackRange = 1

				//if the player is in my personal space, then flip that shit nig.
				if(dist <= minAttackRange)
					actionDir = ~actionDir
					actionDir &= 12
					shouldMove = 1
					inAttackRange = 0

				//if the player is too far away to attack, then run towards that
				if(distX > maxAttackRangeX || distY > maxAttackRangeY)
					shouldMove = 1
					inAttackRange = 0

				//now set the aimAngle
				var/vector/coords = pixelCoordsVector()
				coords.y += getWeaponHeight()

				if(lastLoS != 0)
					attackCoords = player.mob.pixelCoordsVector()
					var/off_y = 0
					if(lastLoS & 4)
						//I can see the bottom edge. Aim at the knees
						off_y = player.mob.bound_height * 0.20 + player.mob.bound_y

					if(lastLoS & 1)
						//I can see the north edge. Aim at the neck
						off_y = player.mob.bound_height * 0.7 + player.mob.bound_y

					if(lastLoS & 2)
						//I can see the center. Aim at the gut
						off_y = player.mob.bound_height * 0.50 + player.mob.bound_y

					attackCoords.y += off_y

				var/vector/difVec = attackCoords.subtract(coords)
				var/targetAngle = _GetAngle(difVec.y, difVec.x)
				var/deltaAngle = targetAngle - aimAngle

				if(deltaAngle < -180) deltaAngle += 360
				if(deltaAngle >=180) deltaAngle -= 360

				if((actionDir & 12) == (src.dir & 12) || abs(deltaAngle) < 90)
					deltaAngle = max(-aimSpeed * processStateDelay, min(aimSpeed * processStateDelay, deltaAngle))

				else
					if(actionDir & 4)
						deltaAngle = 315 - aimAngle

					else if(actionDir & 8)
						deltaAngle = 225 - aimAngle

				aimAngle += deltaAngle

				var
					shouldShoot = (lastLoS != 0) || (screenTime < attackTimer)


				if(aimAngle >= 360) aimAngle -= 360
				if(aimAngle < 0) aimAngle += 360

				if(lastLoS != 0)
					attackTimer = max(attackTimer, screenTime + rand(attackDelayMin*100, attackDelayMax*100)/100)

				if(shouldShoot && inAttackRange && abs(deltaAngle) <= aimThreshhold)
					useEquip = 1
				else
					useEquip = 0

				if(!istype(ground, /Collision)) actionDir |= 2

				if((actionDir & SOUTH) && (isGrounded))
					if(ground && ground.isScaffold)
						moveKeys |= 2
						spawn(0)
							for(var/i = 0; i <= 3; i++)
								sleep(world.tick_lag)
								moveKeys |= 2

							spaceKey = 1
							jumpKeyTimer = screenTime + jumpDelay

				if(shouldMove)
					var/offset_x = 0
					var/offset_y = 0
					if(actionDir & 4) offset_x = tile_width
					if(actionDir & 8) offset_x = -tile_width

					var/atom/groundCheck = checkGround(offset_x, offset_y)

					if((groundCheck) || (actionDir & SOUTH))
						moveKeys |= (actionDir&12)


				else
					if(aimCrouches)
						if(lastLoS & 6)
							moveKeys = 2
						else
							moveKeys = 0

				//if I should move, check if I can move in that direction.
				//otherwise, just sit on my ass.

			if(state == "patrol")
				//	Make sure I have a gun out as well
				if(screenTime < alertTimer && patrolAlertEquip && !equip) equipAnyWeapon()
				if(screenTime >= alertTimer && !equip && patrolEquip && !patrolUnEquip) equipAnyWeapon()
				if(screenTime >= alertTimer && equip && patrolUnEquip) unEquipItem()

				if(alertLocation) actionDir = get_dir(src, alertLocation)
				if(changeState &&!alertLocation) actionDir = pick(4, 8, 0)

				var/offset_x
				if(actionDir & 4)
					offset_x = tile_width
					aimAngle = 315

					if(screenTime < alertTimer) aimAngle = 0

				if(actionDir & 8)
					offset_x = -tile_width
					aimAngle = 225

					if(screenTime < alertTimer) aimAngle = 180

				var/atom/groundCheck = checkGround(offset_x, 0)

				if(!istype(ground, /Collision)) actionDir |= 2

				if((groundCheck) || (actionDir & SOUTH))  moveKeys |= (actionDir&12)

				//if I can run in that direction, run in that direction
				//if not, just stand and chill.

			if(state == "flee")
				//I'm a crying bitch. put my gun away
				if(equip) unEquipItem()
				actionDir = get_dir(player.mob, src)

				var/offset_x
				if(actionDir & 4) offset_x = tile_width
				if(actionDir & 8) offset_x = -tile_width

				var/atom/groundCheck = checkGround(offset_x, 0)

				if((groundCheck) || (actionDir & SOUTH)) moveKeys |= (actionDir&12)

				else
					moveKeys = 2

				//if I can run in that direction, run in that direction
				//otherwise, crouch and cry like a little bitch

			if(state == "idle")
				if(!equip && idleEquip) equipAnyWeapon()
				else if(equip && !idleEquip) unEquipItem()

				//Just chill.
				moveKeys = 0

			if((moveKeys & 12) && checkDense(moveKeys&12))
				var/denseStuff[] = checkDense(moveKeys&12)

				var
					lowY = 0
					highY = 0
					foundDense = denseStuff.len > 0

				for(var/atom/A in denseStuff)
					var/tY = A.getTopEdge() - src.getBottomEdge()
					var/bY = src.getTopEdge() - A.getBottomEdge()

					if(tY > lowY) lowY = tY
					if(bY > highY) highY = bY

				if(foundDense)
					//Check if I should jump...?
					if(lowY > 0 && lowY <= 2*tile_height)
						spaceKey = 1
						jumpKeyTimer = screenTime + jumpDelay

					else moveKeys &= ~12


					//check if door?
					if(lowY >= src.bound_height)
						//It's a door maybe?
						var/obj/door/regulardoor/A = locate() in denseStuff
						if(A && screenTime > useInteractTimer)
							if(!A.isLocked && A.isClosed)
								useInteractTimer = screenTime + useInteractDelay
								A.interactEvent(src)

		equipAnyWeapon()
			var/weapon/W = locate() in src.inventory
			if(W)
				equipItem(W)

		alertLocation(atom/A)
			//a location
			changeState = 1
			alertLocation = A
			if(A) if(!isturf(A)) alertLocation = A.loc

			isAlerted = 1
			alertTimer = currentTime() + alertDuration

			if(state != "attack" && currentTime() >= reactionTimer)
				reactionTimer = currentTime() + reactionDelay

		alertFromSound(atom/A, loudness)
			var/distSlope = 1/5
			var/dist = get_dist(src,A) * distSlope
			var/intensity = 0
			if(dist > 0) intensity = loudness/dist
			if(intensity >= soundReaction)
				if(istype(A, /actor/humanoid/AI)) alertLocation(null)
				else alertLocation(A)

		pushOutOtherHumanoid()
			if(isDead) return
			for(var/actor/humanoid/A in obounds())
				if(A == player.mob) continue
				if(A.isDead) continue

				var/vector/otherCoords = A.pixelCoordsVector()
				otherCoords = otherCoords.add(A.pixelCenterVector())

				var/vector/myCoords = pixelCoordsVector()
				myCoords = myCoords.add(pixelCenterVector())

				var/vector/difVec = otherCoords.subtract(myCoords)
				if(difVec.magnitudeSquared() < 1)
					difVec.x += pick(-1,1)
				//	difVec.y += pick(-1,1)

				difVec = difVec.unit()

				var/dist = max(1, abs(bounds_dist(src,A)))

				A.Accelerate(difVec.x * dist * NPCPushing, difVec.y * dist * NPCPushing)

				src.Accelerate(-difVec.x * dist * NPCPushing, -difVec.y * dist * NPCPushing)

proc
	alertAISound(atom/source, loudness)
		if(!currentScreen) return

		for(var/actor/humanoid/AI/M in currentScreen.activeAtoms)
			M.alertFromSound(source, loudness)