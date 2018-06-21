/*
Author: Miguel SuVasquez
March 2014

This file contains definitions for:
General application parameters, like framerate and application name

This file contains function bodies for:
Application Entry point (the equivalent of a Main() function)
Game loading
Main update loop
Events for window resizing

*/
world
	fps = 30

	icon_size = 20
	view = "31x17"

	name = "RENEGADE"

	New()
		.=..()
		sleep(0)
		worldInitialization()
		mainLoop()

var
	time //World game time
	dt //The duration of the current game tick. "delta time"

	gameSpeed = 1 //This directly affects the game logic time scale.
	tickDelay = 1 //Increasing this value past 1 will slow down the tickrate. Only takes integers.

	gameScreen/currentScreen //This is the current game screen. This guy processes the game logic
	client/player //hurrdurr

	worldActiveAtoms[0][0]

	const
		/*Screen size variables*/
		//pixel dimensions for the screen
		screen_px = 620//640
		screen_py = 340//360

		//tile dimensions for the screen
		screen_tilex = 31//32
		screen_tiley = 17//18

		//tile coordinates for the center of the screen
		center_tilex = 16
		center_tiley = 9

		//pixel coordinates for the center of the screen
		center_px = 310
		center_py = 170

		//yes yes
		tile_width = 20
		tile_height = 20


datum
	var
		tickTimer
	proc
		tick(time)

atom
	var
		activeBool = 0
	New()
		.=..()
		if(activeBool && loc && z > 0)
			if(worldActiveAtoms.len < z)
				worldActiveAtoms.len = z
				worldActiveAtoms[z] = list()

			worldActiveAtoms[z] |= src

proc
	worldInitialization()
		//first create the main menu gameScreen
		//The main menu gameScreen's constructor should
		currentScreen = new/gameScreen/mainMenu()
		worldActiveAtoms.len = world.maxz


	mainLoop()
		while(1)
			dt = world.tick_lag / 10 * gameSpeed

			time += dt

			if(currentScreen)
				currentScreen.tick()

			sleep(0)
			sleep(world.tick_lag * tickDelay)

	calculateWindowSize(zoom = 2)
		//Zoom must be an int. This is for resizing the window to match a certain zoom multiplier.
		var
			window_x = screen_px * zoom
			window_y = (screen_py) * zoom

		return list(window_x, window_y)

client
	New()
		.=..()
		if(player) del src //NO MULTIPLAYER

		mob.loc = locate(1,1,1)

		player = src
		if(locate("mainMenuTag"))
			var/obj/O = locate("mainMenuTag")
			mob.loc = O.loc

		//play menu music
		playMusic('ERH BlueBeat 01 [loop].ogg')

	var
		zoom = 2

	verb
		Zoom(mult as num)
			set hidden = 1
			var/dims[] = calculateWindowSize(mult)
			var/window_x = dims[1], window_y = dims[2]

			zoom = mult

			winset(src, "mainWindow", "menu=Default")
			winset(src, "mainWindow", "border=line")
			winset(src, "mainWindow", "titlebar=true")
			winset(src, "mainWindow", "can-resize=true")
			winset(src, "mainWindow", "is-maximized=false")
			winset(src, "mainWindow", "size=[window_x]x[window_y]")

		FullScreen()
			set hidden = 1

			if(!zoom) return Zoom(2)

			zoom = 0

			winset(src, "mainWindow", "menu=")
			winset(src, "mainWindow", "border=sunken")
			winset(src, "mainWindow", "titlebar=false")
			winset(src, "mainWindow", "can-resize=false")
			winset(src, "mainWindow", "is-maximized=true")

	proc
		tick()
