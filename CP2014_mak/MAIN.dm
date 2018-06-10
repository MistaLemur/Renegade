
world
	icon_size	= 20
	fps			= 30

turf
	icon		= 'icons20.dmi'
	icon_state	= "grid"

client
	view		= "31x17"

	New()
		..()
		mob.icon		= 'icons20.dmi'
		mob.icon_state	= "mob"
		spawn()
			mob.overlays += DMIFont.ExportString("Hello World.",10,0)


/////////////
// DMIFont //
/////////////

DMIFont
	var
		icon	= 'ArialBold8.dmi'
		widths 	= list(	2,3,6,7,6,9,8,3,4,4,4,6,3,4,3,4,6,5,6,6,7,
						6,6,6,6,6,3,3,6,6,6,6,11,8,7,8,7,6,6,8,7,3,
						6,7,7,10,7,8,7,8,8,7,7,7,8,12,7,7,7,4,4,4,
						6,7,4,6,7,6,7,7,6,7,7,3,4,7,3,11,7,7,7,7,5,
						7,5,7,6,10,6,8,6,5,2,5,6)

	proc
		ExportString(T="NoText",OX=0, OY=0, L=FLY_LAYER)
			var/DMIString/o = new
			o.layer			= L
			o.pixel_x		= OX
			o.pixel_y		= OY
			var/px	= 0
			var/py	= 0
			var/ww	= 0
			for (var/i = 1 to length(T))
				world << i
				var/obj/u 		= new
				u.pixel_x 		= px
				u.pixel_y 		= py
				u.icon			= icon
				u.layer			= L
				ww				= text2ascii(T,i)
				u.icon_state	= "[ww]"
				px				+= widths[ww-31]
				o.overlays		+= u
			return o



///////////////
// DMIString //
///////////////

DMIString
	parent_type	= /obj

////////////
// GLOBAL //
////////////

var/DMIFont/DMIFont = new()






/*
client/New()
	..()
	var/s 		= "list("
	var/n		= 0
	var/icon/u	= null
	for (var/i = 32 to 126)
		u = icon('ArialBold8.dmi',"[i]")
		n = 1
		while (n <= 20)
			if (u.GetPixel(n,20))
				n += 1
			else
				s += "[n-1],"
				break
	src << s+")"
*/