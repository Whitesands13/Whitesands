#define GATEWAY_DEST_ANOTHER_UNIVERSE "cataclysm_another_universe"

/datum/station_goal/spatial_emmigration
	name = "Emergency Spatial Emmigration"

/datum/gateway_destination/point/another_universe
	id = GATEWAY_DEST_ANOTHER_UNIVERSE
	var/target_gateway

/datum/gateway_destination/point/another_universe/New()
	if (GLOB.another_universe_dest != null)
		return GLOB.another_universe_dest
	GLOB.another_universe_dest = src

/obj/effect/landmark/another_universe

/obj/effect/landmark/another_universe/Initialize()
	. = ..()
	var/datum/gateway_destination/point/another_universe/current
	current = GLOB.another_universe_dest
	if(!current)
		current = new
	current.target_turfs += get_turf(src)

GLOBAL_DATUM(another_universe_dest, /datum/gateway_destination/point/another_universe)

/obj/machinery/gateway/bs_evac_gateway
	icon = 'waspstation/icons/obj/machines/evac_gateway.dmi'
	desc = "A high-tech interdimensional portal to the multiverse, and your salvation from the Apocalypse. You have no idea where this could lead..."
	var/transited_players = list()
	critical_machine = TRUE
	circuit = /obj/item/circuitboard/machine/bs_evac_gateway

/obj/machinery/gateway/bs_evac_gateway/Initialize()
	use_power = NO_POWER_USE
	destination_type = /datum/gateway_destination/point/another_universe
	destination_name = "Another Universe"
	return ..()

/obj/machinery/gateway/bs_evac_gateway/multitool_act(mob/living/user, obj/item/I)
	if(can_interact(user))
		activate()

/obj/machinery/gateway/bs_evac_gateway/activate()
	if(target)
		return
	var/datum/gateway_destination/point/another_universe/AU = GLOB.another_universe_dest
	if (!istype(AU))
		CRASH("Failed to configure destination for another universe!")
	target = AU
	generate_bumper()
	update_icon()

/obj/machinery/gateway/bs_evac_gateway/deactivate()
	return // No brakes on this train!

/obj/machinery/gateway/bs_evac_gateway/process()
	return

/obj/machinery/gateway/bs_evac_gateway/Transfer(atom/movable/AM)
	if(ismob(AM))
		var/mob/M = AM
		if(M.client)
			transited_players += M.client
	..()

/obj/machinery/gateway/bs_evac_gateway/can_be_unfasten_wrench()
	return FAILED_UNFASTEN
/obj/item/circuitboard/machine/bs_evac_gateway
	name = "Bluespace Evacuation Gateway (Machine Board)"
	icon_state = "command"
	build_path = /obj/machinery/gateway/bs_evac_gateway
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 20,
		/obj/item/stock_parts/subspace/filter = 30,
		/obj/item/stock_parts/subspace/crystal = 10,
		/obj/item/stock_parts/matter_bin/bluespace = 10,
		/obj/item/stock_parts/micro_laser/quadultra = 5,
		/obj/item/stock_parts/manipulator/femto = 3,
		/obj/item/stock_parts/scanning_module/triphasic = 1,
		/obj/item/stack/cable_coil = 30
	)

/datum/supply_pack/emergency/bs_evac_gateway_kit
	name = "Bluespace Evacuation Gateway Kit"
	desc = "Released as part of CASE OMEGA, contains the circuitry for the Bluepsace Evacuation Gateway"
	cost = 10000
	special = TRUE
	contains = list() // TODO
	crate_name = "bluespace evacuation gateway kit"

/datum/station_goal/spatial_emmigration/New()
	..()

/datum/station_goal/spatial_emmigration/get_report()
	return {"<b>A Catastrophic Bluespace Event has occurred within the core worlds.</b>
	 Multiple high level communiques have confirmed a cataclysmic bluespace event has begun rendering all space-time within the local galactic cluser uninhabitable to all forms of life.
	 NT Scientists have determined that this event is irreversable and will require execution of CASE OMEGA.
	 CASE OMEGA instructs all orbital stations to construct Interdimensional Escape Bridges and evacuate through them before the effects of the event reach your station.
	 This is a one way trip. Bring only what is essential to your survival. We do not know what may await you on the other side.
	 Specifications for emergency evacuation equipment is being made available to all NT/SolGov stations in the sector.
	 There will be no further evacuation shuttles. All crew-safe logistical infrastructure has been dedicated to distributing evacuation equipment to underequipped stations.
	 Syndicate Forces are guaranteed to attempt to evacuate through your gate. Ensure they do not succeed.
	 You will have an estimated <b>90 minutes</b> until the cascade event reaches your station.
	 Evacuation Gateway parts are available for shipping via cargo."}

/datum/station_goal/spatial_emmigration/on_report()
	var/datum/supply_pack/P = SSshuttle.supply_packs[/datum/supply_pack/emergency/bs_evac_gateway_kit]
	P.special_enabled = TRUE
	var/datum/game_mode/cataclysm/C = SSticker.mode
	if (!istype(C))
		CRASH("Invalid game_mode [SSticker.mode] for executing start_countdown. Aborting!")
	C.start_countdown()
	set_security_level(SEC_LEVEL_OMEGA)

/datum/station_goal/spatial_emmigration/check_completion()
	if(..())
		return TRUE
	var/list/all_transited_players = list()
	for(var/obj/machinery/gateway/bs_evac_gateway/B in GLOB.machines)
		all_transited_players.Add(B.transited_players)
	for(var/client/C in GLOB.clients)
		if(C in all_transited_players)
			C.set_metacoin_count(C.get_metabalance() * 2, FALSE)
			to_chat(C, "<span class='rose bold'>You have managed to escape the calamity! Your metacoins have double the value here.</span>")
		else
			C.set_metacoin_count(0, FALSE)
			to_chat(C, "<span class='rose bold'>You have been lost to time and space, your metacoin bank has been erased.</span>")
	return all_transited_players >= 1

