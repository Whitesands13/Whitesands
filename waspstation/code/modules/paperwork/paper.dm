/obj/item/paper/crumpled/beernuke
	name = "beer-stained note"

/obj/item/paper/crumpled/beernuke/Initialize()
	. = ..()
	var/code = random_nukecode()
	for(var/obj/machinery/nuclearbomb/beer/beernuke in GLOB.nuke_list)
		if(beernuke.r_code == "ADMIN")
			beernuke.r_code = code
		else 
			code = beernuke.r_code
	info = "important party info, DONT FORGET: <b>[code]</b>"
