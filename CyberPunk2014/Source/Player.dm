/*
Author: Miguel SuVasquez
March 2014

This file defines the player subclass of humanoids.
Included in the definitions are update functions, interpreting key presses, triggering interaction events, some movement behaviors, and so forth.
*/
actor/humanoid
	player

		bound_x = -10
		bound_width = 20
		bound_height = 50

		pixel_x = -25
		pixel_y = -1

		icon = 'Protagonist.dmi'
		armGraphic = 'ProtagonistArms.dmi'

		crouchingHeight = 35
		standingHeight = 50

		damageMult = 0.5

		var
			interactKey
			interactTimer
			useInteractDelay = 1

			ignoreFromFocus

			atom/movable/interactAtom

			GUIDatum/activeGUIDatum

			hotKeyItems[7]
/*
		updateIconState()
			getDisplayDirection()

			dir = displayDirection

			if(isCliffHanging)
				icon_state = "hanging"
				dir = cliffHangDirection

			else if(isWallSliding)
				icon_state = "wallSliding"
				dir = wallSlideDirection

			else if(isCrouching && isGrounded)
				icon_state = "crouching"


			else if(isOnLadder)

				if(moveKeys & 1)
				else if(moveKeys & 2)
				else

			else if(!isGrounded || !lastGrounded)
				if(vy >30) icon_state = "jump 0"
				else if(vy >-60) icon_state = "jump 1"
				else if(vy >-120) icon_state = "jump 2"
				else icon_state = "jump 3"

			else
				if(moveKeys & 12) icon_state = "running"
				else icon_state = "standing"
*/
			//if there's an equipped item
			//run a function that will process the arms son

		tick()
			.=..()

			//if I'm mouse tracking and I have something equipped, turn the mouse coords into an aim angle

			ignoreFromFocus = (player.focus != player)

			getClientInput()

			processMovement()

			processInteraction()

			if(equip)
				if(useEquip) equip.use(useEquip)
				if(player.keys["r"]) equip.rKey()

			player.updateHUD()


		land()
			if(vy < -200)
				flick("landing", src)
				armlessTimer = currentTime() + 0.6
			.=..()

		getWeaponHeight()
			if(isCrouching) return 24
			else return 40

		//equip shit
		equipItem(weapon/I)
			if(!canChangeEquipment()) return
			if(equip == I) return

			if(equip) unEquipItem()
			if(!I) return

			equip = I
			I.equipped(src)
			equipped(I)

			player.updateAmmo = 1

		//unequip shit
		unEquipItem()
			if(equip)
				equip.unEquipped(src)
				equip = null

			player.updateAmmo = 1

		proc
			canInteract()
				if(ignoreKeys) return 0
				if(currentScreen.screenTime < interactTimer) return 0
				return 1

			processInteraction()
				if(!canInteract())
					//remove any related HUD objects
					player.clearHUDGroup("_interact")
					return

				//find some interactive atom within bounds()
				var/updateText
				var/atom/movable/interact
				for(var/atom/movable/A in obounds(src, -2, 0, 4, 0))
					if(A.canInteract)
						interact = A
						break

				if(interactAtom != interact) updateText = 1

				interactAtom = interact

				if(interactAtom)
					if(interactKey)
						//If the interact key is pressed, set the interact timer and trigger the event
						interactTimer = currentScreen.screenTime + useInteractDelay + interactAtom.interactDelay
						interactAtom.interactEvent(src)
						player.clearHUDGroup("_interact")
						interactAtom = null

					else if(interactAtom.interactDesc && updateText)
						//otherwise, display the relevant HUD text
						var/HUDObj/O = player.addHUD("_interactText")
						O.screen_loc = "1, [center_tiley-4]"
						O.maptext_width = screen_px
						O.maptext_height = 400
						O.layer = HUD_LAYER + 25
						O.maptext = "<font align=center size = 0.5 color=white><b>\
						Press E to [interactAtom.getInteractDesc()]"

						O = player.addHUD("_interactTextShadow")
						O.screen_loc = "1:1, [center_tiley-4]:-1"
						O.maptext_width = screen_px
						O.maptext_height = 400
						O.layer = HUD_LAYER + 25 - 0.5
						O.maptext = "<font align=center size=0.5 color=black><b>\
						Press E to [interactAtom.getInteractDesc()]"


				else if(updateText)
					player.clearHUDGroup("_interact")


			getClientInput()
				if(!client) return
				if(!player) return
				if(ignoreFromFocus) return

				if(player.isMouseTracking && equip)
					//Yes, all of this math is necessary to convert the mouse coordinates to an angle relative
					//to the player.

					var/camera/C = player.camera
					var/vector/mouseVec = \
						vec2(player.mouse_x - center_px, player.mouse_y - center_py)
					var/vector/camVec = C.pixelCoordsVector()
					camVec = camVec.add(C.pixelCenterVector())

					var/vector/playerVec = src.pixelCoordsVector()
					playerVec.y += getWeaponHeight()

					var/vector/difVec = playerVec.subtract(camVec)
					mouseVec = mouseVec.subtract(difVec)

					aimAngle = _GetAngle(mouseVec.y, mouseVec.x)

				if(player.keys["w"]) moveKeys |= 1
				else moveKeys &= ~1

				if(player.keys["s"]) moveKeys |= 2
				else moveKeys &= ~2

				if(player.keys["a"]) moveKeys |= 8
				else moveKeys &= ~8

				if(player.keys["d"]) moveKeys |= 4
				else moveKeys &= ~4

				if(player.keys["space"]) spaceKey = 1
				else spaceKey = 0

				if(player.keys["e"]) interactKey = 1
				else interactKey = 0

				if(player.keys["q"])
					if(canChangeEquipment()) showEquipmentRing()

				if(player.keys["i"])
					//open inventory
					player.openInventory()
					player.keys["i"] = 0

				if(player.mouseButton & 3) useEquip = 1
				else useEquip = 0

			//show equipment wheel
			showEquipmentRing()
				//create an equipment ring
				activeGUIDatum = new/EquipmentRing (hotKeyItems, equip)

			closeEquipmentRing()
				//kill the equipment ring
				del activeGUIDatum

				//reset focus to the client
				player.focus = player

			canChangeEquipment()
				if(equip) if(currentTime() < equip.useTimer) return 0
				return 1
