GLOBAL_LIST_EMPTY(ore_vein_landmarks)

/obj/effect/landmark/ore_vein
	name = "OreVein"
	var/resource

/obj/effect/landmark/ore_vein/Initialize(mapload, var/area/lavaland/surface/outdoors/ore_vein/vein_type)
	. = ..()
	GLOB.ore_vein_landmarks += src
	if(!vein_type)
		vein_type = pick(subtypesof(/area/lavaland/surface/outdoors/ore_vein)) //random is default
	if(ispath(vein_type))
		vein_type = GLOB.areas_by_type[vein_type] || new vein_type //Finds either a preexisting instance or makes a new one
	var/turf/T = get_turf(src)
	var/area/old_area = get_area(T)
	vein_type.contents += T
	T.change_area(old_area, vein_type)
	resource = initial(vein_type.ore_type.name)

/*\
	# Ore Veins
	Represents material hidden beneath the earth for Deep Core Mining
\*/
/area/lavaland/surface/outdoors/ore_vein
	name = "Undefined Ore Vein"
	var/obj/item/stack/ore/ore_type //What you're pulling out of the ground
	var/material_rate = 0	//Affects overall value of the ore vein
	var/obj/machinery/deepcore/drill/active_drill
	///Currently linked ore vein landmark
	var/obj/effect/landmark/ore_vein/landmark

// /area/lavaland/surface/outdoors/ore_vein/update_areasize()
// 	//Overrides the outdoors restriction on areasize
// 	areasize = 0
// 	for(var/turf/open/T in contents)
// 		areasize++

/area/lavaland/surface/outdoors/ore_vein/proc/extract_ore() //Called by deepcore drills, returns a list of keyed ore stacks by amount
	var/list/ores = list()
	// if(!areasize)
	// 	update_areasize()
	// ores[ore_type] = CEILING((sqrt(areasize) * material_rate), 1)
	ores[ore_type] = material_rate
	return ores

/area/lavaland/surface/outdoors/ore_vein/iron
	name = "Iron Ore Vein"
	ore_type = /obj/item/stack/ore/iron
	material_rate = 6

/area/lavaland/surface/outdoors/ore_vein/plasma
	name = "Inert Plasma Vein"
	ore_type = /obj/item/stack/ore/plasma
	material_rate = 5

/area/lavaland/surface/outdoors/ore_vein/gold
	name = "Gold Ore Vein"
	ore_type = /obj/item/stack/ore/gold
	material_rate = 3

/area/lavaland/surface/outdoors/ore_vein/silver
	name = "Silver Ore Vein"
	ore_type = /obj/item/stack/ore/silver
	material_rate = 4

/area/lavaland/surface/outdoors/ore_vein/titanium
	name = "Titanium Ore Vein"
	ore_type = /obj/item/stack/ore/titanium
	material_rate = 3

/area/lavaland/surface/outdoors/ore_vein/uranium
	name = "Uranium Ore Vein"
	ore_type = /obj/item/stack/ore/uranium
	material_rate = 2

/area/lavaland/surface/outdoors/ore_vein/diamond
	name = "Diamond Ore Vein"
	ore_type = /obj/item/stack/ore/diamond
	material_rate = 1
