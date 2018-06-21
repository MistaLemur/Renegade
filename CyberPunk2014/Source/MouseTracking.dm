/*
Author: Miguel SuVasquez
March 2014

This file contains definitions for all mouse movement events and mouse button events.
*/

//  add the mouse-tracking events to /atom...
atom
	//  when the mouse enters an atom for the first time
	// (MouseMove purposely is not called)
	MouseEntered(location, control, params)
		.=..()
		usr.client.MousePosition(params)

	//  when the mouse moves around within an atom
	// (and no mouse buttons are down)
	MouseMove(location, control, params)
		.=..()
		usr.client.MousePosition(params)

	//  when the mouse moves around and at least
	// one mouse button is down
	MouseDrag(over_object, src_location, over_location, src_control, over_control, params)
		.=..()
		usr.client.MousePosition(params)

mob
	proc
		track_mouse(bool = 1)
			if(!client) return;
			client.isMouseTracking = bool

client
	var
		mouse_x
		mouse_y
		mouse_screen_loc

		isMouseTracking = 0
		isTrackingButton = 1
		mouseButton

	MouseDown(object, location, control, params)
		if(isTrackingButton)
			var/param[] = params2list(params)
			if(param["left"]) mouseButton |=1
			if(param["right"]) mouseButton |=2
			if(param["middle"]) mouseButton |=4
		.=..()

	MouseUp(object, location, control, params)
		if(isTrackingButton)
			var/param[] = params2list(params)
			if(param["left"]) mouseButton &=~1
			if(param["right"])  mouseButton &=~2
			if(param["middle"])  mouseButton &=~4
		.=..()

	proc
		enableMouseTracking()
			if(isMouseTracking) return

			isMouseTracking = 1

			var/HUDObj/A = addHUD("_mouseTracking")
			A.layer = -1000
			A.icon = 'mouseTracking.dmi'
			A.mouse_opacity = 2
			A.screen_loc = "WEST,SOUTH to EAST,NORTH"

		disableMouseTracking()
			isMouseTracking = 0
			clearHUDGroup("_mouseTracking")

		MousePosition(params)
			if(!isMouseTracking) return

			var/s = params2list(params)["screen-loc"]
			var/mx = 0
			var/my = 0

			var/s1 = copytext(s,1,findtext(s,",",1,0))
			var/s2 = copytext(s,length(s1)+2,0)

			var/colon1 = findtext(s1,":",1,0)
			var/colon2 = findtext(s1,":",colon1+1,0)

			if(colon2)
				mx = (text2num(copytext(s1,colon1+1,colon2))-1) *tile_width
				mx += text2num(copytext(s1,colon2+1,0))-1

			else
				mx = (text2num(copytext(s1,1,colon1))-1) * tile_width
				mx += text2num(copytext(s1,colon1+1,0))-1

			colon2 = findtext(s2,":",1,0)
			my = (text2num(copytext(s2,1,colon2))-1) * tile_height
			my += text2num(copytext(s2,colon2+1,0))-1

			mouse_screen_loc = s
			mouse_x = mx
			mouse_y = my

			if(focus) focus.MouseUpdate(mx, my)

		MouseUpdate(mx, my)

datum
	proc/MouseUpdate(mx, my)
