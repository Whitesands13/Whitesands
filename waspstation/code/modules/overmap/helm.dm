/obj/machinery/computer/helm
	name = "helm control console"
	desc = "Used to view or control the ship."
	icon_screen = "cameras"
	icon_keyboard = "security_key"
	circuit = /obj/item/circuitboard/computer/security
	light_color = LIGHT_COLOR_RED
	ui_x = 870
	ui_y = 708

	///The ship
	var/obj/structure/overmap/ship/current_ship
	var/list/concurrent_users = list()
	///Is this for viewing only?
	var/viewer = FALSE

	var/docked

	var/id = "main"

/obj/machinery/computer/helm/Initialize()
	. = ..()
	set_ship()

/obj/machinery/computer/helm/proc/set_ship(obj/structure/overmap/ship/ship)
	if(!ship)
		ship = SSovermap.get_overmap_object_by_id(id)
	current_ship = ship

/obj/machinery/computer/helm/ui_interact(\
		mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, \
		datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	// Update UI
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
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
		// Open UI
		ui = new(user, src, ui_key, "HelmConsole", name, ui_x, ui_y, master_ui, state)
		ui.open()

/obj/machinery/computer/helm/ui_data(mob/user)
	. = list()
	.["shipInfo"] = list(
		name = current_ship.name,
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
	if(istype(/obj/structure/overmap/ship, current_ship))
		.["heading"] = dir2angle(current_ship.get_heading())
		.["speed"] = current_ship.get_speed() * 1000
		.["maxspeed"] = current_ship.max_speed * 1000
		.["eta"] = current_ship.get_eta()
		.["stopped"] = current_ship.is_still()
		.["x"] = current_ship.x
		.["y"] = current_ship.y

/obj/machinery/computer/helm/ui_static_data(mob/user)
	. = list()
	.["canFly"] = istype(/obj/structure/overmap/ship, current_ship)
	.["isViewer"] = viewer
	.["mapRef"] = current_ship.map_name

/obj/machinery/computer/helm/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("reconnect")
			set_ship()
		if("refresh")
			current_ship.get_close_objects()
		if("change_sensor_range")
			current_ship.sensor_range = text2num(params["sensor_range"])
		if("change_heading")
			current_ship.accelerate(text2num(params["dir"]))
		if("stop")
			current_ship.decelerate()

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
