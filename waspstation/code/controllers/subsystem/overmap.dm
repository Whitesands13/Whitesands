SUBSYSTEM_DEF(overmap)
	name = "Overmap"
	wait = 10
	init_order = INIT_ORDER_OVERMAP
	flags = SS_KEEP_TIMING|SS_NO_TICK_CHECK
	runlevels = RUNLEVEL_SETUP | RUNLEVEL_GAME

	///List of all overmap objects
	var/list/overmap_objects = list()
	///List of all active ships
	var/list/ships = list()
	///List of all helms, to be adjusted
	var/list/helms = list()
	///List of all events
	var/list/events = list()

	///The main station or ship
	var/obj/structure/overmap/main

	///Width/heighth of the overmap "zlevel"
	var/size = 15
	///Should events be processed
	var/events_enabled = TRUE
	///Should ship movement be processed
	var/ship_movement_enabled = TRUE

/**
  * Creates an overmap object for shuttles, triggers initialization procs for ships and helms
  */
/datum/controller/subsystem/overmap/Initialize(start_timeofday)
	create_map()
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

	return ..()

/datum/controller/subsystem/overmap/fire()
	if(ship_movement_enabled)
		for(var/ship in ships)
			var/obj/structure/overmap/ship/S = ship
			S.process_movement()

	if(events_enabled)
		for(var/event in events)
			var/obj/structure/overmap/event/E = event
			if(E.close_overmap_objects)
				E.apply_effect()

/datum/controller/subsystem/overmap/proc/create_map()
	spawn_events()
	spawn_ruin_levels()
	spawn_station()

/**
  * VERY Simple random generation for overmap events, spawns the event in a random turf and sometimes spreads it out similar to ores
  */
/datum/controller/subsystem/overmap/proc/spawn_events()
	var/max_clusters = CONFIG_GET(number/max_overmap_event_clusters)
	for(var/i=1, i<=max_clusters, i++)
		spawn_event_cluster(pick(subtypesof(/obj/structure/overmap/event)), get_unused_overmap_square())
/**
  * See [/datum/controller/subsystem/overmap/proc/spawn_events], spawns "veins" (like ores) of events
  */
/datum/controller/subsystem/overmap/proc/spawn_event_cluster(obj/structure/overmap/event/type, turf/location, chance)
	if(CONFIG_GET(number/max_overmap_events) <= LAZYLEN(SSovermap.events))
		return
	var/obj/structure/overmap/event/E = new type(location)
	if(!chance)
		chance = E.spread_chance
	for(var/dir in GLOB.alldirs)
		if(prob(chance))
			var/turf/T = get_step(E, dir)
			if(!istype(get_area(T), /area/overmap))
				continue
			if(locate(type) in T)
				continue
			spawn_event_cluster(type, T, chance / 2)

/**
  * Creates a station and lavaland overmap object randomly on the overmap.
  */
/datum/controller/subsystem/overmap/proc/spawn_station()
	var/obj/structure/overmap/level/main/station = new(get_unused_overmap_square(), null, SSmapping.levels_by_trait(ZTRAIT_STATION))
	var/obj/structure/overmap/level/planet/lavaland/lavaland = new(get_step(station, pick(GLOB.alldirs))) //no promise lavaland is safe from events
	if(!istype(get_area(lavaland), /area/overmap))
		lavaland.Move(get_unused_overmap_square()) //you're fucked now, it could be ANYWHERE

/**
  * Creates an overmap object for each ruin level, making them accessible.
  */
/datum/controller/subsystem/overmap/proc/spawn_ruin_levels()
	for(var/level in SSmapping.z_list)
		var/datum/space_level/L = level
		if(ZTRAIT_SPACE_RUINS in L.traits)
			var/obj/structure/overmap/level/ruin/new_level = new(get_unused_overmap_square(), null, L.z_value)
			new_level.id = "z[L.z_value]"

/**
  * Returns a random, usually empty turf in the overmap
  * * thing_to_not_have - The thing you don't want to be in the found tile, for example, an overmap event [/obj/structure/overmap/event].
  */
/datum/controller/subsystem/overmap/proc/get_unused_overmap_square(thing_to_not_have = /obj/structure/overmap)
	var/turf/picked_turf
	for(var/i in 1 to 6)
		picked_turf = pick(pick(get_area_turfs(/area/overmap)))
		if(locate(thing_to_not_have) in picked_turf)
			continue
		break
	return picked_turf

/**
  * Gets the corresponding overmap object that shares the provided ID
  * * id - ID of the overmap object you want to find
  */
/datum/controller/subsystem/overmap/proc/get_overmap_object_by_id(id)
	for(var/obj/structure/overmap/object in overmap_objects)
		if(object.id == id)
			return object

/datum/controller/subsystem/overmap/Recover()
	if(istype(SSovermap.ships))
		ships = SSovermap.ships
	if(istype(SSovermap.helms))
		helms = SSovermap.helms
	if(istype(SSovermap.events))
		events = SSovermap.events
	if(istype(SSovermap.main))
		main = SSovermap.main
