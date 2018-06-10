particleEmitter

	quadratic

		bulletSparks

			maxParticles = 5

			rand_offx = 2
			start_offx = 0
			rand_offy = 2
			start_offy = 0

			rand_vx = 150
			start_vx
			rand_vy = 150
			start_vy

			accel_x = 0
			accel_y = -gravity

			drag_x = 0.05
			drag_y = 0.05

			particleIcon = 'Sparks.dmi'

			duration = 0.25

			New(projectile/P)
				loc = P.loc

				start_offx = P.step_x
				start_offy = P.step_y

				start_vx = -P.vx / 10
				start_vy = -P.vy / 10


				lifeTimer = currentTime() + duration

				if(currentScreen)
					currentScreen.addActiveAtom(src)

				tick(-1)

		bloodProjectile
			maxParticles = 15

			rand_offx = 3
			start_offx = 0
			rand_offy = 3
			start_offy = 0

			rand_vx = 100
			start_vx
			rand_vy = 100
			start_vy

			accel_x = 0
			accel_y = -gravity

			drag_x = 0.05
			drag_y = 0.05

			particleIcon = 'Blood.dmi'

			duration = 0.4

			New(projectile/P, damage=maxParticles)

				src.maxParticles = round(damage)

				loc = P.loc

				start_offx = P.step_x
				start_offy = P.step_y

				start_vx = -P.vx / 4
				start_vy = -P.vy / 4


				lifeTimer = currentTime() + duration

				if(currentScreen)
					currentScreen.addActiveAtom(src)

				tick(-1)

		deathBlood
			maxParticles = 20

			rand_offx = 3
			start_offx = 0
			rand_offy = 3
			start_offy = 0

			rand_vx = 150
			start_vx
			rand_vy = 150
			start_vy

			accel_x = 0
			accel_y = -gravity

			drag_x = 0.05
			drag_y = 0.05

			particleIcon = 'Blood.dmi'

			duration = 1

			New(actor/M, numMax=maxParticles)

				src.maxParticles = round(numMax)

				loc = M.loc

				start_offx = M.step_x
				start_offy = M.step_y

				var/offset[] = M.pixelCenter()
				start_offx += offset[1]
				start_offy += offset[2]

				lifeTimer = currentTime() + duration

				if(currentScreen)
					currentScreen.addActiveAtom(src)

				tick(-1)

		pistolBrass
			maxParticles = 1

			rand_offx = 1
			start_offx = 0
			rand_offy = 1
			start_offy = 0

			rand_vx = 100
			start_vx = 0
			rand_vy = 20
			start_vy = 100

			accel_x = 0
			accel_y = -gravity

			drag_x = 0.05
			drag_y = 0.05

			particleIcon = 'PistolBrass.dmi'

			duration = 0.5

			New(atom/movable/source, direction, vector/offset, angle)
				loc = source.loc

				start_offx = offset.x + source.step_x
				start_offy = offset.y + source.step_y + 2


				if(direction & 4) start_vx = -200
				else start_vx = 200

				lifeTimer = currentTime() + duration

				if(currentScreen)
					currentScreen.addActiveAtom(src)

				tick(-1)

		smokeEffect

			rand_offx = 3
			start_offx = 0 + 10
			rand_offy = 3
			start_offy = 0 + 10

			rand_vx = 6
			start_vx = 0
			rand_vy = 10
			start_vy = 60

			accel_x = 0
			accel_y = 0

			drag_x = 0.005
			drag_y = 0.02

			particleIcon = 'Smoke.dmi'

			duration = -1

			maxParticles = 40

			particleRate = 2 //how many particles to create at once
			createParticleDelay = 0.2//how long between "waves" of particles

			particleType = /particle
			particleDuration = 3

			New()
				.=..()

				if(istype(loc, /atom/movable))
					var/atom/movable/source = loc
					loc = source.loc

					start_offx = source.step_x
					start_offy = source.step_y

				if(currentScreen)
					currentScreen.addActiveAtom(src)

				tick(-1)

			createParticle()
				. = ..()

				var/particle/P = .
				if(P)
					P.alpha = 0
					P.transform = scaleMatrix(0.5,0.5)
					animate(P, transform=matrix(), alpha = 255, time = particleDuration*2)
					animate(alpha = 0, time = particleDuration*8)

		droppedMagazine
			maxParticles = 1

			rand_offx = 1
			start_offx = 0
			rand_offy = 1
			start_offy = 0

			rand_vx = 0
			start_vx = 0
			rand_vy = 0
			start_vy = 0

			accel_x = 0
			accel_y = -gravity

			drag_x = 0.05
			drag_y = 0.05

			particleIcon = 'DroppedMagazine.dmi'
			particleIconState = ""
			var/matrix/particleMatrix

			duration = 0.5

			New(atom/movable/source, direction, vector/offset)
				loc = source.loc

				start_offx = offset.x + source.step_x
				start_offy = offset.y + source.step_y

				lifeTimer = currentTime() + duration

				if(currentScreen)
					currentScreen.addActiveAtom(src)

				particleLayer = source.layer - 0.01

				particleMatrix = matrix()

				if(direction & 8)
					particleMatrix.Scale(-1,1)

				tick(-1)

			createParticle()
				. = ..()

				var/particle/P = .
				if(P)
					P.transform = particleMatrix

			Pistol
				particleIconState = "pistol"

			SMG
				particleIconState = "smg"

			AR
				particleIconState = "ar"