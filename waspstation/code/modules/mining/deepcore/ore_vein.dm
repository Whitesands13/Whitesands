GLOBAL_LIST_EMPTY(ore_vein_landmarks)

/obj/effect/landmark/ore_vein
	name = "ore vein"
	var/datum/material/resource
	var/material_rate = 0

/obj/effect/landmark/ore_vein/Initialize(mapload, var/datum/material/mat)
	. = ..()
	GLOB.ore_vein_landmarks += src
	// Key = Material path; Value = Material Rate
	//! Ensure material datum has an ore_type set
	var/static/list/ores_list = list(
		/datum/material/iron = 600,
		/datum/material/glass = 500,
		/datum/material/silver = 400,
		/datum/material/gold = 350,
		/datum/material/diamond = 100,
		/datum/material/plasma = 450,
		/datum/material/uranium = 200,
		/datum/material/titanium = 300,
		/datum/material/bluespace = 50
	)
	var/datum/material/M = mat
	if(!mat)
		M = pick(ores_list) //random is default
	resource = M
	material_rate = ores_list[M]

/obj/effect/landmark/ore_vein/LateInitialize()
	. = ..()
	name = resource.name + " " + name

/obj/effect/landmark/ore_vein/proc/extract_ore() //Called by deepcore drills, returns a list of keyed ore stacks by amount
	var/list/ores = list()
	ores[resource] = material_rate
	return ores
