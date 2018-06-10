//This is regions.
//It's an alternative to /area where you can have "areas" of turfs that capture atom entry and exit events

var
	list/region_instance = list()

atom/movable
	var
		regions[0]

region
	parent_type = /obj
	layer = MOB_LAYER + 1

	var
		list/turfs = list()

		list/contains = list()

		id

	proc/Initialization()
		if(tag in region_instance)

			var/turf/t = loc
			if(t && istype(t))

				var/region/r = region_instance[tag]
				t.regions += r
				r.turfs += t

			del src

		else
			region_instance[tag] = src

			var/turf/t = loc
			if(t && istype(t))
				t.regions += src
				turfs += t

			loc = null
/*
	Entered(atom/movable/m)
		if(!(m in contents)) contents += m
		.=..(m)

	Exited(atom/movable/m)
		contents -= m
		.=..(m)
*/
	Enter(atom/movable/M)
		return 1

turf
	var
		// every turf keeps track of what regions it's a part of
		list/regions = list()
/*
	Enter(atom/movable/m)
		. = ..()
		if(.)
			for(var/region/O in regions)
				if(!O.Enter(m))
					return 0
*/
	// This will catch all region Entered and Exited events
	// when you're moving from one turf to another.
	Entered(atom/movable/m, turf/old_loc)
		. = ..()

		// this'll hold all the regions you're exiting
		var/list/old_regions

		// this'll hold all the regions you're entering
		var/list/new_regions = regions

		// if you're coming from a turf
		if(istype(old_loc))
			// we want old_regions to contain the regions you're leaving
			// so we subtract new_regions because those are the ones that
			// you'll still be in.
			old_regions = old_loc.regions - new_regions

			// we want new_regions to be the regions you're entering so
			// we subtract the ones that you were already in.
			new_regions = regions - old_loc.regions


		for(var/region/r in old_regions)
			r.contains -= m
			m.regions -= r
			r.Exited(m)

		for(var/region/r in new_regions)
			if(!(m in r.contains))
				r.contains += m
				m.regions += r
			r.Entered(m)


mob
	// this should catch the exited event when you're moving
	// from a turf to a non-turf.
	Move()
		var/turf/t = loc

		. = ..()

		// if you moved to a null loc or a non-turf
		if(!loc || !istype(loc, /turf))
			// but you came from a turf
			if(t && istype(t))
				// you exited all of the regions your former loc was a part of
				for(var/region/r in t.regions)
					r.Exited(src)
