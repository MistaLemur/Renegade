/*
Author: Miguel SuVasquez
March 2014

This file defines the Camera class. A Camera Object is the center of the screen, and follows the main character.
It uses an exponential easing function to follow the main character (move % of the way to the target every frame).
This lets the player character move away from the center of the screen to provide a sense of speed, and smooths out any of the
player character's rapid accelerations.
*/

client
	var
		camera/camera

camera
	parent_type = /obj

	density = 0
	invisibility = 101

	bound_width = 1
	bound_height = 1

	layer = PARALLAX_LAYER

	var
		atom/movable/target
		tweenSpeed = 0.15
		tweenThreshhold = 1
		client/parent

		parallaxes[0]

	New(client/client, atom/movable/A)
		target = A

		loc = A.loc

		step_x = A.step_x + A.bound_x + A.bound_width/2
		step_y = A.step_y + A.bound_y + A.bound_height/2


		parent = client

		parent.eye = src
		parent.camera = src

	Del()
		if(parent) parent.eye = target
		.=..()

	tick()
		.=..()
		//move towards center
		if(!target) return

		var/targetCoords[] = target.pixelCoords()
		var/targetCenter[] = target.pixelCenter()
		var/myCoords[] = pixelCoords()

		var/vector
			targetPosition = vec2(targetCoords[1], targetCoords[2])
			myPosition = vec2(myCoords[1], myCoords[2])
			velocity

		targetPosition = targetPosition.add(vec2(targetCenter[1], targetCenter[2]))

		velocity = targetPosition.subtract(myPosition)

		if(velocity.magnitudeSquared() >= tweenThreshhold*tweenThreshhold)
			velocity = velocity.multiply(tweenSpeed)

			vx = round(velocity.x,1)
			vy = round(velocity.y,1)

			Velocity(1)

		else
			Drag(1)

			loc = target.loc
			step_x = target.step_x + target.bound_x + target.bound_width/2
			step_y = target.step_y + target.bound_y + target.bound_height/2

		if(vx != 0 || vy != 0)
			for(var/i in parallaxes)
				var/parallax/P = parallaxes[i]
				P.move(vx,vy)

	proc
		createParallax(pTag, icon/I, start_x, start_y, wrap, newLayer = PARALLAX_LAYER)
			var/parallax/P = new(src, I, start_x, start_y, wrap, newLayer)
			parallaxes[pTag] = P
			return P

		removeParallax(pTag)
			del parallaxes[pTag]
			parallaxes -= pTag

		clearParallaxes()
			for(var/i in parallaxes)
				del parallaxes[i]
				parallaxes -= i

			parallaxes.Cut()

		getParallax(pTag)
			return parallaxes[pTag]
