var
	yxRatio = 1 //This is the ratio of Y to X for the camera projection

atom
	movable
		step_size = 1
		var
			//maximum speed. If this atom is accelerated past this speed, its speed will be
			//automatically reduced
			maxSpeed = 500

			tmp
				//boolean that stops the mob from moving
				isStatic

				//This is a timer that stops the mob from moving
				staticTimer

				//Velocity components
				vx
				vy

				//Subpixel coordinates
				dx
				dy

			dragThreshhold = 0.01 //This is the threshhold for Drag() to completely negate velocity

		proc
			KnockBack(ax,ay) //KnockBack will set the mob's velocity to (ax, ay)
				if(isStatic) return
				if(time < staticTimer) return
				vx = ax
				vy = ay

				Accelerate(0,0)

			AccelerateTowards(accel, atom/target)
				//This is an extremely simplified accelerate towards that relies on get_dir
				var/d = get_dir(src,target)

				var/ax = 0, ay = 0
				if(d & 1) ay =  accel
				if(d & 2) ay = -accel

				if(d & 4) ax =  accel
				if(d & 8) ax = -accel

				Accelerate(ax,ay)

			Accelerate(ax,ay, tick = dt) //Accelerates the mob by (ax, ay)
				//in terms of pixels per second per second
				if(isStatic) return
				if(time < staticTimer) return

				var/speed2 = vx*vx+vy*vy
				var/maxSpeed2 = maxSpeed*maxSpeed

				vx += ax * tick
				vy += ay * tick

				if(speed2 > maxSpeed2)
					var/speed = sqrt(speed2)
					var/reduceMult = maxSpeed / speed
					vx *= reduceMult
					vy *= reduceMult

			Friction(friction) //This is just a frictional acceleration applied opposite of velocity.
				//This is capable of completely stopping an object.
				var/inverseSpeed = 1/sqrt(vx*vx+vy*vy)
				var/fx = friction * vx * inverseSpeed
				var/fy = friction * vy * inverseSpeed

				var/nvx = vx
				var/nvy = vy

				if(nvx > 0) nvx = max(0,nvx - fx)
				if(nvx < 0) nvx = min(0,nvx + fx)

				if(nvy > 0) nvy = max(0,nvy - fy)
				if(nvy < 0) nvy = min(0,nvy + fy)

				vx = nvx
				vy = nvy

			Drag(drag) //this is drag proportional to velocity, like air resistance
				//Mathematically, this sort of drag will never bring any object to a full stop
				vx *= 1 - drag
				vy *= 1 - drag

				if(abs(vx) <= dragThreshhold) vx = 0
				if(abs(vy) <= dragThreshhold) vy = 0


			DragX(drag) //This is like Drag() but only applies to the X axis
				vx *= 1 - drag
				if(abs(vx) <= dragThreshhold) vx = 0

			DragY(drag) //This is like Drag() but only applies to the Y axis
				vy *= 1 - drag
				if(abs(vy) <= dragThreshhold) vy = 0

			Velocity(tick = dt) //Integrates velocity to displacement using Euler's method.
				//Returns true if the mob moved as a result.

				if(isStatic) return
				if(time < staticTimer) return

				if(!vx && !vy) return

				//step(ref,dir,speed) doesn't like non-integer inputs
				//and doesn't like negative inputs
				//So we have to make sure that the input is always an integer
				//We do this by using the variables dx, and dy.
				//dx and dy keep track of the sub-pixel coordinates (the noninteger portion)
				//and we round dx and dy to vdx and vdy for the step()s.

				dx += vx*tick
				dy += vy*tick*yxRatio
				//yxRatio is a ratio to preserve the camera perspective from 3d rendered sprites
				//It's not a magic number. It's computed by cos(cameraPitch) where
				//cameraPitch = 0 is pointing straight down, and cameraPitch = 90 is horizontal
				//Andromeda uses cameraPitch = 30
				//Race for the Stars uses cameraPitch = 45

				var/vdx = round(dx,1), vdy = round(dy,1)

				dx -= vdx; dy -= vdy

				var/success = 0

				if(vdx > 0)
					var/worked = !step(src,EAST,abs(vdx))
					success |= worked

				if(vdx < 0)
					var/worked = !step(src,WEST,abs(vdx))
					success |= worked

				if(vdy > 0)
					var/worked = !step(src,NORTH,abs(vdy))
					success |= worked

				if(vdy < 0)
					var/worked = !step(src,SOUTH,abs(vdy))
					success |= worked

				success = !success

				return success