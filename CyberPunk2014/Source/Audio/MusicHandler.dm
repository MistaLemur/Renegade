
var/musicHandler/musicHandler = new()

proc
	playMusic(song, targetVolume=100)
		//This will play a song and automatically fade out the previous one and fade in this one
		musicHandler.playSong(song)



musicHandler

	var
		var/sound
			stream1
			stream2

		channel1 = 100
		channel2 = 101

		maxVolume1 = 100
		maxVolume2 = 100

		currentStream = 1 //1 or 2

		fadeIn = 5 //duration in seconds
		fadeOut = 5 //duration in seconds

	proc
		playSong(file,  targetVolume=100)
			var/sound/stream = getStream()
			if(stream) return //shit is still fading son.

			stream = sound(file)
			stream.repeat = 1
			stream.channel = getChannel()

			stream.volume = 0
			player << stream

			fadeIn(stream, targetVolume)

			if(currentStream == 1)
				fadeOut(stream2, maxVolume2)
				stream1 = stream
				maxVolume1 = targetVolume

			else
				fadeOut(stream1, , maxVolume1)
				stream2 = stream
				maxVolume2 = targetVolume

			currentStream = currentStream%2 + 1

		getStream()
			if(currentStream == 1) return stream1
			else return stream2

		getChannel()
			if(currentStream == 1) return channel1
			else return channel2

		fadeOut(sound/stream, maxVolume = 100, duration = fadeOut)
			if(!stream) return

			spawn()
				var/timer = fadeOut
				stream.status |= SOUND_UPDATE

				while(timer > 0)
					timer -= dt
					stream.volume = lerp(0, fadeIn, timer, 0, 100)
					player << stream

					sleep(world.tick_lag)
					sleep(0)

				del stream

		fadeIn(sound/stream, maxVolume = 100, duration = fadeIn)
			if(!stream) return

			spawn()
				var/timer = 0
				stream.status |= SOUND_UPDATE

				while(timer <= fadeIn)
					timer += dt
					stream.volume = lerp(0, fadeIn, timer, 0, maxVolume)
					player << stream

					sleep(world.tick_lag)
					sleep(0)

				stream.volume = 100
				player<<stream