/*
Author: Miguel SuVasquez
March 2014

This file contains the class definition for Projectile. Projectiles are just bullets with a specified speed (and accelerations).
These typically perform multiple physics steps per frame.
*/
atom
	var
		canGetHit=0
	proc
		Hit(projectile/O)


actor/canGetHit = 1

projectile
	parent_type = /atom/movable

	bound_width = 4
	bound_height = 4

	var
		lifeTimer = 0
		lifeDelay = 0.5
		createdTime

		atom/ignoreAtom
		ignoreType

		atom/movable/owner

		angle

		velocityTicks = 3

		damage
		armorPenetration

		makeParticles = 1

	maxSpeed = 900

	proc
		checkCollisions()
			for(var/atom/A in obounds(src))
				collide(A)

		calculateVelocity(vAngle = angle, speed = maxSpeed)
			vx = cos(vAngle) * speed
			vy = sin(vAngle) * speed

		collide(atom/O)
			if(istype(O,/projectile)) return
			if(!O.canGetHit) return
			if(O == ignoreAtom) return
			if(istype(O,ignoreType)) return

			makeParticles = !O.Hit(src)
			del src

		getGunAttributes(weapon/gun/gun)
			if(istype(gun))
				//get inaccuracy
				var/inacc = gun.getInaccuracy()
				angle += rand(-inacc, inacc) / 2

			//get damage
			damage = gun.damage
			armorPenetration = gun.armorPenetration

		death() //called by del()

	Del()
		death()
		.=..()

	tick()
		for(var/i=1;i<=velocityTicks; i++)
			var/success = Velocity(dt / velocityTicks)
			if(!success)
				del src

		if(lifeDelay > 0 && currentTime() >= lifeTimer)
			del src

	Velocity()
		.=..()
		checkCollisions()

	New(mowner, fireAng, drawAng, weapon/gun, off_x, off_y)
		owner = mowner

		if(istype(owner, /actor/humanoid/AI))
			ignoreType = /actor/humanoid/AI


		/*
		if((fireAng >= 90 && fireAng <= 270 && (drawAng < 90 || drawAng > 270)) || \
			(drawAng >= 90 && drawAng <= 270 && (fireAng < 90 || fireAng > 270)))

			drawAng = 180 - drawAng
			off_x *=-1
		*/

		var/icon/I = icon(icon, icon_state)
		loc = owner.loc
		step_x = owner.step_x + round(off_x,1)
		step_y = owner.step_y + round(off_y,1)


		angle = drawAng

		//go get the attributes from the gun
		getGunAttributes(gun)


		calculateVelocity()

		var/matrix/m = matrix()


		m.Turn(-drawAng)
		transform = m

		if(currentScreen)
			currentScreen.addActiveAtom(src)

		if(lifeDelay > 0)
			lifeTimer = time + lifeDelay

		createdTime = time

		ignoreAtom = owner

		bound_x = -bound_width/2
		bound_y = -bound_height/2


		//var/icon/I = icon(icon,icon_state)

		pixel_x = -I.Width()/2
		pixel_y = -I.Height()/2

		tick()

projectile
	icon = 'Bullet.dmi'

	bullet
		icon_state = "a"

		death()
			//create the particle system
			if(makeParticles)
				new/particleEmitter/quadratic/bulletSparks(src)

	beam
		invisibility = 101

		//maxSpeed for beams is actually how many pixels long each segment is
		maxSpeed = 10

		tick()
			while(src)
				//place a particle that matches this guy's position and appearance

				//keep running velocity
				Velocity(1)
