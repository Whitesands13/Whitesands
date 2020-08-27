/obj/item/grenade/discogrenade
	name = "Boogie Bomb"
	desc = "An handheld party that incentivises sapient beings to dance to its beat through an unconscious hypnopompic shock."
	icon_state = "concussion"
	item_state = "flashbang"
	var/list/messages = list("This party is great", "Wooo!!!", "Party!", "Check out these moves!", "Hey, want to dance with me?")
	var/list/message_social_anxiety = list("I want to go home...", "Where are the toilets?", "I don't really like this song.")

/obj/item/grenade/discogrenade/prime()
	update_mob()
	var/current_turf = get_turf(src)
	if(!current_turf)
		return

	playsound(current_turf, 'sound/weapons/flashbang.ogg', 100, TRUE, 8, 0.9)

	new /obj/structure/etherealball(current_turf)

	for(var/i = 0; i < 6; i ++)
		new /obj/item/grenade/discogrenade/subgrenade(current_turf, TRUE)

	qdel(src)

//////////////////////
//   Sub grenades   //
//////////////////////

/obj/item/grenade/discogrenade/subgrenade
	name = "Micro-Disco"
	desc = "An entire disco in the palm of your hand."
	icon_state = "concussion"
	item_state = "flashbang"
	var/spawn_new = TRUE
	var/timerID
	var/lightcolor
	var/range = 5
	var/power = 3

/obj/item/grenade/discogrenade/subgrenade/Initialize(mapload, duplicate = FALSE)
	. = ..()
	active = TRUE
	spawn_new = duplicate
	icon_state = initial(icon_state) + "_active"
	var/launch_distance = rand(2, 6)
	for(var/i in 1 to launch_distance)
		step_away(src, loc)
	addtimer(CALLBACK(src, .proc/prime), rand(10, 60))
	randomiseLightColor()

/obj/item/grenade/discogrenade/subgrenade/prime()
	update_mob()
	var/current_turf = get_turf(src)
	if(!current_turf)
		return

	playsound(current_turf, 'sound/weapons/flashbang.ogg', 30, TRUE, 8, 0.9)
	playsound(current_turf, pick('sound/instruments/accordion/Dn2.mid', 'sound/instruments/bikehorn/Cn3.ogg', 'sound/instruments/piano/Dn7.ogg', 'sound/instruments/violin/Cn3.mid'), 100, TRUE, 8, 0.9)

	if(spawn_new)
		for(var/i = 0; i < 3; i ++)
			new /obj/item/grenade/discogrenade/subgrenade(current_turf)

	for(var/mob/living/carbon/human/M in view(4, src))
		forcedance(get_turf(M), M)
	qdel(src)

/obj/item/grenade/discogrenade/subgrenade/proc/randomiseLightColor()
	remove_atom_colour(TEMPORARY_COLOUR_PRIORITY)
	lightcolor = random_color()
	set_light(range, power, lightcolor)
	add_atom_colour("#[lightcolor]", FIXED_COLOUR_PRIORITY)
	update_icon()
	timerID = addtimer(CALLBACK(src, .proc/randomiseLightColor), 2, TIMER_STOPPABLE)

/obj/item/grenade/discogrenade/subgrenade/proc/forcedance(turf/T , mob/living/carbon/human/M)
	if(!T)
		return
	if(M.stat != CONSCIOUS)	//Only conscious people can dance
		return

	var/distance = max(0,get_dist(get_turf(src),T))
	if(distance > 2.5)
		return

	if(M.has_quirk(/datum/quirk/social_anxiety))
		M.say(pick(message_social_anxiety))
		if(rand(3) && M.get_ear_protection() == 0)
			M.drop_all_held_items()
			M.show_message("<span class='warning'>You cover your ears, the music is just too loud for you.</span>", 2)
		return

	if(HAS_TRAIT(M, TRAIT_MINDSHIELD))
		M.show_message("<span class='warning'>You resist your inner urges to break out your best moves.</span>", 2)
		M.set_drugginess(5)
		return

	M.set_drugginess(10)
	M.show_message("<span class='warning'>You feel a strong rythme and your muscles spasm uncontrollably, you begin dancing and cannot move!</span>", 2)
	M.Immobilize(30)

	//Special actions
	switch(rand(0, 6))
		if(0)
			M.Knockdown(4)
			M.show_message("<span class='warning'>You [pick("mess", "screw")] up your moves and trip!</span>", 2)
		if(1 to 3)
			M.emote("spin")
		if(3 to 4)
			M.emote("flip")
		if(5)
			M.say(pick(messages))
		if(6)
			M.emote("dance")
