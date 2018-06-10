////////////////////////////////////////////////////////////////////////////////
//
//	Demo.dm
//	Author:		Gooseheaded
//
//	Created:	02/03/14
//	Last edited:02/03/14
//
////////////////////////////////////////////////////////////////////////////////

world
	fps = 60

turf
	icon = 'Icon.dmi'
	icon_state = "Icon"

mob
	var
		Parallax/para
	verb
		createParallax()

			var/list/images = list(
				new /icon('Background1.png'),
				new /icon('Background2.png'),
				new /icon('Background3.png'))

			para = new /Parallax(src, images)

	Login()
		..()
		loc = locate(world.maxx/2, world.maxy-3, 1)

client
	view = 35
	East()
		mob.para.moveParallax(1, 0)
	West()
		mob.para.moveParallax(-1, 0)
	North()
		mob.para.moveParallax(0, 1)
	South()
		mob.para.moveParallax(0, -1)