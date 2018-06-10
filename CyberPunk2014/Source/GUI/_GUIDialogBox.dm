proc
	createDialogBox(text, icon/portrait, duration = -1, pauseGame = 1, clearEvent, takeFocus = 1, delKey = 1)
		//text is a string
		//portrait is an icon
		//duration is how long before the dialog box deletes itself.
		//	This is in seconds. set it to <0 if you want it to not close by itself.
		//clearEvent is an event that is called when the dialogBox is closed
		return new /GUIDialogBox (text, portrait, duration, pauseGame, clearEvent, takeFocus, delKey)


GUIDialogBox
	parent_type = /GUIDatum
	var
		text
		icon/portrait
		clearEvent
		pauseGame = 1
		duration = -1

		breakThread = 0

		creationComplete = 0

		delOnKey = 0 //delete src when key is pressed?

		sleepingThread = 0

		fadeInDelay = 0.25

		focusParent
		layer = HUD_LAYER + 100

	New(newText, icon/newPortrait, durr = -1, pause, newEvent, takeFocus = 1, delKey = 1)
		.=src

		if(takeFocus)
			if(istype(player.focus, src)) del player.focus
			focusParent = player.focus

			player.focus = src

		pauseGame = pause

		if(pauseGame) currentScreen.isPaused = 1

		if(!isicon(newPortrait) && newPortrait) portrait = icon(newPortrait)
		else portrait = newPortrait

		text = newText
		clearEvent = newEvent

		delOnKey = delKey


		//add the gui
		addDialogHUD()

		duration = durr

		if(duration >=0)
			duration += fadeInDelay
			spawn(duration*10)
				del src

	Del()
		if(pauseGame) currentScreen.isPaused = 0

		if(player.focus == src)
			player.focus = focusParent
			if(!player.focus) player.focus = player

		flush()

		callEvent()

		.=..()

	key_up(k)
		if(k == "space" || k =="enter")
			if(!delOnKey && sleepingThread && creationComplete)
				breakThread = 1

			else if(delOnKey && creationComplete)
				del src

	proc
		changeText(newText)
			creationComplete = 0

			var/px = 140
			var/py = 20

			if(portrait)

				//the portrait will offset the dialog box...
				px += 60
				py += 0
			else
				px += 30

			player.removeHUD("_dialogBox text")

			var/HUDObj/O
			var/matrix/m

			O = player.getHUD("_dialogBox box")

			m = matrix()
			m.Scale(1, 0.01)
			if(O) animate(O, transform = m, alpha = 0, time = fadeInDelay * 5)

			spawn(fadeInDelay * 6)

				text = newText

				O.transform = m
				O.alpha = 255
				animate(O, transform = matrix(), time = fadeInDelay * 10)

				spawn(fadeInDelay * 10)
					if(!src) return
					O = player.addHUD("_dialogBox text", px+5, py+6, null, null, layer+1)
					O.maptext_width = 280 - 8
					O.maptext_height = 50 - 4
					O.maptext = "<font  color=white valign=top size=0.5>[text]"

					creationComplete = 1

		sleepThread()
			sleepingThread = 1
			while(src)
				sleep(0)
				sleep(1)
				if(breakThread)
					break

			breakThread = 0

		flush()
			removeDialogHUD()

		callEvent()
			if(clearEvent)
				currentScreen.event(clearEvent)

		addDialogHUD()
			var/px = 140
			var/py = 20
			var/HUDObj/O

			var/matrix/m

			//add the portrait
			if(portrait)

				O = player.addHUD("_dialogBox portrait", px + 7, py + 7, portrait, null, layer)
				m = matrix()
				m.Scale(1, 0.01)
				O.transform = m
				animate(O, transform = matrix(), time = fadeInDelay * 10)

				//the portrait will offset the dialog box...
				px += 60
				py += 0
			else
				px += 30

			O = player.addHUD("_dialogBox box", px, py, 'Dialog Box.png', null, layer)
			m = matrix()
			m.Scale(1, 0.01)
			O.transform = m
			animate(O, transform = matrix(), time = fadeInDelay * 10)

			spawn(fadeInDelay * 10)
				if(!src) return
				O = player.addHUD("_dialogBox text", px+5, py+6, null, null, layer+1)
				O.maptext_width = 280 - 8
				O.maptext_height = 50 - 4
				O.maptext = "<font  color=white valign=top size=0.5>[text]"

				creationComplete = 1

		removeDialogHUD()
			player.removeHUD("_dialogBox text")
			var/HUDObj/O
			var/matrix/m

			O = player.getHUD("_dialogBox portrait")
			if(O)
				m = matrix()
				m.Scale(1, 0.01)
				animate(O, transform = m, alpha = 0, time = fadeInDelay * 5)

			O = player.getHUD("_dialogBox box")

			m = matrix()
			m.Scale(1, 0.01)
			if(O) animate(O, transform = m, alpha = 0, time = fadeInDelay * 5)

			sleep(fadeInDelay * 5)
			player.clearHUDGroup("_dialogBox")