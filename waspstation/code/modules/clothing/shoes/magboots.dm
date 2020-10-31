/obj/item/clothing/shoes/magboots/lizard //Taken from https://github.com/TheSwain/Fulpstation/pull/466
	name = "digitigrade magboots"
	desc = "A custom-made variant set of magnetic boots, intended to ensure lizardfolk can safely perform EVA."
	flags_inv = FULL_DIGITIGRADE
	icon = 'icons/obj/clothing/shoes.dmi'//need to fix
	icon_state = "jackboots"//need to fix
	magboot_state = "digi_magboots"
	worn_icon = 'icons/mob/feet.dmi'//need to fix
	inhand_icon_state = "jackboots"//need to fix


/obj/item/clothing/shoes/magboots/advance/digicompatable //Taken from https://github.com/TheSwain/Fulpstation/pull/470
	desc = "Advanced magnetic boots that have a lighter magnetic pull, placing less burden on the wearer. They are set to fit normal legs."
	name = "Advanced magboots"
	flags_inv = NOT_DIGITIGRADE
	icon_state = "advmag0"
	magboot_state = "advmag"
	slowdown_active = SHOES_SLOWDOWN
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/item/clothing/shoes/magboots/advance/digicompatable/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		if (flags_inv == NOT_DIGITIGRADE)
			flags_inv = FULL_DIGITIGRADE
			icon = 'icons/obj/clothing/shoes.dmi'//need to fix
			icon_state = "jackboots" //need to fix
			magboot_state = "cedigi_magboots"
			worn_icon = 'icons/mob/feet.dmi'//need to fix
			inhand_icon_state = "jackboots"//need to fix
			desc = "Advanced magnetic boots that have a lighter magnetic pull, placing less burden on the wearer. They are set to fit digitigrade legs."
			to_chat(user, "<span class='notice'>You set the advanced magboots to Digitigrade mode [src].</span>")
		else
			flags_inv = NOT_DIGITIGRADE
			icon = 'icons/obj/clothing/shoes.dmi'
			icon_state = "advmag0"
			magboot_state = "advmag"
			worn_icon = 'icons/mob/clothing/feet.dmi'
			inhand_icon_state = "advmag"
			desc = "Advanced magnetic boots that have a lighter magnetic pull, placing less burden on the wearer. They are set to fit normal legs."
			to_chat(user, "<span class='notice'>You set the advanced magboots to Normal mode [src].</span>")
	I.play_tool_sound(src)
	. = ..()
