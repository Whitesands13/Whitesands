SUBSYSTEM_DEF(scav)
	name		 = "Scav"
	flags		 = SS_BACKGROUND
	init_order	 = INIT_ORDER_DEFAULT

	/// Descriptions for each shipping methods.
	var/shipping_method_descriptions = list(
		SHIPPING_METHOD_SCAV="Long-To-Short-Range-Bluespace-Transceiver, a machine that recieves items outside the station and then teleports them to the location of the uplink.",
	)

	/// List of all existing markets.
	var/list/datum/scav_market/markets					= list()
	/// List of existing ltsrbts.
	var/list/obj/machinery/scav_imp/telepads			= list()
	/// Currently queued purchases.
	var/list/queued_purchases 							= list()

/datum/controller/subsystem/scav/Initialize(timeofday)
	for(var/market in subtypesof(/datum/scav_market))
		markets[market] += new market

	for(var/item in subtypesof(/datum/scavmarket_item))
		var/datum/scavmarket_item/I = new item()
		if(!I.item)
			continue

		for(var/M in I.markets)
			if(!markets[M])
				stack_trace("SSscav: Item [I] available in market that does not exist.")
				continue
			markets[M].add_item(item)
		qdel(I)
	. = ..()

/datum/controller/subsystem/scav/fire(resumed)
	while(length(queued_purchases))
		var/datum/scav_purchase/purchase = queued_purchases[1]
		queued_purchases.Cut(1,2)

		// Uh oh, uplink is gone. We will just keep the money and you will not get your order.
		if(!purchase.uplink || QDELETED(purchase.uplink))
			queued_purchases -= purchase
			qdel(purchase)
			continue

		switch(purchase.method)
			// Find a scav_imp pad and make it handle the shipping.
			if(SHIPPING_METHOD_SCAV)
				if(!telepads.len)
					continue
				// Prioritize pads that don't have a cooldown active.
				var/free_pad_found = FALSE
				for(var/obj/machinery/scav_imp/pad in telepads)
					if(pad.recharge_cooldown)
						continue
					pad.add_to_queue(purchase)
					queued_purchases -= purchase
					free_pad_found = TRUE
					break

				if(free_pad_found)
					continue

				var/obj/machinery/scav_imp/pad = pick(telepads)

				to_chat(recursive_loc_check(purchase.uplink.loc, /mob), "<span class='notice'>[purchase.uplink] flashes a message noting that the order is being processed by [pad].</span>")

				queued_purchases -= purchase
				pad.add_to_queue(purchase)
			// Get random area, throw it somewhere there.

		if(MC_TICK_CHECK)
			break

/// Used to make a teleportation effect as do_teleport does not like moving items from nullspace.
/datum/controller/subsystem/scav/proc/fake_teleport(atom/movable/item, turf/target)
	item.forceMove(target)
	var/datum/effect_system/spark_spread/sparks = new
	sparks.set_up(5, 1, target)
	sparks.attach(item)
	sparks.start()

/// Used to add /datum/scav_purchase to queued_purchases var. Returns TRUE when queued.
/datum/controller/subsystem/scav/proc/queue_item(datum/scav_purchase/P)
	if(P.method == SHIPPING_METHOD_SCAV && !telepads.len)
		return FALSE
	queued_purchases += P
	return TRUE
