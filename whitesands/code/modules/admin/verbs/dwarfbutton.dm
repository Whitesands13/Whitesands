//White Sands Tacky as Hell Dwarf All Button

/proc/dorf_migration()
	for(var/M in GLOB.mob_list)
		if(!isdwarf(M) && isliving(M))
			dorf_apply(M)
		CHECK_TICK
	addtimer(CALLBACK(src, .proc/dorf_migration), 1 SECONDS) //checks for non-dwarfs on glob list and makes them dwarfs, the fix for late spawns.

/proc/dorf_apply(mob/living/carbon/human/H, silent = FALSE)
	if(!isdwarf(H) && isliving(H))
		H.set_species(/datum/species/dwarf)
		if(!silent)
			to_chat(H, "<span class='boldnotice'>Strike the Earth!</span>")
