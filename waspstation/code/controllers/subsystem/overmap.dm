PROCESSING_SUBSYSTEM_DEF(overmap)
	name = "Overmap"
	wait = 10
	init_order = INIT_ORDER_OVERMAP
	flags = SS_KEEP_TIMING|SS_NO_TICK_CHECK
	runlevels = RUNLEVEL_SETUP | RUNLEVEL_GAME

	///List of all active ships
	var/list/ships = list()
	///List of all helms, to be adjusted
	var/list/helms = list()
	///zlevel IDs
	var/list/z_id_list = list()
	///The main station or ship
	var/obj/structure/overmap/main
	///Width/heighth of the overmap "zlevel"
	var/size = 15

/datum/controller/subsystem/processing/overmap/Initialize(start_timeofday)
	for(var/shuttle in SSshuttle.mobile)
		var/obj/docking_port/mobile/M = shuttle
		if(is_station_level(M.z))
			new /obj/structure/overmap/ship/rendered(SSovermap.main, M.id, M)

	for(var/ship in ships)
		var/obj/structure/overmap/ship/S = ship
		S.initial_load()

	for(var/helm in helms)
		var/obj/machinery/computer/helm/H = helm
		H.set_ship()

	for(var/level in SSmapping.z_list)
		LAZYSET(z_id_list, level, get_overmap_object_by_z_level(level))

/datum/controller/subsystem/processing/overmap/proc/get_overmap_object_by_id(id)
	for(var/obj/structure/overmap/object in processing)
		if(object.id == id)
			return object

/datum/controller/subsystem/processing/overmap/proc/get_overmap_object_by_z_level(z) //hardcoded and bad, TODO: make better
	if(z == 1)
		return "centcom"
	else if(is_station_level(z))
		return MAIN_OVERMAP_OBJECT_ID
	else if(SSmapping.level_has_all_traits(z, ZTRAITS_LAVALAND))
		return "lavaland"
	else if(SSmapping.level_trait(z, ZTRAIT_SPACE_RUINS))
		return



