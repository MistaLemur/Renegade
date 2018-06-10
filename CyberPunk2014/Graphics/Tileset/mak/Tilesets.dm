
///////////////////
// WORLD OBJECTS //
///////////////////

WorldObject
	parent_type	= /obj
	icon		= 'Graphics/Tileset/mak/worldobjects.dmi'
	var/alive	= TRUE

	New()
		..()
		icon_state = ""

	Rain
		icon_state = "rain"

		New()
			..()
			spawn()
				while(alive)
					if (prob(5))
						pixel_x = rand(-10,10)
						flick("raindrop[rand(1,2)]",src)
					sleep(world.tick_lag)


//////////////
// TILESETS //
//////////////

Tileset
	parent_type	= /turf

	Terrain20
		icon = 'terrain20.dmi'

	Terrain40
		icon = 'terrain40.dmi'

	Terrain60
		icon = 'terrain60.dmi'

///////////////
// COLLISION //
///////////////

Collision
	parent_type		= /obj
	icon 			= 'Graphics/Tileset/mak/collision.dmi'
	bound_x 		= 0
	bound_y 		= 0
	bound_width 	= tile_width
	bound_height 	= tile_height

	layer = EFFECTS_LAYER
	invisibility = 101

	/*
	New()
		..()
		icon = null
	*/

	Scaffold
		icon_state	= "scaffold"
		isScaffold	= 1

	Ground
		icon_state	= "ground"
		density		= 1
		wallSlide	= 1
		canGetHit	= 1
		cliffHang	= 0

	Ladder
		icon_state	= "ladder"
		isLadder	= 1

	LadderScaffold
		icon_state	= "ladderscaffold"
		isScaffold	= 1
		isLadder	= 1

	Grabbable
		icon_state	= "grabbable"
		density		= 1
		wallSlide	= 1
		cliffHang	= 1
		canGetHit	= 1

	PlayerSpawn
		icon_state	= "playerspawn"
