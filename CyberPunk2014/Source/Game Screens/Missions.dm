/*
Author: Miguel SuVasquez
March 2014

This file contains the class declaration for missions. Missions contain a set of events that can be completed throughout.
these mission events can be different checkpoints, objectives, win conditions or fail conditions.
*/

var/mission/currentMission

mission

	var
		events[0] //this is a list of completed events.

	proc
		missionEvent(name, params)

		complete()

		fail()

		reward()


