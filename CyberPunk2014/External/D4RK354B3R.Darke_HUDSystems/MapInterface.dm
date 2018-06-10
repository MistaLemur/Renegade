//This is shit that goes on the map!
var
	mapObjects[0]

mapInterface
	parent_type = /obj

	maptext_width = 600
	maptext_height = 600
	layer = HUD_LAYER

	var
		atom/clickAtom //This, when set, will call clickAtom.Click().
		param //Just some generic variable.

		//If clickAtom.Click() doesn't provide the functionality you want,
		//there's some metacoding functionality here that will allow you to call any
		//function upon Click().

		//By default, the following will run upon click
		//call(callContext,callFunction)(callParams)
		callContext = null
		callFunction = null
		callParams = null

		children[0]
		HUDObj/parent

		enteredIcon

	mouse_opacity = 1

	Click()
		if(clickAtom)
			return clickAtom:Click()

		if(callContext && callFunction)
			if(!callParams)
				return call(callContext,callFunction)(usr)
			else
				return call(callContext,callFunction)(callParams)

		if(!callContext && callFunction)
			if(!callParams)
				return call(callFunction)(usr)
			else
				return call(callFunction)(callParams)
		..()

	DblClick()
		if(clickAtom)
			return clickAtom:DblClick()

		if(callContext && callFunction)
			if(!callParams)
				return call(callContext,callFunction)(usr)
			else
				return call(callContext,callFunction)(callParams)

		if(!callContext && callFunction)
			if(!callParams)
				return call(callFunction)(usr)
			else
				return call(callFunction)(callParams)
		..()

	MouseDrop(o,src_loc,over_loc,src_con,over_con,params)
		if(clickAtom)
			return clickAtom:MouseDrop(o,src_loc,over_loc,src_con,over_con,params)
		else
			return ..()

	proc
		addChild(HUDObj/O)
			children += O
			O.parent = src

		addParent(HUDObj/O)
			O.children += src
			parent = O

	Del()
		for(var/HUDObj/O in children - parent)
			del O

		..()


proc
	clearMapInterface()
		for(var/i in mapObjects)
			var/mapInterface/O = mapObjects[i]
			del O
			mapObjects -= i

	addMapInterface(t,sx,sy,icon/i,istate,tsx=center_x,tsy=center_y, tsz = 1, param, nlayer=HUD_LAYER) //Add an HUD object
		//sx and sy are in pixels relative to the center...

		sx=round(sx,1)
		sy=round(sy,1)

		if(mapObjects[t])
			var/mapInterface/O = mapObjects[t]
			O.tag = t

			O.x = tsx
			O.y = tsy
			O.z = tsz
			O.pixel_x = sx
			O.pixel_y = sy
			O.param = param

			O.icon = i
			O.icon_state = istate

			if(O.layer!=nlayer) O.layer = nlayer

			return O

		var/mapInterface/O = new()
		O.tag = t

		O.icon = i
		O.icon_state = istate

		O.x = tsx
		O.y = tsy
		O.z = tsz
		O.pixel_x = sx
		O.pixel_y = sy
		O.param = param

		if(O.layer!=nlayer) O.layer = nlayer

		mapObjects[t] = O

		return O


	removeMapInterface(t) //Remove an HUD object

		var/mapInterface/O = mapObjects[t]
		mapObjects -= t
		if(O) del O

	clearMapGroup(t)
		//This removes every HUD Object whose tag contains string t
		for(var/i in mapObjects)
			if(findtext(i,t))
				removeMapInterface(i)