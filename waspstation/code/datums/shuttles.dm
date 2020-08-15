/datum/map_template/shuttle/emergency/syndicate
	suffix = "syndicate"
	name = "Syndicate GM Battlecruiser"
	credit_cost = 20000
	description = "Manufactured by the Gorlex Marauders, this cruiser has been specially designed with high occupancy in mind, while remaining robust in combat situations. Features a fully stocked EVA storage, armory, medbay, and bar!"
	admin_notes = "An emag exclusive, stocked with syndicate equipment and turrets that will target any simplemob."

/datum/map_template/shuttle/emergency/syndicate/prerequisites_met()
	if(SHUTTLE_UNLOCK_EMAGGED in SSshuttle.shuttle_purchase_requirements_met)
		return TRUE
	return FALSE

/datum/map_template/shuttle/cargo/packed
	suffix = "packed"
	name = "supply shuttle (Packedstation)"

/datum/map_template/shuttle/mining/packed
	suffix = "packed"
	name = "mining shuttle (Packedstation)"

/datum/map_template/shuttle/arrival/packed
	suffix = "packed"
	name = "arrival shuttle (Packedstation)"
