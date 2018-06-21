/*
Author: Miguel SuVasquez
March 2014

This file implements the gamescreen class.
A gamescreen is like a discrete state of the game, like the Main Menu, or a Load Character menu,
or in-game where you control the player character.

Different screens have different game logic and handle game logic differently;
The main update loop calls the update function every frame for the active game screen.
*/

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
