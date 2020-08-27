/obj/item/clothing/under/syndicate/intern
	name = "red polo and khaki pants"
	desc = "A non-descript and slightly suspicious looking polo paired with a respectable yet also suspicious pair of khaki pants."
	icon_state = "jake"
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 40)
	alt_covers_chest = TRUE
	icon = 'waspstation/icons/obj/clothing/under/syndicate.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/under/syndicate.dmi'

/datum/outfit/syndicate/intern
	name = "Syndicate Operative - Intern"

	uniform = /obj/item/clothing/under/syndicate/intern
	suit = /obj/item/clothing/suit/space/syndicate/surplus
	suit_store = /obj/item/tank/internals/emergency_oxygen/engi
	head = /obj/item/clothing/head/helmet/space/syndicate/surplus
	mask = /obj/item/clothing/mask/breath
	shoes = /obj/item/clothing/shoes/laceup
	r_hand = /obj/item/gun/ballistic/automatic/surplus
	gloves =  null
	l_pocket = /obj/item/pinpointer/nuke/syndicate
	r_pocket = /obj/item/ammo_box/magazine/m10mm/rifle
	belt = null
	back = /obj/item/tank/jetpack/oxygen/harness
	backpack_contents = null
	internals_slot = ITEM_SLOT_SUITSTORE

	tc = 10
	uplink_type = /obj/item/uplink/nuclear
	uplink_slot = ITEM_SLOT_BELT

/obj/item/clothing/under/plasmaman/punisher
	name = "Executioners' plasma envirosuit"
	desc = "A custom made plasmaman containment suit designed from a head of security's envirosuit, with devilstrand silk, very tough, good at insulating, and protects exceptionally well."
	icon = 'waspstation/icons/obj/clothing/under/syndicate.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/under/syndicate.dmi'
	icon_state = "punisher_envirosuit"
	item_state = "punisher_envirosuit"
	armor = list("melee" = 10, "bullet" = 10, "laser" = 10, "energy" = 10, "bomb" = 10, "bio" = 100, "rad" = 0, "fire" = 100, "acid" = 100)

/obj/item/clothing/head/helmet/space/plasmaman/punisher
	name = "Executioners' plasma envirosuit helmet"
	desc = "Those who do wrong to others...the traitors, the changelings, spies, tiders...you will come to know me well. Oganesson CXVIII is dead. Call me...the Executioner."
	icon = 'waspstation/icons/obj/clothing/hats.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/head.dmi'
	icon_state = "punisher_envirohelm"
	item_state = "punisher_envirohelm"
	armor = list("melee" = 40, "bullet" = 40, "laser" = 30, "energy" = 40, "bomb" = 70, "bio" = 100, "rad" = 0, "fire" = 100, "acid" = 100)
