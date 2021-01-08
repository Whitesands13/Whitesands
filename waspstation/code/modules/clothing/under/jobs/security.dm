//Brig Phys
/obj/item/clothing/under/rank/security/brig_phys
	name = "brig physician's uniform"
	desc = "A lightly armored uniform worn by Nanotrasen's Asset Protection Medical Corps."
	icon = 'waspstation/icons/obj/clothing/under/security.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/under/security.dmi'
	icon_state = "brig_phys"
	item_state = "labcoat_sec"

/obj/item/clothing/under/rank/security/brig_phys/security_medic
	name = "security medic's uniform"
	desc = "A lightly armored uniform worn by medics ensuring the health of prisoners."
	icon_state = "security_medic"
	fitted = NO_FEMALE_UNIFORM

/obj/item/clothing/under/rank/security/brig_phys/security_medic/skirt
	name = "security medic's uniform"
	desc = "A lightly armored uniform, with a skirt, worn by medics ensuring the health of prisoners."
	icon_state = "security_medic_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE

//Prisoner Uniforms Alt

/obj/item/clothing/under/rank/prisoner/protected_custody
	name = "protected custody jumpsuit"
	desc = "It's standardised Nanotrasen prisoner-wear worn by those in protected custody. Its suit sensors are stuck in the \"Fully On\" position."
	icon = 'waspstation/icons/obj/clothing/under/security.dmi'
	mob_overlay_icon = 'waspstation/icons/mob/clothing/under/security.dmi'
	icon_state = "protected_custody"
	item_state = "o_suit"
	has_sensor = LOCKED_SENSORS
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	fitted = NO_FEMALE_UNIFORM

/obj/item/clothing/under/rank/prisoner/protected_custody/skirt
	name = "protected custody jumpskirt"
	desc = "It's standardised Nanotrasen prisoner-wear worn by those in protected custody. Its suit sensors are stuck in the \"Fully On\" position."
	icon_state = "protected_custody_skirt"
	item_state = "o_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	fitted = FEMALE_UNIFORM_TOP
