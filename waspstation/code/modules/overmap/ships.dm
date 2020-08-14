#define SHIP_MOVE_RESOLUTION 0.00001
#define MOVING(speed) abs(speed) >= min_speed
#define SANITIZE_SPEED(speed) SIGN(speed) * clamp(abs(speed), 0, max_speed)
#define CHANGE_SPEED_BY(speed_var, v_diff) \
	v_diff = SANITIZE_SPEED(v_diff);\
	if(!MOVING(speed_var + v_diff)) \
		{speed_var = 0};\
	else \
		{speed_var = SANITIZE_SPEED((speed_var + v_diff)/(1 + speed_var*v_diff/(max_speed ** 2)))}

/obj/structure/overmap
	name = "overmap object"
	desc = "A spacefaring vessel."
	icon = 'waspstation/icons/effects/overmap.dmi'
	icon_state = "ship"
	///The current speed in x,y direction (in grid squares per second)
	var/speed = list(0,0)
	///Max possible speed (PLACEHOLDER)
	var/max_speed = 1/(1 SECONDS)
	///Minimum speed. Any lower is rounded down.
	var/min_speed = 1/(2 MINUTES)
	///The last time the vessel moved
	var/last_movement = list(0,0)
	///TRUE if the vessel is currently slowing and stopping.
	var/decelerating = FALSE
	///TRUE if the vessel is currently speeding up.
	var/accelerating = FALSE
	///Should this vessel be immobile?
	var/stationary = FALSE
	///The helm currently controlling the vessel
	var/obj/machinery/computer/helm/helm
	///The current range of sensors (subject to be relegated to something else)
	var/sensor_range = 4
	///ID
	var/id ="main"
	///Acceleration (PLACEHOLDER)
	var/acceleration = 1/(30 SECONDS)
	///icon_state that's shown when the vessel is moving
	var/moving_state = "ship_moving"

	var/burn_delay = 0.5 SECONDS

/obj/structure/overmap/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/overmap/LateInitialize()
	. = ..()
	SSovermap.ships += src
	START_PROCESSING(SSovermap, src)

/obj/structure/overmap/Destroy()
	. = ..()
	SSovermap.ships -= src
	STOP_PROCESSING(SSovermap, src)

/obj/structure/overmap/proc/is_still()
	return !MOVING(speed[1]) && !MOVING(speed[2])

/obj/structure/overmap/process()
	if(!stationary && !is_still())
		var/list/deltas = list(0,0)
		for(var/i=1, i<=2, i++)
			if(MOVING(speed[i]) && world.time > last_movement[i] + 1/abs(speed[i]))
				deltas[i] = SIGN(speed[i])
				last_movement[i] = world.time
		var/turf/newloc = locate(x + deltas[1], y + deltas[2], z)
		if(newloc)
			Move(newloc)
			helm?.update_location()
			handle_wraparound()
		update_icon()

/obj/structure/overmap/proc/get_speed()
	return round(sqrt(speed[1] ** 2 + speed[2] ** 2), SHIP_MOVE_RESOLUTION)

/obj/structure/overmap/proc/get_heading()
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

/obj/structure/overmap/proc/get_eta()
	var/eta = null
	for(var/i=1, i<=2, i++)
		if(MOVING(speed[i]))
			eta = min(last_movement[i] - world.time + 1/abs(speed[i]), .)
	return max(eta, 0)

/obj/structure/overmap/proc/adjust_speed(n_x, n_y)
	CHANGE_SPEED_BY(speed[1], n_x)
	CHANGE_SPEED_BY(speed[2], n_y)
	update_icon()

/obj/structure/overmap/proc/accelerate(direction, target)
	if(direction & EAST)
		adjust_speed(min(acceleration, target - acceleration), 0)
	if(direction & WEST)
		adjust_speed(max(-acceleration, target + acceleration), 0)
	if(direction & NORTH)
		adjust_speed(0, min(acceleration, target - acceleration))
	if(direction & SOUTH)
		adjust_speed(0, max(-acceleration, target + acceleration))

/obj/structure/overmap/proc/decelerate(target)
	if(((speed[1]) || (speed[2])))
		if (speed[1])
			adjust_speed(-SIGN(speed[1]) * min(acceleration, abs(speed[1])), 0)
		if (speed[2])
			adjust_speed(0, -SIGN(speed[2]) * min(acceleration, abs(speed[2])))

/obj/structure/overmap/Bump(atom/A)
	if(istype(A, /turf/open/overmap/edge))
		handle_wraparound()
	..()

/obj/structure/overmap/proc/handle_wraparound()
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

/obj/structure/overmap/update_icon()
	if(!is_still())
		icon_state = moving_state
		dir = get_heading()
	else
		icon_state = initial(icon_state)

#undef MOVING
#undef SANITIZE_SPEED
#undef CHANGE_SPEED_BY
