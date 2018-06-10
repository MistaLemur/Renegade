//This file should enable debugging and contain debugging commands for the debugging console
//Including this file will enable debugging features, and unincluding this file should disable debugging features.

#define DEBUG

client
	New()
		.=..()
		winset(src, "_DEBUG", "is-visible=true") //Enable the debugging console

	verb
		checkClientScreen()
			for(var/i in hud)
				world<<"[i]: [hud[i]]"

			world<<null

			for(var/obj/o in screen)
				world<<"[o]: [o.screen_loc]"

		testShop()
			new/GUIDatum/GUIShop/(src)

		testDialog(t as text)
			createDialogBox(t, 'Ghost Portrait.png')

		setHealth(n as num)
			n = max(0, min(100, n))
			mob:health = n
			updateHealth = 1

		testActiveWorldAtoms(n as num)
			world<<"active World Atoms [length(worldActiveAtoms)]"

			world<<"Z: [n], [length(worldActiveAtoms[n])]"
			for(var/atom/A in worldActiveAtoms[n])
				world<<A

		findParticleEmitters()
			for(var/particleEmitter/A in world)
				world<<"[A], [A.loc]: [A.x], [A.y], [A.z]"