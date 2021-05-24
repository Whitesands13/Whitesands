#define MAX_DERRINGER_DISPLAY_BULLETS 5

/obj/item/storage/fancy/cigarettes/cigars/derringer
	name = "\improper Robusto cigar case"
	desc = "Smoked by the robust."
	icon_state = "derringer"
	spawn_type = /obj/item/gun/ballistic/derringer/traitor
	othertype = TRUE

/obj/item/storage/fancy/cigarettes/cigars/derringer/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 7
	STR.set_holdable(list(/obj/item/clothing/mask/cigarette/cigar, /obj/item/lighter, /obj/item/gun/ballistic/derringer, /obj/item/ammo_casing/a357))

/obj/item/storage/fancy/cigarettes/cigars/derringer/AltClick(mob/living/carbon/user)
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	var/obj/item/W = (locate(/obj/item/ammo_casing/a357) in contents) || (locate(/obj/item/clothing/mask/cigarette) in contents) //Easy access smokes and bullets
	if(W && contents.len > 0)
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE, W, user)
		user.put_in_hands(W)
		contents -= W
		to_chat(user, "<span class='notice'>You take \a [W] out of the pack.</span>")
	else
		to_chat(user, "<span class='notice'>There are no items left in the pack.</span>")

/obj/item/storage/fancy/cigarettes/cigars/derringer/update_overlays()
	. = ..()
	if(fancy_open && contents.len)
		var/bullet_position = 1
		for(var/C in contents)
			var/mutable_appearance/inserted_overlay = mutable_appearance('whitesands/icons/obj/cigarettes.dmi')

			if(istype(C, /obj/item/ammo_casing/a357))
				if(bullet_position <= MAX_DERRINGER_DISPLAY_BULLETS)
					inserted_overlay.icon_state = "overlay_bullet"
					inserted_overlay.icon_state = "[inserted_overlay.icon_state]_[bullet_position]"
					. += inserted_overlay
				bullet_position++

			if(istype(C, /obj/item/clothing/mask/cigarette/cigar))
				if(istype(C, /obj/item/clothing/mask/cigarette/cigar/robusto))
					inserted_overlay.icon_state = "overlay_cigar_robusto"
				else if(istype(C, /obj/item/clothing/mask/cigarette/cigar/gold))
					inserted_overlay.icon_state = "overlay_cigar_gold"
				else
					inserted_overlay.icon_state = "overlay_cigar"
				. += inserted_overlay

			if(istype(C, /obj/item/gun/ballistic/derringer))
				if(istype(C, /obj/item/gun/ballistic/derringer/traitor))
					inserted_overlay.icon_state = "syndi_gun"
				else if(istype(C, /obj/item/gun/ballistic/derringer/gold))
					inserted_overlay.icon_state = "gold_gun"
				else
					inserted_overlay.icon_state = "normal_gun"
				. += inserted_overlay

/obj/item/storage/fancy/cigarettes/cigars/derringer/PopulateContents()
	new spawn_type(src)
	new /obj/item/ammo_casing/a357(src)
	new /obj/item/ammo_casing/a357(src)
	new /obj/item/ammo_casing/a357(src)
	new /obj/item/ammo_casing/a357(src)
	new /obj/item/ammo_casing/a357(src)
	new /obj/item/clothing/mask/cigarette/cigar/robusto(src)

//For traitors with luck/class
/obj/item/storage/fancy/cigarettes/cigars/derringer/gold
	name = "\improper Robusto Gold cigar case"
	desc = "Smoked by the truly robust."
	icon_state = "derringer_gold"
	spawn_type = /obj/item/gun/ballistic/derringer/gold

/obj/item/storage/fancy/cigarettes/cigars/derringer/gold/PopulateContents()
	new spawn_type(src)
	new /obj/item/ammo_casing/a357(src)
	new /obj/item/ammo_casing/a357(src)
	new /obj/item/ammo_casing/a357(src)
	new /obj/item/ammo_casing/a357(src)
	new /obj/item/ammo_casing/a357(src)
	new /obj/item/clothing/mask/cigarette/cigar/gold(src)

#undef MAX_DERRINGER_DISPLAY_BULLETS
