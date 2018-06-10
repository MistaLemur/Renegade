////////////////////////////////////////////////////////////////////////////////
//
//	_GUIDatum.dm
//	Author:	Gooseheaded
//
////////////////////////////////////////////////////////////////////////////////

GUIDatum
	key_up(k, client/c)

	key_down(k, client/c)

	#ifndef NO_KEY_REPEAT
	key_repeat(k, client/c)
	#endif

	#ifndef NO_CLICK
	click(object, client/c)
	#endif

	var

	proc
		/*
		*/
		transitionIn()/*
			var/matrix/finalPosition = transform
			transform.Translate(-50, 0)
			animate(src, transform = finalPosition, time = 5, easing = SINE_EASING|EASE_OUT)*/

		/*
		*/
		transitionOut()/*
			var/matrix/finalPosition = new matrix()
			finalPosition.Translate(50, 0)
			animate(src, transform = finalPosition, time = 5, easing = SINE_EASING|EASE_IN)*/

	GUIObjectives

	GUIShop
		var/obj/shopkeeperPortrait
		var/obj/shopkeeperDialogue
		var/obj/windowFrame
		var/obj/buyButton

		New(client/c)
			shopkeeperPortrait = c.addHUD("GUIShop Shopkeeper Portrait", 485, 205, 'Shopkeeper Portrait.png') //Add an HUD object
			shopkeeperPortrait.alpha = 0
			var/matrix/finalPosition = matrix()
			var/matrix/m = matrix()
			m.Translate(-477, 0)
			shopkeeperPortrait.transform = m
			animate(shopkeeperPortrait, transform = finalPosition, alpha = 255, time = 5, easing = CUBIC_EASING)

			shopkeeperDialogue = c.addHUD("GUIShop Shopkeeper Dialogue", 15, 210, 'Shopkeeper Dialogue.png') //Add an HUD object
			shopkeeperDialogue.alpha = 0
			m = matrix()
			m.Translate(-456, 0)
			shopkeeperDialogue.transform = m
			animate(shopkeeperDialogue, transform = shopkeeperDialogue, alpha = 255, time = 5, easing = CUBIC_EASING)

			windowFrame = c.addHUD("GUIShop Frame", 10, 25, 'Small Frame.png') //Add an HUD object
			windowFrame.alpha = 0
			m = matrix()
			m.Translate(-456, 0)
			windowFrame.transform = m
			animate(windowFrame, transform = windowFrame, alpha = 255, time = 5, easing = CUBIC_EASING)

		Del()
			var/matrix/m = matrix()
			m.Translate(630, 0)
			animate(shopkeeperPortrait, transform = m, alpha = 0, time = 5, easing = CUBIC_EASING)
			animate(shopkeeperDialogue, transform = m, alpha = 0, time = 5, easing = CUBIC_EASING)
			animate(windowFrame, transform = m, alpha = 0, time = 5, easing = CUBIC_EASING)

			spawn(6)
				..()