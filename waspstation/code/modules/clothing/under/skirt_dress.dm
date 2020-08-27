/obj/item/clothing/under/dress/skirt/polychromic
	name = "polychromic skirt"
	desc = "A fancy skirt made with polychromic threads."
	icon = 'waspstation/icons/obj/clothing/uniforms.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/uniforms.dmi'
	icon_state = "polyskirt"
	item_state = "rainbow"
	var/list/poly_colors = list("#FFFFFF", "#F08080", "#808080")

/obj/item/clothing/under/dress/skirt/polychromic/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, poly_colors, 3)

/obj/item/clothing/under/dress/skirt/polychromic/pleated
	name = "polychromic pleated skirt"
	desc = "A magnificent pleated skirt complements the woolen polychromatic sweater."
	icon = 'waspstation/icons/obj/clothing/uniforms.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/uniforms.dmi'
	icon_state = "polypleat"
	item_state = "rainbow"
	body_parts_covered = CHEST|GROIN|ARMS
	poly_colors = list("#8CC6FF", "#808080", "#FF3535")
