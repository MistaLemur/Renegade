proc
	pixelDistY(atom/movable/A, atom/movable/B) //This returns the distance in pixels between A and B along the Y axis
		var/Ay1 = (A.y-1)*tile_height
		if(istype(A)) Ay1 += A.step_y + A.bound_y

		var/Ay2 = Ay1
		if(istype(A)) Ay2 += A.bound_height
		else Ay2 += tile_height

		var/By1 = (B.y-1)*tile_height
		if(istype(B)) By1 += B.step_y + B.bound_y

		var/By2 = By1
		if(istype(B)) By2 += B.bound_height
		else By2 += tile_height

		var/dist1 = Ay1 - By2
		var/dist2 = Ay2 - By1
		var/dist3 = Ay1 - By1
		var/dist4 = Ay2 - By2

		var/minDist = min(abs(dist1), abs(dist2), abs(dist3), abs(dist4))

		if(abs(dist1) == abs(minDist)) return dist1
		if(abs(dist2) == abs(minDist)) return dist2
		if(abs(dist3) == abs(minDist)) return dist3
		if(abs(dist4) == abs(minDist)) return dist4

	pixelDistX(atom/movable/A, atom/movable/B) //This returns the distance in pixels between A and B along the X axis
		var/Ax1 = (A.x-1)*tile_width
		if(istype(A)) Ax1 += A.step_x + A.bound_x

		var/Ax2 = Ax1
		if(istype(A)) Ax2 += A.bound_height
		else Ax2 += tile_height

		var/Bx1 = (B.x-1)*tile_width
		if(istype(B)) Bx1 += B.step_x + B.bound_x

		var/Bx2 = Bx1
		if(istype(B)) Bx2 += B.bound_height
		else Bx2 += tile_height

		var/dist1 = Ax1 - Bx2
		var/dist2 = Ax2 - Bx1
		var/dist3 = Ax1 - Bx1
		var/dist4 = Ax2 - Bx2

		var/minDist = min(abs(dist1), abs(dist2), abs(dist3), abs(dist4))

		if(abs(dist1) == abs(minDist)) return dist1
		if(abs(dist2) == abs(minDist)) return dist2
		if(abs(dist3) == abs(minDist)) return dist3
		if(abs(dist4) == abs(minDist)) return dist4

	scaleMatrix(scaleX, scaleY)
		var/matrix/m = matrix()
		m.Scale(scaleX, scaleY)
		return m

	rotateMatrix(angle)
		var/matrix/m = matrix()
		m.Turn(angle)
		return m

atom
	//these functions return a two size array in the format of [offset_x, offset_y] relative to src.step_x
	proc
		getTopLeftCorner()
			var/Ax1 = (x-1)*tile_width
			var/Ay1 = (y-1)*tile_height
			var/Ay2 = Ay1 + tile_height

			return list(Ax1, Ay2)

		getTopRightCorner()
			var/Ax1 = (x-1)*tile_width
			var/Ax2 = Ax1 + tile_width
			var/Ay1 = (y-1)*tile_height
			var/Ay2 = Ay1 + tile_height

			return list(Ax2, Ay2)

		getTopEdge()
			var/Ay1 = (y-1)*tile_height
			var/Ay2 = Ay1 + tile_height

			return Ay2

		getBottomLeftCorner()
			var/Ax1 = (x-1)*tile_width
			var/Ay1 = (y-1)*tile_height

			return list(Ax1, Ay1)

		getBottomRightCorner()
			var/Ax1 = (x-1)*tile_width
			var/Ax2 = Ax1 + tile_width
			var/Ay1 = (y-1)*tile_height

			return list(Ax2, Ay1)


		getBottomEdge()
			var/Ay1 = (y-1)*tile_height
			return Ay1

		pixelCoords()
			return list((x-1)*tile_width, (y-1)*tile_height)


atom/movable
	getTopLeftCorner()
		var/Ax1 = (x-1)*tile_width + step_x + bound_x
		var/Ay1 = (y-1)*tile_height + step_y + bound_y
		var/Ay2 = Ay1 + bound_height

		return list(Ax1, Ay2)

	getTopRightCorner()
		var/Ax1 = (x-1)*tile_width + step_x + bound_x
		var/Ax2 = Ax1 + bound_width
		var/Ay1 = (y-1)*tile_height + step_y + bound_y
		var/Ay2 = Ay1 + bound_height

		return list(Ax2, Ay2)

	getTopEdge()
		var/Ay1 = (y-1)*tile_height + step_y + bound_y
		var/Ay2 = Ay1 + bound_height

		return Ay2

	getBottomLeftCorner()
		var/Ax1 = (x-1)*tile_width + step_x + bound_x
		var/Ay1 = (y-1)*tile_height + step_y + bound_y

		return list(Ax1, Ay1)

	getBottomRightCorner()
		var/Ax1 = (x-1)*tile_width + step_x + bound_x
		var/Ax2 = Ax1 + bound_width
		var/Ay1 = (y-1)*tile_height + step_y + bound_y

		return list(Ax2, Ay1)

	getBottomEdge()
		var/Ay1 = (y-1)*tile_height + step_y + bound_y

		return Ay1

	pixelCoords()
		return list((x-1)*tile_width + step_x, (y-1)*tile_height + step_y)

	proc
		pixelCenter() //This returns the center of this movable atom relative to step_x and step_y
			//returns a list(2) with the coordinates
			return list(bound_x + bound_width/2, bound_y + bound_height/2)

		pixelCenterVector() //This returns the center of this movable atom relative to step_x and step_y
			//returns a list(2) with the coordinates
			return vec2(bound_x + bound_width/2, bound_y + bound_height/2)

		pixelCoordsVector()
			return vec2((x-1)*tile_width + step_x, (y-1)*tile_height + step_y)

proc
	bool(a)
		return a? 1 : 0

	sig(x,y,b=10)
		return scv(x,y,b)-rand(1,1000)/1000

	scv(x,y,b=10)
		return 1/(1+b**(-(x-y)/(x+y)))

	arctan(x)
		return arcsin(x/sqrt(1+x*x))

	turnAngle(angle, inc)
		angle += inc
		if(angle >= 360) angle -= 360
		if(angle < 0) angle += 360
		return angle

	_GetAngle(y, x)
		var/ang=0
		if(x == 0)
			if(y > 0) ang= 90
			if(y < 0) ang= 270
		else ang = arctan(y / x)
		if(x<0) ang+=180
		if(ang < 0) ang += 360
		if(ang >=360) ang -= 360
		return ang

	parseTo(string,char)
		var/i = findtext(string,char)
		if(!i) return null
		else return copytext(string,1,i+length(char))

	parsePast(string,char)
		var/i = findtext(string,char)
		if(!i) return null
		else return copytext(string,i+length(char),0)

	dist(x1, x2, y1, y2)
		var/dx = x1-x2
		var/dy = y1-y2
		return sqrt(dx*dx+dy*dy)

	odds(c)
		return rand() * 100 <= c

	lerp(lo1, hi1, val, lo2, hi2)
		//linearly interpolate a value between lo1 and hi1
		//into a value between lo2 and hi2
		return (val - lo1)/(hi1 - lo1) * (hi2 - lo2) + lo2