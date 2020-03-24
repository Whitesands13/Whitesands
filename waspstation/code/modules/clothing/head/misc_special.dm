/obj/item/clothing/head/wig/suicide_act(mob/living/user)
	if (ishumanbasic(user) || iszombie(user) || isfelinid(user) || isvampire(user) || isdullahan(user))		// (Semi)non degenerates
		user.visible_message("<span class='suicide'>[user] strangles [user.p_their()] neck with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
		return OXYLOSS
	else
		var/turf/T = get_turf(src)
		user.visible_message("<span class='suicide'>[user] is stitching the [src] to [user.p_their()] head! It looks like [user.p_theyre()] trying to have hair!</span>")
		QDEL_IN(user, 2)
		for(var/mob/living/carbon/C in viewers(T, null))
			C.flash_act()
		new /obj/effect/dummy/lighting_obj (get_turf(src), LIGHT_COLOR_WHITE, 10, 4, 4)
		return MANUAL_SUICIDE
