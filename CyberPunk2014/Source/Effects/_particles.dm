var
	particleLimit = 150
	numParticlesActive

particle
	parent_type = /atom/movable

	density = 0
	canGetHit = 0

	layer = 10

	var
		lifeTimer
		hasLife = 0

		particleEmitter/emitter

	New()
		.=..()

	tick()
		checkLife()

		Velocity()
		.=..()

	Cross(particle/P)
		if(istype(P))
			particleCollision(P)
		.=..()

	Del()
		if(emitter) emitter.particles -= src
		.=..()

	proc
		resetPosition()
			loc = emitter.loc
			step_x = emitter.step_x
			step_y = emitter.step_y

		particleCollision(particle/P) //some particles might interact with eachother

		checkLife()
			if(currentTime() >= lifeTimer && hasLife) del src


particleEmitter
	parent_type = /obj

	icon = 'marker.dmi'
	icon_state = "particleEmitter"

	invisibility = 101
	activeBool = 1

	var
		particles[0]

		maxParticles = 100

		particleRate = 100 //how many particles to create at once
		createParticleTimer
		createParticleDelay //how long between "waves" of particles

		duration
		lifeTimer

		particleType = /particle
		particleDuration = -1

		particleIcon
		particleIconState

		particleLayer

		dist_x = 17
		dist_y = 10


	New(newLoc)
		loc = newLoc
		if(!isturf(newLoc)) loc = newLoc:loc

		if(istype(newLoc, /atom/movable))
			var/center[] = newLoc:pixelCenter()
			step_x = newLoc:step_x + center[1]
			step_y = newLoc:step_y + center[2]

		if(duration >= 0) lifeTimer = currentTime() + duration

		if(currentScreen)
			currentScreen.addActiveAtom(src)

		tick(-1)


	tick(screenTime)
		if(duration >= 0 && screenTime > lifeTimer && screenTime > 0) del src
		var/time = 0

		if(lifeTimer) time = screenTime - lifeTimer

		if(!checkPlayerDist()) return 0

		for(var/particle/P in particles)
			if(numParticlesActive < particleLimit)
				numParticlesActive ++
				affectParticle(P, time)
				P.tick()
			else
				del P


		if(particles.len < maxParticles && createParticleTimer < screenTime && numParticlesActive < particleLimit)
			createParticleTimer = screenTime + createParticleDelay

			var/numToCreate = min(particleRate, maxParticles - particles.len)
			for(var/i = 1; i<= numToCreate; i++)
				createParticle()

	Del()
		for(var/particle/P in particles) del P
		.=..()

	proc
		createParticle()
			var/particle/P = new particleType()
			P.loc = loc
			P.step_x = step_x
			P.step_y = step_y


			applyParticleAttributes(P)
			P.icon = particleIcon
			if(!particleIconState)
				P.icon_state = pick(icon_states(particleIcon))
			else
				P.icon_state = particleIconState


			centerParticle(P)
			if(particleLayer) P.layer = particleLayer
			P.emitter= src


			particles += P
			return P

		deleteParticle(particle/P)
			particles -= P
			del P

		applyParticleAttributes(particle/P) //This is called when particles are created
			P.lifeTimer = currentTime() + particleDuration
			if(particleDuration > 0) P.hasLife = 1

		affectParticle(particle/P) //This is called by tick() on every particle

		centerParticle(particle/P)
			var/icon/I = icon(P.icon, P.icon_state)
			P.pixel_x = -I.Width()/2
			P.pixel_y = -I.Height()/2

		checkPlayerDist()
			if(!player) return 0
			var/mob/mob = player.mob
			if(!mob) return 0
			if(mob.z != z) return 0

			var/dx = mob.x - x
			var/dy = mob.y - y

			if(abs(dx) <= dist_x && abs(dy) <= dist_y) return 1
			return 0

	particleText

		var
			string
			start_vx = 0
			start_vy = 60

		maxParticles = 1
		duration = 0.5

		applyParticleAttributes(particle/P)
			P.step_x = step_x
			P.step_y = step_y

			P.vx = start_vx
			P.vy = start_vy

			P.maptext_width = 200
			P.maptext_height = 30
			P.maptext = string

			centerParticle(P)
			.=..()

		New(loc, newString)
			string = newString

			.=..(loc)


	quadratic
		//There are hella effects you can do with quadratic modelling
		//This uses fairly simple euler's method for integration
		var
			rand_offx
			start_offx
			rand_offy
			start_offy

			rand_vx
			start_vx
			rand_vy
			start_vy

			accel_x
			accel_y

			drag_x
			drag_y

		applyParticleAttributes(particle/P)
			P.step_x = start_offx + rand(-rand_offx, rand_offx) + step_x
			P.step_y = start_offy + rand(-rand_offy, rand_offy) + step_y

			P.vx = start_vx + rand(-rand_vx, rand_vx)
			P.vy = start_vy + rand(-rand_vy, rand_vy)

			centerParticle(P)
			.=..()

		affectParticle(particle/P)
			P.Accelerate(accel_x, accel_y)

			P.DragX(drag_x)
			P.DragY(drag_y)

	parametric
		affectParticle(particle/P, time)
			parametricFunction(P, time)

		proc
			parametricFunction(particle/P, time)
				//whatever the fuck you want

		circle

			var
				radius
				orbitalVelocity //this is lateral velocity, not angular velocity!

			applyParticleAttributes(particle/P)

				var/angle = rand(0,359)
				P.step_x = step_x + radius * cos(angle)
				P.step_y = step_y + radius * sin(angle)

				P.vx = -sin(angle) * orbitalVelocity
				P.vy = cos(angle) * orbitalVelocity

				centerParticle(P)

			parametricFunction(particle/P, time)
				var/acceleration = orbitalVelocity*orbitalVelocity/radius

				var/off_x = P.step_x - step_x
				var/off_y = P.step_y - step_y
				off_x += world.icon_size * (P.x - x)
				off_y += world.icon_size * (P.y - y)

				var/invOffset = 1/sqrt(off_x * off_x + off_y * off_y)

				P.vx += acceleration * off_x * invOffset
				P.vy += acceleration * off_y * invOffset

			spiral
				var
					deltaRadius

				tick(screenTime)
					.=..(screenTime)
					radius += deltaRadius