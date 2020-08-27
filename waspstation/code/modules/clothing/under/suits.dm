/obj/item/clothing/under/suit/polychromic	//enables all three overlays to reduce copypasta and defines basic stuff
	name = "polychromic suit"
	desc = "For when you want to show off your horrible colour coordination skills."
	icon = 'waspstation/icons/obj/clothing/uniforms.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/uniforms.dmi'
	icon_state = "polysuit"
	item_state = "sl_suit"
	can_adjust = FALSE
	mutantrace_variation = NONE

/obj/item/clothing/under/suit/polychromic/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, list("#FFFFFF", "#FFFFFF", "#808080"), 3)
