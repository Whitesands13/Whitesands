/obj/machinery/deepcore/hopper
	name = "Bluespace Material Hopper"
	desc = "A machine designed to recieve the output of any bluespace drills connected to its network."
	icon_state = "hopper_off"
	density = TRUE
	idle_power_usage = 5
	active_power_usage = 50
	anchored = FALSE

	var/active = FALSE
	var/list/ore_contained = list()

/obj/machinery/deepcore/hopper/interact(mob/user, special_state)
	. = ..()
	if(active)
		active = FALSE
		use_power = 1 //Use idle power
		to_chat(user, "<span class='notice'>You deactiveate [src]</span>")
	else
		if(!network && !length(ore_contained))
			to_chat(user, "<span class='warning'>Unable to activate [src]! No ore located for processing.</span>")
		else if(!powered(power_channel))
			to_chat(user, "<span class='warning'>Unable to activate [src]! Insufficient power.</span>")
		else
			active = TRUE
			use_power = 2 //Use active power
			to_chat(user, "<span class='notice'>You activeate \the [src]</span>")
	update_icon_state()

/obj/machinery/deepcore/hopper/process()
	if((!network && !length(ore_contained)) || !anchored)
		active = FALSE
		update_icon_state()
	if(active)
		if(network)
			network.Pull(ore_contained)
		for(var/O in ore_contained)
			dropOre(O, ore_contained[O])

/obj/machinery/deepcore/hopper/proc/dropOre(obj/item/stack/ore/O, amount)
	if(ore_contained[O] > amount)
		ore_contained[O] -= amount
	else if(ore_contained[O] == amount)
		ore_contained -= O
	else
		return 0
	new O(get_step(src, dir), amount, TRUE)
	return amount

/obj/machinery/deepcore/hopper/update_icon_state()
	if(powered(power_channel) && anchored)
		if(active)
			icon_state = "hopper_on"
		else
			icon_state = "hopper_off"
	else
		icon_state = "hopper_nopower"

/obj/machinery/deepcore/hopper/can_be_unfasten_wrench(mob/user, silent)
	if(active)
		to_chat(user, "<span class='warning'>Turn \the [src] off first!</span>")
		return FAILED_UNFASTEN
	return ..()

/obj/machinery/deepcore/hopper/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	if(default_unfasten_wrench(user, I))
		update_icon_state()
		return TRUE

/obj/machinery/deepcore/hopper/anchored
	anchored = 1
