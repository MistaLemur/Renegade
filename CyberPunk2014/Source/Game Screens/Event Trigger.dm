
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