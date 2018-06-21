/*
Author: Miguel SuVasquez
March 2014

This is a crude lighting system that multiplies a color to a sprite to give the illusion of changing lightsources.
Lighting colors are defined tile-by-tile in the map.

This is used to give a purple hue to outdoor locations.
*/

atom
	var
		hasLight = 0
		lightColor = rgb(255,255,255)

atom/movable
	var
		isShaded = 0

		shadeColor

	proc
		shade()
			if(!loc) return
			if(isShaded)
				var/shadeTick = 0
				for(var/atom/A in obounds())
					if(A.hasLight)
						shadeTick = 1
						if(shadeColor != A.lightColor)
							shadeColor = A.lightColor
							animate(src, color = getShadeColor(), time = 5)

				if(!shadeTick && shadeColor != src.lightColor)
					shadeColor = src.lightColor
					animate(src, color = getShadeColor(), time = 5)

			else if(!isShaded)
				if(shadeColor != src.lightColor)
					shadeColor = src.lightColor
					animate(src, color = getShadeColor(), time = 5)

		getShadeColor() //There might be some stuff in the future that complicates the color displayed...
			//If there is, then override this function
			return shadeColor

actor
	isShaded = 1

	Velocity()
		.=..()
		shade()
