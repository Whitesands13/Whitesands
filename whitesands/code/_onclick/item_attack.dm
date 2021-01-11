/**
  * Does a swing depending on the object's swing_type var.
  * user - The mob swinging the object
  */
/obj/item/proc/swing_attack(mob/living/user)
	var/list/affected_turfs = list()
	var/effect_type = /obj/effect/temp_visual/dir_setting/item_swing
	switch(swing_type)
		if(SWINGABLE_STAB)
			effect_type = /obj/effect/temp_visual/dir_setting/item_stab
			affected_turfs[get_step(src, user.dir)] = 1 //the tile in front of the user
		if(SWINGABLE_SWING)
			for(var/ranged_turf in RANGE_TURFS(1, user))
				if(get_dir(user, ranged_turf) & user.dir) //the three tiles in front of the user
					affected_turfs[ranged_turf] = 0.75
			if(user.dir & NORTHWEST) //makes it so you always swing the same way around
				reverseRange(affected_turfs)
		if(SWINGABLE_FLAIL)
			for(var/ranged_turf in RANGE_TURFS(1, user))
				if(!(get_dir(user, ranged_turf) & REVERSE_DIR(user.dir)) && ranged_turf != get_turf(user)) //all tiles around user that aren't the back three or the user's tile
					affected_turfs[ranged_turf] = 0.5
			if(user.dir & NORTHWEST) //makes it so you always swing the same way around
				reverseRange(affected_turfs)
		if(SWINGABLE_THRUST)
			effect_type = /obj/effect/temp_visual/dir_setting/item_stab
			var/turf/front_turf = get_step(user, user.dir) //the tile in front of the user and the one in front of that
			if(isopenturf(front_turf))
				affected_turfs[front_turf] = 0.5
				affected_turfs[get_step(front_turf, user.dir)] = 1

	var/swings_left = swing_penetration
	var/missed = TRUE
	for(var/turf in affected_turfs)
		var/turf/T = turf
		if(!isopenturf(T))
			continue
		new effect_type(T)
		for(var/mob/M in T)
			melee_attack_chain(user, M, affected_turfs[turf])
			missed = FALSE
			if(--swings_left <= 0)
				return
			else
				break
	if(missed)
		playsound(loc, 'sound/weapons/slashmiss.ogg', 25, TRUE, -1) //nice swingin', G
