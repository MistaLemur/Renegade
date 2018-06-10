//The gamescreen class handles game logic.
//Since different screens handle logic differently, the main loop in the game only calls the tick() of the current screen.

gameScreen
	var
		activeAtoms[0]

		resources[0]

		screenTime //this is the time for the tick

		isPaused

		activeZ

	tick() //Game logic tick
		if(isPaused) return

		screenTime += dt

		numParticlesActive = 0

		for(var/atom/A in activeAtoms)
			if(A.tickTimer <= screenTime) A.tick(screenTime)

	proc
		flush() //This is called in gameScreen.del(). This is for removing specific assets for this game screen.
			for(var/i in resources) del i

		event(name, params) //This is for some event capture.

		addActiveAtom(atom/A)
			activeAtoms += A

		removeActiveAtom(atom/A)
			activeAtoms -= A

		addActiveWorldAtoms(z = activeZ)
			activeAtoms |= worldActiveAtoms[z]

		removeActiveWorldAtoms(z = activeZ)
			activeAtoms.Remove(worldActiveAtoms[z])

		addParticleEmitters()
			for(var/particleEmitter/E)
				if(E.z != activeZ) continue
				activeAtoms |= E

		addItems()
			for(var/item/E)
				if(E.z != activeZ) continue
				activeAtoms |= E

		addNPCs()
			for(var/actor/humanoid/AI/E)
				if(E.z != activeZ) continue
				activeAtoms |= E

	Del()
		flush()
		.=..()

proc
	currentTime()
		if(!currentScreen) return 0
		return currentScreen.screenTime