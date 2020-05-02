/datum/design/geprocket
	name = "\improper GEP Gun Rocket"
	desc = "Explosive gyro-stabilized rockets that can easily stop any criminal."
	id = "geprocket"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 7500, /datum/material/gold = 1000, /datum/material/titanium = 5000)
	build_path = /obj/item/ammo_casing/caseless/rocket/gep
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/geprocket/rubber
	name = "\improper GEP Gun Rubber Rocket"
	desc = "Non-Explosive gyro-stabilized rockets that can easily stop any criminal."
	id = "geprubberrocket"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 7500, /datum/material/gold = 1000, /datum/material/titanium = 2000)
	build_path = /obj/item/ammo_casing/caseless/rocket/gep/rubber
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/gepgun
	name = "GEP Gun"
	desc = "A gun perfect for silent takedowns."
	id = "gepgun"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 15000, /datum/material/glass = 2500, /datum/material/silver = 3000, /datum/material/titanium = 5000)
	build_path = /obj/item/gun/ballistic/rocketlauncher/gepgun
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY
