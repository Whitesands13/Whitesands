/obj/item/clothing/suit/hooded/wintercoat/polychromic
	name = "polychromic winter coat"
	icon = 'waspstation/icons/obj/clothing/suits.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/suits.dmi'
	icon_state = "coatpoly"
	item_state = "coatpoly"
	hoodtype = /obj/item/clothing/head/hooded/winterhood/polychromic

/obj/item/clothing/suit/hooded/wintercoat/polychromic/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, list("#6A6964", "#C4B8A6", "#0000FF"), 3)

/obj/item/clothing/head/hooded/winterhood/polychromic
	icon = 'waspstation/icons/obj/clothing/hats.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/head.dmi'
	icon_state = "winterhood_poly"
	item_state = "winterhood_poly"
