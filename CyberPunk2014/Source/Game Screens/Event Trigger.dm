/*
Author: Miguel SuVasquez
March 2014

This file contains the definition for the EventTrigger class.
This class represents map-triggers for story or mission events. These objects trigger story events when the player character intersects their bounding box.
*/
EventTrigger
	parent_type = /obj
	icon = 'marker.dmi'
	icon_state = "eventTrigger"
	invisibility = 101

	var
		missionEvent

	Crossed(actor/A)
		if(player && A == player.mob)
			if(currentMission)
				currentMission.missionEvent(missionEvent)


		else
			.=..()
