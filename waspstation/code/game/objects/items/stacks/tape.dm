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

	var/prefix = "sticky"
	var/tapesound = 'waspstation/sound/items/tape.ogg'
	var/list/conferred_embed = EMBED_HARMLESS
	var/overwrite_existing = FALSE

/obj/item/stack/tape/attack(mob/living/carbon/C, mob/living/user)
	if(!istype(C))
		return

	//Relatable suffering
	if(iscarbon(user) && (HAS_TRAIT(user, TRAIT_CLUMSY) && prob(25)))
		to_chat(user, "<span class='warning'>Uh... where did the tape edge go?!</span>")
		return

	//Tape that filthy mouth shut
	if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		if(C.is_mouth_covered() || C.is_muzzled())
			to_chat(user, "<span class='warning'>There is something covering [C]s mouth!</span>")
			return
		if(use(1))
			playsound(loc, tapesound, 30, TRUE, -2)
			if(do_mob(user, C, 10) && (!C.is_mouth_covered() || !C.is_muzzled()))
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
				if(do_mob(user, C, 45) && (C.get_num_arms(FALSE) >= 2 || C.get_arm_ignore()))
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

/obj/item/clothing/mask/muzzle/tape/equipped(mob/M, slot)
	. = ..()
	user.visible_message("<span class='danger'>[M] rips the tape off [M.p_their()] face!</span>", \
							"<span class='userdanger'>You tear the [src] off your mouth!</span>")
	user.dropItemToGround(src, 1, 1)

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
