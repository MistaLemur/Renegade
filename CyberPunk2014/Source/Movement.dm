/*
Author: Miguel SuVasquez
March 2014

This file overrides some of the engine's built-in movement functions; 
It adds some functionality where I can define which objects are allowed to clip through eachother's collision primitives.
It adds an event for when an object gets collided with.
It also adds some helpful functions for collision detection in the forwards direction of any character object.
*/
atom/movable
	var
		allowEnterTag
		attemptEnterTag

		passThroughType

	Cross(atom/movable/A)
		if(allowEnterTag == A.attemptEnterTag && allowEnterTag) return 1
		if(passThroughType && istype(A,passThroughType)) return 1
		.=..()

	Bump(atom/movable/A)
		.=..()
		if(A && istype(A)) A.Bumped(src)

	proc
		Bumped(atom/movable/A)

		checkDense(direction)
			var/off_x=0
			var/off_y=0

			if(direction&4) off_x += tile_width
			if(direction&8) off_x -= tile_width

			if(direction&1) off_y += tile_height
			if(direction&2) off_y -= tile_height

			var/result[0]

			for(var/atom/A in obounds(src,off_x, off_y))
				if(!A.density) continue
				if(!A.Enter(src)) result |= A
			for(var/atom/movable/A in obounds(src,off_x, off_y))
				if(!A.density) continue
				if(!A.Cross(src)) result |= A

			return result
