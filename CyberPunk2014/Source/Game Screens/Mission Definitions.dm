/*
Author: Miguel SuVasquez
March 2014

This file defines specific story events and mission events. 
These events usually include some dialog, some door changes, music changes, and so forth.

Some events have a longer duration, like the finale of the demo where enemies are continuously attacking the player for a full minute.
*/

mission

	tutorial_Mission
		var

			wardenElevatorFlag

		missionEvent(name, params)

			if(name in events)
				return

			events += name

			switch(name)
				/*
				TEXT EVENTS
				*/
				if("Start")

					var/GUIDialogBox/box
					box = createDialogBox("Use the WASD keys to move around, and space to jump.", \
						null, -1, 1, null, 1)
					box.sleepThread()

					missionEvent("ghostStartTimer")

				if("ghostStartTimer")
					spawn(75)
						var/VFX/vfx = locate("Prison Cell")
						vfx.icon_state = "Shutdown"
						flick("Alert", vfx)
						sleep(20)
						missionEvent("ghostIntro")
						//missionEvent("Goose's ghostIntro")

				if("Goose's ghostIntro")

					currentScreen.isPaused = 1

					var/GUIDialogBox/box
					box = createDialogBox("<b>Ghost: </b>\n\
						Dagon, do you copy? I've looked everywhere for you.", \
						'Ghost Portrait.png', -1, 1, null, 1)
					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						I see the place's heavily guarded, but you got no hardware on you.")
					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						Let me get you out of that cell. Just gotta make sure no one's looking...")
					box.sleepThread()

					currentScreen.isPaused = 0

					return missionEvent("ghostOpensCellDoor")


				if("ghostIntro")
					currentScreen.isPaused = 1

					//Ghost's talking style is filled with slang from the Shadowrun universe.
					//I'm also trying to make him talk like an advice animal, since that's where
					//Internet Slang seems to be headed towards.

					var/GUIDialogBox/box
					box = createDialogBox("<b>Ghost: </b>\n\
						Sup, Dagon. You done dancing around in that shitty little cell, choob?", \
						'Ghost Portrait.png', -1, 1, null, 1, 0)
					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						You must be wondering who da fuck I am, and how I'm transmitting to ya. ")

					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						Da details don't matter, choob. Lets try to keep dis shit short.")
					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						I'll help you break out if you agrees to do a little retrieval fo me.")
					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						There's some hot data in an isolated Gibson mainframe nearby dat I wants.")
					//Gibson Mainframe is an allusion to "Hackers" and William Gibson
					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						When you gets a physical copy of dat for me, I'll arrange for yo exit path.")
					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						An ace decker like Yours Truly can open yo cell door easy.")
					//Yours Truly is an allusion to a character from "Snow Crash". Great Novel
					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						But da problem is all da corp coppers up and down yo fuckin buildin.")
					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						See da rafters along top of da hallway? Use 'em to sneak past yo guards.")
					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						Imma open yo door when no ones near. Get ready to jam, choob!")
					box.sleepThread()

					del box

					currentScreen.isPaused = 0

					return missionEvent("ghostOpensCellDoor")

				if("ghostOpensCellDoor")
					spawn()
						sleep(10)
						while(1)
							var/Prop/forcefield_door/O = locate("playerCellDoor")
							var/Enemy/E = locate(/Enemy) in range(12, O)
							var/dist = get_dist(src,E)
							if(!E || ((E.dir&4) && dist > 8))
								O.open()
								break

							sleep(0)
							sleep(1)

				if("ghostDescribesMaintenance")
					var/GUIDialogBox/box
					box = createDialogBox("<b>Ghost: </b>\n\
						A lil to yo east is a vertical maintenance shaft.", \
						'Ghost Portrait.png', -1, 1, null, 1, 0)
					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						Try to walljump or climb yo way up.")
					box.sleepThread()

					del box

				if("ghostDirectsToSecurity")
					var/GUIDialogBox/box
					box = createDialogBox("<b>Ghost: </b>\n\
						I'm buying some time so da coppers dont set off any alarms.", \
						'Ghost Portrait.png', -1, 1, null, 1, 0)
					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						If you go down the ladder below, you'll find a security supply closet.")
					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						See if you can find any hardware in there to dust some coppers.")
					box.sleepThread()

					del box

				if("ghostOpensSecurityDoor")

					var/GUIDialogBox/box
					box = createDialogBox("<b>Ghost: </b>\n\
						Slammin work, choob. Lemme take care of dat for you.", \
						'Ghost Portrait.png', -1, 1, null, 1)
					box.sleepThread()

					spawn(50)
						var/Prop/forcefield_door/O = locate("securityClosetDoor")
						O.open()

						box = createDialogBox("<b>Ghost: </b>\n\
							Jack-in to dat console there so I can take a peek around da security.", \
							'Ghost Portrait.png', -1, 1, null, 1)
						//Jack-in is an obvious allusion to "The Matrix"
						box.sleepThread()

					//createDialogBox("As with wall sliding, you can hang on the edges of terrain. Move quicker!"
					//createPortrait("Ghost")

				if("ghostOpensEastWing")

					var/GUIDialogBox/box

					//change the music.


					box = createDialogBox("<b>Ghost: </b>\n\
						'kay, Choob. Here's how to get to the Gibson mainframe.", \
						'Ghost Portrait.png', -1, 1, null, 1, 0)

					playMusic('eden_-_02_-_HEAVEN_VERSION.ogg')

					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						To your east is an elevator that can go straight to the mainframe's section.")
					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						Let's check it out.")
					box.sleepThread()

					del box


					//open remote door
					var/obj/door/O = locate("eastWingDoor")
					if(O)
						O.isLocked = 0
						O.open()

				if("ghostExaminesElevator")

					var/GUIDialogBox/box
					box = createDialogBox("<b>Ghost: </b>\n\
						Shit! The Elevators won't move. Okay here's what you need, Dagon.", \
						'Ghost Portrait.png', -1, 1, null, 1, 0)
					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						1. The Elevator requires the Warden's key-card to operate")
					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						Da keycard should be in the Warden's office, above the elevator.")
					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						2. My hack to open your cell damaged the elevator's power conduits.")
					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						Couldn't open the laser doors any other way.")
					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						You'll have to fix the power conduits manually. They are near the elevator.")
					box.sleepThread()

					del box

					for(var/obj/door/remoteDoor/O)
						if(O.tag == "examinedElevator")
							if(O)
								O.isLocked = 0
								O.open()

				if("ghostApproachesWardenOffice")

					var/GUIDialogBox/box

					box = createDialogBox("<b>Ghost: </b>\n\
						We're getting close to the Warden's office.", \
						'Ghost Portrait.png', -1, 1, null, 1, 0)
					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						A bunch of coppers are along the way.\nHope you're good at shooting, choob!")
					box.sleepThread()

					del box

				if("ghostLastStand")

					var/GUIDialogBox/box

					box = createDialogBox("<b>Ghost: </b>\n\
						Dagon yo pickups eta is 1 minute, but you got corp coppers hot on yo ass.", \
						'Ghost Portrait.png', -1, 1, null, 1, 0)
					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						Survive, choob!")
					box.sleepThread()

					del box

					spawn()
						var/maxAIs = 4
						var/AIs[0]
						var/nextSpawn = 0

						var/counter = 60
						var/showCount = 60

						var/canLeave = 0

						while(currentMission == src)

							var/screenTime = currentTime()

							if(screenTime > nextSpawn)
								nextSpawn = screenTime + rand(1800,2200)/100

								while(null in AIs) AIs -= null

								var/numSpawn = rand(0.5 * maxAIs, maxAIs)

								spawn()
									for(var/i=1; i<=numSpawn; i++)

										if(AIs.len < maxAIs)
											var/NPCTypes[0]
											NPCTypes+= typesof(/Enemy/Sentinel) - /Enemy/Sentinel
											NPCTypes+= typesof(/Enemy/Guard) - /Enemy/Guard
											NPCTypes+= typesof(/Enemy/Guard) - /Enemy/Guard
											NPCTypes+= typesof(/Enemy/Guard) - /Enemy/Guard
											NPCTypes+= typesof(/Enemy/Guard) - /Enemy/Guard

											var/NPCType = pick(NPCTypes)

											var/atom/npcSpawn = locate("lastStandSpawn")

											if(!npcSpawn) world<<"LOL SHITTY SPAWN"

											if(npcSpawn)
												world<<"[npcSpawn.x], [npcSpawn.y], [npcSpawn.z]: [npcSpawn.type]"

												var/Enemy/E = new NPCType (npcSpawn.loc)
												E.loc = npcSpawn.loc

												E.maxHealth *= 0.8
												E.health = E.maxHealth

												world<<"OH GOD THEY'RE COMING"
												world<<"[E.x], [E.y], [E.z]: [E.type]"


												AIs += E

												E.alertLocation(player.mob.loc)
												E.forceActive = 1
												currentScreen.activeAtoms |= E

										sleep(10)


							sleep(1)
							sleep(0)
							counter -= 0.1

							if(-round(-counter/10) < showCount && counter%10 == 0 && counter <= 50 && counter > 9)
								showCount = -round(-counter/10) * 10
								box = createDialogBox("<b>Ghost: </b>\n\
								Pickup eta in [round(counter)] seconds!", \
								'Ghost Portrait.png', 2, 0, null, 0, 0)

							if(counter <= 0)
								if(!canLeave)
									canLeave = 1

									box = createDialogBox("<b>Ghost: </b>\n\
									Dagon yo pickup's here! Get moving!", \
									'Ghost Portrait.png', 5, 0, null, 0, 0)

				if("suicide")

					currentMission = null

					createDialogBox("<b>Ghost: </b>\n\
						Why would you do that you stupid fuck...", \
						'Ghost Portrait.png', 2, 0, null, 0, 0)

					spawn(20)
						player.mob:death()

						sleep(50)

						world.Reboot()


				if("repairedConduits")

					var/GUIDialogBox/box


					if(locate(/item/key/wardenKey) in player.mob:inventory)
						box = createDialogBox("<b>Ghost: </b>\n\
							Sexy shit, the elevators should be running now.", \
							'Ghost Portrait.png', -1, 1, null, 1)
						box.sleepThread()

					else
						box = createDialogBox("<b>Ghost: </b>\n\
							Good work, Choob. Now get da key card!", \
							'Ghost Portrait.png', -1, 1, null, 1)
						box.sleepThread()


				if("tutorialItems")
					var/GUIDialogBox/box
					box = createDialogBox("You just picked up an item!\n\
						Hold Q and then click to use or equip items.\n\
						Press Left Mouse to attack with equipped weapons.",\
						null, -1, 1, null, 1)
					box.sleepThread()

				if("useWardenElevator")
					currentScreen.isPaused = 1

					player.FadeOut()

					var/Prop/O = locate(/Prop/upperElevator)
					if(O)
						player.mob.loc = O.loc

					sleep(10)

					player.FadeIn()
					var/GUIDialogBox/box
					box = createDialogBox("<b>Ghost: </b>\n\
						Sweet shit, chummer. The Gibson mainframe is somewhere on this level.", \
						'Ghost Portrait.png', -1, 1, null, 1)


					box.sleepThread()

					currentScreen.isPaused = 0

				if("useMainframe")

					currentScreen.isPaused = 1

					var/GUIDialogBox/box
					box = createDialogBox("<b>Ghost: </b>\n\
						Fuckin' Beautiful. You do fine work.", \
						'Ghost Portrait.png', -1, 1, null, 1, 0)
					box.sleepThread()

					box.changeText("<b>Ghost: </b>\n\
						I've arranged for your pickup on the east edge of the roof. CYA chummer.")
					box.sleepThread()

					del box

					currentScreen.isPaused = 0

				if("ghostJump")
					currentScreen.isPaused = 1

					var/GUIDialogBox/box
					box = createDialogBox("<b>Ghost: </b>\n\
						Ya gotta jump, chummer. Hovercar is waiting for you below.", \
						'Ghost Portrait.png', -1, 1, null, 1)
					box.sleepThread()

					currentScreen.isPaused = 0

				if("resetParallax")
					player.camera.createCityParallax()


				if("End")
					if(!("useMainframe" in events))
						events -= "End"
						return

					currentScreen.isPaused = 1

					player.FadeOut()
					//mission success I guess.

					var/GUIDialogBox/box
					box = createDialogBox("Mission Success!",\
						null, -1, 0, null, 1)
					box.sleepThread()

					sleep(10)

					world.Reboot()



				if("Death")

					var/GUIDialogBox/box
					box = createDialogBox("<b>Ghost: </b>\n\
						Damn it. Fucker just flatlined...", \
						'Ghost Portrait.png', -1, 0, null, 1)
					box.sleepThread()

					sleep(10)

					world.Reboot()

				else return
