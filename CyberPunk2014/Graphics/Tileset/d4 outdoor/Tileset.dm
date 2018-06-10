
turf
	backdrop
		hasLight = 1
		lightColor = rgb(255,224,255)

	concreteGround
		density = 1
		cliffHang = 1
		wallSlide = 1
		icon = 'outdoor_tiles 1.dmi'
		icon_state = "ground a"
		var/icon_states[] = list("ground a","ground b","ground c","ground d","ground e")

		New()
			.=..()
			icon_state = pick(icon_states)

	concreteSides
		density = 1
		cliffHang = 1
		wallSlide = 1
		icon = 'outdoor_tiles 1.dmi'
		sides
			icon_state = "genericDenseWall"

			east
				dir = 4

			northeast
				dir = 5

			northwest
				dir = 9

			west
				dir = 8


	denseblack
		icon = 'foregroundTiles.dmi'
		icon_state = "foregroundBlack"
		density = 1
		canGetHit = 1
		blocksLoS = 1

	concreteWalls
		icon = 'indoor_walls.dmi'
		density = 1
		cliffHang = 1
		wallSlide = 1

		w
			icon_state = "concrete_w"

		e
			icon_state = "concrete_e"

		back
			density = 0
			wallSlide = 0
			cliffHang = 0
			icon = 'outdoor_tiles 1.dmi'
			icon_state = "concreteWall 1"

			dirt
				icon_state = "concreteWall 4"

				a {dir=1;}
				b {dir=2;}
				c {dir=4;}
				d {dir=8;}

	barredWindow
		icon = 'indoor_walls.dmi'
		icon_state="barred window"

	lightTiles
		icon = 'lightTiles.dmi'
		a/icon_state = "1"
		b/icon_state = "2"
		c/icon_state = "3"
		d/icon_state = "4"
		e/icon_state = "5"
		f/icon_state = "6"
		g/icon_state = "7"

	shapeCenter
		icon = 'foregroundTiles.dmi'
		icon_state = "gray center"


		hasLight = 1
		lightColor = rgb(128,128,128)

	shapeEdge
		icon = 'foregroundTiles.dmi'
		icon_state = "shape gray"

		north/dir = 1
		northeast/dir = 5
		east/dir = 4
		southeast/dir = 6
		south/dir = 2
		southwest/dir = 10
		west/dir = 8
		northwest/dir = 9

		hasLight = 1
		lightColor = rgb(128,128,128)

	lightShape
		icon = 'foregroundTiles.dmi'
		icon_state = "metal shape"

		center/icon_state = "metal center"

		a/dir = 1
		b/dir = 2
		c/dir = 4
		d/dir = 8
		e/dir = 5
		f/dir = 6
		g/dir = 9
		h/dir = 10




Prop
	parent_type = /obj

	rooftop
		icon = 'outdoor_props.dmi'

		blower
			icon_state = "blower"
			density = 1
			canGetHit = 1
			bound_width = 40
			bound_height = 30

		chimney
			icon_state = "chimney"
			isScaffold = 1

			bound_x = 11
			bound_width = 20

			bound_height = 35

	prisonbed
		icon = 'outdoor_props.dmi'
		icon='terrain60.dmi'
		icon_state = "darke_bed"
		isScaffold = 1
		bound_width = 60
		bound_height = 15

		layer = OBJ_LAYER-0.2

	stealthScaffold
		icon = 'terrain40.dmi'
		icon_state = "scaffold_stealth"
		isScaffold = 1
		blocksLoS = 1
		bound_width = 40
		bound_height = 14
		bound_y = 6
		pixel_y = 6
		layer = MOB_LAYER + 2


	forcefield_door
		icon = 'forceField_door.dmi'
		bound_height = 60
		bound_width = 14
		bound_x = 6

		pixel_y = -2
		density = 1
		canGetHit = 1
		blocksLoS = 1

		Bumped(actor/A)
			if(istype(A, /actor))
				flick("flash", src)

				playSound('zap.wav', src)

				var/ax, ay = 300
				if(get_dir(src,A) & 4) ax += 300
				if(get_dir(src,A) & 8) ax -= 300
				A.KnockBack(ax,ay)

				if(istype(A,/actor/humanoid))
					A:isGrounded = 0
					A:ground = 0

		Hit(projectile/O)
			flick("flash", src)

			playSound('zap.wav', src)
			.=..()

		proc
			open()
				density = 0
				icon_state = "open"
				canGetHit = 0
				blocksLoS = 0
				//play a sound

				playSound('powerDown.wav', src)

	crate
		icon = 'outdoor_mediumprops.dmi'
		icon_state = "crate"

		density = 1
		bound_x = 8
		bound_width = 27
		bound_height = 28
		canGetHit = 1

		pixel_y = -1

		New()
			.=..()
			layer += rand(1,9)/100

		background
			density = 0
			icon_state = "crate_undense"
			layer = OBJ_LAYER-0.1
			canGetHit = 0

		crate_2
			icon_state = "crate 2"

			background
				density = 0
				icon_state = "crate 2_undense"
				layer = OBJ_LAYER-0.1
				canGetHit = 0

	chair
		icon = 'outdoor_mediumprops.dmi'
		icon_state = "chair"

	foreground
		layer = MOB_LAYER + 2
		icon = 'foregroundTiles.dmi'

		pipes
			pipes_a/icon_state="pipes a"
			pipes_b/icon_state="pipes b"
			pipes_c/icon_state="pipes c"
			pipes_d/icon_state="pipes d"
			pipes_e/icon_state="pipes e"
			pipes_f/icon_state="pipes f"

		vents
			vent_v/icon_state="vent v"
			vent_h/icon_state="vent h"

			vent2/icon_state="vent 2"
			vent3/icon_state="vent 3"
			vent4/icon_state="vent 4"
			vent5/icon_state="vent 5"
			vent6/icon_state="vent 6"
			vent7/icon_state="vent 7"
			vent8/icon_state="vent 8"

		pillar
			pillar_a/icon_state="pillar a"
			pillar_b/icon_state="pillar b"
			pillar_top/icon_state="pillar top"
			pillar_bottom/icon_state="pillar bottom"
			pillar_cap/icon_state="pillar cap"

		black
			icon_state = "foregroundBlack"

		trashPile
			icon = 'outdoor_mediumprops.dmi'
			icon_state = "trash 1"
			pixel_y = -4
			layer = MOB_LAYER + 1

	keypad
		layer = OBJ_LAYER - 0.3
		icon = 'indoor_walls.dmi'
		icon_state = "keypad"

	terminal

		icon = 'Terminal 1.png'
		bound_x = 11
		bound_y = 0

		bound_width = 40
		bound_height = 20
		isScaffold = 1

		securityCloset
			canInteract = 1
			interactDesc = "activate this terminal"

			interactEvent(actor/M)
				//play a sound
				M<<'computer.wav'

				//then call the mission event
				currentMission.missionEvent("ghostOpensEastWing")

	wardenElevator
		name = "Level 7 Elevator"
		icon = 'wardenElevator.png'

		bound_x = 10
		bound_y = 0
		bound_width = 60
		bound_height = 70

		canInteract = 1
		interactDesc = "use the elevator."

		var
			isWorking = 0
			keyType = /item/key/wardenKey

		interactEvent(actor/M)
			var/canUseElevator = isWorking
			if(M == player.mob && isWorking)
				if(locate(keyType) in M.inventory)
					del (locate(keyType) in M.inventory)
				else
					canUseElevator = 0

			if(canUseElevator)
				//play a sound
				M<<'computer.wav'

				//then call the mission event
				currentMission.missionEvent("useWardenElevator")
			else
				//play a sound
				M<<'error.ogg'

				//different mission event
				currentMission.missionEvent("ghostExaminesElevator")

	upperElevator
		name = "Level 97 Elevator"
		icon = 'upperElevator.png'


	mainframe
		icon='Mainframe Prop.png'
		canInteract = 1
		interactDesc = "extract data from the Gibson mainframe"
		bound_width = 80
		bound_height = 80

		interactEvent(actor/M)
			if(istype(M))
				currentMission.missionEvent("useMainframe")



	elevatorConduit
		icon = 'terrain40.dmi'
		icon_state = "power box"
		bound_width = 40
		bound_height = 40

		canInteract = 1
		interactDesc = "repair the elevator's power conduits"

		interactEvent(actor/M)
			if(istype(M))
				var/minigameSuccess
				//play a minigame here

				M<<'computer.wav'

				minigameSuccess = 1 //yeah...

				if(minigameSuccess)
					//find the elevator and turn it on
					var/Prop/wardenElevator/E = locate()
					if(E)
						E.isWorking = 1

					currentMission.missionEvent("repairedConduits")