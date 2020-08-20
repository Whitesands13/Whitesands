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


	///The current speed in x/y direction (in grid squares per... second?)
	var/speed = list(0,0)
	///Max possible speed (PLACEHOLDER)
	var/max_speed = 1/(1 SECONDS)
	///Minimum speed. Any lower is rounded down.
	var/min_speed = 1/(2 MINUTES)
	///The last time the vessel moved
	var/last_movement = list(0,0)
	///Acceleration (PLACEHOLDER)
	var/acceleration = 1/(30 SECONDS)
	///icon_state that's shown when the vessel is moving
	var/moving_state = "ship_moving"

	var/burn_delay = 0.5 SECONDS

/obj/structure/overmap/ship/Initialize(mapload, _id)
	. = ..()
	SSovermap.ships += src
	shuttle = SSshuttle.getShuttle(id)
	if(istype(loc, /obj/structure/overmap))
		docked = loc
	if(shuttle)
		name = shuttle.name

/obj/structure/overmap/ship/Destroy()
	. = ..()
	SSovermap.ships -= src

/obj/structure/overmap/ship/proc/dock(obj/structure/overmap/to_dock)
	if(!is_still())
		return "Ship must be stopped to dock!"
	var/dock_to_use
	if(SSshuttle.getDock("[id]_[to_dock.id]"))
		dock_to_use = SSshuttle.getDock("[id]_[to_dock.id]")
	else if(SSshuttle.getDock("whiteship_[to_dock.id]"))
		dock_to_use = SSshuttle.getDock("[id]_[to_dock.id]")
	else
		return "Error finding valid docking port!"

	shuttle.request(dock_to_use)
	docked = to_dock

	dock_change_start_time = world.time + shuttle.ignitionTime
	state = SHIP_DOCKING
	return "Commencing docking..."

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

/obj/structure/overmap/ship/proc/is_still()
	return !MOVING(speed[1]) && !MOVING(speed[2])

/obj/structure/overmap/ship/process()
	..()
	if((world.time >= dock_change_start_time)) //Handler for undocking and docking timer
		switch(state)
			if(SHIP_DOCKING)
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
			handle_wraparound()
		update_icon()

/obj/structure/overmap/ship/proc/get_speed()
	return round(sqrt(speed[1] ** 2 + speed[2] ** 2), SHIP_MOVE_RESOLUTION)

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
	var/eta
	for(var/i=1, i<=2, i++)
		if(MOVING(speed[i]))
			eta = min(last_movement[i] - world.time + 1/abs(speed[i]), eta)
	return max(eta, 0)

/obj/structure/overmap/ship/proc/adjust_speed(n_x, n_y)
	CHANGE_SPEED_BY(speed[1], n_x)
	CHANGE_SPEED_BY(speed[2], n_y)
	update_icon()

/obj/structure/overmap/ship/proc/accelerate(direction, target)
	if(direction & EAST)
		adjust_speed(min(acceleration, target - acceleration), 0)
	if(direction & WEST)
		adjust_speed(max(-acceleration, target + acceleration), 0)
	if(direction & NORTH)
		adjust_speed(0, min(acceleration, target - acceleration))
	if(direction & SOUTH)
		adjust_speed(0, max(-acceleration, target + acceleration))

/obj/structure/overmap/ship/proc/decelerate()
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

/obj/structure/overmap/ship/update_icon()
	if(!is_still())
		icon_state = moving_state
		dir = get_heading()
	else
		icon_state = initial(icon_state)

/obj/structure/overmap/ship/rendered
	render_map = TRUE

#undef SHIP_IDLE
#undef SHIP_FLYING
#undef SHIP_DOCKING
#undef SHIP_UNDOCKING

#undef MOVING
#undef SANITIZE_SPEED
#undef CHANGE_SPEED_BY
