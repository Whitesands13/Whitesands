/obj/item/melee/weebstick
	name = "Weeb Stick"
	desc = "Glorious nippon steel, folded 1000 times."
	icon = 'whitesands/icons/obj/items_and_weapons.dmi'
	icon_state = "weeb_blade"
	item_state = "weeb_blade"
	lefthand_file = 'whitesands/icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'whitesands/icons/mob/inhands/weapons/swords_righthand.dmi'
	flags_1 = CONDUCT_1
	obj_flags = UNIQUE_RENAME
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	sharpness = IS_SHARP
	force = 25
	throw_speed = 4
	throw_range = 5
	throwforce = 12
	block_chance = 40
	armour_penetration = 50
	hitsound = 'whitesands/sound/weapons/anime_slash.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "diced", "cut")

/obj/item/melee/weebstick/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 25, 90, 5) //Not made for scalping victims, but will work nonetheless

/obj/item/melee/weebstick/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(attack_type == PROJECTILE_ATTACK)
		final_block_chance = block_chance / 2 //Pretty good...
	return ..()

/obj/item/melee/weebstick/on_exit_storage(datum/component/storage/concrete/S)
	var/obj/item/storage/belt/weebstick/B = S.real_location()
	if(istype(B))
		playsound(B, 'sound/items/unsheath.ogg', 25, TRUE)

/obj/item/melee/weebstick/on_enter_storage(datum/component/storage/concrete/S)
	var/obj/item/storage/belt/weebstick/B = S.real_location()
	if(istype(B))
		playsound(B, 'sound/items/sheath.ogg', 25, TRUE)

/obj/item/melee/weebstick/suicide_act(mob/user)
	if(prob(50))
		user.visible_message("<span class='suicide'>[user] carves deep into [user.p_their()] torso! It looks like [user.p_theyre()] trying to commit seppuku...</span>")
	else
		user.visible_message("<span class='suicide'>[user] carves a grid into [user.p_their()] chest! It looks like [user.p_theyre()] trying to commit sudoku...</span>")
	return (BRUTELOSS)

/obj/item/storage/belt/weebstick
	name = "nanoforged blade sheath"
	desc = "It yearns to bath in the blood of your enemies... but you hold it back!"
	icon = 'whitesands/icons/obj/items_and_weapons.dmi'
	icon_state = "weeb_sheath"
	item_state = "sheath"
	w_class = WEIGHT_CLASS_BULKY
	force = 5
	var/primed = FALSE //Prerequisite to anime bullshit

/obj/item/storage/belt/weebstick/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
	STR.rustle_sound = FALSE
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.set_holdable(list(
		/obj/item/melee/weebstick
		))

/obj/item/storage/belt/weebstick/examine(mob/user)
	. = ..()
	if(length(contents))
		. += "<span class='notice'>Alt-click it to quickly draw the blade.</span>"
		. += "<span class='notice'>Use [src] in-hand to prime for an opening strike."

/obj/item/storage/belt/weebstick/AltClick(mob/user)
	if(!iscarbon(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)) || primed)
		return
	if(length(contents))
		var/obj/item/I = contents[1]
		playsound(user, 'whitesands/sound/weapons/unsheathed_blade.ogg', 30, TRUE)
		user.visible_message("<span class='notice'>[user] swiftly draws \the [I].</span>", "<span class='notice'>You draw \the [I].</span>")
		user.put_in_hands(I)
		update_icon()
	else
		to_chat(user, "<span class='warning'>[src] is empty!</span>")

/obj/item/storage/belt/weebstick/attack_self(mob/user)
	if(!iscarbon(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	if(length(contents))
		var/datum/component/storage/CP = GetComponent(/datum/component/storage)
		if(primed)
			CP.locked = FALSE
			playsound(user, 'sound/items/sheath.ogg', 25, TRUE)
			to_chat(user, "<span class='notice'>You return your stance.</span>")
			primed = FALSE
			update_icon()
		else
			CP.locked = TRUE //Prevents normal removal of the blade while primed
			playsound(user, 'sound/items/unsheath.ogg', 25, TRUE)
			user.visible_message("<span class='warning'>[user] grips the blade within [src] and primes to attack.</span>", "<span class='warning'>You take an opening stance...</span>", "<span class='warning'>You hear a weapon being drawn...</span>")
			primed = TRUE
			update_icon()
	else
		to_chat(user, "<span class='warning'>[src] is empty!</span>")

/obj/item/storage/belt/weebstick/attack(mob/living/M, mob/living/user)
	. = ..()
	if(!.)
		return .
	if(primed && length(contents))
		var/obj/item/I = contents[1]
		if(!user.put_in_inactive_hand(I))
			to_chat(user, "<span class='warning'>You need a free hand!</span>")
			return
		force = primed_attack(user, I)
		user.swap_hand()
	else
		sharpness = IS_BLUNT
		force = 5

/obj/item/storage/belt/weebstick/proc/primed_attack(mob/living/user, obj/item/I)
	var/datum/component/storage/CP = GetComponent(/datum/component/storage)
	CP.locked = FALSE
	primed = FALSE
	user.spin(4, 1)
	playsound(user, 'whitesands/sound/weapons/unsheathed_blade.ogg', 80)
	user.visible_message("<span class='danger'>[user] swiftly strikes with [I] from the draw!</span>", "<span class='warning'>You stirke with [I] in an opening attack.</span>")
	update_icon()
	sharpness = IS_SHARP
	return I.force * 2

/obj/item/storage/belt/weebstick/update_icon_state()
	icon_state = "weeb_sheath"
	item_state = "sheath"
	if(contents.len)
		if(primed)
			icon_state += "-primed"
		else
			icon_state += "-blade"
		item_state += "-sabre"

/obj/item/storage/belt/weebstick/PopulateContents()
	//Time to generate names now that we have the sword
	var/title = pick(GLOB.ninja_titles)
	var/name = pick(GLOB.ninja_names)
	var/obj/item/melee/weebstick/sword = new /obj/item/melee/weebstick(src)
	sword.name = "[title] blade of clan [name]"
	update_icon()
