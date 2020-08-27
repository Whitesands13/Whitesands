
/obj/item/clothing/under/shorts/polychromic
	name = "polychromic athletic shorts"
	desc = "95% Polychrome, 5% Spandex!"
	icon = 'waspstation/icons/obj/clothing/uniforms.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/uniforms.dmi'
	icon_state = "polyshortpants"
	item_state = "rainbow"
	mutantrace_variation = NONE
	var/list/poly_colors = list("#FFFFFF", "#F08080")

/obj/item/clothing/under/shorts/polychromic/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, poly_colors, 2)

/obj/item/clothing/under/shorts/polychromic/pantsu
	name = "polychromic panties"
	desc = "Topless striped panties. Now with 120% more polychrome!"
	icon = 'waspstation/icons/obj/clothing/uniforms.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/uniforms.dmi'
	icon_state = "polypantsu"
	item_state = "rainbow"
	body_parts_covered = GROIN
	mutantrace_variation = MUTANTRACE_VARIATION

	poly_colors = list("#FFFFFF", "#8CC6FF")
