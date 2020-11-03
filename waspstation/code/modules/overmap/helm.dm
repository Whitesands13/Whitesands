/obj/machinery/computer/helm
	name = "helm control console"
	desc = "Used to view or control the ship."
	icon_screen = "shuttle"
	icon_keyboard = "tech_key"
	circuit = /obj/item/circuitboard/computer/security
	light_color = LIGHT_COLOR_RED

	///The ship
	var/obj/structure/overmap/ship/current_ship
	var/list/concurrent_users = list()
	///Is this for viewing only?
	var/viewer = FALSE
	///The overmap object/shuttle ID
	var/id

/obj/machinery/computer/helm/Initialize(mapload)
	. = ..()
	LAZYADD(SSovermap.helms, src)
	if(!mapload)
		set_ship()

/obj/machinery/computer/helm/proc/set_ship(_id)
	if(_id)
		id = _id
	if(!id)
		var/obj/docking_port/port = SSshuttle.get_containing_shuttle(src)
		var/area/A = get_area(src)
		if(port)
			id = port.id
		else if(is_station_level(z) && !A?.outdoors)
			id = MAIN_OVERMAP_OBJECT_ID
		else
			return FALSE
	current_ship = SSovermap.get_overmap_object_by_id(id)

/obj/machinery/computer/helm/Destroy()
	. = ..()
	LAZYREMOVE(SSovermap.helms, src)

/obj/machinery/computer/helm/ui_interact(mob/user, datum/tgui/ui)
	// Update UI
	if(!current_ship)
		set_ship()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		var/user_ref = REF(user)
		var/is_living = isliving(user)
		// Ghosts shouldn't count towards concurrent users, which produces
		// an audible terminal_on click.
		if(is_living)
			concurrent_users += user_ref
		// Turn on the console
		if(length(concurrent_users) == 1 && is_living)
			playsound(src, 'sound/machines/terminal_on.ogg', 25, FALSE)
			use_power(active_power_usage)
		// Register map objects
		if(current_ship)
			user.client.register_map_obj(current_ship.cam_screen)
			user.client.register_map_obj(current_ship.cam_plane_master)
			user.client.register_map_obj(current_ship.cam_background)

			current_ship.refresh_engines()
		// Open UI
		ui = new(user, src, "HelmConsole", name)
		ui.open()

/obj/machinery/computer/helm/ui_data(mob/user)
	. = list()
	.["shipInfo"] = list(
		name = current_ship.name,
		class = istype(current_ship, /obj/structure/overmap/ship) ? "ship" : istype(current_ship, /obj/structure/overmap/level/planet) ? "planet" : "station",
		integrity = current_ship.integrity,
		sensor_range = current_ship.sensor_range,
		ref = REF(current_ship)
	)
	.["otherInfo"] = list()
	for (var/object in current_ship.close_overmap_objects)
		var/obj/structure/overmap/O = object
		var/list/other_data = list(
			name = O.name,
			integrity = O.integrity,
			ref = REF(O)
		)
		.["otherInfo"] += list(other_data)

	if(istype(current_ship, /obj/structure/overmap/ship))
		.["canFly"] = TRUE
		.["state"] = current_ship.state
		.["docked"] = current_ship.docked ? TRUE : FALSE
		.["heading"] = dir2angle(current_ship.get_heading())
		.["speed"] = current_ship.get_speed() * 1000
		.["maxspeed"] = current_ship.max_speed * 1000
		.["eta"] = current_ship.get_eta()
		.["stopped"] = current_ship.is_still()
		.["x"] = current_ship.x
		.["y"] = current_ship.y
		.["shipInfo"] += list(
			mass = current_ship.mass,
			est_thrust = current_ship.est_thrust
		)
		.["engineInfo"] = list()
		for(var/obj/machinery/shuttle/engine/E in current_ship.shuttle.engine_list)
			var/obj/machinery/atmospherics/components/unary/shuttle/heater/H = E.attached_heater.resolve()
			if(!E.thruster_active)
				continue
			var/list/engine_data = list(
				name = E.name,
				fuel = H ? H.getGas() : FALSE,
				enabled = E.enabled,
				ref = REF(E)
			)
			.["engineInfo"] += list(engine_data)

/obj/machinery/computer/helm/ui_static_data(mob/user)
	. = list()
	.["isViewer"] = viewer
	.["mapRef"] = current_ship.map_name

/obj/machinery/computer/helm/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("act_overmap")
			var/obj/structure/overmap/to_act = locate(params["ship_to_act"])
			say(current_ship.dock(to_act))
		if("undock")
			say(current_ship.undock())
		if("reload_ship")
			set_ship()
		if("reload_engines")
			current_ship.refresh_engines()
		if("toggle_engine")
			var/obj/machinery/shuttle/engine/E = locate(params["engine"])
			E.enabled = !E.enabled
		if("change_heading")
			current_ship.burn_engines(text2num(params["dir"]))
		if("stop")
			current_ship.burn_engines()

/obj/machinery/computer/helm/ui_close(mob/user)
	var/user_ref = REF(user)
	var/is_living = isliving(user)
	// Living creature or not, we remove you anyway.
	concurrent_users -= user_ref
	// Unregister map objects
	if(current_ship)
		user.client.clear_map(current_ship.map_name)
	// Turn off the console
	if(length(concurrent_users) == 0 && is_living)
		playsound(src, 'sound/machines/terminal_off.ogg', 25, FALSE)
		use_power(0)

/obj/machinery/computer/helm/viewscreen
	name = "ship viewscreen"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "telescreen"
	layer = SIGN_LAYER
	density = FALSE
	viewer = TRUE
