/obj/item/clothing/under/misc/poly_shirt
	name = "polychromic button-up shirt"
	desc = "A fancy button-up shirt made with polychromic threads."
	icon = 'waspstation/icons/obj/clothing/uniforms.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/uniforms.dmi'
	icon_state = "polysuit"
	item_state = "sl_suit"
	mutantrace_variation = NONE

/obj/item/clothing/under/misc/poly_shirt/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, list("#FFFFFF", "#353535", "#353535"), 3)

/obj/item/clothing/under/misc/polyshorts
	name = "polychromic shorts"
	desc = "For ease of movement and style."
	icon = 'waspstation/icons/obj/clothing/uniforms.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/uniforms.dmi'
	icon_state = "polyshorts"
	item_state = "rainbow"
	can_adjust = FALSE
	body_parts_covered = CHEST|GROIN|ARMS

/obj/item/clothing/under/misc/polyshorts/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, list("#353535", "#808080", "#808080"), 3)

/obj/item/clothing/under/misc/polyjumpsuit
	name = "polychromic tri-tone jumpsuit"
	desc = "A fancy jumpsuit made with polychromic threads."
	icon = 'waspstation/icons/obj/clothing/uniforms.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/uniforms.dmi'
	icon_state = "polyjump"
	item_state = "rainbow"
	can_adjust = FALSE
	mutantrace_variation = NONE

/obj/item/clothing/under/misc/polyjumpsuit/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, list("#FFFFFF", "#808080", "#353535"), 3)

/obj/item/clothing/under/misc/poly_bottomless
	name = "polychromic bottomless shirt"
	desc = "Great for showing off your underwear in dubious style."
	icon = 'waspstation/icons/obj/clothing/uniforms.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/uniforms.dmi'
	icon_state = "polybottomless"
	item_state = "rainbow"
	body_parts_covered = CHEST|ARMS	//Because there's no bottom included
	can_adjust = FALSE
	mutantrace_variation = MUTANTRACE_VARIATION

/obj/item/clothing/under/misc/poly_bottomless/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, list("#808080", "#FF3535"), 2)

/obj/item/clothing/under/misc/poly_tanktop
	name = "polychromic tank top"
	desc = "For those lazy summer days."
	icon = 'waspstation/icons/obj/clothing/uniforms.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/uniforms.dmi'
	icon_state = "polyshimatank"
	item_state = "rainbow"
	body_parts_covered = CHEST|GROIN
	can_adjust = FALSE
	mutantrace_variation = MUTANTRACE_VARIATION
	var/list/poly_states = 3
	var/list/poly_colors = list("#808080", "#FFFFFF", "#8CC6FF")

/obj/item/clothing/under/misc/poly_tanktop/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, poly_colors, poly_states)

/obj/item/clothing/under/misc/poly_tanktop/female
	name = "polychromic feminine tank top"
	desc = "Great for showing off your chest in style. Not recommended for males."
	icon = 'waspstation/icons/obj/clothing/uniforms.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/uniforms.dmi'
	icon_state = "polyfemtankpantsu"
	poly_states = 2
	poly_colors = list("#808080", "#FF3535")
