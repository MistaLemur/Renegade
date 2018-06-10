EquipmentRing
	/*
	This class defines behavior for the equipment ring, like the one from GTA V
	*/
	
	parent_type = /GUIDatum

	var
		menu[7]

		highlight
		lastHighlight

		specialHighlight

		updateTimer

		layer = HUD_LAYER + 50

		prevSpeed

		startDelay = 0.5
		slowDown = 0.1

	key_up(k, client/c)
		if(k == "q" || k == "Q")
			del src

	key_down(k, client/c)

	#ifndef NO_KEY_REPEAT
	key_repeat(k, client/c)
	#endif

	#ifndef NO_CLICK
	click(object, client/c)
		player.keys["q"] = 0
		player.keys["Q"] = 0
		computeSelection(player.mouse_x, player.mouse_y)

		del src

	#endif

	New(options[], spec)
		menu = options.Copy()


		player.focus = src

		specialHighlight = spec

		prevSpeed = gameSpeed

		gameSpeed = slowDown

		updateTimer = currentScreen.screenTime + startDelay * slowDown

		//Now add the HUD objects
		addSelectionHUD()

		if(specialHighlight in menu)
			highlight = specialHighlight
			updateSelectionHUD()

	Del()
		//now compute the selection

		//and call the player function for the selection
		//call(callContext, callFunction)(highlight)
		processEquip()

		gameSpeed = prevSpeed

		player.focus = player

		cleanUpHUDObjects()

		.=..()

	MouseUpdate(mx, my)
		computeSelection(mx, my)

	proc
		processEquip()
			var/item/O = highlight
			if(istype(O,/weapon) || !O)
				return player.mob:equipItem(O)
			if(istype(O,/item))
				return O.use()


		computeSelection(mouseX, mouseY)
			if(currentScreen.screenTime < updateTimer) return
			mouseX -= center_px
			mouseY -= center_py

			//now get the angle
			var/angle = _GetAngle(mouseY, mouseX)
			var/dist = sqrt(mouseX*mouseX + mouseY*mouseY)

			//now convert that angle into an index and read from the options array
			var/updateHUD = 0

			if(dist >= 60 && dist <= 120)
				var/index = 0

				if(angle >= 67.5 && angle < 112.5) index = 1
				if(angle >= 22.5 && angle < 67.5) index = 2
				if(angle >= 337.5 || angle < 22.5) index = 3
				if(angle >= 292.5 && angle < 337.5) index = 4
				if(angle >= 202.5 && angle < 247.5) index = 5
				if(angle >= 157.5 && angle < 202.5) index = 6
				if(angle >= 112.5 && angle < 157.5) index = 7

				var/newHighlight
				if(index > 0)
					newHighlight = menu[index]

				updateHUD = highlight!=newHighlight

				if(lastHighlight != highlight && updateHUD)
					lastHighlight = highlight

				highlight = newHighlight

			//now update the hud
			if(updateHUD)
				updateSelectionHUD()

		addSelectionHUD()
			var/HUDObj/O
			var/t = "_equipRing"
			//first add the ring
			O = player.addHUD("[t] ring", 198, 55, 'EquipRing.png', null, layer - 5)//addHUD(hudTag, screen_px, screen_py, icon/graphic
			O.alpha = 0
			O.transform = scaleMatrix(0.75,0.75)
			animate(O, transform = matrix(), alpha = 255, time = startDelay * 10)

			player.Darken(128)

			//then add the "special"
			var/index = menu.Find(specialHighlight)
			if(index > 0 && specialHighlight)
				O = player.addHUD("[t] special", 198, 55, 'EquipRingEquipped.png', null, layer)//addHUD(hudTag, screen_px, screen_py, icon/graphic
				O.alpha = 0
				O.transform = scaleMatrix(0.75,0.75)
				O.layer ++

				if(index > 4) index ++

				var/matrix/m = matrix()
				m = turn(m, (index-1) * 45)

				animate(O, transform = m, alpha = 255, time = startDelay * 10)

			for(var/i = 1; i<=menu.len; i++)
				index = i
				if(index > 4) index ++

				var/item/W = menu[i]//then add the guns
				if(!W) continue
				var/r = 92
				var/angle = (index-1) * 45

				var/px = center_px + r * sin(angle)
				var/py = center_py + r * cos(angle) + 5

				//scale then transform
				O = player.addHUD("[t] gun[i]", px, py, W.bigGraphic, null, layer + 1)
				O.layer +=2
				O.alpha = 0

				var/icon/graphic = icon(W.bigGraphic)
				var/matrix/m = matrix()
				m.Scale(0.75,0.75)
				m.Translate(-graphic.Width()/2, -graphic.Height()/2)

				O.transform = m
				animate(O, alpha = 192, time = startDelay * 10)

				if(istype(W, /weapon))
					//now ammunition
					var/textWidth = graphic.Width() * 2
					O = player.addHUD("[t] ammo[i]", px - textWidth/2, py -graphic.Height()/2 - 10, null, null, layer + 1)
					O.layer +=2
					O.maptext_width = textWidth
					O.maptext_height = 200
					O.maptext = "<font align=center size=0.5><b>[W:getAmmoString()]"

					O = player.addHUD("[t] ammo[i] shadow", px - textWidth/2 + 2, py -graphic.Height()/2 - 10 - 2, null, null, layer)
					O.layer ++
					O.maptext_width = textWidth
					O.maptext_height = 200
					O.maptext = "<font align=center color=black  size=0.5><b>[W:getAmmoString()]"

		updateSelectionHUD()
			var/HUDObj/O
			var/index
			var/matrix/m
			var/icon/graphic

			//fade away lastHighlight
			if(lastHighlight != highlight && lastHighlight)
				graphic = icon(lastHighlight:bigGraphic)
				m = matrix()
				m.Scale(0.75,0.75)
				m.Translate(-graphic.Width()/2, -graphic.Height()/2)

				index = menu.Find(lastHighlight)
				O = player.getHUD("_equipRing gun[index]")
				animate(O, transform = m, alpha = 192, time = 2.5)

			//fade in highlight
			if(highlight)
				graphic = icon(highlight:bigGraphic)
				m = matrix()
				m.Scale(1,1)
				m.Translate(-graphic.Width()/2, -graphic.Height()/2)

				index = menu.Find(highlight)
				O = player.getHUD("_equipRing gun[index]")
				animate(O, transform = m, alpha = 255, time = 2.5)

				//compute the center coords
				if(index > 4) index++
				var/r = 92
				var/angle = (index-1) * 45
				var/px = center_px + r * sin(angle)
				var/py = center_py + r * cos(angle) + 5

				var/textWidth = graphic.Width() * 2
				O = player.addHUD("_equipRing selectName", px - textWidth, py +graphic.Height()/2 + 0, null, null, layer + 1)
				O.layer +=2
				O.maptext_width = textWidth * 2
				O.maptext_height = 200
				O.maptext = "<font align=center size=0.5><b>[highlight:name]"

				O = player.addHUD("_equipRing selectName shadow", px - textWidth + 2, py +graphic.Height()/2 + 0 - 2, null, null, layer)
				O.layer ++
				O.maptext_width = textWidth * 2
				O.maptext_height = 200
				O.maptext = "<font align=center color=black  size=0.5><b>[highlight:name]"

			if(!highlight)
				player.removeHUD("_equipRing selectName")
				player.removeHUD("_equipRing selectName shadow")

		cleanUpHUDObjects()

			//clean up the hud objects
			//animate them

			//remove the equip thing
			player.removeHUD("darken")
			player.removeHUD("_equipRing selectName")
			player.removeHUD("_equipRing selectName shadow")

			var/HUDObj/O
			player.removeHUD("_equipRing special")

			//make all of the guns fade
			for(var/i=1; i <= menu.len; i++)
				player.removeHUD("_equipRing ammo[i]")
				player.removeHUD("_equipRing ammo[i] shadow")

				O = player.getHUD("_equipRing gun[i]")
				if(O) animate(O, alpha = 0, time = 2.5)

			//make the ring fade and shrink
			O = player.getHUD("_equipRing ring")
			animate(O, transform=scaleMatrix(0.75,0.75), alpha = 0, time = 2.5)

			//sleep
			spawn(5)
			//delete them
				player.clearHUDGroup("_equipRing")
