/obj/item/scav_uplink
	name = "Scav Uplink"
	icon = 'icons/obj/blackmarket.dmi'
	icon_state = "uplink"

	// UI variables.
	var/ui_x = 720
	var/ui_y = 480
	var/viewing_category
	var/viewing_market
	var/selected_item
	var/buying

	/// How much money is inserted into the uplink.
	var/datum/money = 0
	/// List of typepaths for "/datum/scav_market"s that this uplink can access.
	var/list/accessible_markets = list(/datum/scav_market/scavmarket)

/obj/item/scav_uplink/Initialize()
	. = ..()
	if(accessible_markets.len)
		viewing_market = accessible_markets[1]
		var/list/categories = SSscav.markets[viewing_market].categories
		if(categories && categories.len)
			viewing_category = categories[1]

/obj/item/scav_uplink/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "scav_uplink", name, ui_x, ui_y, master_ui, state)
		ui.open()

/obj/item/scav_uplink/ui_data(mob/user)
	var/list/data = list()
	var/datum/scav_market/market = viewing_market ? SSscav.markets[viewing_market] : null
	data["categories"] = market ? market.categories : null
	data["delivery_methods"] = list()
	if(market)
		for(var/delivery in market.shipping)
			data["delivery_methods"] += list(list("name" = delivery, "price" = market.shipping[delivery]))
	var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_SCA)
	if(D)
		data["money"] = D.account_balance
	data["buying"] = buying
	data["items"] = list()
	data["viewing_category"] = viewing_category
	data["viewing_market"] = viewing_market
	if(viewing_category && market)
		if(market.available_items[viewing_category])
			for(var/datum/scavmarket_item/I in market.available_items[viewing_category])
				data["items"] += list(list(
					"id" = I.type,
					"name" = I.name,
					"cost" = I.price,
					"amount" = I.stock,
					"desc" = I.desc || I.name
				))
	return data

/obj/item/scav_uplink/ui_static_data(mob/user)
	var/list/data = list()
	data["delivery_method_description"] = SSscav.shipping_method_descriptions_scav
	data["scav_imp_built"] = SSscav.telepads.len
	data["markets"] = list()
	for(var/M in accessible_markets)
		var/datum/scav_market/BM = SSscav.markets[M]
		data["markets"] += list(list(
			"id" = M,
			"name" = BM.name
		))
	return data

/obj/item/scav_uplink/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("set_category")
			if(isnull(params["category"]))
				return
			if(isnull(viewing_market))
				return
			if(!(params["category"] in SSscav.markets[viewing_market].categories))
				return
			viewing_category = params["category"]
			. = TRUE
		if("set_market")
			if(isnull(params["market"]))
				return
			var/market = text2path(params["market"])
			if(!(market in accessible_markets))
				return

			viewing_market = market

			var/list/categories = SSscav.markets[viewing_market].categories
			if(categories && categories.len)
				viewing_category = categories[1]
			else
				viewing_category = null
			. = TRUE
		if("cancel")
			selected_item = null
			buying = FALSE
			. = TRUE
		if("buy")
			if(isnull(params["item"]))
				return
			var/item = text2path(params["item"])
			selected_item = item
			buying = TRUE
			var/datum/scav_market/market = SSscav.markets[viewing_market]
			market.purchase(selected_item, viewing_category, SHIPPING_METHOD_SCAV, src, usr)

			buying = FALSE
			selected_item = null

