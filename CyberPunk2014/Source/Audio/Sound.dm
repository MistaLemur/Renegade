/*
Author: Miguel SuVasquez
March 2014

This file provides a basic playSound() function that fades sound based on distance. 3d sound environment is specifically disabled here.

Additionally, this file defines the SoundEmitter class, which can play looping sounds whose volume fades with distance.
*/

proc
	playSound(file,turf/tile,volume=100,range=21,falloff=5)
		if(!file) return
		var/sound/S = sound(file)
		//S.environment = 0
		S.volume = volume
		//S.falloff=falloff

		for(var/mob/M)
			if(M.z != tile.z) continue

			//parabolic interpolation
			var/x2 = LENGTHSQ(M.x,M.y,tile.x,tile.y)
			var/h = volume
			var/r2 = range*range
			S.volume = h * (1 - x2/r2)

			M << S



SoundEmitter
	parent_type = /obj
	icon = 'marker.dmi'
	icon_state = "soundEmitter"
	invisibility = 101

	var
		listeners[0]
		//obj = timer

		sound/sound

		soundFile
		soundDelay

		radius=4 //Sound emission radius
		r2

		volume = 100
		falloffMult=1

	Del()
		for(var/mob/M in listeners)
			RemoveListener(M)
		..()

	proc
		Init()
			sound = new(file(soundFile),1)
			sound.volume = volume
			//sound.falloff = 999999//dist/2 * falloffMult
			//Falloff just because. It's arbitrary because I don't want the sounds to follow the
			//inverse distance squared rule.

			r2 = radius*radius

		EmitterStep()
			//Deal with present listeners

			//For every mob who was previously listening,
			//First check their distance from the sound and remove from listening if necessary
			//Then update the sound and send to the mob

			for(var/mob/M in listeners)
				sound.status = 0

				Listener(M)

			//Now add new mobs who have just entered the affected area to the listeners
			for(var/mob/M in range(src,radius) - listeners)
				if(!M.client) continue
				if(LENGTHSQ(x,y,M.x,M.y)>r2) continue

				sound.status = 0

				AddListener(M)


		AddListener(mob/M)
			if(M in listeners) return

			listeners += M

			sound.status = 0

			Listener(M)

		SoundCoordinate(mob/M)
			var/dx = x-M.x, dy = y-M.y
			/*
			sound.x = dx
			sound.y = dy       //sin(60) * (dy)
			sound.z = 0        //cos(60) * (dy)
			*/

			var/d2 = (dx*dx+dy*dy)//+sound.z*sound.z)
			var/vr = volume/r2
			var/intensity = (r2-d2)*vr
			sound.volume = intensity
			//quadratic dropoff for sound volume

		RemoveListener(mob/M)
			listeners -= M

			M<<sound(null,0,0,M.soundChannels[sound],volume)

			M.soundChannels -= sound

		Listener(mob/M)

			if(!(sound in M.soundChannels))
				var/lowestChannel = M.getLowestSoundChannel()

				M.soundChannels += sound
				M.soundChannels[sound] = lowestChannel

			if(LENGTHSQ(x,y,M.x,M.y)>r2)
				return RemoveListener(M)

			sound.status = SOUND_UPDATE
			SoundCoordinate(M)
			sound.channel = M.soundChannels[sound]

			M<<sound

mob
	var
		soundChannels[0] //sound = channel
/*
	verb
		ChannelData()
			world<<"==Channel Data ([soundChannels.len])=="
			for(var/i=1;i<=soundChannels.len;i++)
				var/sound/S = soundChannels[i]
				world<<"Sound #[i], Channel [soundChannels[S]]. Volume: [S.volume]. Relative Coordinates: [S.x], [S.y], [S.z]"
*/
	proc
		getLowestSoundChannel()
			var/lowestChannel = 32
			for(var/i in soundChannels)
				if(soundChannels[i] >= lowestChannel)
					lowestChannel = soundChannels[i]+1
			return lowestChannel
