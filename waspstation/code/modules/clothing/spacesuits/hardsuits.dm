/obj/item/clothing/head/helmet/space/hardsuit/solgov
	name = "SolGov hardsuit helmet"
	desc = "An armored spaceproof helmet. The glass has a metallic shine on it."
	icon_state = "hardsuit0-sol"
	item_state = "sol_helm"
	hardsuit_type = "sol"
	armor = list("melee" = 50, "bullet" = 45, "laser" = 40,"energy" = 30, "bomb" = 60, "bio" = 100, "rad" = 90, "fire" = 85, "acid" = 75)
	icon = 'waspstation/icons/obj/clothing/hats.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/head.dmi'

/obj/item/clothing/suit/space/hardsuit/solgov
	icon_state = "solhardsuit"
	name = "SolGov hardsuit"
	desc = "An armored spaceproof suit. An exoskeleton helps the user not have slowdown, allowing full mobility with the suit."
	item_state = "solhardsuit"
	armor = list("melee" = 50, "bullet" = 45, "laser" = 40, "energy" = 30, "bomb" = 60, "bio" = 100, "rad" = 90, "fire" = 85, "acid" = 75) //intentionally the fucking strong, this is master chief-tier armor //is this really what you call the strong?? is this the best solgov has to offer??????
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/solgov
	slowdown = 0
	icon = 'waspstation/icons/obj/clothing/suits.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/suits.dmi'

