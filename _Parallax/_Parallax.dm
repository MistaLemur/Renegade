////////////////////////////////////////////////////////////////////////////////
//
//	Parallax.dm
//	Author:		Gooseheaded
//
//	Created:	02/03/14
//	Last edited:02/03/14
//
////////////////////////////////////////////////////////////////////////////////

/*
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!													!!
!! ERASE THESE AND USE THE PROJECTS'  VARIABLES!	!!
!!													!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
*/
var
	/*Screen size variables*/
	//pixel dimensions for the screen
	screen_px = 620//640
	screen_py = 340//360

	//tile dimensions for the screen
	screen_tilex = 31//32
	screen_tiley = 17//18

	tile_width = 20
	tile_height = 20


var/const/PARALLAX_LAYER = OBJ_LAYER - 0.1

/*
*/
ParallaxBackground
	var
		list/images = list()
		width =		0
		speedX =	0
		speedY =	0
		bufferX =	0
		bufferY =	0
		layer =		0

	proc
		/*
		*/
		draw(qtyX, qtyY)
			bufferX = qtyX * (speedX)
			bufferY = qtyY * (speedY)

			for(var/image/i in images)
				// Checks whether or not the image is entirely outside the screen
				//	on the left side of the screen. If it is, then the image should
				//	be drawn on the far right, instead.

				if(qtyX > 0 && i.pixel_x + width < -screen_px/2)
					world << "\red[i.pixel_x] + [width] > [-screen_px/2]"
					i.pixel_x += width * (images.len)
					world << "\green[i.pixel_x] + [width] > [-screen_px/2]"
				else if(qtyX < 0 && i.pixel_x > screen_px/2 + tile_width*1.5)
					world << "\red[i.pixel_x] + [width] > [-screen_px/2]"
					i.pixel_x -= width * (images.len)
					world << "\green[i.pixel_x] + [width] > [-screen_px/2]"

				if(bufferX > 0)
					i.pixel_x -= round(bufferX)
				else if(bufferX < 0)
					i.pixel_x += abs(round(-bufferX))
				if(bufferY > 0)
					i.pixel_y -= round(bufferY)
				else if (bufferY < 0)
					i.pixel_y += abs(round(-bufferY))

			if(bufferX > 0) bufferX -= round(bufferX)
			else if(bufferX < 0) bufferX -= abs(round(-bufferX))

			if(bufferY > 0) bufferY -= round(bufferY)
			else if(bufferY < 0) bufferY -= abs(round(-bufferY))

	/*
	At least 2 images are created... guaranteed!
	*/
	New(argAnchor, argIcon, argSpeedX = 1, argSpeedY = 1)
		if(!argAnchor)
			world << "Error ([__FILE__], line [__LINE__]) - No anchor provided as argument."
			return
		if(!argIcon)
			world << "Error ([__FILE__], line [__LINE__]) - No icon provided as argument."
			return

		var/icon/ic = argIcon

		speedX = argSpeedX
		speedY = argSpeedY
		width = ic.Width()

		world << "Icon width: [width]"

		var/imageCount = (screen_px / width) + 1
		var/image/im
		for(var/i = 0; i <= imageCount; i ++)
			im = new/image(argIcon, argAnchor)
			im.pixel_x = -screen_px/2 + (width * i) // Reposition the image on the far left, first.
			im.pixel_y = 0
			images += im
			argAnchor << im

/*
*/
Parallax
	var
		atom/movable/anchor = null

		list/backgrounds =	list()

		list/bufferX =	list()
		list/bufferY =	list()

	proc
		/*
		Modifies all the images' layers so that they look appropiate.
		The order in which they layer up against one another is the order in
		 which they appear in the list of images.
		*/
		configureLayers()
			var/counter = PARALLAX_LAYER
			for(var/ParallaxBackground/bg in backgrounds)
				bg.layer = counter
				for(var/image/i in bg.images)
					i.layer = counter
				counter -= 0.01

		/*
		*/
		moveParallax(qtyX = 0, qtyY = 0)
			if(!anchor)	return
			for(var/ParallaxBackground/bg in backgrounds)
				bg.draw(qtyX, qtyY)

	/*
	*/
	New(argAnchor, argIcons)
		anchor = argAnchor

		var/speedCounter = 1  * (length(argIcons) + 1)
		for(var/icon/i in argIcons)
			backgrounds += new /ParallaxBackground(anchor, i, speedCounter, speedCounter)
			speedCounter -= 1

		configureLayers()

	/*
	*/
	Del()
		del backgrounds