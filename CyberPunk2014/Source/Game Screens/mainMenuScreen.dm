/*
Author: Miguel SuVasquez
March 2014

This file contains the implementation of the main menu gamescreen. It handles the creation and behaviors and logic for the main menu.
*/
gameScreen/mainMenu
	New()
		.=..()

		//Create the backdrop
		var/obj/back = new()
		back.icon = 'MainMenu.png'
		back.loc = locate(1,1,1)
		back.layer = 3

		resources += back

		var/obj/cam = new()
		cam.loc = locate(center_tilex, center_tiley, 1)
		cam.tag = "mainMenuTag"

		//Create the buttons
		var/menuButton/button

		//New Character Button
		//button = new(175, 155, 'NewCharacterButton.png', "NewCharacter", src)
		button = new(224, 155, 'NewGame.png', "NewCharacter", src)
		resources += button

		/*
		//Load Character
		button = new(172, 125, 'LoadCharacterButton.png', "LoadCharacter", src)
		resources += button

		//Options
		button = new(245, 95, 'OptionsButton.png', "Options", src)
		resources += button
		*/

		//Credits
		//button = new(247, 65, 'CreditsButton.png', "Credits", src)
		button = new(247, 125, 'CreditsButton.png', "Credits", src)
		resources += button

	event(name, params)
		world<<"[src] event: [name]"

		if(name == "NewCharacter")
			player.FadeOut(duration = 0.5)

			sleep(10)

			var/actor/humanoid/player/newMob = new()
			//Create the new character game screen
			//set the parent
			//make shit happen
			var/mob/oldMob = player.mob
			player.mob = newMob
			del oldMob

			newMob.client = player


			var/gameScreen/gameAction/screen = new()
			currentScreen = screen

			//load the first mission object and set the mission

			//Place the mob
			var/atom/newLoc = locate("TestLevelTurf")
			newMob.loc = newLoc
			if(!istype(newLoc, /turf)) newMob.loc = newLoc.loc

			//Create a camera here
			//Attach client to camera
			//Attach camera to mob
			player.camera = new(player, newMob)
			player.camera.createCityParallax()


			player.enableMouseTracking()


			screen.activeAtoms += player.mob
			screen.activeZ = newLoc.z
			screen.addActiveWorldAtoms()
			screen.addParticleEmitters()
			screen.addItems()
			screen.addNPCs()

			playMusic('Factory.ogg')

			sleep(10)

			player.FadeIn(0.5)

			//Create the mission
			currentMission = new /mission/tutorial_Mission() // <--------------------------------------------
			//Start the mission
			currentMission.missionEvent("Start")



			del src //clean up
		//if(name == "LoadCharacter")
		//if(name == "Options")
		if(name == "Credits")
			new/GUICredits()
		//if(name == "Zyncko")
		//if(name == "#cyberpunkjam")


menuButton
	parent_type = /obj
	mouse_opacity = 2
	layer = 4

	var
		clickEvent
		gameScreen/parentScreen

	New(px, py, icon/i, event, screen)
		x = round(px/tile_width) + 1
		y = round(py/tile_height) + 1
		pixel_x = px%tile_width
		pixel_y = py%tile_width

		icon = i
		clickEvent = event
		parentScreen = screen

		MouseExited()
		. = src

	MouseEntered()
		.=..()

		animate(src, transform = matrix(), alpha = 255, time = 2)

	MouseExited()
		.=..()

		animate(src, transform = scaleMatrix(0.85, 0.85), alpha = 128, time = 5)

	Click()
		if(clickEvent)
			parentScreen.event(clickEvent)

		.=..()
