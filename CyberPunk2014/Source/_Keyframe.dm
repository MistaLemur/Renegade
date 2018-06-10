
keyframe
/*
This class holds animation keyframe data for the arms' inverse kinematics.
The animations simply work by LERPing between keyframes and using the inverse kinematics to fill in the in-between frames.
*/
	var
		x
		y

		state

		time

	New(nx, ny, nt, ns)
		x = nx
		y = ny
		src.time = nt
		state = ns

		.=..()

	proc
		toString()
			return "[x], [y], [state], [time]"

proc
	getKeyframes(listOfFrames[], T) //This function takes a list of keyframe objects, and a time and will return the two keyframes from the list that bound the time.
		if(listOfFrames.len < 1) return null

		if(listOfFrames.len == 1)
			return list(listOfFrames[1], listOfFrames[1])

		var
			keyframe
				key1 = listOfFrames[1]
				key2 = listOfFrames[listOfFrames.len]

		for(var/keyframe/F in listOfFrames)
			if(T >= F.time && F.time >= key1.time)
				key1 = F

			if(T < F.time && F.time < key2.time)
				key2 = F

		return list(key1, key2)

	interpolateKeyframes(T, keyframe/key1, keyframe/key2)
		//this will return a new keyframe object that is interpolated between key1 and key2


		var/T0 = key1.time
		var/T1 = key2.time

		var/inverseDT = 1/(key2.time - key1.time)

		var/u = (T - T0) * inverseDT
		var/v = (T1 - T) * inverseDT

		var/keyframe/newFrame = new()
		if(key2.state) newFrame.state = key2.state

		newFrame.time = T

		newFrame.x = key2.x * u + key1.x * v
		newFrame.y = key2.y * u + key1.y * v

		return newFrame
