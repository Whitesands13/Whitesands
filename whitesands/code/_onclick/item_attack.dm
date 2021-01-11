/**
  * Does a swing depending on the object's swing_type var.
  * user - The mob swinging the object
  */
/obj/item/proc/swing_attack(mob/living/user)
	var/list/affected_turfs = list()
	var/effect_type = /obj/effect/temp_visual/dir_setting/item_swing
	var/swing_speed = 1.5
	switch(swing_type)
		if(SWINGABLE_STAB)
			effect_type = /obj/effect/temp_visual/dir_setting/item_swing/stab
			affected_turfs[get_step(src, user.dir)] = 1 //the tile in front of the user
		if(SWINGABLE_SWING)
			for(var/ranged_turf in RANGE_TURFS(1, user))
				if(get_dir(user, ranged_turf) & user.dir) //the three tiles in front of the user
					affected_turfs[ranged_turf] = 0.75
			if(user.dir & NORTHWEST) //makes it so you always swing the same way around
				reverseRange(affected_turfs)
		if(SWINGABLE_FLAIL)
			for(var/ranged_turf in RANGE_TURFS(1, user))
				var/turf_dir = get_dir(user, ranged_turf)
				if(!(turf_dir & REVERSE_DIR(user.dir)) && ranged_turf != get_turf(user)) //all tiles around user that aren't the back three or the user's tile
					if(turf_dir & user.dir)
						affected_turfs[ranged_turf] = 0.5
					else
						affected_turfs[ranged_turf] = 0.25
			if(user.dir & NORTHWEST) //makes it so you always swing the same way around
				reverseRange(affected_turfs)
		if(SWINGABLE_THRUST)
			effect_type = /obj/effect/temp_visual/dir_setting/item_swing/stab
			swing_speed = 0.5
			var/turf/front_turf = get_step(user, user.dir) //the tile in front of the user and the one in front of that
			if(isopenturf(front_turf))
				affected_turfs[front_turf] = 0.5
				affected_turfs[get_step(front_turf, user.dir)] = 1

	var/swings_left = swing_penetration
	var/swing_num = 0
	for(var/turf in affected_turfs)
		var/turf/T = turf
		addtimer(CALLBACK(T, /turf/proc/swing_attack_act, user, src, effect_type, affected_turfs[turf]), swing_speed * swing_num++)

	if(--swings_left <= 0)
		return

/turf/proc/swing_attack_act(mob/living/user, obj/item/I, effect_type, damage_modifier = 1)
	if(!isopenturf(src))
		return
	for(var/mob/M in contents)
		if(M == user)
			continue
		I.melee_attack_chain(user, M, modifier = damage_modifier)
		return TRUE
	new effect_type(src)
