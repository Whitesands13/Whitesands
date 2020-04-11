/datum/scav_market
	/// Name for the market.
	var/name = "huh?"

	/// Available shipping methods and prices, just leave the shipping method out that you don't want to have.
	var/list/shipping


	// Automatic vars, do not touch these.
	/// Items available from this market, populated by SSblackmarket on initialization.
	var/list/available_items = list()
	/// Item categories available from this market, only items which are in these categories can be gotten from this market.
	var/list/categories	= list()

/// Adds item to the available items and add it's category if it is not in categories yet.
/datum/scav_market/proc/add_item(datum/scavmarket_item/item)
	if(!prob(initial(item.availability_prob)))
		return FALSE

	if(ispath(item))
		item = new item()

	if(!(item.category in categories))
		categories += item.category
		available_items[item.category] = list()

	available_items[item.category] += item
	return TRUE

/// Handles buying the item, this is mainly for future use and moving the code away from the uplink.
/datum/scav_market/proc/purchase(item, category, method, obj/item/scav_uplink/uplink, user)
	message_admins("Purchase called  item [item]  category [category]  method [method]  uplink [uplink]  user [user]")
	if(!istype(uplink) || !(method in shipping))
		message_admins("Failed first if")
		return FALSE

	for(var/datum/scavmarket_item/I in available_items[category])
		message_admins("Entered purchase loop")
		if(I.type != item)
			message_admins("I.type != item")
			continue
		var/price = I.price + shipping[method]
		// I can't get the price of the item and shipping in a clean way to the UI, so I have to do this.
		if(uplink.money < price)
			to_chat("<span class='warning'>You don't have enough credits in [uplink] for [I] with [method] shipping.</span>")
			message_admins("Not enough money")
			return FALSE

		if(I.buy(uplink, user, method))
			message_admins("Purchase success")
			uplink.money -= price
			return TRUE
		message_admins("Purchase reached end")
		return FALSE
	message_admins("Crit Fail")

/datum/scav_market/scavmarket
	name = "Scavmarket"
	shipping = list(SHIPPING_METHOD_SCAV	=50)
