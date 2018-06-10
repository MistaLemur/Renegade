gameScreen/gameAction

	tick() //Game logic tick
		if(isPaused) return

		.=..()

		if(player.camera)
			player.camera.tick(screenTime)

		if(player.focus)
			player.focus.tick(screenTime)


	flush() //This is for shit like exiting to the main menu
		.=..()

		//remove all AI npcs
		//clean out the player shit

		//ultimately, the player mob should be deleted.

	event(name, params)
		if(findtext(params, "_mission ") && currentMission)
			currentMission.missionEvent(parsePast(name, "_mission "), params)