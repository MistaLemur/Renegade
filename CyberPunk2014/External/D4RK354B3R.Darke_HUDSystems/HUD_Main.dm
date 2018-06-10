//This is the HUD system I end up using in almost every game!
var
	const
		HUD_LAYER = 1000

HUDObj
	parent_type = /obj

	maptext_width = 600
	maptext_height = 600
	layer = HUD_LAYER

	//isShaded = 0

	var
		client/client
		atom/clickAtom //This, when set, will call clickAtom.Click().
		atom/overAtom //This, when set, will pass MouseEntered() to overAtom
		param //Just some generic variable.
		param2 //just another generic variable

		//If clickAtom.Click() doesn't provide the functionality you want,
		//there's some metacoding functionality here that will allow you to call any
		//function upon Click().

		//By default, the following will run upon click
		//call(callContext,callFunction)(callParams)
		callMouseDown = 0

		callContext = null
		callFunction = null
		callParams = null

		dblCallContext = null
		dblCallFunction = null
		dblCallParams = null

		children[0]
		HUDObj/parent

		enteredIcon

	mouse_opacity = 0


	MouseDown(object,location,control,params)
		if(callContext && callFunction && callMouseDown)
			usr.client.mouseButton = 0

			if(!callParams)
				return call(callContext,callFunction)(usr)
			else
				return call(callContext,callFunction)(callParams)

		if(!callContext && callFunction && callMouseDown)
			if(!callParams)
				return call(callFunction)(usr)
			else
				return call(callFunction)(callParams)
		..(object,location,control,params)

	Click(object,location,control,params)
		if(clickAtom)
			return clickAtom:Click()

		if(callContext && callFunction && !callMouseDown)
			usr.client.mouseButton = 0

			if(!callParams)
				return call(callContext,callFunction)(usr)
			else
				return call(callContext,callFunction)(callParams)

		if(!callContext && callFunction && !callMouseDown)
			if(!callParams)
				return call(callFunction)(usr)
			else
				return call(callFunction)(callParams)
		..(object,location,control,params)

	DblClick()
		if(clickAtom)
			return clickAtom:DblClick()

		if(dblCallContext && dblCallFunction)
			usr.client.mouseButton = 0

			if(!dblCallParams)
				return call(dblCallContext,dblCallFunction)(usr)
			else
				return call(dblCallContext,dblCallFunction)(dblCallParams)

		..()

	MouseDrop(o,src_loc,over_loc,src_con,over_con,params)
		if(clickAtom)
			return clickAtom:MouseDrop(o,src_loc,over_loc,src_con,over_con,params)
		else
			return ..()

	MouseEntered(loc,con,params)
		if(overAtom)
			return overAtom:MouseEntered(loc, con, params)
		else
			.=..()

	MouseExited(loc,con,params)
		if(overAtom)
			return overAtom:MouseExited(loc, con, params)
		else
			.=..()

	proc
		addChild(HUDObj/O)
			children += O
			O.parent = src

		addParent(HUDObj/O)
			O.children += src
			parent = O

	Del()
		if(client)
			client.hud -= src.tag

		for(var/HUDObj/O in children - parent)
			del O

		..()
mob
	proc
		addHUD(hudTag, screen_px, screen_py, icon/graphic, iconState, newLayer, mapTag, param)
			if(!client) return
			return client.addHUD(hudTag, screen_px, screen_py, icon/graphic, iconState, newLayer, mapTag, param)

		removeHUD(hudTag)
			if(!client) return
			return client.removeHUD(hudTag)

		clearHUDGroup(hudTag)
			if(!client) return
			return client.clearHUDGroup(hudTag)


client
	var/tmp
		hud[0] //List of HUD objects

	proc
		addHUD(hudTag, pixel_x, pixel_y, icon/graphic, iconState, newLayer = HUD_LAYER, mapTag, param) //Add an HUD object
			//this creates a HUD object with the stated graphic and layer.
			//the screen coordinate is specified in pixels, and is converted into the tile:pixel format for screen_loc
			//0,0 for screen_px and screen_py translates into screen_loc of "1:0, 1:0"
			var/screenLoc = computeScreenLoc(pixel_x, pixel_y)

			if(mapTag!=null && mapTag != "") screenLoc = "[mapTag]:[screenLoc]"

			if(hud[hudTag])
				var/HUDObj/O = hud[hudTag]
				O.client = src
				O.tag = hudTag

				O.icon = graphic
				O.icon_state = iconState

				O.screen_loc = screenLoc

				if(param) O.param = param

				if(O.layer!=newLayer) O.layer = newLayer

				return O

			var/HUDObj/O = new()
			O.client = src
			O.tag = hudTag

			O.icon = graphic
			O.icon_state = iconState

			O.screen_loc = screenLoc

			if(param) O.param = param

			if(O.layer!=newLayer) O.layer = newLayer

			screen += O

			if(param) O.param = param

			hud[hudTag] = O

			return O

		removeHUD(hudTag) //Remove an HUD object
			//hudTag is the string tag of the HUD Object
			if(!(hudTag in hud)) return

			var/HUDObj/O = hud[hudTag]
			hud -= hudTag
			if(O) del O

		getHUD(hudTag) //This returns the HUD object by t tag.
			return hud[hudTag]

		clearHUD()
			//This removes every HUD Object for the mob
			for(var/hudTag in hud)
				var/HUDObj/O = hud[hudTag]
				del O

			hud.Cut()
			//screen.Cut()

		clearPopup()
			clearHUDGroup("popup")

		clearHUDGroup(hudTag)
			//This removes every HUD Object whose tag contains string hudTag
			for(var/index in hud)
				if(findtext(index,hudTag))
					removeHUD(index)


		FadeOut(duration = 0.5) //duration is in seconds
			var/tag = "fade"
			var/HUDObj/O = hud[tag]
			if(!O)
				O = new()
				O.tag = tag
				O.screen_loc = "WEST,SOUTH to EAST,NORTH"
				hud[tag] = O
				O.layer = HUD_LAYER+100
				O.mouse_opacity = 2
				screen += O

			O.icon = 'BlackTile.dmi'
			O.alpha = 0
			animate(O,alpha = 255,time=duration*10)

		FadeIn(duration = 0.5) //duration is in seconds
			var/tag = "fade"
			var/HUDObj/O = hud[tag]
			if(!O)
				O = new()
				O.tag = tag
				O.screen_loc = "WEST,SOUTH to EAST,NORTH"
				hud[tag] = O
				O.layer = HUD_LAYER+100
				O.mouse_opacity = 2
				screen += O

			O.icon = 'BlackTile.dmi'
			O.alpha = 255
			animate(O,alpha = 0,time=duration*10)
			spawn(duration * 10)
				removeHUD(tag)

		Darken(darkness = 255, duration = 0.5)
			var/tag = "darken"
			var/HUDObj/O = hud[tag]
			if(!O)
				O = new()
				O.tag = tag
				O.screen_loc = "WEST,SOUTH to EAST,NORTH"
				hud[tag] = O
				O.layer = HUD_LAYER+10
				O.mouse_opacity = 2
				O.alpha = 0
				screen += O

			O.icon = 'BlackTile.dmi'
			animate(O,alpha = darkness,time=duration*10)

			if(darkness == 0)
				spawn(duration*10)
					removeHUD(tag)


proc
	computeScreenLoc(px,py)
		var
			pixelx = px % tile_width
			pixely = py % tile_height
			screenx = round(px / tile_width) + 1
			screeny = round(py / tile_height) + 1

		return "[screenx]:[pixelx],[screeny]:[pixely]"