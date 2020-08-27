/obj/item/clothing/under/costume/kilt/polychromic
	name = "polychromic kilt"
	desc = "It's not a skirt!"
	icon = 'waspstation/icons/obj/clothing/uniforms.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/uniforms.dmi'
	icon_state = "polykilt"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	mutantrace_variation = MUTANTRACE_VARIATION

/obj/item/clothing/under/costume/kilt/polychromic/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, list("#FFFFFF", "#F08080"), 2)
