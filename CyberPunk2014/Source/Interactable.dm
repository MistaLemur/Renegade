atom/movable
	var
		canInteract

		interactDesc //This is a description of the interaction.
		//For example, "Press E to 'Open the Door'", where the desc is 'Open the Door'

		interactDelay = 0
	proc
		interactEvent(mob/actor/M)

		getInteractDesc()
			return interactDesc