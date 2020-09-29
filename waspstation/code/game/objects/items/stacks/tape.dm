/obj/item/stack/tape
	name = "packaging tape"
	singular_name = "packaging tape"
	desc = "Sticks things together with minimal effort."
	icon = 'icons/obj/tapes.dmi'
	icon_state = "tape_w"
	item_flags = NOBLUDGEON
	amount = 5
	max_amount = 5
	resistance_flags = FLAMMABLE
	grind_results = list(/datum/reagent/cellulose = 5)

	var/stop_bleed = 600
	var/nonorganic_heal = 10
	var/self_delay = 30 //! Also used for the tapecuff delay
	var/other_delay = 10
	var/prefix = "sticky"
	var/tapesound = 'waspstation/sound/items/tape.ogg'
	var/list/conferred_embed = EMBED_HARMLESS
	var/overwrite_existing = FALSE

/obj/item/stack/tape/attack(mob/living/M, mob/living/user)
	if(!istype(M))
		return

	//Bootleg bandage
	if(user.a_intent == INTENT_HELP)
		try_heal(M, user)

	//! ANYTHING THAT NEEDS CARBON BELOW HERE
	if(!iscarbon(M))
		return
	var/mob/living/carbon/C = M

	//Relatable suffering
	if((HAS_TRAIT(user, TRAIT_CLUMSY) && prob(25)))
		to_chat(user, "<span class='warning'>Uh... where did the tape edge go?!</span>")
		return

	//Mouth taping and tapecuffs
	if(user.a_intent == INTENT_DISARM)
		if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH) //mouth tape
			if(C.is_mouth_covered() || C.is_muzzled())
				to_chat(user, "<span class='warning'>There is something covering [C]s mouth!</span>")
				return
			if(use(1))
				playsound(loc, tapesound, 30, TRUE, -2)
				if(do_mob(user, C, other_delay) && (!C.is_mouth_covered() || !C.is_muzzled()))
					apply_gag(C, user)
					C.visible_message("<span class='notice'>[user] tapes [C]s mouth shut.</span>", \
										"<span class='userdanger'>[user] taped your mouth shut!</span>")
					log_combat(user, C, "gags")
				else
					to_chat(user, "<span class='warning'>You fail to tape up [C]!</span>")
			else
				to_chat(user, "<span class='warning'>There isn't enough tape left!")
		else if (!C.handcuffed) //tapecuffs
			if(iscarbon(user) && (HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50)))
				to_chat(user, "<span class='warning'>Uh... which side sticks again?</span>")
				apply_tapecuffs(user, user)
				return
			if(C.get_num_arms(FALSE) >= 2 || C.get_arm_ignore())
				if(use(4))
					C.visible_message("<span class='danger'>[user] is trying to put [src.name] on [C]!</span>", \
										"<span class='userdanger'>[user] is trying to put [src.name] on you!</span>")

					playsound(loc, tapesound, 30, TRUE, -2)
					if(do_mob(user, C, self_delay) && (C.get_num_arms(FALSE) >= 2 || C.get_arm_ignore()))
						apply_tapecuffs(C, user)
						C.visible_message("<span class='notice'>[user] tapecuffs [C].</span>", \
											"<span class='userdanger'>[user] tapecuffs you.</span>")
						SSblackbox.record_feedback("tally", "handcuffs", 1, type)

						log_combat(user, C, "tapecuffed")
					else
						to_chat(user, "<span class='warning'>You fail to tapecuff [C]!</span>")
				else
					to_chat(user, "<span class='warning'>There isn't enough tape left!</span>")
			else
				to_chat(user, "<span class='warning'>[C] doesn't have two hands...</span>")

/obj/item/stack/tape/proc/try_heal(mob/living/M, mob/user)
	if(M == user)
		playsound(loc, tapesound, 30, TRUE, -2)
		user.visible_message("<span class='notice'>[user] starts to apply \the [src] on [user.p_them()]self...</span>", "<span class='notice'>You begin applying \the [src] on yourself...</span>")
		if(!do_mob(user, M, self_delay, extra_checks=CALLBACK(M, /mob/living/proc/can_inject, user, TRUE)))
			return
	else if(other_delay)
		user.visible_message("<span class='notice'>[user] starts to apply \the [src] on [M].</span>", "<span class='notice'>You begin applying \the [src] on [M]...</span>")
		if(!do_mob(user, M, other_delay, extra_checks=CALLBACK(M, /mob/living/proc/can_inject, user, TRUE)))
			return

	if(heal(M, user))
		log_combat(user, M, "tape bandaged", src.name)
		use(1)

/obj/item/stack/tape/proc/heal(mob/living/M, mob/user)
	if(M.stat == DEAD)
		to_chat(user, "<span class='notice'>There isn't enough [src] in the universe to fix that...</span>")
		return
	if(!iscarbon(M))
		return
	var/mob/living/carbon/C = M
	var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(user.zone_selected))
	if(!affecting) //Missing limb?
		to_chat(user, "<span class='warning'>[C] doesn't have \a [parse_zone(user.zone_selected)]!</span>")
		return
	if(affecting.status == BODYPART_ORGANIC)
		if(ishuman(C))
			var/mob/living/carbon/human/H = C
			if(!H.bleedsuppress && H.bleed_rate)
				H.suppress_bloodloss(stop_bleed)
				to_chat(user, "<span class='notice'>You tape up the bleeding of [M]!</span>")
				return TRUE
		to_chat(user, "<span class='warning'>[M] has a problem \the [src] won't fix!</span>")
	else //Robotic patch-up
		if(affecting.brute_dam)
			user.visible_message("<span class='notice'>[user] applies \the [src] on [C]'s [affecting.name].</span>", "<span class='green'>You apply \the [src] on [C]'s [affecting.name].</span>")
			if(affecting.heal_damage(nonorganic_heal))
				C.update_damage_overlays()
			return TRUE
		to_chat(user, "<span class='warning'>[src] can't patch what [M] has...</span>")

/obj/item/stack/tape/proc/apply_gag(mob/living/carbon/target, mob/user)
	if(target.is_muzzled() || target.is_mouth_covered())
		return
	var/obj/item/clothing/mask/muzzle/tape/gag = new /obj/item/clothing/mask/muzzle/tape(get_turf(target))
	target.equip_to_slot_or_del(gag, ITEM_SLOT_MASK, 1, 0)
	return

/obj/item/stack/tape/proc/apply_tapecuffs(mob/living/carbon/target, mob/user)
	if(target.handcuffed)
		return
	var/obj/item/restraints/handcuffs/tape/tapecuff = new /obj/item/restraints/handcuffs/tape(get_turf(target))
	tapecuff.apply_cuffs(target, user, 0)
	return

/obj/item/stack/tape/afterattack(obj/item/I, mob/living/user)
	if(!istype(I))
		return

	if(I.embedding && I.embedding == conferred_embed)
		to_chat(user, "<span class='warning'>[I] is already coated in [src]!</span>")
		return

	user.visible_message("<span class='notice'>[user] begins wrapping [I] with [src].</span>", "<span class='notice'>You begin wrapping [I] with [src].</span>")

	if(do_after(user, 30, target=I))
		use(1)
		if(istype(I, /obj/item/clothing/gloves/fingerless))
			var/obj/item/clothing/gloves/tackler/offbrand/O = new /obj/item/clothing/gloves/tackler/offbrand
			to_chat(user, "<span class='notice'>You turn [I] into [O] with [src].</span>")
			QDEL_NULL(I)
			user.put_in_hands(O)
			return

		I.embedding = conferred_embed
		I.updateEmbedding()
		to_chat(user, "<span class='notice'>You finish wrapping [I] with [src].</span>")
		I.name = "[prefix] [I.name]"

		if(istype(I, /obj/item/grenade))
			var/obj/item/grenade/sticky_bomb = I
			sticky_bomb.sticky = TRUE

/obj/item/clothing/mask/muzzle/tape
	name = "tape muzzle"
	pickup_sound = 'sound/items/poster_ripped.ogg'
	item_flags = DROPDEL

/obj/item/restraints/handcuffs/tape
	name = "tapecuffs"
	desc = "Seems you are in a sticky situation."
	breakouttime = 20 SECONDS
	trashtype = /obj/item/restraints/handcuffs/tape/used
	flags_1 = NONE

/obj/item/restraints/handcuffs/tape/used
	item_flags = DROPDEL

/obj/item/restraints/handcuffs/tape/used/dropped(mob/user)
	playsound(loc, 'sound/items/poster_ripped.ogg', 30, TRUE, -2)
	user.visible_message("<span class='danger'>[user] rips off the tape around [user.p_their()] hands!</span>", \
							"<span class='userdanger'>You tear off the [src] and free yourself!</span>")
	. = ..()
