/obj/machinery/power/bluespace_miner
	name = "bluespace mining machine"
	desc = "A machine that uses the magic of Bluespace to slowly generate materials and add them to a linked ore silo."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "stacker_off"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/bluespace_miner
	layer = BELOW_OBJ_LAYER
	use_power = NO_POWER_USE
	idle_power_usage = 50000

	var/icon_state_on = "stacker"
	var/icon_state_off = "stacker_off"

	var/mining_rate = 10 //Amount of material gained on a mining tick
	var/mining_chance = 30 //Chance a mining tick results in materials gained
	var/powered = FALSE
	var/active = FALSE
	//Ores that can be mined (and their weight)
	var/list/minable_ores = list(/datum/material/iron = 6, /datum/material/glass = 6, /*/datum/material/copper = 0.4,*/)
	var/list/tier2_ores = list(/datum/material/plasma = 2, /datum/material/silver = 3, /datum/material/titanium = 2)
	var/list/tier3_ores = list(/datum/material/gold = 2, /datum/material/uranium = 1)
	var/list/tier4_ores = list(/datum/material/diamond = 1)
	var/datum/component/remote_materials/materials

/obj/machinery/power/bluespace_miner/Initialize(mapload)
	. = ..()
	RefreshParts()
	if(anchored)
		connect_to_network()
	materials = AddComponent(/datum/component/remote_materials, "bsm", mapload)

/obj/machinery/power/bluespace_miner/Destroy()
	materials = null
	return ..()

/obj/machinery/power/bluespace_miner/update_icon_state()
	icon_state = (powered && active) ? icon_state_on : icon_state_off

/obj/machinery/power/bluespace_miner/RefreshParts()
	var/M_C = 0 //mining_chance
	var/P_U = 5000000 //idle_power_usage
	for(var/obj/item/stock_parts/scanning_module/SM in component_parts)
		if (SM.rating > 1)
			minable_ores |= tier2_ores
		if (SM.rating > 2)
			minable_ores |= tier3_ores
		if(SM.rating > 3)
			minable_ores |= tier4_ores
	for(var/obj/item/stock_parts/micro_laser/ML in component_parts)
		mining_rate = 10 ** (ML.rating)
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		M_C += sqrt(M.rating) * 16
	mining_chance = M_C
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		P_U -= 3 * (MB.rating + 1) ** 5

/obj/machinery/power/bluespace_miner/examine(mob/user)
	. = ..()
	if(anchored)
		. += "<span class='info'>It's currently anchored to the floor, you can unsecure it with a <b>wrench</b>.</span>"
	else
		. += "<span class='info'>It's not anchored to the floor. You can secure it in place with a <b>wrench</b>.</span>"
	if(in_range(user, src) || isobserver(user))
		if(!materials?.silo)
			. += "<span class='notice'>No ore silo connected. Use a multi-tool to link an ore silo to this machine.</span>"
		else if(materials?.on_hold())
			. += "<span class='warning'>Ore silo access is on hold, please contact the quartermaster.</span>"
		if(!active)
			. += "<span class='notice'>Its status display is currently turned off.</span>"
		else if(!powered)
			. += "<span class='notice'>Its status display is glowing faintly.</span>"
		else
			. += "<span class='notice'>Its status display reads: Mining with [mining_chance]% efficiency.</span>"
			. += "<span class='notice'>Power consumption at <b>[DisplayPower(idle_power_usage)]</b>.</span>"

/obj/machinery/power/bluespace_miner/interact(mob/user)
	add_fingerprint(user)
	if(anchored)
		if(!powernet)
			to_chat(user, "<span class='warning'>\The [src] isn't connected to a wire!</span>")
			return TRUE
		if(active)
			active = FALSE
			to_chat(user, "<span class='notice'>You turn off the [src].</span>")
		else
			active = TRUE
			to_chat(user, "<span class='notice'>You turn on the [src].</span>")
		update_icon()
	else
		to_chat(user, "<span class='warning'>[src] needs to be firmly secured to the floor first!</span>")
		return TRUE

/obj/machinery/power/bluespace_miner/process()
	if(!materials?.silo || materials?.on_hold())
		return
	if(!materials.mat_container || panel_open)
		return
	if(!anchored || (!powernet && idle_power_usage))
		active = FALSE
		update_icon()
		return
	if(active)
		if(!idle_power_usage || surplus() >= idle_power_usage)
			add_load(idle_power_usage)
			if(!powered)
				powered = TRUE
				update_icon()
			if(prob(mining_chance))
				mine()
		else
			if(powered)
				powered = FALSE
				update_icon()
			return

/obj/machinery/power/bluespace_miner/can_be_unfasten_wrench(mob/user, silent)
	if(active)
		to_chat(user, "<span class='warning'>Turn \the [src] off first!</span>")
		return FAILED_UNFASTEN
	return ..()

/obj/machinery/power/bluespace_miner/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I)
	if(anchored)
		connect_to_network()
	else
		disconnect_from_network()
	return TRUE

/obj/machinery/power/bluespace_miner/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	default_deconstruction_screwdriver(user, icon_state, icon_state_off, I)
	return TRUE

/obj/machinery/power/bluespace_miner/crowbar_act(mob/living/user, obj/item/I)
	default_deconstruction_crowbar(I)
	return TRUE

/obj/machinery/power/bluespace_miner/proc/mine()
	var/datum/material/ore = pickweight(minable_ores)
	materials.mat_container.insert_amount_mat((mining_rate), ore)
