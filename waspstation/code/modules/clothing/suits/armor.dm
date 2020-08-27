/obj/item/clothing/suit/armor/vest/lieutenant
	name = "lieutenant's armor"
	desc = "An armored vest with the lieutenant's insignia imprinted on it."
	icon = 'waspstation/icons/obj/clothing/suits.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/suits.dmi'
	icon_state = "blueshield"
	item_state = "blueshield"

/obj/item/clothing/suit/armor/vest/terra
	name = "terragov armor vest"
	desc = "An armor used by TerraGov's marines. Inferior ceramics make this heavier armor only as protective as the armors on the station."
	icon_state = "terraarmor"
	item_state = "terraarmor"
	icon = 'waspstation/icons/obj/clothing/suits.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/suits.dmi'

/obj/item/clothing/suit/armor/vest/punisher
	name = "vigilante overcoat"
	desc = "A plasteel-reinforced and fireproofed trenchcoat best used for concealing a sawn-down shotgun and shooting 3 Syndicate contractors in the darkened loading dock of a biker bar."
	icon_state = "leathercoat"
	item_state = "leathercoat"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor = list("melee" = 50, "bullet" = 40, "laser" = 50, "energy" = 50, "bomb" = 70, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 100)
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS