/*
Author: Miguel SuVasquez
March 2014

This file contains definitions for the actor class.
*/
var
	const
		gravity = 600 //This is an acceleration in terms of pixels per second per second


actor
	//This represents a character within the game. An NPC or a PC.
	parent_type = /mob

	attemptEnterTag = "actor"

	var
		health
		maxHealth = 100

		inventory[0]

		inaccuracy = 1

	proc
		gravity() //acceleration due to world gravity
			Accelerate(0, -gravity)

		dropInventory()
			for(var/item/I in inventory)
				I.owner = src
				I.drop()

		getWeaponHeight(h = bound_height)
			return 3/4 * h

	New()
		.=..()
		health = maxHealth

	Cross(atom/movable/A)
		if(isDead) return 1
		.=..()

	humanoid
		//All humanoid characters will inherit the same platforming/parkour behaviors and actions from this class

		var
			displayDirection = 4
			//The AI will set these input variables. A humanoid PC will just read the input from the client.
			moveKeys //this is the "input" for movement
			//moveKey is a bitarray that uses BYOND directional convention
			spaceKey //this is the "input" for spacebar
			//spaceKey is a boolean
			useEquip //this is the input for using the equipped item
			//it is a boolean

			ignoreKeys //This is a boolean. For things like knockback from explosions and stunning effects.
			ignoreKeysTimer

			//These speed variables determine the maximum speed for each movement type action
			//All speed and velocity variables are in terms of pixels per second
			runningSpeed = 225
			crouchingSpeed = 90
			climbingSpeed = 90

			//Acceleration is in pixels per second per second
			runningAcceleration = 600
			jumpingAcceleration = 325 //2.5 tiles jump height, 16 tiles jump distance, 2 second jump duration
			jumpBoost = 0

			//Drag variables approximately follow the formula F = -bv
			runningDrag = 0.25

			//special platforming movement variables
			isGrounded //boolean variable
			atom/ground
			lastGrounded
			landTimer

			isOnLadder = 0
			canClimbLadder = 1

			isCliffHanging = 0
			cliffHangDirection //East or West towards the cliff atom
			canCliffHang = 1

			isWallSliding = 0
			wallSlideDirection //East or West towards the wall atom
			canWallSlide = 1
			lastWallSliding = 0//The previous wall sliding state

			isCrouching = 0
			crouchingHeight = 35
			standingHeight = 51

			jumpTimer
			jumpingDrag = 0.1

			releaseTimer

			//I think parkour moves should have two parameters:
			//1. a string that identifies which move it is
			//2. an environmental atom that is involved with this move
			//For example, if I were doing a dash vault over a table, parkourMove="dashVault" and parkourAtom=table
			parkourMove
			parkourAtom
			parkourTimer //Timekeeping for animation purposes

			//some coordinates for dynamic graphics
			//Head coordinates are relative to the midpoint of the top-most edge in the collission box.
			head_x = 0
			head_y = -6

			//
			weapon/equip
			justEquipped

			aimAngle = 0
			lastAimAngle
			armState
			armlessTimer
			drawAngle = 0

			//weapons stuff
			movingAccuracyMultiplier = 1.5
			aimingAccuracyMultiplier = 0.75

			armGraphic

		gravity() //acceleration due to world gravity
			if(!isGrounded && !isOnLadder && !isCliffHanging)
				if(!isWallSliding) Accelerate(0, -gravity)
				else  Accelerate(0, -gravity*2)

		Bump(atom/A)
			if(A.density)
				var/direction = get_dir(src,A)
				if(direction & 12) vx = 0
				if(direction & 3) vy = 0
			.=..()

		proc
			processInputs() //This will handle the accelerations from the inputs
				if(ignoreKeys) return

				if(isDead)
					moveKeys = 0
					spaceKey = 0

					useEquip = 0

					if(isGrounded) DragX(runningDrag * 0.25)

					if(equip) unEquipItem()

					return

				//If I'm doing a parkour move, then my inputs should be frozen
				if(parkourMove) return parkourAnimation()

				if(currentTime() < landTimer)
					landTick()
					return 0

				var/hasLadder = checkLadder() //Checks if I'm on a ladder.
				if(!hasLadder) isOnLadder = 0

				if((hasLadder && moveKeys & 3) || isOnLadder)
					//Process all four keys
					isOnLadder = 1
					isCliffHanging = 0
					isWallSliding = 0
					isCrouching = 0

					vx = 0
					vy = 0

					//Accelerate in any direction.
					if(moveKeys & 1) Accelerate(0,  climbingSpeed, 1)
					if(moveKeys & 2) Accelerate(0, -climbingSpeed, 1)

					if(moveKeys & 4) Accelerate( climbingSpeed, 0, 1)
					if(moveKeys & 8) Accelerate(-climbingSpeed, 0, 1)

					/*
					if(spaceKey)
						isOnLadder = 0
						releaseTimer = currentScreen.screenTime + 0.5
					*/

				else if(isCliffHanging)
					var/modKeys = moveKeys & (~cliffHangDirection)

					Drag(1)

					//If I'm pressing a key opposite of my cliffhanging direction, then release
					//If I'm pressing "down", then release
					if(modKeys & 14)
						isCliffHanging = 0
						cliffHangDirection = 0
						releaseTimer = currentScreen.screenTime + 0.5

					//If I'm pressing space, then jump
					if(spaceKey)
						jump()

					//If I'm pressing a key towards my cliffhanging direction or up, then climb up

				else if(isWallSliding)

					Drag(1)

					//If I'm pressing a key opposite of my wallSliding direction, then release
					if(!(moveKeys & wallSlideDirection))
						isWallSliding = 0
						wallSlideDirection = 0
						releaseTimer = currentScreen.screenTime + 0.5


					//If I'm pressing space, then jump away from the wall
					if(spaceKey)
						var/xAccel = runningSpeed * 0.9
						if(wallSlideDirection & 4) xAccel *= -1

						jump(xAccel, jumpingAcceleration * 0.9)

				else if(!isGrounded)

					 //the 0.25's here means that you're much harder to control while falling

					if((moveKeys & 4) && vx < 0) DragX(runningDrag * 0.1)
					if((moveKeys & 8) && vx > 0) DragX(runningDrag * 0.1)

					if(moveKeys & 4) Accelerate( runningAcceleration * 0.33, 0)
					if(moveKeys & 8) Accelerate(-runningAcceleration * 0.33, 0)

					//If I'm not pressing any horizontal key, then apply Drag
					var/maxSpeed = runningSpeed * 0.80
					if(!(moveKeys & 12)) DragX(runningDrag * 0.1)
					if(!spaceKey && vy > 0) DragY(jumpingDrag)

					if(abs(vx) > maxSpeed)
						vx = min(maxSpeed, max(-maxSpeed, vx))

				else if(isGrounded)
					//I realize this last else if is a little redundant, but it's easier to read

					if(lastGrounded == isGrounded || ground.isScaffold)
						vy = 0

					if((lastGrounded != isGrounded || ground.isScaffold) && (get_dir(src,ground) == 2))
						if(vy < 0)
							land()

					if((moveKeys & 4) && vx < 0) DragX(runningDrag * 0.25)
					if((moveKeys & 8) && vx > 0) DragX(runningDrag * 0.25)

					if(moveKeys & 4) Accelerate( runningAcceleration, 0)
					if(moveKeys & 8) Accelerate(-runningAcceleration, 0)

					//if I'm pressing down, then crouch
					var/newCrouching = (moveKeys & 2)!=0

					//Evaluate if the new state is possible or not.

					//If I'm trying to stand up, but there's no room, then remain crouching.
					var/cantStand = 0
					if(isCrouching && (!newCrouching || spaceKey))
						for(var/atom/A in bounds(src,0,0,0,standingHeight-crouchingHeight) - bounds(src))
							if(A == src) continue
							if(A.density)
								newCrouching = 1
								cantStand = 1
								break

					isCrouching = newCrouching

					if((moveKeys & 2) && spaceKey && ground.isScaffold)
						//If I'm crouching and jumping and on a scaffold, then make me drop through.
						isGrounded = 0
						isCrouching = 0
						ground = null

					else if(spaceKey && !cantStand)
						//if I'm pressing space, then jump
						jump()

					var/maxSpeed = runningSpeed
					if(isCrouching) maxSpeed = crouchingSpeed
					//If I'm not pressing any horizontal key, then apply Drag
					if((!(moveKeys & 12) && isGrounded))
						DragX(runningDrag * ground.surfaceDrag)

					if(abs(vx) > maxSpeed)
						vx = min(maxSpeed, max(-maxSpeed, vx))

				if(!isGrounded)
					isCrouching = 0

			checkLadder() //This will check to see if there is a ladder behind this actor.
				//If there is, returns the atom
				if(currentScreen.screenTime < releaseTimer)
					return 0

				for(var/atom/A in obounds(src))
					if(A.isLadder)
						return A

			fallingChecks() //This will handle checks for hanging onto cliffs and wallsliding
				//If the checks are successful, then it will set those states.

				//first check if this actor is falling
				if(isGrounded || isOnLadder || isCliffHanging) return //

				if(currentScreen.screenTime < releaseTimer)
					isWallSliding = 0
					isCliffHanging = 0
					return

				//then check if this actor is pressing any horizontal keys.
				//cliff hanging and wall sliding only activate if the keys are being pressed
				if(!(moveKeys&12))
					if(isWallSliding) isWallSliding = 0 //disable wall sliding because the key was released
					return

				//First check wallsliding. This is simply:
				//1. If there are walls within 1 pixel in the same horizontal direction that I am pressing a key
				isWallSliding = 0
				if((moveKeys & 4) && !(moveKeys & 8) && vy < 0)
					for(var/atom/A in (obounds(src,2,0,-1)-bounds(src)))
						if(A.density && A.wallSlide)
							isWallSliding = 1
							wallSlideDirection = 4
							break
				if((moveKeys & 8) && !(moveKeys & 4)  && vy < 0)
					for(var/atom/A in (obounds(src,-1,0,-1)-bounds(src)))
						if(A.density && A.wallSlide)
							isWallSliding = 1
							wallSlideDirection = 8
							break

				if(!lastWallSliding && lastWallSliding != isWallSliding)
					jumpTimer = max(jumpTimer, currentScreen.screenTime + 0.2)

				lastWallSliding = isWallSliding


				//Checking cliff hanging
				if(moveKeys & 12)
					var/bx , bwidth
					var/by = bound_height - 4, bheight = 4
					var/coords[] = pixelCoords()

					var/width = 2

					if(moveKeys & 4)
						bx =  bound_width/2 - width
						bwidth = width*2

					if(moveKeys & 8)
						bx = -(bound_width/2 - width)
						bwidth = -width*2

					var/atom/foundCorner
					var/foundBlock
					var/checkCorners[] = bounds(coords[1]+bx, coords[2]+by, bwidth, bheight, z)

					for(var/atom/A in checkCorners)
						checkCorners |= get_step(A,NORTH)//obounds(A, 0, 1, 2, 2)

					for(var/turf/A in checkCorners)
						checkCorners |= A.contents//obounds(A, 0, 1, 2, 2)

					for(var/atom/A in checkCorners)
						if(A == src) continue
						if(!A.density) continue

						var/topY = (A.y-1) * tile_height
						if(istype(A,/atom/movable)) topY +=  A:bound_y + A:bound_height
						else topY += tile_height

						if(topY >= coords[2] + by && topY <= coords[2] + by + bheight)
							var/coordX = (A.x-1) * tile_width

							if(istype(A,/atom/movable)) coordX += A:bound_x

							if(moveKeys & 8)

								if(istype(A,/atom/movable)) coordX += A:bound_width
								else coordX += tile_width

							if(moveKeys & 4 && (coordX < coords[1] + bx || coordX > coords[1] + bx + bwidth))
								foundBlock = 1
								break

							if(moveKeys & 8 && (coordX > coords[1] + bx || coordX < coords[1] + bx + bwidth))
								foundBlock = 1
								break

							if(!foundBlock)
								if(A.cliffHang) foundCorner = A
								else
									foundBlock = 1
									break


						else if(topY > coords[2] + by + bheight)
							foundBlock = 1
							break

					if(!foundBlock && foundCorner)
						isCliffHanging = 1
						isWallSliding = 0
						cliffHangDirection = 0

						var/cornerCoords[2]
						var/newCoords[2]

						//get the corner coordinates
						if(moveKeys & 4)
							cornerCoords = foundCorner.getTopLeftCorner()
							cliffHangDirection = 4

						if(moveKeys & 8)
							cornerCoords = foundCorner.getTopRightCorner()
							cliffHangDirection = 8

						//find where I should move
						newCoords[1] = cornerCoords[1] - bx - bwidth/2
						newCoords[2] = cornerCoords[2] - by - bheight/2

						//Then force me to move there by directly setting the step coordinates
						x = newCoords[1]/tile_width + 1
						y = newCoords[2]/tile_height + 1
						step_x = newCoords[1]%tile_width
						step_y = newCoords[2]%tile_height


				//Then check cliff hanging
				//There is a specific collission box that should be defined, relative to this actor
				//It then needs to check all of the walls/ground atoms within this collision box and make sure that
				//This collision box's upper bound is higher than all of the other atoms upper bound
				//If this checks out, turn off wall sliding and turn on cliff hanging

			parkourChecks() //This will handle checks for special parkour moves.
			//If the checks are successful, then it will set the special parkour move states.

			parkourAnimation()

			breakParkourMove() //This is for cancelling the parkourMove
				parkourMove = null
				parkourTimer = 0
				parkourAtom = null

			updateIconState() //This will go through all of the special movement variables
				//and set the icon state as appropriate

				//this shit needs to get refactored pretty badly

				getDisplayDirection()

				dir = displayDirection

				if(isCliffHanging)
					icon_state = "hanging"
					dir = cliffHangDirection

				else if(isWallSliding)
					icon_state = "wallSliding"
					dir = wallSlideDirection

				else if(isCrouching && isGrounded)
					if(moveKeys & 12) icon_state = "crouch walking"
					else icon_state = "crouching"

					if(equip && canUseWeapon() && currentTime() >= armlessTimer)
						if(aimAngle > 90 && aimAngle < 270) displayDirection = 8
						else displayDirection = 4

						dir = displayDirection


				else if(isOnLadder)

					if(vx || vy) icon_state = "climbing"
					else icon_state = "climb"

				else if(!isGrounded || !lastGrounded)
					if(vy >30) icon_state = "jump 0"
					else if(vy >-60) icon_state = "jump 1"
					else if(vy >-120) icon_state = "jump 2"
					else icon_state = "jump 3"

				else
					if(moveKeys & 12) icon_state = "running"
					else icon_state = "standing"

				if(equip && canUseWeapon() && currentTime() >= armlessTimer && istype(equip,/weapon/gun))
					icon_state = "[icon_state] -armless"

					if(aimAngle > 90 && aimAngle < 270) displayDirection = 8
					else displayDirection = 4

					var/arms = canUseWeapon()

					if(aimArmState() != armState || justEquipped)
						armState = aimArmState()

						justEquipped = 0
						drawAngle = computeArms(equip, aimAngle, equip.hands, arms)
				else
					removeArms()
					armState = null

				if(isDead)
					if(isGrounded)
						icon_state = "dead 0"
						bound_height = crouchingHeight

					else
						icon_state = "dead 1"
						bound_height = standingHeight


			checkGround(offset_x = 0, offset_y = 0) //This will check to see if there is a ground for this actor to land on.
				//If there is, it will return the atom
				if(!loc) return

				var/x_off = vx*dt + offset_x
				var/y_off = min(-1, vy*dt - 1) + offset_y

				if(x_off < 0) x_off = round(x_off)
				if(x_off > 0) x_off = -round(-x_off)

				if(y_off < 0) y_off = round(y_off)
				if(y_off > 0) y_off = -round(-y_off)

				for(var/atom/A in obounds(src, x_off, y_off, 0, bound_height-2) )
					//if(A == src) continue
					if(A.density || (A.isScaffold && vy <=0))
						if(get_dir(src, A) & 2)
							return A

			processGrounded()
				ground = checkGround()
				if(ground) //The active "ground" for this atom greatly affects how it moves
					//So check and set ground first.
					isGrounded = 1

					if(bounds_dist(src,ground) != 0 && ground.isScaffold && pixelDistY(src,ground)>0)

						var/dist = pixelDistY(src,ground)
						step_y -= dist
						vy = 0

				else
					isGrounded = 0

				if(isGrounded != lastGrounded && isGrounded)
					jumpTimer = max(jumpTimer, currentScreen.screenTime + 0.1)


			processMovement()
				//Process ground check and behaviors
				if(isCrouching)
					bound_height = crouchingHeight
				else
					bound_height = standingHeight

				processGrounded()

				fallingChecks()

				parkourChecks()

				processInputs()

				gravity()
				Velocity()

				updateIconState()

				lastGrounded = isGrounded
				lastAimAngle = aimAngle

			canJump()
				return (currentScreen.screenTime >= jumpTimer)

			jump(ax = 0, ay = jumpingAcceleration)

				if(!src) return //wat
				if(!canJump()) return
				vy = 0


				jumpTimer = currentScreen.screenTime + 0.25
				Accelerate(ax, ay, 1)
				step_y += jumpBoost

				isGrounded = 0
				ground = 0

				isCliffHanging = 0

				isWallSliding = 0

				isOnLadder = 0

			getDisplayDirection()
				if(moveKeys & 4) displayDirection = 4
				if(moveKeys & 8) displayDirection = 8

			land()
				if(vy < -200)
					landTimer = currentScreen.screenTime + 0.25

				//If the vx is too fast, then add a roll

			landTick()

			computeArms(weapon/W, angle, hands = 2, arms = 1)
				//I'm just going to use vectors for all of this shit
				//This adds the arms via a precise kinematics solver. what a pain in the ass
				var
					vector
						center
						rightShoulder
						leftShoulder
						hand //right

						gun
						scale_x = 1

					useAngle = angle
					shoulderLength = 10
					forearmLength = 8

					gunRadius = W.dRadius

					drawLayer = src.layer// + 10
					returnAngle

					hand1_x
					hand1_y

					hand2_x
					hand2_y

					isReloading = 0
					reloadTime = 0

					equip_state = W.equip_state

				if(isGrounded && !isCrouching)
					if(moveKeys & 12)
						gunRadius += 3

				//if hands = 1, then both hands are in the same spot and only one is drawn. right hand is used only
				//if hands = 2, then there are two hand placements

				//if arms = 1, then only the right shoulder is drawn
				//if arms = 2, then only the left shoulder is drawn
				//if arms = 3, then both shoulders are drawn

				//set the displayDirection based upon angle

				//Initializing hand coords
				if((arms & 1) && (hands  > 0))
					hand1_x = W.hand1_x
					hand1_y = W.hand1_y

				if((arms & 2) && (hands  == 2))
					hand2_x = W.hand2_x
					hand2_y = W.hand2_y

				if(istype(W, /weapon/gun/))
					if(W.isReloading)

						if(displayDirection & 4)
							angle = 0
						if(displayDirection & 8)
							angle = 180

						isReloading = 1
						reloadTime = currentTime()
						reloadTime -= W:reloadTime


				if(arms && (arms&3)!=3)
					gunRadius *= 2

				removeArms(arms)

				//compute angular limitations here
				useAngle = canAimAt(angle)
				returnAngle = useAngle

				if(useAngle > 90 && useAngle < 270)
					useAngle = 180-useAngle
					scale_x = -1

				//compute the center
				center = vec2()
				center.y = getWeaponHeight()

				//compute the shoulders

				rightShoulder = getShoulder(1)
				leftShoulder = getShoulder(2)

				var/icon/graphic = new(src.icon)

				center.x += graphic.Width()/2
				rightShoulder.x += graphic.Width()/2
				leftShoulder.x += graphic.Width()/2

				gun = vec2(gunRadius * cos(useAngle), gunRadius * sin(useAngle))
				gun.x *= scale_x


				//compute the right arm
				//compute the hand position
				hand = vec2(hand1_x, hand1_y)
				hand = hand.rotateAboutAxis(vec3(0,0,1), useAngle)
				hand.x *= scale_x

				hand = hand.add(gun)
				hand = hand.add(center)

				if(arms & 1)
					computeArm("right", rightShoulder, hand, useAngle, drawLayer + 0.2, shoulderLength, forearmLength, scale_x)
				//compute the left arm
				//compute the hand position


				if(arms & 2)
					if(hands == 2 || isReloading)
						//get the keyframes if isReloading
						var/shouldRotateHand = 1

						if(isReloading)
							var/keyframes[] = getKeyframes(W:reloadKeyframes, reloadTime)

							if(keyframes)
								//interpolate keyframes
								var/keyframe
									key1 = keyframes[1]
									key2 = keyframes[2]

								if(key1.state == "C")
									key1 = new(-gun.x, -gun.y - 15, key1.time, key1.state)
									shouldRotateHand = 0
									key1.x *= scale_x
									key1.x += 5

								if(key2.state == "C")
									key2 = new(-gun.x, -gun.y - 15, key2.time, key2.state)
									shouldRotateHand = 0
									key2.x *= scale_x
									key2.x += 5

								//apply the update and compute the hand vector

								var/keyframe/handFrame = interpolateKeyframes(reloadTime, key1, key2)

								hand2_x = handFrame.x
								hand2_y = handFrame.y


								if(handFrame.state != null)
									equip_state = W:reload_state

						hand = vec2(hand2_x, hand2_y)
						if(shouldRotateHand) hand = hand.rotateAboutAxis(vec3(0,0,1), useAngle)
						hand.x *= scale_x

						hand = hand.add(gun)
						hand = hand.add(center)

					computeArm("left", leftShoulder, hand, useAngle, drawLayer - 0.2, shoulderLength, forearmLength, scale_x)


				//add the gun overlay
				gun = gun.add(center)

				var/Overlay/O = src.overlay("gun")
				O.Icon(W.equip_icon)
				O.IconState(equip_state)
				O.Layer(drawLayer)

				O.ShowTo(player)
				var/icon/I = icon(W.equip_icon, W.equip_state)
				var/matrix/m = matrix()
				m.Turn(-useAngle)
				m.Scale(scale_x, 1)
				m.Translate(-I.Width()/2, -I.Height()/2)
				m.Translate(gun.x, gun.y)
				O.Layer(layer+1)
				O.Transform(m)

				if(useAngle < 0) useAngle += 360
				if(useAngle > 360) useAngle -= 360

				//Create the reloading particle systems
				if(isReloading)
					if(reloadTime >= W:dropMagDelay && !W.reloadParticle)
						//create a mag particle here
						if(W.reloadParticleType)
							var/vector/reloadVector = vec2(W.reload_x, W.reload_y)
							reloadVector = reloadVector.rotateAboutAxis(vec3(0,0,1), useAngle)
							reloadVector.x *= scale_x

							reloadVector = reloadVector.add(gun)
							reloadVector = reloadVector.add(vec2(-24,0))

							W.reloadParticle = 1

							new W.reloadParticleType (src, src.displayDirection, reloadVector)

				return returnAngle

			computeArm(side, vector/shoulder, vector/hand, angle, layer, shoulderLength, forearmLength, scale_x = 1)
				//This is the IK solver for an arm.

				var/vector
					elbow
					midpoint
					difVec

				var/Overlay/O

				difVec = hand.subtract(shoulder)
				var/d = difVec.magnitude()

				if(d > shoulderLength + forearmLength)
					difVec = difVec.scaleToMagnitude(shoulderLength + forearmLength - 1)
					d = shoulderLength + forearmLength - 1

				//compute the elbow position
				var/a = (shoulderLength*shoulderLength - forearmLength*forearmLength + d*d)/ (2*d)
				var/h = sqrt(shoulderLength*shoulderLength - a*a)

				midpoint = difVec.multiply(a/d)
				midpoint = midpoint.add(shoulder)

				var/ex = difVec.y * h/d
				var/ey = difVec.x * h/d

				var/x1 = midpoint.x + ex
				var/y1 = midpoint.y - ey

				var/x2 = midpoint.x - ex
				var/y2 = midpoint.y + ey

				if(side == "right")
					if(y1 < y2)
						elbow = vec2(x1, y1)
					else
						elbow = vec2(x2, y2)

				if(side == "left")
					if(y1 < y2)
						elbow = vec2(x1, y1)
					else
						elbow = vec2(x2, y2)

				//now place everything...
				var/vector/forearm = hand.subtract(elbow)
				var/shoulderAngle
				var/elbowAngle
				var/matrix/m = matrix()

				shoulderAngle = _GetAngle(elbow.y - shoulder.y, elbow.x - shoulder.x)

				O = src.overlay("[side] shoulder", armGraphic, "[side] shoulder", layer-0.1)
				O.ShowTo(player)
				m.Scale(1, scale_x)
				m.Turn(-shoulderAngle)
				m.Translate(-10,-10)
				m.Translate(shoulder.x, shoulder.y)
				O.Transform(m)

				elbowAngle = _GetAngle(forearm.y, forearm.x)
				m = matrix()

				O = src.overlay("[side] forearm", armGraphic, "[side] fore", layer+0.1)
				O.ShowTo(player)
				m.Scale(1, scale_x)
				m.Turn(-elbowAngle)
				m.Translate(-10,-10)
				m.Translate(elbow.x, elbow.y)
				O.Transform(m)

				m = matrix()
				O = src.overlay("[side] hand", armGraphic, "[side] hand", layer+0.4)
				O.ShowTo(player)
				m.Turn(-angle)
				m.Scale(scale_x, 1)
				m.Translate(-10,-10)
				m.Translate(hand.x, hand.y)
				O.Transform(m)

			removeArms(arms)
				var/Overlay/O

				if(!(arms & 1))
					O = src.getOverlay("right shoulder")
					if(O) del O
					O = src.getOverlay("right forearm")
					if(O) del O
					O = src.getOverlay("right hand")
					if(O) del O

				if(!(arms & 2))
					O = src.getOverlay("left shoulder")
					if(O) del O
					O = src.getOverlay("left forearm")
					if(O) del O
					O = src.getOverlay("left hand")
					if(O) del O

				if(!(arms & 3))
					O = src.getOverlay("gun")
					if(O) del O

			canUseWeapon()
				if(currentTime() < armlessTimer) return 0

				if(!isOnLadder && !isCliffHanging)
					if(isWallSliding) return 1
					else return 3

				return 0

			getShoulder(num) //num=1 for right, num=2 for left
				var/px, py

				if(icon_state == "crouching -armless")
					if(num == 1)
						px = -6
						py = 22
					if(num == 2)
						px = 6
						py = 22

					if(displayDirection & 8) px *=-1

				else if(icon_state == "crouch walking -armless")
					if(num == 1)
						px = -6
						py = 22
					if(num == 2)
						px = 6
						py = 22

					if(displayDirection & 8) px *=-1

				else if(icon_state == "running -armless")
					px = 3
					py = 36

					if(moveKeys & 8) px = -3

				else if(icon_state == "wallSliding -armless")
					px = 10
					py = 41
					if(num == 2) px = -10

					if(wallSlideDirection & 4) px *=-1

				else if(icon_state == "standing -armless")
					if(num == 1)
						px = -5
						py = 36
					if(num == 2)
						px = 5
						py = 36

					if(displayDirection & 8) px *=-1

				else
					if(num == 1)
						px = -5
						py = 38
					if(num == 2)
						px = 8
						py = 38

					if(displayDirection & 8) px *=-1

				return vec2(px,py)

			equipped(weapon/O)
				justEquipped = 1

			aimArmState()
				var/aimArmState =  icon_state + " [round(aimAngle, 3)] [moveKeys] [spaceKey]"
				if(equip.isReloading) aimArmState += " RELOAD[currentTime()]"
				return aimArmState

			canAimAt(angle)
				if(isWallSliding)
					if(wallSlideDirection & 4) angle = max(135, min(225, angle))
					else
						if(angle > 180)  angle = max(angle, 315)
						else  angle = min(angle, 45)

				else if(!isGrounded)
					if(angle > 90)  angle = max(135, angle)
					else  angle = min(45, angle)

				else if(isGrounded)
					if((moveKeys & 12) && !isCrouching)

						if(moveKeys & 8)  angle = max(135, min(225, angle))
						else
							if(angle > 180)  angle = max(angle, 315)
							else  angle = min(angle, 45)

				return angle

			equipItem(weapon/I)
				if(equip == I) return

				if(equip) unEquipItem()
				if(!I) return

				equip = I
				I.equipped(src)
				equipped(I)

			//unequip shit
			unEquipItem()
				if(equip)
					equip.unEquipped(src)
					equip = null
					///it be 100% unequipped
