/obj/machinery/computer/helm
	name = "helm control console"
	desc = "Used to view or control the ship."
	icon_screen = "cameras"
	icon_keyboard = "security_key"
	circuit = /obj/item/circuitboard/computer/security
	light_color = LIGHT_COLOR_RED
	ui_x = 870
	ui_y = 708

	var/obj/structure/overmap/current_ship
	var/list/concurrent_users = list()

	// Stuff needed to render the map
	var/map_name
	var/const/default_map_size = 15
	var/obj/screen/map_view/cam_screen
	var/obj/screen/plane_master/lighting/cam_plane_master
	var/obj/screen/background/cam_background

	var/id = "main"

/obj/machinery/computer/helm/Initialize()
	. = ..()
	// Map name has to start and end with an A-Z character,
	// and definitely NOT with a square bracket or even a number.
	// I wasted 6 hours on this. :agony:
	map_name = "helm_console_[REF(src)]_map"
	// Initialize map objects
	cam_screen = new
	cam_screen.name = "screen"
	cam_screen.assigned_map = map_name
	cam_screen.del_on_map_removal = FALSE
	cam_screen.screen_loc = "[map_name]:1,1"
	cam_plane_master = new
	cam_plane_master.name = "plane_master"
	cam_plane_master.assigned_map = map_name
	cam_plane_master.del_on_map_removal = FALSE
	cam_plane_master.screen_loc = "[map_name]:CENTER"
	cam_background = new
	cam_background.assigned_map = map_name
	cam_background.del_on_map_removal = FALSE
	// Process each overmap fire
	for(var/S in SSovermap.ships)
		var/obj/structure/overmap/ship = S
		if(ship.id == id)
			current_ship = ship
			if(!current_ship.helm)
				current_ship.helm = src

/obj/machinery/computer/helm/Destroy()
	qdel(cam_screen)
	qdel(cam_plane_master)
	qdel(cam_background)
	return ..()

/obj/machinery/computer/helm/proc/update_location()
	if(concurrent_users)
		var/list/visible_turfs = list()
		for(var/turf/T in view(current_ship.sensor_range, current_ship))
			visible_turfs += T

		var/list/bbox = get_bbox_of_atoms(visible_turfs)
		var/size_x = bbox[3] - bbox[1] + 1
		var/size_y = bbox[4] - bbox[2] + 1

		cam_screen.vis_contents = visible_turfs
		cam_background.icon_state = "clear"
		cam_background.fill_rect(1, 1, size_x, size_y)
		return TRUE

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
		user.client.register_map_obj(cam_screen)
		user.client.register_map_obj(cam_plane_master)
		user.client.register_map_obj(cam_background)
		// Open UI
		ui = new(user, src, ui_key, "HelmConsole", name, ui_x, ui_y, master_ui, state)
		ui.open()

/obj/machinery/computer/helm/ui_data(mob/user)
	var/list/data = list()
	data["heading"] = dir2angle(current_ship.get_heading())
	data["speed"] = current_ship.get_speed() * 1000
	data["maxspeed"] = current_ship.max_speed * 1000
	data["eta"] = current_ship.get_eta()
	data["stopped"] = current_ship.is_still()
	return data

/obj/machinery/computer/helm/ui_static_data()
	var/list/data = list()
	data["mapRef"] = map_name
	return data

/obj/machinery/computer/helm/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("change_heading")
			var/direction = text2num(params["dir"])
			current_ship.accelerate(direction)
		if("speed_change")
			var/newspeed = text2num(params["newspeed"])
			if(newspeed > (current_ship.get_speed() * 1000))
				current_ship.accelerate(current_ship.dir, newspeed)
			else
				current_ship.decelerate()

		if("stop")
			current_ship.decelerate()

/obj/machinery/computer/helm/ui_close(mob/user)
	var/user_ref = REF(user)
	var/is_living = isliving(user)
	// Living creature or not, we remove you anyway.
	concurrent_users -= user_ref
	// Unregister map objects
	user.client.clear_map(map_name)
	// Turn off the console
	if(length(concurrent_users) == 0 && is_living)
		playsound(src, 'sound/machines/terminal_off.ogg', 25, FALSE)
		use_power(0)
