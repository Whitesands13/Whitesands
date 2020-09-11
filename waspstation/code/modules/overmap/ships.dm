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

/obj/structure/overmap/ship/Destroy()
	. = ..()
	LAZYREMOVE(SSovermap.ships, src)

/*
/obj/structure/overmap/ship/proc/overmap_act(mob/user, obj/structure/overmap/to_act)
	var/dockable = istype(to_act, /obj/structure/overmap/level)
	var/interactable =
	if(istype(to_act))
*/

/**
  * Docks the shuttle by requesting a port at the requested spot.
  */
/obj/structure/overmap/ship/proc/dock(obj/structure/overmap/to_dock)
	if(!is_still())
		return "Ship must be stopped to dock!"
	var/dock_to_use
	if(SSshuttle.getDock("[id]_[to_dock.id]"))
		dock_to_use = SSshuttle.getDock("[id]_[to_dock.id]")
	else if(SSshuttle.getDock("whiteship_[to_dock.id]")) //TODO: needs to be changed to `default_id`
		dock_to_use = SSshuttle.getDock("whiteship_[to_dock.id]")
	else
		return "Error finding valid docking port!"
	if(!shuttle.check_dock(dock_to_use, TRUE))
		return "Error with docking port. Try using a docking computer if one is available."
	shuttle.request(dock_to_use)
	docked = to_dock

	dock_change_start_time = world.time + shuttle.ignitionTime
	state = SHIP_DOCKING
	return "Commencing docking..."

/**
  * Undocks the shuttle by launching the shuttle with no destination (this causes it to remain in transit)
  */
/obj/structure/overmap/ship/proc/undock()
	if(!is_still()) //how the hell would it even be moving
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
  */
/obj/structure/overmap/ship/proc/burn_engines(n_dir = null)
	var/thrust_used = 0 //The amount of thrust that the engines will provide with one burn
	refresh_engines()
	if(!mass)
		calculate_mass()
	for(var/obj/machinery/shuttle/engine/E in shuttle.engine_list)
		if(!E.enabled)
			continue
		if(E.attached_heater)
			var/obj/machinery/atmospherics/components/unary/shuttle/heater/resolved_heater = E.attached_heater.resolve()
			if(!resolved_heater.hasFuel(E.fuel_use * E.thrust)) //if there's not enough fuel, don't burn
				continue
			resolved_heater.consumeFuel(E.fuel_use * E.thrust)
		E.fireEngine()
		thrust_used = thrust_used + E.thrust
	est_thrust = thrust_used //cheeky way of rechecking the thrust, check it every time it's used
	thrust_used = (thrust_used / 20) / max(mass, 1)
	if(n_dir)
		accelerate(n_dir, thrust_used)
	else
		decelerate(thrust_used)

/**
  * Just double checks all the engines on the shuttle
  */
/obj/structure/overmap/ship/proc/refresh_engines()
	var/calculated_thrust
	for(var/obj/machinery/shuttle/engine/E in shuttle.engine_list)
		E.check_setup()
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

/obj/structure/overmap/ship/proc/check_loc()
	var/docked_object = SSovermap.get_overmap_object_by_z(shuttle.z)
	if(docked_object == loc) //The docked object is correct, move along
		return TRUE
	if(!docked_object && !docked) //The shuttle is in transit, and the ship is not docked to anything, move along
		return TRUE
	if(docked && !docked_object) //The overmap object thinks it's docked to something, but it really isn't. Move to a random tile on the overmap
		Move(SSovermap.get_unused_overmap_square())
		docked = null
		return FALSE
	if(!docked && docked_object) //The overmap object thinks it's NOT docked to something, but it actually is. Move to the correct place.
		Move(docked_object)
		docked = docked_object
		return FALSE


/* BEWARE ALL YE WHO PASS THIS LINE */
// This code needs to be reworked before it gets merged. I'm serious.


/obj/structure/overmap/ship/proc/is_still()
	return !MOVING(speed[1]) && !MOVING(speed[2])

/**
  * Handles all movement, called by the SSovermap subsystem
  */
/obj/structure/overmap/ship/proc/process_movement()
	if(docked && integrity < initial(integrity))
		integrity++
	if((world.time >= dock_change_start_time)) //Handler for undocking and docking timer
		switch(state)
			if(SHIP_DOCKING) //so that the shuttle is truly docked first
				if(shuttle.mode != SHUTTLE_DOCKED)
					return
				Move(docked)
				state = SHIP_IDLE
			if(SHIP_UNDOCKING)
				Move(get_turf(docked))
				docked = null
				state = SHIP_FLYING
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

/obj/structure/overmap/ship/proc/get_speed()
	return round(sqrt(speed[1] ** 2 + speed[2] ** 2), SHIP_MOVE_RESOLUTION) / 2

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

/obj/structure/overmap/ship/proc/get_eta()
	var/eta = INFINITY
	for(var/i=1, i<=2, i++)
		if(MOVING(speed[i]))
			eta = min(last_movement[i] - world.time + 1/abs(speed[i]), eta)
	return max(eta, 0)

/obj/structure/overmap/ship/proc/adjust_speed(n_x, n_y)
	CHANGE_SPEED_BY(speed[1], n_x)
	CHANGE_SPEED_BY(speed[2], n_y)
	update_icon()

/obj/structure/overmap/ship/proc/accelerate(direction, acceleration)
	if(direction & EAST)
		adjust_speed(acceleration, 0)
	if(direction & WEST)
		adjust_speed(-acceleration, 0)
	if(direction & NORTH)
		adjust_speed(0, acceleration)
	if(direction & SOUTH)
		adjust_speed(0, -acceleration)

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

/obj/structure/overmap/ship/proc/handle_wraparound()
	var/nx = x
	var/ny = y
	var/low_edge = 2
	var/high_edge = SSovermap.size

	if((dir & WEST) && x == low_edge)
		nx = high_edge
	else if((dir & EAST) && x == high_edge - 1)
		nx = low_edge
	if((dir & SOUTH)  && y == low_edge)
		ny = high_edge
	else if((dir & NORTH) && y == high_edge - 1)
		ny = low_edge
	if((x == nx) && (y == ny))
		return //we're not flying off anywhere

	var/turf/T = locate(nx,ny,z)
	if(T)
		forceMove(T)

/obj/structure/overmap/ship/update_icon()
	if(!is_still())
		icon_state = moving_state
		dir = get_heading()
	else
		icon_state = initial(icon_state)

/* YE OLDE LINE OF WARNING ENDS HERE */

/obj/structure/overmap/ship/rendered
	render_map = TRUE

/obj/structure/overmap/ship/shuttle
	icon_state = "shuttle"
	moving_state = "shuttle_moving"

/obj/structure/overmap/ship/shuttle/rendered
	render_map = TRUE

#undef SHIP_IDLE
#undef SHIP_FLYING
#undef SHIP_DOCKING
#undef SHIP_UNDOCKING

#undef MOVING
#undef SANITIZE_SPEED
#undef CHANGE_SPEED_BY
