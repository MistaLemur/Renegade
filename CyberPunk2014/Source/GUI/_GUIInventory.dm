/*
Author: Miguel SuVasquez
March 2014

This file provides the definition for the GUIInventory object, which represents the inventory menu in-game.
*/

client/proc
	openInventory()
		if(src.focus != src) return
		new/GUIInventory(src)



GUIInventory
	parent_type = /GUIDatum

	var
		actor/humanoid/player/owner

		inventory[0]
		shortcuts[0]

		item/selectedItem

		inventoryIndex = 1

		shortcuts_px = 483
		shortcuts_py = 175

		layer = HUD_LAYER+50

		drawnIndex

	//
	New()
		owner = player.mob
		if(!currentScreen) del src
		if(!istype(owner, /actor/humanoid/player)) del src

		player.focus = src
		player.isTrackingButton = 0
		player.mouseButton = 0
		player.mob:useEquip = 0

		currentScreen.isPaused = 1

		//gets inventory list. Pass it by reference.
		//gets shortcuts list. Pass it by reference.
		inventory = owner.inventory
		shortcuts = owner.hotKeyItems

		//Now start drawing shit
		addInventoryHUD()

	Del()
		player.focus = player
		player.mouseButton = 0
		player.mob:useEquip = 0
		player.isTrackingButton = 1

		removeInventoryHUD()

		currentScreen.isPaused = 0

		.=..()

	proc
		addInventoryHUD()
			player.Darken(128)

			//add background
			var/HUDObj/O = player.addHUD("_inventory back", 0, 0, 'Inventory GUI.png', null, layer - 5)
			O.mouse_opacity = 2
			//add pane
			player.addHUD("_inventory inventory", 32, 27, 'inventoryListBack.png', null, layer - 4)


			O = player.addHUD("_inventory title", 20, 317, null, null, layer)
			O.maptext_width = 200
			O.maptext_height = 20
			O.maptext = "<font color=white size=3><b>Inventory"

			//add shortcuts bar
			player.addHUD("_inventory shortcuts", 372, 63, 'EquipRing.png', null, layer - 4)

			//add close button
			O = player.addHUD("_inventory closeButton", 584, 306, 'closeButton.png', null, layer)
			O.mouse_opacity = 2
			O.callContext = src
			O.callFunction = "Del"
			O.callMouseDown = 1

			updateInventoryHUD()

		updateInventoryHUD()
			var/px, py
			//Draw inventory
			//inventory items in the gui should be limited to 20x20 size.
			px = 34
			py = 314
			var/listHeight = 260
			var/listWidth = 140
			var/entryWidth = 22
			var/entryHeight = 22
			var/startingIndex = inventoryIndex
			var/endingIndex = min(inventory.len, startingIndex + round(listHeight/entryHeight))
			drawnIndex = max(1, inventory.len, drawnIndex)

			for(var/i = 1; i <= drawnIndex; i++)

				if(i < startingIndex || i > endingIndex)
					//remove HUD stuff
					player.removeHUD("_inventory item[i]")
					player.removeHUD("_inventory name[i]")
					player.removeHUD("_inventory back[i]")

					continue

				py -= entryHeight
				var/item/item = inventory[i]
				if(!item)
					inventory -= item
					i--
					continue

				//place the item
				player.addHUD("_inventory item[i]", px+2, py + 3, item.icon, item.icon_state, layer)


				//place the item name
				var/HUDObj/H = player.addHUD("_inventory name[i]", px+entryWidth, py)
				H.maptext_width = listWidth
				H.maptext_height = entryHeight
				H.layer = layer
				H.maptext = "<b><font size=0.5 color=white valign=middle align=center>[item.name]"

				//place item background
				var/hudTag = "_inventory back[i]"

				var/HUDObj/inv/back
				if(hudTag in player.hud) back = player.hud[hudTag]
				else back = new()
				back.screen_loc = computeScreenLoc(px,py)
				back.layer = layer-1
				back.tag = hudTag
				back.icon = 'inventoryItemEmptyBack.png'
				back.parentGUI = src
				back.param = item

				player.hud[hudTag] = back
				player.screen += back

				back.mouse_opacity = 2
				back.mouse_drag_pointer = icon(item.icon, item.icon_state)

				back.callContext = src
				back.callFunction = "select"
				back.callParams = item
				//

				//if the item is selected
				if(item == selectedItem)
					//place item highlight AND name shadow
					back.icon = 'inventoryItemHighlight.png'

					H = player.addHUD("_inventory selectedShadow", px + entryWidth + 1, py-1)
					H.maptext_width = listWidth
					H.maptext_height = entryHeight
					H.layer = layer - 0.5
					H.maptext = "<b><font size=0.5 color=black valign=middle align=center>[item.name]"

			//scrolling buttons...
			if(startingIndex > 1)
				var/HUDObj/O = player.addHUD("_inventory ScrollUp", 176, 306, 'scrollUpButton.png', null, layer + 10)
				O.mouse_opacity = 2
				O.callContext = src
				O.callFunction = "scrollInventory"
				O.callParams = -1
			else player.removeHUD("_inventory ScrollUp")

			if(endingIndex < inventory.len)
				var/HUDObj/O = player.addHUD("_inventory ScrollDown", 176, 35, 'scrollDownButton.png', null, layer + 10)
				O.mouse_opacity = 2
				O.callContext = src
				O.callFunction = "scrollInventory"
				O.callParams = 1
			else player.removeHUD("_inventory ScrollDown")

			px = 197
			py = 25

			if(selectedItem && istype(selectedItem))
				player.addHUD("_inventory selectedPane", px, py, 'inventoryItemDetails.png', null, layer - 4)

				//Draw the selected item's large graphic
				player.addHUD("_inventory selectedGraphicFrame", px + 6, py + 242, 'AmmoHUD.png', null, layer - 3)

				var/icon/itemGraphic = icon(selectedItem.bigGraphic)
				if(!selectedItem.bigGraphic) itemGraphic = icon(selectedItem.icon, selectedItem.icon_state)

				var/xOffset = (100 - itemGraphic.Width())/2
				var/HUDObj/O
				player.addHUD("_inventory selectedGraphic", px + 6 + xOffset, py + 242 + 3, selectedItem.bigGraphic, null, layer)

				O = player.addHUD("_inventory selectedName", px + 6, py + 227, null, null, layer)
				O.maptext_width = 150
				O.maptext_height = 40
				O.maptext = "<b><font size=0.5 color=white>[selectedItem.name]"

				//Draw selected item details.
				if(istype(selectedItem, /weapon/gun))
					//gun damage
					O = player.addHUD("_inventory selectedDamage", px + 6, py + 205, 'GunStats.dmi', \
						"damage", layer)
					O.maptext_width = 80
					O.maptext_height = 20
					O.maptext = "<b><font size=0.5 color=white align=center valign=middle>\
						[selectedItem:getDamageStat()]"

					//gun penetration
					O = player.addHUD("_inventory selectedPenetration", px + 6, py + 185, 'GunStats.dmi', \
						"penetration", layer)
					O.maptext_width = 80
					O.maptext_height = 20
					O.maptext = "<b><font size=0.5 color=white align=center valign=middle>\
						[selectedItem:getPenetrationStat()]"

					//gun current ammo
					O = player.addHUD("_inventory selectedLoudness", px + 6, py + 165, 'GunStats.dmi', \
						"loudness", layer)
					O.maptext_width = 80
					O.maptext_height = 20
					O.maptext = "<b><font size=0.5 color=white align=center valign=middle>\
						[selectedItem:loudness]"

					//gun magazine size
					O = player.addHUD("_inventory selectedCapacity", px + 6, py + 145, 'GunStats.dmi', \
						"capacity", layer)
					O.maptext_width = 80
					O.maptext_height = 20
					O.maptext = "<b><font size=0.5 color=white align=center valign=middle>\
						[selectedItem:getCapacityStat()]"

					//next column...

					//gun firerate
					O = player.addHUD("_inventory selectedFireRate", px + 80, py + 205, 'GunStats.dmi', \
						"firerate", layer)
					O.maptext_width = 80
					O.maptext_height = 20
					O.maptext = "<b><font size=0.5 color=white align=center valign=middle>\
						[selectedItem:getFireRateStat()]"

					//gun accuracy
					O = player.addHUD("_inventory selectedAccuracy", px + 80, py + 185, 'GunStats.dmi', \
						"accuracy", layer)
					O.maptext_width = 80
					O.maptext_height = 20
					O.maptext = "<b><font size=0.5 color=white align=center valign=middle>\
						[selectedItem:getAccuracyStat()]"

					//gun precision
					O = player.addHUD("_inventory selectedPrecision", px + 80, py + 164, 'GunStats.dmi', \
						"precision", layer)
					O.maptext_width = 80
					O.maptext_height = 20
					O.maptext = "<b><font size=0.5 color=white align=center valign=middle>\
						[selectedItem:getPrecisionStat()]"

					//gun handling
					O = player.addHUD("_inventory selectedHandling", px + 80, py + 145, 'GunStats.dmi', \
						"handling", layer)
					O.maptext_width = 80
					O.maptext_height = 20
					O.maptext = "<b><font size=0.5 color=white align=center valign=middle>\
						[selectedItem:getHandlingStat()]"

					//description
					O = player.addHUD("_inventory selectedDesc", px + 3, py + 25, null, null, layer)
					O.maptext_width = 153
					O.maptext_height = 115
					O.maptext = "<b><font size=0.5 color=white valign=top>[selectedItem.description]"

				else if(istype(selectedItem, /item))
					player.removeHUD("_inventory selectedDamage")
					player.removeHUD("_inventory selectedPenetration")
					player.removeHUD("_inventory selectedLoudness")
					player.removeHUD("_inventory selectedCapacity")
					player.removeHUD("_inventory selectedFireRate")
					player.removeHUD("_inventory selectedAccuracy")
					player.removeHUD("_inventory selectedPrecision")
					player.removeHUD("_inventory selectedHandling")

					O = player.addHUD("_inventory selectedDesc", px + 3, py + 25, null, null, layer)
					O.maptext_width = 153
					O.maptext_height = 180
					O.maptext = "<b><font size=0.5 color=white valign=top>[selectedItem.description]"

				//Draw drop button
				O = player.addHUD("_inventory selectedDropButton", px + 92, py + 9, 'dropItemButton.png', null, layer)
				O.mouse_opacity = 2
				O.callContext = src
				O.callFunction = "dropItem"

			else
				//otherwise remove item highlight AND name shadow
				player.clearHUDGroup("_inventory selected")


			//Draw hotkeys
			px = 483
			py = 175

			for(var/i=1; i<=shortcuts.len; i++)
				if(!shortcuts[i])
					player.removeHUD("_inventory shortcuts[i]")
					continue
				var/item/item = shortcuts[i]

				var/angle = (i-1) * 45
				var/r = 92
				if(i > 4) angle += 45
				//This angle is degrees clockwise from the +Y axis

				var/icon/graphic = icon(item.bigGraphic)
				var/off_x = r * sin(angle) - graphic.Width()/2
				var/off_y = r * cos(angle) - graphic.Height()/2

				var/hudTag = "_inventory shortcuts[i]"
				var/HUDObj/inv/O
				if(hudTag in player.hud) O = player.hud[hudTag]
				else O = new()

				O.mouse_opacity = 2
				O.screen_loc = computeScreenLoc(px + off_x, py + off_y)
				O.layer = layer + 5
				O.tag = hudTag
				O.icon = item.bigGraphic
				O.parentGUI = src
				O.param = item

				player.hud[O.tag] = O
				player.screen += O

				O.mouse_opacity = 2
				O.mouse_drag_pointer = icon(item.icon, item.icon_state)

				O.callContext = src
				O.callFunction = "select"
				O.callParams = item

			drawnIndex = inventory.len

		removeInventoryHUD()
			player.removeHUD("darken")
			player.clearHUDGroup("_inventory")

		select(item/I)
			if(!(I in inventory) || !I) return
			if(I == selectedItem) return deSelect()
			selectedItem = I
			updateInventoryHUD()

		deSelect()
			selectedItem = null
			updateInventoryHUD()

		dropItem()
			selectedItem.drop()
			selectedItem = null
			updateInventoryHUD()

		moveItem(item/A, item/B)

		scrollInventory(amount)
			inventoryIndex = max(1, min(inventory.len, inventoryIndex + amount))
			selectedItem = null
			updateInventoryHUD()

		placeIntoHotkeys(index, item/A = null)
			if(index < 0 || index > 7) return
			if(A)
				var/i = shortcuts.Find(A)
				if(i>0) shortcuts[i] = null
				if(!A.canUse) return

			shortcuts[index] = A

			updateInventoryHUD()

HUDObj //I'm going to create some subclasses of HUDObj to capture mouseDrop and mouseDrag events

	inv//inventory...
		var
			GUIInventory/parentGUI

		MouseDrop(over_object,src_location,over_location,src_control,over_control,params)
			.=..()
			//check the over object

			if(istype(over_object, /HUDObj))
				var
					px = 483
					py = 175

				if(istype(src.param, /item))
					//I'm trying to put something on the equipment wheel
					var/dx = usr.client.mouse_x - px
					var/dy = usr.client.mouse_y - py
					var/d = sqrt(dx*dx+dy*dy)
					if(d >= 80 && d <= 115)
						var/index = 0
						var/angle = _GetAngle(dy,dx)

						if(angle >= 67.5 && angle < 112.5) index = 1
						if(angle >= 22.5 && angle < 67.5) index = 2
						if(angle >= 337.5 || angle < 22.5) index = 3
						if(angle >= 292.5 && angle < 337.5) index = 4
						if(angle >= 202.5 && angle < 247.5) index = 5
						if(angle >= 157.5 && angle < 202.5) index = 6
						if(angle >= 112.5 && angle < 157.5) index = 7

						if(index)
							parentGUI.placeIntoHotkeys(index, param)

			//If the params var includes specific substrings, then call and pass data to GUIInventory procs as necessary...
