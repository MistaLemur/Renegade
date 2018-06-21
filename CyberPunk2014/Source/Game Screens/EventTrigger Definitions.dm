/*
Author: Miguel SuVasquez
March 2014

This file contains EventTrigger definitions in a database-like format.
Specific classes trigger a specific stroy event, indicated by the "missionEvent" attribute.
*/

EventTrigger

	ghostOpensSecurityDoor
		missionEvent = "ghostOpensSecurityDoor"

	ghostDirectsToSecurity
		missionEvent = "ghostDirectsToSecurity"

	ghostDescribesMaintenance
		missionEvent = "ghostDescribesMaintenance"

	ghostApproachesWardenOffice
		missionEvent = "ghostApproachesWardenOffice"

	ghostLastStand
		missionEvent = "ghostLastStand"

	ghostJump
		missionEvent = "ghostJump"

	suicide
		missionEvent = "suicide"

	resetParallax
		missionEvent = "resetParallax"

	finishMission
		missionEvent = "End"
