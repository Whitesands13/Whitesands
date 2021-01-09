SUBSYSTEM_DEF(overmap)
	name = "Overmap"
	wait = 10
	init_order = INIT_ORDER_OVERMAP
	flags = SS_KEEP_TIMING|SS_NO_TICK_CHECK
	runlevels = RUNLEVEL_SETUP | RUNLEVEL_GAME

	///List of all overmap objects
	var/list/overmap_objects
	///List of all active, simulated ships
	var/list/simulated_ships
	///List of all helms, to be adjusted
	var/list/helms
	///List of all nav computers to initialize
	var/list/navs
	///List of all events
	var/list/events

	///The main station or ship
	var/obj/structure/overmap/main

	///Width/heighth of the overmap "zlevel"
	var/size = 20
	///Should events be processed
	var/events_enabled = TRUE

	///Cooldown on dynamically loading encounters
	var/encounter_cooldown = 0

/**
  * Creates an overmap object for shuttles, triggers initialization procs for ships and helms
  */
/datum/controller/subsystem/overmap/Initialize(start_timeofday)
	create_map()

	for(var/shuttle in SSshuttle.mobile)
		var/obj/docking_port/mobile/M = shuttle
		if(istype(M, /obj/docking_port/mobile/arrivals))
			continue
		setup_shuttle_ship(M)

	for(var/ship in simulated_ships)
		var/obj/structure/overmap/ship/simulated/S = ship
		S.initial_load()

	for(var/helm in helms)
		var/obj/machinery/computer/helm/H = helm
		H.set_ship()

	for(var/nav in navs)
		var/obj/machinery/computer/camera_advanced/shuttle_docker/nav/N = nav
		N.link_shuttle()

	return ..()

/datum/controller/subsystem/overmap/fire()
	if(events_enabled)
		for(var/event in events)
			var/obj/structure/overmap/event/E = event
			if(E?.affect_multiple_times && E?.close_overmap_objects)
				E.apply_effect()

/**
  * Creates an overmap ship object for the provided mobile docking port if one does not already exist.
  * * Shuttle: The docking port to create an overmap object for
  */
/datum/controller/subsystem/overmap/proc/setup_shuttle_ship(obj/docking_port/mobile/shuttle)
	var/docked_object = get_overmap_object_by_z(shuttle.z)
	if(docked_object)
		shuttle.current_ship = new /obj/structure/overmap/ship/simulated(docked_object, shuttle.id, shuttle)
	else if(!is_centcom_level(shuttle.z) && !istype(shuttle, /obj/docking_port/mobile/arrivals))
		shuttle.current_ship = new /obj/structure/overmap/ship/simulated(get_unused_overmap_square(), shuttle.id, shuttle)

/**
  * The proc that creates all the objects on the overmap, split into seperate procs for redundancy.
  */
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
	for(var/dir in GLOB.cardinals)
		if(prob(chance))
			var/turf/T = get_step(E, dir)
			if(!istype(get_area(T), /area/overmap))
				continue
			if(locate(/obj/structure/overmap/event) in T)
				continue
			spawn_event_cluster(type, T, chance / 2)

/**
  * Creates a station and lavaland overmap object randomly on the overmap.
  * * attempt - Used for the failsafe respawning of the station. Don't set unless you want it to only try to spawn it once.
  */
/datum/controller/subsystem/overmap/proc/spawn_station(attempt = 1)
	if(main)
		qdel(main)
	var/obj/structure/overmap/level/mining/mining_level = /obj/structure/overmap/level/mining/lavaland
	switch(GLOB.current_mining_map)
		if("lavaland")
			mining_level = /obj/structure/overmap/level/mining/lavaland
		if("icemoon")
			mining_level = /obj/structure/overmap/level/mining/icemoon
		if("whitesands")
			mining_level = /obj/structure/overmap/level/mining/whitesands

	var/obj/structure/overmap/level/main/station = new(get_unused_overmap_square(), null, SSmapping.levels_by_trait(ZTRAIT_STATION))
	for(var/dir in shuffle(GLOB.alldirs))
		var/turf/possible_tile = get_step(station, dir)
		if(!istype(get_area(possible_tile), /area/overmap))
			continue
		if(locate(/obj/structure/overmap/event) in possible_tile)
			continue
		new mining_level(possible_tile, null, SSmapping.levels_by_trait(ZTRAIT_MINING))
		return
	if(attempt <= MAX_OVERMAP_PLACEMENT_ATTEMPTS)
		spawn_station(++attempt) //Try to spawn the whole thing again
	else
		new mining_level(get_unused_overmap_square(), null, SSmapping.levels_by_trait(ZTRAIT_MINING))

/**
  * Creates an overmap object for each ruin level, making them accessible.
  */
/datum/controller/subsystem/overmap/proc/spawn_ruin_levels()
	for(var/level in SSmapping.z_list)
		var/datum/space_level/L = level
		if(ZTRAIT_SPACE_RUINS in L.traits)
			var/obj/structure/overmap/level/ruin/new_level = new(get_unused_overmap_square(), null, L.z_value)
			new_level.id = "z[L.z_value]"
	for(var/i in 1 to CONFIG_GET(number/max_overmap_dynamic_events))
		new /obj/structure/overmap/dynamic(get_unused_overmap_square())

/**
  * Reserves a square dynamic encounter area, and spawns a ruin in it if one is supplied.
  * * on_planet - If the encounter should be on a generated planet. Required, as it will be otherwise inaccessible.
  * * target - The ruin to spawn, if any
  * * dock_id - The id of the stationary docking port that will be spawned in the encounter
  * * size - Size of the encounter, defaults to 1/3 total world size
  * * visiting_shuttle - The shuttle that is going to go to the encounter. Allows ruins to scale.
  */
/datum/controller/subsystem/overmap/proc/spawn_dynamic_encounter(planet_type, ruin = TRUE, dock_id, size = world.maxx / 4, obj/docking_port/mobile/visiting_shuttle, ignore_cooldown = FALSE)
	if(!ignore_cooldown && !COOLDOWN_FINISHED(SSovermap, encounter_cooldown))
		return FALSE

	COOLDOWN_START(src, encounter_cooldown, 90 SECONDS) //Cooldown starts even if ignore_cooldown is set.

	if(!dock_id)
		CRASH("Encounter spawner tried spawning an encounter without a docking port ID!")

	var/total_size = size
	var/ruin_size = CEILING(size / 2, 1)
	var/dock_size = FLOOR(size / 2, 1)
	if(visiting_shuttle)
		dock_size = max(visiting_shuttle.width, visiting_shuttle.height) + 3 //a little bit of wiggle room

	var/list/ruin_list = SSmapping.space_ruins_templates
	var/datum/map_template/ruin/ruin_type
	var/datum/map_generator/mapgen
	if(planet_type)
		switch(planet_type)
			if(DYNAMIC_WORLD_LAVA)
				ruin_list = SSmapping.lava_ruins_templates
				mapgen = new /datum/map_generator/cave_generator/lavaland
			if(DYNAMIC_WORLD_ICE)
				ruin_list = SSmapping.ice_ruins_templates
				mapgen = new /datum/map_generator/cave_generator/icemoon/surface
			if(DYNAMIC_WORLD_SAND)
				ruin_list = SSmapping.sand_ruins_templates
				mapgen = new /datum/map_generator/cave_generator/whitesands
			if(DYNAMIC_WORLD_JUNGLE)
				ruin_list = SSmapping.jungle_ruins_templates
				mapgen = new /datum/map_generator/jungle_generator

	if(ruin && ruin_list) //Done BEFORE the turfs are reserved so that it allocates the right size box
		ruin_type = ruin_list[pick(ruin_list)]
		if(ispath(ruin_type))
			ruin_type = new ruin_type
		ruin_size = max(ruin_type.width, ruin_type.height) + 3

	total_size = min(dock_size + ruin_size, total_size)

	var/datum/turf_reservation/encounter_reservation = SSmapping.RequestBlockReservation(total_size, total_size, border_turf_override = /turf/closed/indestructible/blank, area_override = planet_type ? /area/ruin/unpowered/planetoid : null)
	if(mapgen)
		mapgen.generate_terrain(encounter_reservation.non_border_turfs)

	if(ruin_type) //Does AFTER the turfs are reserved so it can find where the allocation is
		//gets a turf vaguely in the middle of the reserve
		var/turf/ruin_turf = locate(encounter_reservation.bottom_left_coords[1] + dock_size + 1, encounter_reservation.bottom_left_coords[2] + dock_size + 1, encounter_reservation.bottom_left_coords[3])
		ruin_type.load(ruin_turf)

	//gets the turf with an X in the middle of the reservation, and a Y that's 1/4ths up in the reservation.
	var/turf/docking_turf = locate(encounter_reservation.bottom_left_coords[1] + dock_size, encounter_reservation.bottom_left_coords[2] + CEILING(dock_size / 2, 1), encounter_reservation.bottom_left_coords[3])
	var/obj/docking_port/stationary/dock = new(docking_turf)
	dock.dir = WEST
	dock.name = "\improper Uncharted Space"
	dock.id = dock_id
	dock.height = dock_size
	dock.width = dock_size
	if(visiting_shuttle)
		dock.dheight = min(visiting_shuttle.dheight, dock_size)
		dock.dwidth = min(visiting_shuttle.dwidth, dock_size)
	else
		dock.dheight = dock_size / 2
		dock.dwidth = dock_size / 2

	return encounter_reservation

/**
  * Returns a random, usually empty turf in the overmap
  * * thing_to_not_have - The thing you don't want to be in the found tile, for example, an overmap event [/obj/structure/overmap/event].
  * * tries - How many attempts it will try before giving up finding an unused tile..
  */
/datum/controller/subsystem/overmap/proc/get_unused_overmap_square(thing_to_not_have = /obj/structure/overmap, tries = MAX_OVERMAP_PLACEMENT_ATTEMPTS)
	var/turf/picked_turf
	for(var/i in 1 to tries)
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

/**
  * Gets the corresponding overmap object that shares the provided z level
  * * zlevel - The Z-level of the overmap object you want to find
  */
/datum/controller/subsystem/overmap/proc/get_overmap_object_by_z(zlevel)
	for(var/obj/structure/overmap/level/object in overmap_objects)
		if(zlevel in object.linked_levels)
			return object

/datum/controller/subsystem/overmap/Recover()
	if(istype(SSovermap.simulated_ships))
		simulated_ships = SSovermap.simulated_ships
	if(istype(SSovermap.helms))
		helms = SSovermap.helms
	if(istype(SSovermap.events))
		events = SSovermap.events
	if(istype(SSovermap.main))
		main = SSovermap.main
