
/*
Author: Miguel SuVasquez
March 2014

This file defines a parallax class. The parallax class handles scrolling backgrounds based on the camera's x and y position.
*/
var
	const
		PARALLAX_LAYER = 0.1

parallax
	var
		atom/movable/parent

		off_x
		off_y

		width_x
		width_y

		center_x
		center_y

		speed_x = 1
		speed_y = 1

		hasBoundariesX
		hasBoundariesY
		min_x
		min_y
		max_x
		max_y

		layer

		image/imageObj

		wrapping
		//wrapping & 1 : horizontal wrapping
		//wrapping & 2 : vertical wrapping

	New(parentAtom, icon/I, start_x = 0, start_y = 0, wrap, newLayer = PARALLAX_LAYER)
		parent = parentAtom
		if(!istype(I)) I = icon(I)

		layer = newLayer

		imageObj = new()
		imageObj.loc = parent
		imageObj.icon = I
		imageObj.layer = newLayer
		parent.layer = newLayer

		player<<imageObj

		wrapping = wrap

		width_x = I.Width()
		center_x = width_x/2
		width_y = I.Height()
		center_y = width_y/2

		off_x = start_x
		off_y = start_y

		if(wrap & 1)

			var/image/temp = new()
			temp.icon = I
			temp.layer = layer
			temp.pixel_x = width_x

			imageObj.overlays += temp

		if(wrap & 2)

			var/image/temp = new()
			temp.icon = I
			temp.layer = layer
			temp.pixel_y = width_y

			imageObj.overlays += temp

		if((wrap & 3) == 3)

			var/image/temp = new()
			temp.icon = I
			temp.layer = layer
			temp.pixel_x = width_x
			temp.pixel_y = width_y

			imageObj.overlays += temp

	Del()
		del imageObj
		.=..()

	proc
		move(vx, vy)
			if(speed_x==0 && speed_y==0) return

			off_x += -vx * speed_x
			off_y += -vy * speed_y

			//now it computes the offset wrapping

			//If there's no wrapping, don't fuck with the offset.
			if(hasBoundariesX) off_x = max(min_x, min(max_x, off_x))
			if(hasBoundariesY) off_y = max(min_y, min(max_y, off_y))

			//If there's horizontal wrapping, wrap the off_x
			if(wrapping & 1)
				while(off_x > 0) off_x -= width_x
				while(off_x < -width_x) off_x += width_x

			//If there's vertical wrapping, wrap the off_y
			if(wrapping & 2)
				while(off_y > 0) off_y -= width_y
				while(off_y < -width_y) off_y += width_y


			imageObj.pixel_x = -center_x + off_x
			imageObj.pixel_y = -center_y + off_y

			imageObj.layer = layer


var/const/FLAT_MODIFIER = 0.2
var/const/MULT_MODIFIER = 1

camera
	proc
		createCityParallax()
			clearParallaxes()
			var/parallax/P

			P = src.createParallax("gradient", 'Purple Gradient 1.png', \
				0, 1, 1, 0.01)
			P.speed_x = (0.1 + FLAT_MODIFIER) * MULT_MODIFIER
			P.speed_y = 0

			//frontmost layer

			P = src.createParallax("city 1", 'City 1.png', \
				0, -250, 1, 0.5)
			P.speed_x = (0.15 + FLAT_MODIFIER) * MULT_MODIFIER
			P.speed_y = 0.2
			P.hasBoundariesY = 1
			P.max_y = 100
			P.min_y = -700

			P = src.createParallax("city 2", 'City 2.png', \
				0, -200, 1, 0.4)
			P.speed_x = (0.08 + FLAT_MODIFIER) * MULT_MODIFIER
			P.speed_y = 0.1
			P.hasBoundariesY = 1
			P.max_y = 0
			P.min_y = -700

			P = src.createParallax("city 3", 'City 3.png', \
				0, -180, 1, 0.2)
			P.speed_x = (0.06 + FLAT_MODIFIER) * MULT_MODIFIER
			P.speed_y = 0.06
			P.hasBoundariesY = 1
			P.max_y = 0
			P.min_y = -700

			P = src.createParallax("city 4", 'City 4.png', \
				300, -20, 0, 0.1)
			P.speed_x = (0.03) * MULT_MODIFIER
			P.speed_y = 0.03
			P.hasBoundariesY = 1
			P.max_y = 0
			P.min_y = -700
