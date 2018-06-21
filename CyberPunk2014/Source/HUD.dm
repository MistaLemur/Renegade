/*
Author: Miguel SuVasquez
March 2014

This file contains logic for the HUD. Class definitions are elsewhere.
*/
client

	var
		updateHealth = 1
		updateAmmo = 1
		updateHUDButtons = 1

	proc
		updateHUD()
			if(!istype(mob, /actor/humanoid/player)) return

			if(updateHealth)
				updateHealth = 0
				updateHealth()

			if(updateAmmo)
				updateAmmo = 0
				updateAmmo()

			if(updateHUDButtons)
				updateHUDButtons = 0
				updateHUDButtons()

		updateHealth()
			var
				px = 13
				py = 305

			addHUD("_health back", px, py, 'HealthHUD.png')
			var/HP = mob:health
			var/maxHP = mob:maxHealth

			var/fullBars = round(HP/10)
			var/numBars = round(maxHP/10)

			px += 20
			py += 5

			var/i = 1
			for(i ; i<=fullBars ; i++)
				//add these full bars...
				addHUD("_health white[i]", px, py, 'Health WhitePiece.png', null, HUD_LAYER+1)
				removeHUD("_health black[i]")
				px += 7

			for(i; i <= numBars; i++)
				//draw the bar
				var/HUDObj/O = addHUD("_health black[i]", px, py, 'Health BlackPiece.png', null, HUD_LAYER+2)
				O.transform = matrix()

				var/partialHeight = 1-((HP)%(10))/10

				if(i == fullBars+1 && partialHeight < 1)
					//then make the partial bar
					var/matrix/m = matrix()

					//scale first
					m.Scale(1,partialHeight)
					//then translate
					m.Translate(0, 15 / 2 * (1-partialHeight))

					O.transform = m

					//add the white piece just in case
					addHUD("_health white[i]", px, py, 'Health WhitePiece.png', null, HUD_LAYER+1)

				else
					//remove the white piece
					removeHUD("_health white[i]")

				px += 7

		updateAmmo()
			var
				px = 13
				py = 10
				weapon/gun/G = mob:equip

			if(!G || !istype(G, /weapon/gun))
				//remove the ammo hud

				removeHUD("_ammo back")
				removeHUD("_ammo graphic")
				removeHUD("_ammo text")
				removeHUD("_ammo textShadow")
				removeHUD("_ammo name")
				removeHUD("_ammo nameShadow")

			else
				addHUD("_ammo back", px, py, 'AmmoHUD.png')

				var/icon/I = icon(G.bigGraphic)
				var/xOffset = (100 - I.Width())/2
				//now show the equip graphic
				addHUD("_ammo graphic", px + xOffset, py + 3, G.bigGraphic, null, HUD_LAYER+1)

				//now draw the text
				var/HUDObj/O = addHUD("_ammo text", px - 1, py - 9, null, null, HUD_LAYER+2)
				O.maptext_width = 100
				O.maptext_height = 15
				O.maptext = "<font size=0.5 color=white align=right><b>[G.getAmmoString()]"

				O = addHUD("_ammo textShadow", px - 1 + 1, py - 9 - 1, null, null, HUD_LAYER+1)
				O.maptext_width = 100
				O.maptext_height = 15
				O.maptext = "<font size=0.5 color=black align=right><b>[G.getAmmoString()]"

				O = addHUD("_ammo name", px - 1, py + 45, null, null, HUD_LAYER+2)
				O.maptext_width = 150
				O.maptext_height = 15
				O.maptext = "<font size=0.5 color=white><b>[G.name]"

				O = addHUD("_ammo nameShadow", px - 1 + 1, py + 45 - 1, null, null, HUD_LAYER+1)
				O.maptext_width = 150
				O.maptext_height = 15
				O.maptext = "<font size=0.5 color=black><b>[G.name]"

		updateHUDButtons()
			//add the buttons chummer.
			var/px, py
			//inventory button
			px = 529
			py = 305
			var/HUDObj/O = addHUD("_buttons Inventory", px, py, 'inventoryHUDButton.png', null, HUD_LAYER)
			O.mouse_opacity = 2
			O.callContext = src
			O.callFunction = "openInventory"
			O.callMouseDown = 1
