/datum/design/floor_painter
	name = "Floor Painter"
	id = "floor_painter"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 300, /datum/material/glass = 100)
	build_path = /obj/item/floor_painter
	category = list("initial","Tools","Tool Designs")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/hypovial
	name = "Hypovial"
	id = "hypovial"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/glass = 500)
	build_path = /obj/item/reagent_containers/glass/bottle/vial/small
	category = list("initial", "Medical", "Medical Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/bluespacehypovial
	name = "Bluespace Hypovial"
	id = "bluespacehypovial"
	build_type = PROTOLATHE
	materials = list(/datum/material/glass = 1500, /datum/material/plasma = 750, /datum/material/diamond = 250, /datum/material/bluespace = 500)
	build_path = /obj/item/reagent_containers/glass/bottle/vial/small/bluespace
	category = list("Medical Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL
