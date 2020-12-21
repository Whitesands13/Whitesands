#define SHIP_MOVE_RESOLUTION 0.00001
#define MOVING(speed) abs(speed) >= min_speed
#define SANITIZE_SPEED(speed) SIGN(speed) * clamp(abs(speed), 0, max_speed)
#define CHANGE_SPEED_BY(speed_var, v_diff) \
	v_diff = SANITIZE_SPEED(v_diff);\
	if(!MOVING(speed_var + v_diff)) \
		{speed_var = 0};\
	else \
		{speed_var = SANITIZE_SPEED((speed_var + v_diff)/(1 + speed_var*v_diff/(max_speed ** 2)))}

#define SHIP_IDLE		"idle"
#define SHIP_FLYING		"flying"
#define SHIP_DOCKING	"docking"
#define SHIP_UNDOCKING	"undocking"

/**
  * ## Overmap ships
  * Basically, any overmap object that is movable.
  * Can be docked to any other overmap object with a corresponding docking port and/or zlevel.
  * SUPPOSED to be linked to the corresponding shuttle's mobile docking port, but you never know do you
  */
/obj/structure/overmap/ship
	name = "overmap vessel"
	desc = "A spacefaring vessel."
	icon = 'waspstation/icons/effects/overmap.dmi'
	icon_state = "ship"
	///The overmap object the ship is docked to, if any
	var/obj/structure/overmap/docked
	///The docking port of the linked shuttle
	var/obj/docking_port/mobile/shuttle
	///State of the shuttle: idle, flying, docking, or undocking
	var/state = SHIP_IDLE
	///The time the shuttle started launching
	var/dock_change_start_time
	///Vessel approximate mass
	var/mass
	///Vessel estimated thrust
	var/est_thrust
	///The current speed in x/y direction (in grid squares per... second?)
	var/speed = list(0,0)
	///Max possible speed (PLACEHOLDER)
	var/max_speed = 1/(1 SECONDS)
	///Minimum speed. Any lower is rounded down.
	var/min_speed = 1/(2 MINUTES)
	///The last time the vessel moved
	var/last_movement = list(0,0)
	///icon_state that's shown when the vessel is moving
	var/moving_state = "ship_moving"
	///Suffix of the icon_state that's shown when the vessel is damaged. Omit to disable damaged states.
	var/damaged_state
	///List of weapons/utility modules (currently unused)
	var/list/modules
	///Direction the thrusters will repeatedly thrust in
	var/locked_dir

/obj/structure/overmap/ship/Initialize(mapload, _id, _shuttle = null)
	. = ..()
	LAZYADD(SSovermap.ships, src)
	if(_shuttle)
		shuttle = _shuttle

/**
  * Called by SSovermap, this ensures that SSshuttle will be available for getting shuttles.
  */
/obj/structure/overmap/ship/proc/initial_load()
	if(istype(loc, /obj/structure/overmap))
		docked = loc
	if(!shuttle)
		shuttle = SSshuttle.getShuttle(id)
	if(shuttle)
		name = shuttle.name
		calculate_mass()
		refresh_engines()

/obj/structure/overmap/ship/recieve_damage(amount)
	. = ..()
	update_icon_state()
	if(integrity > 0)
		return
	if(docked) //what even
		return
	for(var/MN in GLOB.mob_living_list)
		var/mob/M = MN
		if(shuttle.is_in_shuttle_bounds(M))
			if(M.stat <= HARD_CRIT) //Is not in hard crit, or is dead.
				return //MEANT TO BE A RETURN, DO NOT REPLACE WITH CONTINUE, THIS KEEPS IT FROM DELETING THE SHUTTLE WHEN THERE'S CONCIOUS PEOPLE ON
			throw_atom_into_space(M)
	shuttle.jumpToNullSpace()
	qdel(src)

/obj/structure/overmap/ship/Destroy()
	. = ..()
	LAZYREMOVE(SSovermap.ships, src)

/**
  * Acts on the specified option. Used for docking.
  * * user - Mob that started the action
  * * object - Overmap object to act on
  */
/obj/structure/overmap/ship/proc/overmap_object_act(mob/user, obj/structure/overmap/object)
	if(istype(object, /obj/structure/overmap/dynamic))
		var/obj/structure/overmap/dynamic/D = object
		to_chat(user, "<span class='notice'>The \"PREPARING TO DOCK\" indicator begins flashing.")
		var/return_value = D.load_level(shuttle)
		return return_value || dock(D) //If a value is returned from load_level(), say that, otherwise, commence docking
	else if(istype(object, /obj/structure/overmap/level))
		return dock(object)
	else if(istype(object, /obj/structure/overmap/event))
		var/obj/structure/overmap/event/E = object
		return E.ship_act(user, src)

/**
  * Docks the shuttle by requesting a port at the requested spot.
  * * to_dock - The [/obj/structure/overmap] to dock to.
  */
/obj/structure/overmap/ship/proc/dock(obj/structure/overmap/to_dock)
	if(!is_still())
		return "Ship must be stopped to dock!"
	var/dock_to_use
	if(SSshuttle.getDock("[id]_[to_dock.id]"))
		dock_to_use = SSshuttle.getDock("[id]_[to_dock.id]")
	else if(SSshuttle.getDock("[DEFAULT_OVERMAP_DOCK_PREFIX]_[to_dock.id]"))
		dock_to_use = SSshuttle.getDock("[DEFAULT_OVERMAP_DOCK_PREFIX]_[to_dock.id]")
	else
		return "Error finding valid docking port!"
	if(!shuttle.check_dock(dock_to_use, TRUE))
		return "Error with docking port. Try using a docking computer if possible."
	shuttle.request(dock_to_use)
	docked = to_dock

	dock_change_start_time = world.time + shuttle.ignitionTime
	state = SHIP_DOCKING
	return "Commencing docking..."

/**
  * Undocks the shuttle by launching the shuttle with no destination (this causes it to remain in transit)
  */
/obj/structure/overmap/ship/proc/undock()
	if(!is_still()) //how the hell is it even moving (is the question I've asked multiple times)
		return "Ship must be stopped to undock!"
	if(!docked)
		return "Ship not docked!"
	if(!shuttle)
		return "Shuttle not found!"
	shuttle.destination = null
	shuttle.mode = SHUTTLE_IGNITING
	shuttle.setTimer(shuttle.ignitionTime)
	dock_change_start_time = world.time + shuttle.ignitionTime
	state = SHIP_UNDOCKING
	return "Beginning undocking procedures..."

/**
  * Burns the engines in one direction, accelerating in that direction.
  * If no dir variable is provided, it decelerates the vessel.
  * * n_dir - The direction to move in
  */
/obj/structure/overmap/ship/proc/burn_engines(n_dir = null, percentage = 100)
	if(state != SHIP_FLYING)
		return

	var/thrust_used = 0 //The amount of thrust that the engines will provide with one burn
	refresh_engines()
	if(!mass)
		calculate_mass()
	for(var/obj/machinery/power/shuttle/engine/E in shuttle.engine_list)
		if(!E.enabled)
			continue
		thrust_used = E.burn_engine(percentage)
	est_thrust = thrust_used //cheeky way of rechecking the thrust, check it every time it's used
	thrust_used = thrust_used / max(mass * 100, 100) //do not know why this minimum check is here, but I clearly ran into an issue here before
	if(n_dir)
		accelerate(n_dir, thrust_used)
	else
		decelerate(thrust_used)

/**
  * Just double checks all the engines on the shuttle
  */
/obj/structure/overmap/ship/proc/refresh_engines()
	var/calculated_thrust
	for(var/obj/machinery/power/shuttle/engine/E in shuttle.engine_list)
		E.update_engine()
		calculated_thrust += E.thrust
	est_thrust = calculated_thrust

/**
  * Calculates the mass based on the amount of turfs in the shuttle's areas
  */
/obj/structure/overmap/ship/proc/calculate_mass()
	. = 0
	var/list/areas = shuttle.shuttle_areas
	for(var/shuttleArea in areas)
		. += length(get_area_turfs(shuttleArea))
	mass = .

/**
  * Proc called after a shuttle is moved, used for checking a ship's location when it's moved manually (E.G. calling the mining shuttle via a console)
  */
/obj/structure/overmap/ship/proc/check_loc()
	var/docked_object = SSovermap.get_overmap_object_by_z(shuttle.z)
	if(docked_object == loc) //The docked object is correct, move along
		return TRUE
	if(!docked_object && !docked) //The shuttle is in transit, and the ship is not docked to anything, move along
		return TRUE
	if(state == SHIP_DOCKING || state == SHIP_UNDOCKING)
		return
	if(docked && !docked_object) //The overmap object thinks it's docked to something, but it really isn't. Move to a random tile on the overmap
		if(istype(docked, /obj/structure/overmap/dynamic))
			var/obj/structure/overmap/dynamic/D = docked
			D.unload_level()
		forceMove(SSovermap.get_unused_overmap_square())
		docked = null
		return FALSE
	if(!docked && docked_object) //The overmap object thinks it's NOT docked to something, but it actually is. Move to the correct place.
		forceMove(docked_object)
		docked = docked_object
		return FALSE


/* BEWARE ALL YE WHO PASS THIS LINE */
// This code needs to be reworked before it gets merged. I'm serious.

/**
  * Returns whether or not the ship is moving in any direction.
  */
/obj/structure/overmap/ship/proc/is_still()
	return !MOVING(speed[1]) && !MOVING(speed[2])

/**
  * Handles all movement, called by the SSovermap subsystem
  */
/obj/structure/overmap/ship/proc/process_movement()
	if(docked && integrity < initial(integrity))
		integrity++
	if((state == SHIP_DOCKING || state == SHIP_UNDOCKING) && (world.time >= dock_change_start_time)) //Handler for undocking and docking timer
		switch(state)
			if(SHIP_DOCKING) //so that the shuttle is truly docked first
				if(shuttle.mode == SHUTTLE_DOCKED || shuttle.mode == SHUTTLE_IDLE)
					Move(docked)
					state = SHIP_IDLE
			if(SHIP_UNDOCKING)
				if(docked)
					Move(get_turf(docked))
					if(istype(docked, /obj/structure/overmap/dynamic))
						var/obj/structure/overmap/dynamic/D = docked
						D.unload_level()
					docked = null
					state = SHIP_FLYING
	if(locked_dir)
		burn_engines(locked_dir)
	if(!is_still() && !docked)
		var/list/deltas = list(0,0)
		for(var/i=1, i<=2, i++)
			if(MOVING(speed[i]) && world.time > last_movement[i] + 1/abs(speed[i]))
				deltas[i] = SIGN(speed[i])
				last_movement[i] = world.time
		var/turf/newloc = locate(x + deltas[1], y + deltas[2], z)
		if(newloc)
			Move(newloc)
		update_icon()

/**
  * Returns the total speed in all directions.
  */
/obj/structure/overmap/ship/proc/get_speed()
	return round(sqrt(speed[1] ** 2 + speed[2] ** 2), SHIP_MOVE_RESOLUTION) / 2

/**
  * Returns the direction the ship is moving in terms of dirs
  */
/obj/structure/overmap/ship/proc/get_heading()
	var/direction = 0
	if(MOVING(speed[1]))
		if(speed[1] > 0)
			direction |= EAST
		else
			direction |= WEST
	if(MOVING(speed[2]))
		if(speed[2] > 0)
			direction |= NORTH
		else
			direction |= SOUTH
	return direction

/**
  * Returns the estimated time in seconds to the next tile at current speed
  */
/obj/structure/overmap/ship/proc/get_eta()
	var/eta = INFINITY
	for(var/i=1, i<=2, i++)
		if(MOVING(speed[i]))
			eta = min(last_movement[i] - world.time + 1/abs(speed[i]), eta)
	return max(eta, 0)

/**
  * Change the speed in any direction.
  * * n_x - Speed in the X direction to change
  * * n_y - Speed in the Y direction to change
  */
/obj/structure/overmap/ship/proc/adjust_speed(n_x, n_y)
	CHANGE_SPEED_BY(speed[1], n_x)
	CHANGE_SPEED_BY(speed[2], n_y)
	update_icon()

/**
  * Change the speed in a specified dir.
  * * direction - dir to accelerate in (NORTH, SOUTH, SOUTHEAST, etc.)
  * * acceleration - How much to accelerate by
  */
/obj/structure/overmap/ship/proc/accelerate(direction, acceleration)
	if(direction & EAST)
		adjust_speed(acceleration, 0)
	if(direction & WEST)
		adjust_speed(-acceleration, 0)
	if(direction & NORTH)
		adjust_speed(0, acceleration)
	if(direction & SOUTH)
		adjust_speed(0, -acceleration)

/**
  * Reduce the speed or stop in all directions.
  * * acceleration - How much to decelerate by
  */
/obj/structure/overmap/ship/proc/decelerate(acceleration)
	if(((speed[1]) || (speed[2])))
		if (speed[1])
			adjust_speed(-SIGN(speed[1]) * min(acceleration, abs(speed[1])), 0)
		if (speed[2])
			adjust_speed(0, -SIGN(speed[2]) * min(acceleration, abs(speed[2])))

/obj/structure/overmap/ship/Bump(atom/A)
	if(istype(A, /turf/open/overmap/edge))
		handle_wraparound()
	..()

/**
  * Check if the ship is flying into the border of the overmap.
  */
/obj/structure/overmap/ship/proc/handle_wraparound()
	var/nx = x
	var/ny = y
	var/low_edge = 2
	var/high_edge = SSovermap.size - 1

	if((dir & WEST) && x == low_edge)
		nx = high_edge
	else if((dir & EAST) && x == high_edge)
		nx = low_edge
	if((dir & SOUTH)  && y == low_edge)
		ny = high_edge
	else if((dir & NORTH) && y == high_edge)
		ny = low_edge
	if((x == nx) && (y == ny))
		return //we're not flying off anywhere

	var/turf/T = locate(nx,ny,z)
	if(T)
		forceMove(T)

/obj/structure/overmap/ship/update_icon_state()
	if(!is_still())
		icon_state = moving_state
		dir = get_heading()
	else
		icon_state = initial(icon_state)
	if(damaged_state && integrity < initial(integrity) / 4)
		icon_state = "[icon_state]_[damaged_state]"

/* YE OLDE LINE OF WARNING ENDS HERE */

/obj/structure/overmap/ship/rendered
	render_map = TRUE

/obj/structure/overmap/ship/shuttle
	name = "overmap shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	damaged_state = "damaged"

/obj/structure/overmap/ship/shuttle/rendered
	render_map = TRUE

#undef SHIP_IDLE
#undef SHIP_FLYING
#undef SHIP_DOCKING
#undef SHIP_UNDOCKING

#undef MOVING
#undef SANITIZE_SPEED
#undef CHANGE_SPEED_BY
