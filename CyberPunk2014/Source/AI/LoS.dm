/*
Author: Miguel SuVasquez
March 2014

This file provides a crude function for checking Line-Of-Sight.
It computes Line-Of-Sight by moving an invisible projectile along a line until it hits something or reaches a certain number of steps.
It does not do a Ray-AABB collision computation.
*/

atom
	var
		blocksLoS

proc
	crouchLoS(actor/humanoid/source, actor/target, ignoreType, casts = 1|2|4)
		//These are rays cast from the center

		//return values:
		//return&1 for North edge
		//return&2 for Center
		//return&4 for South edge
		var/ret = 0
		var/angle = 0

		var/vector/coords = source.pixelCoordsVector()
		var/vector/center = source.pixelCenterVector()
		coords.x += center.x
		coords.y += source.getWeaponHeight(source.crouchingHeight)

		var/vector/targ = target.pixelCoordsVector()
		var/vector/difVec

		//north edge

		if(casts & 1)
			difVec = targ.subtract(coords)
			difVec.y += target.bound_y + target.bound_height * 0.8
			angle = _GetAngle(difVec.y, difVec.x)

			if(castLOSRay(coords, angle, source.z, ignoreType, target)) ret |= 1

		//center

		if(casts & 2)
			difVec = targ.subtract(coords)
			difVec.y += target.bound_y + target.bound_height * 0.50
			angle = _GetAngle(difVec.y, difVec.x)

			if(castLOSRay(coords, angle, source.z, ignoreType, target)) ret |= 2

		if(casts & 4)
			difVec = targ.subtract(coords)
			difVec.y += target.bound_y + target.bound_height * 0.1
			angle = _GetAngle(difVec.y, difVec.x)

			if(castLOSRay(coords, angle, source.z, ignoreType, target)) ret |= 4

		return ret

	LoS(actor/source, actor/target, ignoreType, casts = 1|2|4)
		//These are rays cast from the center

		//return values:
		//return&1 for North edge
		//return&2 for Center
		//return&4 for South edge
		var/ret = 0
		var/angle = 0

		var/vector/coords = source.pixelCoordsVector()
		var/vector/center = source.pixelCenterVector()
		coords.x += center.x
		coords.y += source.getWeaponHeight()

		var/vector/targ = target.pixelCoordsVector()
		var/vector/difVec

		//north edge

		if(casts & 1)
			difVec = targ.subtract(coords)
			difVec.y += target.bound_y + target.bound_height * 0.8
			angle = _GetAngle(difVec.y, difVec.x)

			if(castLOSRay(coords, angle, source.z, ignoreType, target)) ret |= 1

		//center

		if(casts & 2)
			difVec = targ.subtract(coords)
			difVec.y += target.bound_y + target.bound_height * 0.50
			angle = _GetAngle(difVec.y, difVec.x)

			if(castLOSRay(coords, angle, source.z, ignoreType, target)) ret |= 2

		if(casts & 4)
			difVec = targ.subtract(coords)
			difVec.y += target.bound_y + target.bound_height * 0.1
			angle = _GetAngle(difVec.y, difVec.x)

			if(castLOSRay(coords, angle, source.z, ignoreType, target)) ret |= 4

		return ret


	castLOSRay(vector/start, angle, z, ignoreType, actor/target, speed = 10, range = 35) //range is 360 pixels by default
	/*
	this doesn't actually shoot a ray, but it shoots a projectile to simulate the ray.
	The engine doesn't come with ray-AABB intersection by default so this was a quick and easy way to approximate ray collision
	*/
		var/x = round(start.x/tile_width) + 1
		var/y = round(start.y/tile_height) + 1

		var/px = start.x%tile_width
		var/py = start.y%tile_height

		var/obj/O = new()
		O.x = x
		O.y = y
		O.z = z
		O.step_x = px
		O.step_y = py

		O.bound_width = 2
		O.bound_height = 2
		O.density = 0
		O.invisibility = 101

		O.vx = speed * cos(angle)
		O.vy = speed * sin(angle)

		for(var/i = 1; i <= range; i++)
			O.step_x += O.vx
			O.step_y += O.vy

			//now check for hits
			if(target in obounds(O))
				del O
				return 1

			for(var/atom/A in obounds(O))
				if((A.canGetHit || A.blocksLoS) && !istype(A,ignoreType))
					del O
					return 0

			sleep(-1)

		del O
		return 0
