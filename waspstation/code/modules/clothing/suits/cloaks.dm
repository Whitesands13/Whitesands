/obj/item/clothing/neck/cloak/polychromic
	name = "polychromic cloak"
	desc = "For when you want to show off your horrible colour coordination skills."
	icon = 'waspstation/icons/obj/clothing/neck.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/neck.dmi'
	icon_state = "polyce"
	item_state = "qmcloak"
	var/list/poly_colors = list("#FFFFFF", "#FFFFFF", "#808080")

/obj/item/clothing/neck/cloak/polychromic/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, poly_colors, 3)
