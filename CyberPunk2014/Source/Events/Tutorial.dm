/*
Author: Miguel SuVasquez
March 2014

This file contains Storyevents for a test scenario.
*/
client
	var
		eventList[] = newlist()


obj
	eventTiles
		textEvents
			icon = 'TestMob.dmi'
			icon_state = "crouching"
			var
				eventName = "Test"
				eventText = "Oh hey yo, this has to be changed"
				eventDuration = 5
				eventPortrait = null

			Crossed(actor/O)
				..()
				if(eventName in player.eventList) return
				else
					O.client.eventList.Add(eventName)
					world << "YOU DUN FUCKED UP"
			Test_tile1

