/*
	surfaceDrag = 1 //surfaceDrag is for when this atom is acting as the "ground" for an actor
		//A surface drag of < 1 will make the surface more slippery.
		//For example, for icy surfaces you could set surfaceDrag = 0

		wallSlide = 0
		cliffHang = 0
		isScaffold = 0 //Scaffolds let you drop through them or jump through them. But you cannot hang off of them.
		isLadder = 0
*/


turf
	size_80
		icon='terrain80.dmi'
		box/icon_state = "box"
	size_40
		icon = 'terrain40.dmi'
		arrowheadbox/icon_state = "arrowhead box"
		open/icon_state = "open"
		powerbox/icon_state = "power box"
	size_60
		icon='terrain60.dmi'
		dec_door/icon_state = "dec door"
		atennabot/icon_state = "antenna"
		antenna_top/icon_state = "antenna top"
	size_20
		icon='terrain20.dmi'
		bg_1c/icon_state ="bg_1c"
		bg_1n/icon_state ="bg_1n"
		bg_1s/icon_state ="bg_1s"

		stool/icon_state ="stool"

		bar_s/icon_state ="bar_s"

		bar_n1/icon_state ="bar_n1"
		bar_n2/icon_state ="bar_n2"
		bar_n3/icon_state ="bar_n3"
		bar_n4/icon_state ="bar_n4"

		bg2/icon_state ="bg2"
		bg3/icon_state ="bg3"

		ceil1/icon_state ="ceil1"

		light/icon_state ="light"

		block1/icon_state ="block1"

		scaffold_ns/icon_state ="scaffold_ns"
		scaffold_ew/icon_state ="scaffold_ew"
		scaffold_c/icon_state ="scaffold_c"
		scaffoldb_ns/icon_state ="scaffold_bns"
		scaffoldb_ew/icon_state ="scaffold_bew"
		scaffoldb_c/icon_state ="scaffold_bc"

		pipe_n/icon_state ="pipe_n"
		pipe_c/icon_state ="pipe_c"
		pipe_ns/icon_state ="pipe_ns"
		pipe_ew/icon_state ="pipe_ew"
		pipe_x/icon_state ="pipe_x"
		pipe_n_LC/icon_state ="pipe_n_LC"

		ladder/icon_state ="ladder"

		floor1/icon_state ="floor1"
		floor2/icon_state ="floor2"
		floor3/icon_state ="floor3"

		black/icon_state ="black"

		beigefloor/icon_state ="beigefloor"
		beigefloor2/icon_state ="beigefloor2"
		beigeblock/icon_state ="beigeblock"

		dirtblock/icon_state ="dirtblock"
		dirtblock2/icon_state ="dirtblock2"
		dirtblock3/icon_state ="dirtblock3"

		glasspane/icon_state ="glasspane"
		glass/icon_state ="glass"

		bg_purple/icon_state ="bg_purple"
		bg_purple_b/icon_state = "bgpurple_b"
		bg_purple_v/icon_state ="bg_purple_v"
		bg_blue/icon_state ="bg_blue"
		bg_blue_v/icon_state ="bg_blue_v"

		bgpurple_ne/icon_state ="bgpurple_ne"
		bgpurple_nw/icon_state ="bgpurple_nw"
		bgpurple_se/icon_state ="bgpurple_se"
		bgpurple_sw/icon_state ="bgpurple_sw"
		bgpurple_e/icon_state ="bgpurple_e"
		bgpurple_w/icon_state ="bgpurple_w"
		bgpurple_n/icon_state ="bgpurple_n"
		bgpurple_s/icon_state ="bgpurple_s"
		bgpurple_ns/icon_state ="bgpurple_ns"
		bgpurple_ew/icon_state ="bgpurple_ew"
		bgpurple_sw2/icon_state ="bgpurple_sw2"
		bgpurple_se2/icon_state ="bgpurple_se2"
		bgpurple_ne2/icon_state ="bgpurple_nw2"
		bgpurple_nw2/icon_state ="bgpurple_ne2"

		cable/icon_state = "cable"

		bg_dblue/icon_state ="bg_dblue"

		beigebg_s/icon_state ="beigebg_s"
		beigebg_n/icon_state ="beigebg_n"
		beigebg/icon_state ="beigebg"

		black_n/icon_state ="black_n"

		street_s/icon_state ="street_s"



obj
	breakable
		canGetHit = 1
		Hit(projectile/O)
			invisibility = 1
			density = 0
			canGetHit = 0

		glass
			icon = 'Tutorial tileset.dmi'
			icon_state = "w5"