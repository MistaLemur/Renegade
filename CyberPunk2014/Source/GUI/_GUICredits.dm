/*
Author: Miguel SuVasquez
March 2014

This file contains the definition and logic for the credits scene that can be entered from the main menu.
*/

GUICredits
	parent_type = /GUIDatum

	var
		oldFocus

	New()
		if(!player) del src
		.=..()

		oldFocus = player.focus
		player.focus = src

		player.Darken(192)

		sleep(5)

		var/HUDObj/O = player.addHUD("_credits team", 1, 1)
		O.layer = HUD_LAYER + 1000
		O.maptext_width = screen_px/2
		O.maptext_height = screen_py
		O.maptext = "<font color=white align=center valign=middle size=0.5><b>\n\
			<u>TEAM ZYNKCO</u>\n\n\
			- MistaLemur </b>(Lead Programmer, Artist, Level Design)<b>\n\
			- Mekanios </b>(Level Design)<b>\n\
			- Gooseheaded </b>(Level Design, Programmer)<b>\n\
			- Makeii </b>(Artist)<b>"

		O = player.addHUD("_credits assets", screen_px * 1/2, 1)
		O.layer = HUD_LAYER + 1000
		O.maptext_width = screen_px/2
		O.maptext_height = screen_py
		O.maptext = "<font color=white align=center valign=middle size=0.5><b>\n\
			<u>USED ASSETS</u>\n\n\
			ERH - BlueBeat 01\n\
			yd -  Factory Ambiance\n\
			EDEN - HEAVEN VERSION"

		while(src)
			sleep(1)
			sleep(0)

	key_up(k, client/c)
		if(k == "space" || k == "escape" || k == "enter" || k == "return")
			del src


	Del()
		player.focus = oldFocus
		player.clearHUDGroup("_credits")

		player.Darken(0)

		.=..()
