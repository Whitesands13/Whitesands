// / / / / / / / / / / / / / / / //
/// // WHITESANDS SMOKEABLES // ///
// / / / / / / / / / / / / / / / //

#define CIGARETTE	3.6
#define CIGAR	6
#define SMOKEMINUTE SECONDS*6

//Cigarettes - PACKETS

/obj/item/storage/fancy/cigarettes
	name = "Nanotransen packet"
	desc = "A standard packet of six Nanotransen approved coping sticks.  A label on the packaging reads, \"A loyalists best friend! Now 46% more cancer free!\""
	icon = 'whitesands/icons/obj/boxes.dmi'
	icon_state = "nt"
	icon_type = "cigarette"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	slot_flags = ITEM_SLOT_BELT
	spawn_type = /obj/item/clothing/mask/cigarette/nanotransen
	custom_price = 75
	age_restricted = TRUE

/obj/item/storage/fancy/cigarettes/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.set_holdable(list(/obj/item/clothing/mask/cigarette, /obj/item/lighter))

/obj/item/storage/fancy/cigarettes/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click to extract contents.</span>"

/obj/item/storage/fancy/cigarettes/AltClick(mob/living/carbon/user)
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	var/obj/item/clothing/mask/cigarette/W = locate(/obj/item/clothing/mask/cigarette) in contents
	if(W && contents.len > 0)
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE, W, user)
		user.put_in_hands(W)
		contents -= W
		to_chat(user, "<span class='notice'>You take \a [W] out of the pack.</span>")
	else
		to_chat(user, "<span class='notice'>There are no [icon_type]s left in the pack.</span>")

/obj/item/storage/fancy/cigarettes/update_icon_state()
	if(fancy_open || !contents.len)
		if(!contents.len)
			icon_state = "[initial(icon_state)]_empty"
		else
			icon_state = initial(icon_state)

/obj/item/storage/fancy/cigarettes/update_overlays()
	. = ..()
	var/obj/item/clothing/mask/cigarette/A = locate(/obj/item/clothing/mask/cigarette) in contents
	if(fancy_open && contents.len)
		. += "[icon_state]_open"
		var/cig_position = 1
		for(var/C in contents)
			var/mutable_appearance/inserted_overlay = mutable_appearance('whitesands/icons/obj/cigarettes.dmi')

			if(istype(C, /obj/item/lighter/greyscale) || istype(C, /obj/item/lighter))
				inserted_overlay.icon_state = "overlay_other"
			if(istype(C, /obj/item/reagent_containers/food/snacks/donkpocket))
				inserted_overlay.icon_state = "overlay_pocket"
			else
				inserted_overlay.icon_state = "overlay_[A.smoke_type]"

			inserted_overlay.icon_state = "[inserted_overlay.icon_state]_[cig_position]"
			. += inserted_overlay
			cig_position++

/obj/item/storage/fancy/cigarettes/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!ismob(M))
		return
	var/obj/item/clothing/mask/cigarette/cig = locate(/obj/item/clothing/mask/cigarette) in contents
	if(cig)
		if(M == user && contents.len > 0 && !user.wear_mask)
			var/obj/item/clothing/mask/cigarette/W = cig
			SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE, W, M)
			M.equip_to_slot_if_possible(W, ITEM_SLOT_MASK)
			contents -= W
			to_chat(user, "<span class='notice'>You take \a [W] out of the pack.</span>")
		else
			..()
	else
		to_chat(user, "<span class='notice'>There are no [icon_type]s left in the pack.</span>")

//brands

/obj/item/storage/fancy/cigarettes/cigpack_syndicate
	name = "Syndicate packet"
	desc = "A badass packet of operative healing smokes. A label on the packaging reads, \"You goddamn know who to smoke.\""
	icon_state = "syndi"
	spawn_type = /obj/item/clothing/mask/cigarette/syndicate

/obj/item/storage/fancy/cigarettes/cigpack_donkco
	name = "Donk-Co packet"
	desc = "A well packaged fancy box containing the favourite smokes/snack of every hard working spacefarer. A label on the packaging reads, \"Buy now and have a chance to find one free donk pocket duty-free! (Refund not included).\""
	icon_state = "donk"
	spawn_type = /obj/item/clothing/mask/cigarette/donkco

/obj/item/storage/fancy/cigarettes/cigpack_donkco/Initialize()
	. = ..()
	if(prob(7))
		qdel(src)
		new /obj/item/storage/fancy/cigarettes/cigpack_donkco/pocket(src)

/obj/item/storage/fancy/cigarettes/cigpack_donkco/pocket
	spawn_type = /obj/item/reagent_containers/food/snacks/donkpocket/warm

/obj/item/storage/fancy/cigarettes/cigpack_donkco/pocket/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
	STR.set_holdable(list(/obj/item/clothing/mask/cigarette, /obj/item/lighter, /obj/item/reagent_containers/food/snacks/donkpocket))

/obj/item/storage/fancy/cigarettes/cigpack_waffleco
	name = "Waffle-Co packet"
	desc = "An irresistable pack of mouth-watering nicotine infusing heavenly sweet goodness."
	icon_state = "waffle"
	spawn_type = /obj/item/clothing/mask/cigarette/waffleco

/obj/item/storage/fancy/cigarettes/cigpack_solgov
	name = "SolGov packet"
	desc = "A 6 pack of invigorating duty-free SolGov cigarettes. A label on the packaging reads, \"Move Today! Contact your nearest representative to find out more!\""
	icon_state = "solgov"
	spawn_type = /obj/item/clothing/mask/cigarette/solgov

/obj/item/storage/fancy/cigarettes/cigpack_superfresh
	name = "Superfresh packet"
	desc = "The label on the packaging is composed of gibberish and covered in an yellow insulative rubber, one word stands clear to you: \"Superfresh\"."
	icon_state = "solgov"
	spawn_type = /obj/item/clothing/mask/cigarette/superfresh

/obj/item/storage/fancy/cigarettes/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.set_holdable(list(/obj/item/clothing/mask/cigarette, /obj/item/lighter))

/obj/item/storage/fancy/cigarettes/cigpack_xeno
	name = "Xeno Filtered packet"
	desc = "Loaded with 100% pure slime. And also nicotine."
	icon_state = "slime"
	spawn_type = /obj/item/clothing/mask/cigarette/xeno

//Rollies - PACKETS

/obj/item/storage/fancy/cigarettes/cigpack_turbo
	name = "Turbo packet"
	desc = "A 6-pack of turbo brand rollies, guaranteed to make you trip shit like no tommorrow."
	icon_state = "turbo"
	spawn_type = /obj/item/clothing/mask/cigarette/rollie/turbo

//Cigars - PACKETS

/obj/item/storage/fancy/cigarettes/cigars
	name = "premium cigar case"
	desc = "A case of premium cigars. Very expensive."
	icon_state = "cigar"
	w_class = WEIGHT_CLASS_NORMAL
	icon_type = "cigar"
	spawn_type = /obj/item/clothing/mask/cigarette/cigar

/obj/item/storage/fancy/cigarettes/cigars/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 4
	STR.set_holdable(list(/obj/item/clothing/mask/cigarette/cigar))

/obj/item/storage/fancy/cigarettes/cigars/update_icon_state()
	if(fancy_open)
		icon_state = "[initial(icon_state)]_open"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/storage/fancy/cigarettes/cigars/robusto
	name = "robusto cigar case"
	desc = "A case of premium robusto cigars. Smoked by the truly robust."
	spawn_type = /obj/item/clothing/mask/cigarette/cigar/robusto

/obj/item/storage/fancy/cigarettes/cigars/gold
	name = "robusto gold cigar case"
	icon_state = "gold"
	desc = "A case of the elitist cigars in the known universe."
	spawn_type = /obj/item/clothing/mask/cigarette/cigar/gold

/obj/item/storage/fancy/cigarettes/cigars/havana
	name = "cocubana havana cigar case"
	icon_state = "gold"
	desc = "The finest empire building, crack smoking cigars. Honchos Only."
	spawn_type = /obj/item/clothing/mask/cigarette/cigar/havana

//Cigarettes - ITEMS

/obj/item/clothing/mask/cigarette
	name = "cigarette"
	desc = "A roll of tobacco and nicotine."
	icon = 'whitesands/icons/obj/cigarettes.dmi'
	mob_overlay_icon = 'whitesands/icons/mob/clothing/cigarettes.dmi'
	mob_overlay_state = "standard"
	lefthand_file = 'whitesands/icons/mob/inhands/equipment/cigarettes_lefthand.dmi'
	righthand_file = 'whitesands/icons/mob/inhands/equipment/cigarettes_righthand.dmi'
	icon_state = "standard"
	item_state = "standard"
	throw_speed = 0.5
	w_class = WEIGHT_CLASS_TINY
	body_parts_covered = null
	grind_results = list()
	heat = 1000
	var/dragtime = 100
	var/nextdragtime = 0
	var/smoke_all = FALSE
	var/lit = FALSE
	var/starts_lit = FALSE
	var/type_butt = /obj/item/cigbutt
	var/lastHolder = null
	var/smoketime = 6 SMOKEMINUTE
	var/chem_volume = 30
	var/list_reagents = list(/datum/reagent/drug/nicotine = 15)
	var/lung_harm = 0
	var/chain_smoking_damage = 0.01
	var/lit_type = "cigarette" //USE FOR LIT OVERLAYS
	var/smoke_type = null // USE THIS FOR OVERLAYS, IN PACKET, SHORTENING, AND CUSTOM UNIVERSAL CIGBUTT

/obj/item/clothing/mask/cigarette/test/damage
	chain_smoking_damage = 0.1

/obj/item/clothing/mask/cigarette/nanotransen
	desc = "A nanotransen generic branded cigarette."
	icon_state = "standard"
	list_reagents = list(/datum/reagent/drug/nicotine = 15)
	smoke_type = "standard"

/obj/item/clothing/mask/cigarette/syndicate
	desc = "A suspicious looking, unbranded cigarette."
	icon_state = "syndicate"
	list_reagents = list(/datum/reagent/drug/nicotine = 10, /datum/reagent/medicine/omnizine = 15)
	smoke_all = TRUE
	smoke_type = "syndicate"

/obj/item/clothing/mask/cigarette/donkco
	desc = "A donk-co branded cigarette, hunger for those without time or hands."
	icon_state = "donk"
	list_reagents = list(/datum/reagent/drug/nicotine = 10, /datum/reagent/consumable/nutriment/stabilized = 5, /datum/reagent/medicine/omnizine = 2)
	smoke_type = "donk"

/obj/item/clothing/mask/cigarette/waffleco
	desc = "A waffle-co branded cigarette, it smells amazing."
	icon_state = "waffle"
	list_reagents = list(/datum/reagent/drug/nicotine = 10, /datum/reagent/consumable/corn_syrup = 14, /datum/reagent/consumable/honey = 1)
	smoke_type = "waffle"

/obj/item/clothing/mask/cigarette/waffleco/Initialize()
    . = ..()
    if(!prob(25))
        return
    reagents?.add_reagent(/datum/reagent/consumable/secretsauce = 5)

/obj/item/clothing/mask/cigarette/solgov
	desc = "A duty-free solgov cigarette, refreshing."
	icon_state = "solgov"
	list_reagents = list(/datum/reagent/drug/nicotine = 10, /datum/reagent/consumable/tonic = 10) //straight from sol itself!
	smoke_type = "solgov"

/obj/item/clothing/mask/cigarette/superfresh
	desc = "A mysterious maintenance cigarette, legends say only true greytiders know whats within."
	icon_state = "superfresh"
	smoke_type = "superfresh"

/obj/item/clothing/mask/cigarette/superfresh/Initialize()
	. = ..()
	list_reagents = list(/datum/reagent/drug/nicotine = 10, get_random_reagent_id() = rand(5,20))
	grind_results = list_reagents

/obj/item/clothing/mask/cigarette/xeno
	desc = "A Xeno Filtered brand cigarette."
	icon_state = "slime"
	list_reagents = list (/datum/reagent/drug/nicotine = 20, /datum/reagent/medicine/regen_jelly = 15, /datum/reagent/drug/krokodil = 4)
	smoke_all = TRUE
	smoke_type = "slime"

//Rollies - ITEMS

/obj/item/clothing/mask/cigarette/rollie
	name = "rollie"
	desc = "A roll of dried plant matter wrapped in thin paper."
	icon_state = "boof"
	smoke_type = "boof"
	chem_volume = 50
	lit_type = "joint"
	list_reagents = list(/datum/reagent/drug/space_drugs = 35)

/obj/item/clothing/mask/cigarette/rollie/Initialize()
	. = ..()
	pixel_x = rand(-3, 3)
	pixel_y = rand(-3, 3)

/obj/item/clothing/mask/cigarette/rollie/custom
	chain_smoking_damage = 0
	smoketime = 4 SMOKEMINUTE

/obj/item/clothing/mask/cigarette/rollie/turbo
	desc = "A turbo branded rollie, for the good times."
	list_reagents = list(/datum/reagent/drug/nicotine = 15, /datum/reagent/drug/space_drugs = 10, /datum/reagent/drug/happiness = 10)

/obj/item/clothing/mask/cigarette/rollie/trippy
	list_reagents = list(/datum/reagent/drug/nicotine = 15, /datum/reagent/drug/mushroomhallucinogen = 35)
	starts_lit = TRUE

/obj/item/clothing/mask/cigarette/rollie/cannabis
	list_reagents = list(/datum/reagent/drug/space_drugs = 15, /datum/reagent/toxin/lipolicide = 35)

//Cigars - ITEMS

/obj/item/clothing/mask/cigarette/cigar
	name = "premium cigar"
	desc = "A brown roll of tobacco and... well, you're not quite sure. This thing's huge!"
	icon_state = "cigar"
	smoketime = 10 SMOKEMINUTE
	chem_volume = 40
	list_reagents = list(/datum/reagent/drug/nicotine = 35)
	lit_type = "cigar"
	smoke_type = "cigar"

/obj/item/clothing/mask/cigarette/cigar/robusto
	name = "robusto cigar"
	desc = "A hefty wad of nicotine and robusting goodness."
	icon_state = "robusto"
	smoketime = 20 SMOKEMINUTE
	chem_volume = 60
	list_reagents = list(/datum/reagent/drug/nicotine = 30, /datum/reagent/consumable/grey_bull = 10)
	smoke_type = "robusto"

/obj/item/clothing/mask/cigarette/cigar/gold
	name = "robusto gold cigar"
	desc = "The Elite Cigar, for the truly robust."
	icon_state = "gold"
	smoketime = 30 SMOKEMINUTE
	chem_volume = 80
	chain_smoking_damage = 0.005 //15 minutes of smoke damage
	list_reagents = list(/datum/reagent/drug/nicotine = 60, /datum/reagent/gold = 10)
	smoke_type = "gold"

/obj/item/clothing/mask/cigarette/cigar/havana
	name = "premium Havanian cigar"
	desc = "A cigar fit for only the best of the best."
	icon_state = "gold"
	smoketime = 30 SMOKEMINUTE
	chain_smoking_damage = 0 //badass antag only cigar, no cancer
	list_reagents = list(/datum/reagent/drug/nicotine = 35)
	smoke_type = "gold"

/obj/item/clothing/mask/cigarette/cigar/cohiba
	name = "robusto Cohiba cigar"
	desc = "A cigar fit for only the robustest of the robust."
	icon_state = "robusto"
	smoketime = 30 SMOKEMINUTE
	list_reagents = list(/datum/reagent/drug/nicotine = 30, /datum/reagent/consumable/grey_bull = 10)
	smoke_type = "robusto"

//Vapes - ITEMS

/obj/item/clothing/mask/vape/cigar
    name = "\improper E-Cigar"
    desc = "The latest recreational device developed by a small tech startup, Shadow Tech, the E-Cigar has all the uses of a normal E-Cigarette, with the classiness of short fat cigar. Must be lit via interfacing with a PDA."
    icon_state = "ecigar_vapeoff"
    item_state = "ecigar_vapeoff"
    vapecolor = "ecigar"
    overlayname = "ecigar"
    chem_volume = 150
    custom_premium_price = 300

//Cigbutt - ITEM

/obj/item/cigbutt
	name = "cigarette butt"
	desc = "A manky old cigarette butt."
	icon = 'whitesands/icons/obj/cigarettes.dmi'
	icon_state = "butt"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	grind_results = list(/datum/reagent/carbon = 2)

/obj/item/cigbutt/Initialize()
	. = ..()
	if(prob(7))
		qdel(src)
		new /obj/item/cigbutt/cigar(src)

/obj/item/cigbutt/cigar
	name = "cigar butt"
	desc = "A manky old cigar butt."
	icon_state = "butt_alt"
	grind_results = list(/datum/reagent/carbon = 10)

//Cigarettes - CODE

/obj/item/clothing/mask/cigarette/proc/light() //removes lit and unlit states
	if(lit)
		return
	if(!(flags_1 & INITIALIZED_1))
		return

	item_state = "[item_state]_lit"
	mob_overlay_state = "[mob_overlay_state]_lit"
	lit = TRUE
	name = "lit [name]"
	attack_verb = list("burnt", "singed")
	hitsound = 'sound/items/welder.ogg'
	damtype = "fire"
	force = 4
	if(reagents.get_reagent_amount(/datum/reagent/toxin/plasma))
		var/datum/effect_system/reagents_explosion/e = new()
		e.set_up(round(reagents.get_reagent_amount(/datum/reagent/toxin/plasma) / 2.5, 1), get_turf(src), 0, 0)
		e.start()
		qdel(src)
		return
	if(reagents.get_reagent_amount(/datum/reagent/fuel))
		var/datum/effect_system/reagents_explosion/e = new()
		e.set_up(round(reagents.get_reagent_amount(/datum/reagent/fuel) / 5, 1), get_turf(src), 0, 0)
		e.start()
		qdel(src)
		return
	// allowing reagents to react after being lit
	reagents.flags &= ~(NO_REACT)
	reagents.handle_reactions()
	START_PROCESSING(SSobj, src)
	update_overlays()

	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_wear_mask()
		M.update_inv_hands()

	playsound(src, 'sound/items/cig_light.ogg', 25, 1)

/obj/item/clothing/mask/cigarette/extinguish() //removes lit and unlit states
	if(!lit)
		return
	name = copytext_char(name, 5)
	attack_verb = null
	hitsound = null
	damtype = BRUTE
	force = 0
	STOP_PROCESSING(SSobj, src)
	reagents.flags |= NO_REACT
	lit = FALSE
	item_state = "[item_state]_extinguished"
	mob_overlay_state = "[mob_overlay_state]_extinguished"
	if(ismob(loc))
		var/mob/living/M = loc
		to_chat(M, "<span class='notice'>Your [name] goes out.</span>")
		M.update_inv_wear_mask()
		M.update_inv_hands()
	update_overlays()

/obj/item/clothing/mask/cigarette/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is huffing [src] as quickly as [user.p_they()] can! It looks like [user.p_theyre()] trying to give [user.p_them()]self cancer.</span>")
	return (TOXLOSS|OXYLOSS)

/obj/item/clothing/mask/cigarette/Initialize()
	. = ..()
	mob_overlay_state = lit_type
	item_state = lit_type
	create_reagents(chem_volume, INJECTABLE | NO_REACT)
	if(list_reagents)
		reagents.add_reagent_list(list_reagents)
	if(starts_lit)
		light()
	AddComponent(/datum/component/knockoff,90,list(BODY_ZONE_PRECISE_MOUTH),list(ITEM_SLOT_MASK))//90% to knock off when wearing a mask

/obj/item/clothing/mask/cigarette/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/clothing/mask/cigarette/attackby(obj/item/W, mob/user, params)
	if(!lit && smoketime > 0)
		var/lighting_text = W.ignition_effect(src, user)
		if(lighting_text)
			light(lighting_text)
	else
		return ..()

/obj/item/clothing/mask/cigarette/afterattack(obj/item/reagent_containers/glass/glass, mob/user, proximity)
	. = ..()
	if(!proximity || lit) //can't dip if cigarette is lit (it will heat the reagents in the glass instead)
		return
	if(istype(glass))	//you can dip cigarettes into beakers
		if(glass.reagents.trans_to(src, chem_volume, transfered_by = user))	//if reagents were transfered, show the message
			to_chat(user, "<span class='notice'>You dip \the [src] into \the [glass].</span>")
		else			//if not, either the beaker was empty, or the cigarette was full
			if(!glass.reagents.total_volume)
				to_chat(user, "<span class='warning'>[glass] is empty!</span>")
			else
				to_chat(user, "<span class='warning'>[src] is full!</span>")

/obj/item/clothing/mask/cigarette/process()
	var/mob/living/M = loc
	if(isliving(loc))
		M.IgniteMob()
	smoketime--
	if(smoketime < 1)
		var/obj/butt
		butt = new type_butt(get_turf(src))
		butt.pixel_x = rand(-10, 2)
		butt.pixel_y = rand(-10, 2)
		butt.icon_state = "[smoke_type]_4"
		butt.add_overlay(image(icon, icon_state = "[lit_type]_extinguished", pixel_x = 6, pixel_y = 6))
		butt.name = "[lit_type] butt"
		if(ismob(loc))
			to_chat(M, "<span class='notice'>Your [name] goes out.</span>")
			playsound(src, 'sound/items/cig_snuff.ogg', 25, 1)
		qdel(src)
		return
	open_flame()
	shmoke()
	switch(smoketime)
		if(288)
			icon_state = "[smoke_type]_1"
			update_overlays()
		if(215)
			icon_state = "[smoke_type]_2"
			update_overlays()
		if(143)
			icon_state = "[smoke_type]_3"
			update_overlays()
		if(71)
			icon_state = "[smoke_type]_4"
			update_overlays()
	if((reagents && reagents.total_volume) && (nextdragtime <= world.time))
		nextdragtime = world.time + dragtime
		handle_reagents()

/obj/item/clothing/mask/cigarette/proc/handle_reagents()
	if(reagents.total_volume)
		var/to_smoke = REAGENTS_METABOLISM
		if(iscarbon(loc))
			var/mob/living/carbon/C = loc
			if (src == C.wear_mask) // if it's in the human/monkey mouth, transfer reagents to the mob
				var/fraction = min(REAGENTS_METABOLISM/reagents.total_volume, 1)
				/*
				 * Given the amount of time the cig will last, and how often we take a hit, find the number
				 * of chems to give them each time so they'll have smoked it all by the end.
				 */
				if (smoke_all)
					to_smoke = reagents.total_volume/((smoketime * 2) / (dragtime / 10))

				reagents.expose(C, INGEST, fraction)
				var/obj/item/organ/lungs/L = C.getorganslot(ORGAN_SLOT_LUNGS)
				if(L && !(L.organ_flags & ORGAN_SYNTHETIC))
					C.adjustOrganLoss(ORGAN_SLOT_LUNGS, lung_harm)
				if(!reagents.trans_to(C, to_smoke))
					reagents.remove_any(to_smoke)
				return
		reagents.remove_any(to_smoke)

/obj/item/clothing/mask/cigarette/attack_self(mob/user)
	if(lit)
		user.visible_message("<span class='notice'>[user] calmly drops and treads on \the [src], putting it out instantly.</span>")
		playsound(src, 'sound/items/cig_snuff.ogg', 25, 1)
		var/obj/butt
		butt = new type_butt(get_turf(src))
		butt.pixel_x = rand(-10, 2)
		butt.pixel_y = rand(-10, 2)
		butt.icon_state = "[smoke_type]_4"
		butt.add_overlay(image(icon, icon_state = "[lit_type]_extinguished", pixel_x = 6, pixel_y = 6))
		butt.name = "[lit_type] butt"
		new /obj/effect/decal/cleanable/ash(user.loc)
		qdel(src)
	. = ..()

/obj/item/clothing/mask/cigarette/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!istype(M))
		return ..()
	if(M.on_fire && !lit)
		light("<span class='notice'>[user] lights [src] with [M]'s burning body. What a cold-blooded badass.</span>")
		return
	var/obj/item/clothing/mask/cigarette/cig = help_light_cig(M)
	if(lit && cig && user.a_intent == INTENT_HELP)
		if(cig.lit)
			to_chat(user, "<span class='warning'>The [cig.name] is already lit!</span>")
		if(M == user)
			cig.attackby(src, user)
		else
			cig.light("<span class='notice'>[user] holds the [name] out for [M], and lights [M.p_their()] [cig.name].</span>")
	else
		return ..()

/obj/item/clothing/mask/cigarette/fire_act(exposed_temperature, exposed_volume)
	light()

/obj/item/clothing/mask/cigarette/get_temperature()
	return lit * heat

/obj/item/clothing/mask/cigarette/update_overlays()
	var/lit_or_extinguished
	if(lit)
		lit_or_extinguished = "lit"
	if(!lit)
		lit_or_extinguished = "extinguished"
	if(lit || !lit)
		var/mutable_appearance/LT = mutable_appearance(icon_state = "[lit_type]_[lit_or_extinguished]")
		switch(smoketime)
			if(360 to 1800)
				add_overlay(LT)
			if(288)
				cut_overlays()
				LT.pixel_x = 2
				LT.pixel_y = 2
				add_overlay(LT)
			if(215)
				cut_overlays()
				LT.pixel_x = 4
				LT.pixel_y = 4
				add_overlay(LT)
			if(143)
				cut_overlays()
				LT.pixel_x = 5
				LT.pixel_y = 5
				add_overlay(LT)
			if(71)
				cut_overlays()
				LT.pixel_x = 6
				LT.pixel_y = 6
				add_overlay(LT)
	. = ..()

/obj/item/clothing/mask/cigarette/proc/shmoke()
	if(iscarbon(loc))
		var/mob/living/carbon/C = loc
		var/obj/item/organ/lungs/L = C.getorganslot(ORGAN_SLOT_LUNGS)
		if(src == C.wear_mask)
			if(L && !(L.organ_flags & ORGAN_SYNTHETIC) && L.chain_smokah < 100)
				L.chain_smokah += chain_smoking_damage
		else if(!(src == C.wear_mask) && (L.chain_smokah) >= (7.2)) //no cigarette in mouth, has smoked at least 2 cigarette
			L.chain_smokah -= 0.6 //dissipates 1 cigarette smoked a minute

/obj/item/organ/lungs
	var/chain_smokah = 0

/obj/item/organ/lungs/on_life()
	. = ..()
	switch(chain_smokah)
		if(10.8 to 14.3) //3 cigarettes
			owner.adjustOrganLoss(ORGAN_SLOT_LUNGS, 0.01)
			if(prob(1))
				to_chat(owner, "<span class='danger'>[pick("You're having difficulty breathing.", "Your breathing becomes heavy.")]</span>")
			if(prob(5))
				owner.emote(pick("cough","yawn"))
		if(14.4 to 17.9) //4 cigarettes
			owner.adjustOrganLoss(ORGAN_SLOT_LUNGS, 0.02)
			if(prob(1))
				to_chat(owner, "<span class='danger'>[pick("You're having difficulty breathing.", "Your breathing becomes heavy.")]</span>")
			if(prob(5))
				owner.emote(pick("cough","yawn","twitch_s"))
			if(prob(1))
				owner.Jitter(8)
		if(18 to 21.5) //5 cigarettes
			owner.adjustOrganLoss(ORGAN_SLOT_LUNGS, 0.03)
			if(prob(1))
				to_chat(owner, "<span class='userdanger'>[pick("Your throat itches with dryness, it is very hard to breathe!", "Your eyes water and throat fills with smog!")]</span>")
				owner.emote("cough")
			if(prob(7))
				owner.emote(pick("cough","yawn","twitch_s","sway"))
			if(prob(2))
				owner.Jitter(8)
			if(prob(1))
				owner.blur_eyes(10)
		if(21.6 to 25.1) //6 cigarettes
			var/list/screens = list(owner.hud_used.plane_masters["[FLOOR_PLANE]"], owner.hud_used.plane_masters["[GAME_PLANE]"], owner.hud_used.plane_masters["[LIGHTING_PLANE]"])
			owner.adjustOrganLoss(ORGAN_SLOT_LUNGS, 0.04)
			if(prob(1))
				to_chat(owner, "<span class='userdanger'>[pick("Your throat itches with dryness, it is very hard to breathe!", "Your eyes water and throat fills with smog!")]</span>")
			if(prob(10))
				owner.emote(pick("cough","yawn","twitch_s","sway","gasp"))
			if(prob(5))
				owner.Jitter(8)
			if(prob(3))
				owner.blur_eyes(10)
			if(owner.hud_used)
				for(var/whole_screen in screens)
					animate(whole_screen, transform = matrix(5, MATRIX_ROTATE), time = 5, easing = QUAD_EASING, loop = -1)
					animate(transform = matrix(-5, MATRIX_ROTATE), time = 5, easing = QUAD_EASING)
		if(25.2 to 100) //7 cigarettes
			var/list/screens = list(owner.hud_used.plane_masters["[FLOOR_PLANE]"], owner.hud_used.plane_masters["[GAME_PLANE]"], owner.hud_used.plane_masters["[LIGHTING_PLANE]"])
			owner.adjustOrganLoss(ORGAN_SLOT_LUNGS, 1)
			if(prob(1))
				to_chat(owner, "<span class='userdanger'>[pick("You take a hearty gasp! Finding it near impossible to breathe!")]</span>")
				owner.emote("gasp")
			if(prob(15))
				owner.emote(pick("cough","yawn","twitch_s","sway","gasp"))
			if(prob(10))
				owner.Jitter(8)
			if(prob(10))
				owner.blur_eyes(10)
			if(prob(3))
				owner.vomit(20)
			if(owner.hud_used)
				for(var/whole_screen in screens)
					animate(whole_screen, transform = matrix(10, MATRIX_ROTATE), time = 5, easing = QUAD_EASING, loop = -1)
					animate(transform = matrix(-10, MATRIX_ROTATE), time = 5, easing = QUAD_EASING)
