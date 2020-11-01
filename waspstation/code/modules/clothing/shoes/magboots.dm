/obj/item/clothing/shoes/magboots
	icon = 'waspstation/icons/obj/clothing/shoes.dmi'
	icon_state = 'magboots0'

/obj/item/clothing/shoes/magboots/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WELDER)
		if (alert(user, "Are you sure you want to irreversibly weld the [src] to be able to fit digitigrade legs?", "Mold magboots:", "Yes", "No") != "Yes")
			return
		I.play_tool_sound(src)
		to_chat(user, "<span class='notice'>You weld the [src] into a shape able to be worn by those with digitigrade legs.</span>")
		var/obj/item/clothing/shoes/magboots/digitigrade/C = new (get_turf(src))
		user.put_in_hands(C)
		qdel(src)


/obj/item/clothing/shoes/magboots/digitigrade //Taken from https://github.com/TheSwain/Fulpstation/pull/466
	name = "digitigrade magboots"
	desc = "A pair of magboots shaped with a welder to fit a digitigrade."
	flags_inv = FULL_DIGITIGRADE
	icon_state = "magboots_digi0"
	magboot_state = "magbootsdigi"

/obj/item/clothing/shoes/magboots/digitigrade/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WELDER)
		return


/obj/item/clothing/shoes/magboots/syndie/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WELDER)
		return
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		if (flags_inv == NOT_DIGITIGRADE)
			flags_inv = FULL_DIGITIGRADE
			icon_state = "syndiemag_digi0"
			magboot_state = "syndiemagdigi"
			desc = "Reverse-engineered magnetic boots that have a heavy magnetic pull. Property of Gorlex Marauders. They are set to fit digitigrade legs."
			to_chat(user, "<span class='notice'>You set the blood-red magboots to Digitigrade mode [src].</span>")
		else
			flags_inv = NOT_DIGITIGRADE
			icon_state = "syndiemag0"
			magboot_state = "syndiemag"
			desc = "Reverse-engineered magnetic boots that have a heavy magnetic pull. Property of Gorlex Marauders. They are set to fit normal legs."
			to_chat(user, "<span class='notice'>You set the blood-red magboots to Normal mode [src].</span>")
		I.play_tool_sound(src)
	return ..()

/obj/item/clothing/shoes/magboots/advance/digicompatable //Taken from https://github.com/TheSwain/Fulpstation/pull/470
	desc = "Advanced magnetic boots that have a lighter magnetic pull, placing less burden on the wearer. They are set to fit normal legs."
	name = "Advanced magboots"
	flags_inv = NOT_DIGITIGRADE
	icon_state = "advmag0"
	magboot_state = "advmag"
	slowdown_active = SHOES_SLOWDOWN
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/item/clothing/shoes/magboots/advance/digicompatable/attackby(obj/item/I, mob/user, params) //Taken from https://github.com/TheSwain/Fulpstation/pull/470
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		if (flags_inv == NOT_DIGITIGRADE)
			flags_inv = FULL_DIGITIGRADE
			icon_state = "advmag_digi0"
			magboot_state = "advmagdigi"
			desc = "Advanced magnetic boots that have a lighter magnetic pull, placing less burden on the wearer. They are set to fit digitigrade legs."
			to_chat(user, "<span class='notice'>You set the advanced magboots to Digitigrade mode [src].</span>")
		else
			flags_inv = NOT_DIGITIGRADE
			icon_state = "advmag0"
			magboot_state = "advmag"
			desc = "Advanced magnetic boots that have a lighter magnetic pull, placing less burden on the wearer. They are set to fit normal legs."
			to_chat(user, "<span class='notice'>You set the advanced magboots to Normal mode [src].</span>")
		user.put_in_hands(src)
		I.play_tool_sound(src)
	return ..()
