/*
Author: Miguel SuVasquez
March 2014

This file contains definitions for objects that make up the game's levels.
*/
atom
	var
		//The following variables define the ways that characters can interact with this environmental object.
		//many of these are flags
		
		surfaceDrag = 1 //surfaceDrag is for when this atom is acting as the "ground" for an actor
		//A surface drag of < 1 will make the surface more slippery.
		//For example, for icy surfaces you could set surfaceDrag = 0

		wallSlide = 0 //Can this surface be slid against slowly?
		cliffHang = 0 //Can a character hang from the corner of this object?
		isScaffold = 0 //Scaffolds are platforms but you can jump through them or fall through them.
		isLadder = 0

obj
	warpdoor
		icon = 'Graphics/Tileset/mak/collision.dmi'
		icon_state = "door"
		canInteract = 1
		density = 0
		interactDesc = "enter."
		var
			_tag = null
			_toTag = null

		interactEvent(actor/M)
			if((!_tag) || (!_toTag)) return world << "you dun fucked up."
			var/obj/O = locate(_toTag)
			M.loc = O.loc

		New()
			tag = _tag
			icon = null
			.=..()

		apartmentDoors

			A
				_tag = "Tut A"
				_toTag = "Tut B"
			B
				_tag = "Tut B"
				_toTag = "Tut A"

			C
				_tag = "Tut C"
				_toTag = "Tut D"
			D
				_tag = "Tut D"
				_toTag = "Tut C"

			E
				_tag = "Tut E"
				_toTag = "Tut F"
			F
				_tag = "Tut F"
				_toTag = "Tut E"

			G
				_tag = "Tut G"
				_toTag = "Tut H"
			H
				_tag = "Tut H"
				_toTag = "Tut G"

			I
				_tag = "Tut I"
				_toTag = "Tut J"
			J
				_tag = "Tut J"
				_toTag = "Tut I"

			K
				_tag = "Tut K"
				_toTag = "Tut L"
			L
				_tag = "Tut L"
				_toTag = "Tut K"

	door
		density = 1
		canGetHit = 1
		blocksLoS = 1
		bound_width = 20
		bound_height = 60

		var
			keyType
			isLocked

			isClosed

			openIconState
			closeIconState

			openSound = 'dooropen.ogg'
			closeSound = 'doorclose.ogg'
			errorSound = 'error.ogg'

			animDelay = 5 //delay until dense or undense.


		canInteract = 1
		interactDesc = "open this door."
		interactDelay = 0.5
		interactEvent(actor/M)
			if(isClosed)
				var/canOpen = !isLocked
				if(isLocked && keyType)
					if(checkKeys(M)) canOpen = 1

				if(canOpen)
					//open the door
					if(isLocked)
						if(keyType)
							var/item/keyItem = checkKeys(M)
							keyItem.drop()
							del keyItem

						isLocked = 0

					open()



				else
					//error cannot open door.
					//play a sound
					if(errorSound)
						playSound(errorSound,src)

			else
				//close the door
				close()

		getInteractDesc()
			if(isClosed) return "open this door."
			else return "close this door"

		proc
			open()
				icon_state = openIconState

				spawn(animDelay)
					density = 0
					canGetHit = 0
					blocksLoS = 0

				isClosed = 0
				if(openSound)
					playSound(openSound,src)

			close()
				icon_state = closeIconState

				spawn(animDelay)
					density = 1
					canGetHit = 1
					blocksLoS = 1

				isClosed = 1
				//door is closed.
				if(closeSound)
					playSound(closeSound,src)


		proc
			checkKeys(actor/M)
				if(!keyType) return 1
				if(locate(keyType) in M.inventory) return locate(keyType) in M.inventory
				return 0

		remoteDoor
			canInteract = 0

			icon='terrain60.dmi'
			icon_state = "door3"
			interactDesc = "Regular door."

			openIconState = "door3 open"
			closeIconState = "door3 closed"

		regulardoor
			icon='terrain60.dmi'
			icon_state = "door3"
			interactDesc = "Regular door."
		//	keyType = /item/key/tutorialkey
			isLocked = 0

			isClosed = 1

			animDelay = 8

			openIconState = "door3 open"
			closeIconState = "door3 closed"

			NPCdoor

				open()
					.=..()

					spawn() while(!isClosed)
						sleep(10)
						sleep(0)

						var/shouldClose = 1

						var/bound[] = bounds(src, -tile_width, -tile_height, tile_width, tile_height)

						for(var/actor/M in bound)
							if(M != player)
								shouldClose = 0

						if(shouldClose)
							close()

				interactEvent(actor/M)
					if(isClosed)
						var/canOpen = !isLocked
						if(isLocked && keyType)
							if(checkKeys(M)) canOpen = 1

						if(canOpen && M != player.mob)
							//open the door
							if(isLocked)
								if(keyType)
									var/item/keyItem = checkKeys(M)
									keyItem.drop()
									del keyItem

								isLocked = 0

							open()



						else
							//error cannot open door.
							//play a sound
							if(errorSound)
								playSound(errorSound,src)


/*
		tutorialdoor
			icon='terrain60.dmi'
			icon_state = "door3"
			interactDesc = "Your first door!"
			keyType = /item/key/tutorialkey
			isLocked = 1

			isClosed = 1

			animDelay = 8

			openIconState = "door3 open"
			closeIconState = "door3 closed"
*/

item
	key
		icon = 'key.dmi'

		wardenKey
			name = "Warden's Keycard"
			description = "This is the keycard needed to operate the prison elevators."





/*

SHIT TIER GLASS
*/

//lolwat.

obj
	glass
		density = 0
		icon = 'tutorial tileset.dmi'
		icon_state = "glass"
		Crossed(actor/O)
			..()
			world << "Crossed"
			//Fancy particle shit here
			invisibility = 1
			density = 0
			for(var/obj/glass/g in view(7))
				g.invisibility = 1
				g.density = 0
			//..()

/*
	Goose
*/
VFX
	parent_type = /obj

	PrisonCell
		icon = 'Prison Cell.dmi'
		icon_state = "Animated"
		layer = TURF_LAYER + 0.01
		New()
			..()
			//tag = "Prison Cell"
