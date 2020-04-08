/datum/scavmarket_item
	/// Name for the item entry used in the uplink.
	var/name
	/// Description for the item entry used in the uplink.
	var/desc
	/// The category this item belongs to, should be already declared in the market that this item is accessible in.
	var/category
	/// "/datum/scav_market"s that this item should be in, used by SSscav on init.
	var/list/markets = list(/datum/scav_market/scavmarket)

	/// Price for the item, if not set creates a price according to the *_min and *_max vars.
	var/price
	/// How many of this type of item is available, if not set creates a price according to the *_min and *_max vars.
	var/stock

	/// Path to or the item itself what this entry is for, this should be set even if you override spawn_item to spawn your item.
	var/item

	/// Minimum price for the item if generated randomly.
	var/price_min	= 0
	/// Maximum price for the item if generated randomly.
	var/price_max	= 0
	/// Minimum amount that there should be of this item in the market if generated randomly. This defaults to 1 as most items will have it as 1.
	var/stock_min	= 1
	/// Maximum amount that there should be of this item in the market if generated randomly.
	var/stock_max	= 0
	/// Probability for this item to be available. Used by SSscav on init.
	var/availability_prob = 0

/datum/scavmarket_item/New()
	if(isnull(price))
		price = rand(price_min, price_max)
	if(isnull(stock))
		stock = rand(stock_min, stock_max)

/// Used for spawning the wanted item, override if you need to do something special with the item.
/datum/scavmarket_item/proc/spawn_item(loc)
	return new item(loc)

/// Buys the item and makes SSscav handle it.
/datum/scavmarket_item/proc/buy(obj/item/blackmarket_uplink/uplink, mob/buyer, shipping_method)
	// Sanity
	if(!istype(uplink) || !istype(buyer))
		return FALSE

	// This shouldn't be able to happen unless there was some manipulation or admin fuckery.
	if(!item || stock <= 0)
		return FALSE

	// Alright, the item has been purchased.
	var/datum/scav_purchase/purchase = new(src, uplink, shipping_method)

	// SSscav takes care of the shipping.
	if(SSscav.queue_item(purchase))
		stock--
		log_game("[key_name(buyer)] has succesfully purchased [name] using [shipping_method] for shipping.")
		return TRUE
	return FALSE

// This exists because it is easier to keep track of all the vars this way.
/datum/scav_purchase
	/// The entry being purchased.
	var/datum/scavmarket_item/entry
	/// Instance of the item being sent.
	var/item
	/// The uplink where this purchase was done from.
	var/obj/item/scav_uplink/uplink
	/// Shipping method used to buy this item.
	var/method

/datum/scav_purchase/New(_entry, _uplink, _method)
	entry = _entry
	if(!ispath(entry.item))
		item = entry.item
	uplink = _uplink
	method = _method
