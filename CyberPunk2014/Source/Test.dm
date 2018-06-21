/*
Author: Miguel SuVasquez
March 2014

This file defines some debugging output and classes for testing purposes, like a test wall class for testing platforming behaviors.
*/
actor/humanoid

	player

		Stat()
			stat("moveKeys", moveKeys)
			stat("velocity", "<[vx], [vy]>")
			stat("", )
			stat("displayDirection", displayDirection)
			stat("armState", armState)
			stat("", )
			stat("aimAngle", aimAngle)
			stat("drawAngle", drawAngle)



turf
	wall
		icon = 'TestEnv.dmi'
		icon_state = "Wall"
		density = 1
		wallSlide = 1
		cliffHang = 1

obj/environment
	icon = 'TestEnv.dmi'
	scaffold
		icon_state = "scaffold"
		isScaffold = 1

	ladder
		icon_state = "ladder"
		isLadder = 1
