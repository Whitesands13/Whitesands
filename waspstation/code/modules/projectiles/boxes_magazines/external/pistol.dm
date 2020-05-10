/obj/item/ammo_box/magazine/co9mm
	name = "Commander magazine (9mm)"
	desc = "A single stack M1911 reproduction magazine, modified to chamber 9mm."
	icon_state = "45-8"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = "9mm"
	max_ammo = 8

/obj/item/ammo_box/magazine/co9mm/update_icon()
	..()
	if (ammo_count() >= 8)
		icon_state = "45-8"
	else
		icon_state = "45-[ammo_count()]"
