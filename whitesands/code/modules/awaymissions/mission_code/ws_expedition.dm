/obj/item/card/id/away/ws_exped
	name = "\proper a Whitesands Colonial ID"
	desc = "The government issued ID of a former civilian colonist. Whatever it opened is long gone."
	icon_state = "ws_colonial"
	access = list(ACCESS_AWAY_GENERAL)

/obj/item/card/id/away/ws_exped/spaceport_tcomms
	name = "\proper a Spaceport ID"
	desc = "An ID with the White Sands Spaceport logo emblazoned on the front. This one looks like it has special access."
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_GENERIC1)

/obj/effect/mob_spawn/human/whitesands/survivor/tribesman
	name = "planetside cryopod"
	desc = "A humming cryo pod, with its own microreactor. It looks like it was started recently. The machine is attempting to wake up its occupant."
	mob_name = "a survivor leader"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	roundstart = FALSE
	death = FALSE
	random = TRUE
	mob_species = /datum/species/human
	short_desc = "You are a grizzled survivor of the Inter-Corporate war, and a member of a tribe on White Sands. Defend your base from intruders."
	flavour_text = "The last engagement you had with a neighboring tribe left you bruised and battered. \
	Instead of eating and drinking the limited resources of the camp, you decided to jump into a cryopod to allow the healing gel to work. \
	You awake to the remants of your tribe calling your name, and the sounds of ships flying overhead. Time to protect what's yours."
	uniform = /obj/item/clothing/under/color/random
	back = /obj/item/storage/backpack
	shoes = /obj/item/clothing/shoes/workboots/mining
	suit = /obj/item/clothing/suit/hooded/survivor
	belt = /obj/item/gun/ballistic/rifle/boltaction/polymer
	l_pocket = /obj/item/ammo_box/aac_300blk_stripper
	r_pocket = /obj/item/tank/internals/emergency_oxygen/engi
	gloves = /obj/item/clothing/gloves/color/black
	backpack_contents = list(
		/obj/item/ammo_box/aac_300blk_stripper = 2,
		/obj/item/storage/box/survival = 1,
		/obj/item/reagent_containers/hypospray/medipen/survival = 1
	)
	id = /obj/item/card/id/away/ws_exped
	assignedrole = "Survivor Warrior"

/obj/effect/mob_spawn/human/whitesands/survivor/tribesman/equip(mob/living/carbon/human/H)
	. = ..()
	H.faction = list("ws_mining_base")

/obj/effect/mob_spawn/human/whitesands/survivor/leader
	name = "planetside cryopod"
	desc = "A humming cryo pod, with its own microreactor. It looks like it was started recently. The machine is attempting to wake up its occupant."
	mob_name = "a survivor leader"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	roundstart = FALSE
	death = FALSE
	random = TRUE
	mob_species = /datum/species/human
	short_desc = "You are a grizzled survivor of the Inter-Corporate war, leading a group of former colonists on White Sands. Defend your base from intruders."
	flavour_text = "The last engagement you had with a neighboring tribe left you bruised and battered. \
	Instead of eating and drinking the limited resources of the camp, you decided to jump into a cryopod to allow the healing gel to work. \
	You awake to the remants of your tribe calling your name, and the sounds of ships flying overhead. Time to protect what's yours."
	uniform = /obj/item/clothing/under/color/random
	back = /obj/item/storage/backpack
	shoes = /obj/item/clothing/shoes/workboots/mining
	suit = /obj/item/clothing/suit/hooded/survivor
	belt = /obj/item/gun/ballistic/automatic/aks74u
	l_pocket = /obj/item/ammo_box/magazine/aks74u
	r_pocket = /obj/item/tank/internals/emergency_oxygen/engi
	gloves = /obj/item/clothing/gloves/color/black
	id = /obj/item/card/id/away/ws_exped/spaceport_tcomms
	backpack_contents = list(
		/obj/item/ammo_box/magazine/aks74u = 2,
		/obj/item/storage/box/survival = 1,
		/obj/item/reagent_containers/hypospray/medipen/survival = 1
	)
	assignedrole = "Survivor Leader"

/obj/effect/mob_spawn/human/whitesands/survivor/leader/equip(mob/living/carbon/human/H)
	. = ..()
	H.faction = list("ws_mining_base")

/obj/effect/mob_spawn/human/whitesands/survivor/leader/Destroy()
	new/obj/structure/showcase/machinery/oldpod/used(drop_location())
	return ..()
