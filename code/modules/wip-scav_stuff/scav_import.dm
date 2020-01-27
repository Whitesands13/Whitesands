/obj/machinery/scav_buying
	name = "Import pad"
	icon = 'icons/obj/telescience.dmi'
	icon_state = "lpad-idle-o"
	var/idle_state = "lpad-idle-o"
	var/warmup_state = "lpad-idle"
	var/sending_state = "lpad-beam"

/obj/machinery/scav_buying/multitool_act(mob/living/user, obj/item/multitool/I)
	if (istype(I))
		to_chat(user, "<span class='notice'>You register \the [src] in [I]'s buffer.</span>")
		I.buffer = src
		return TRUE


/obj/machinery/computer/cargo/scav
	name = "supply console"
	desc = "Used to buy equipmen and technology from the scav marketplace."
	icon_screen = "supply"
	circuit = /obj/item/circuitboard/computer/cargo
	var/obj/machinery/scav_buing/pad
	var/scav_import_id
	ui_x = 780
	ui_y = 750

/obj/machinery/computer/cargo/scav/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/scav_selling_control/multitool_act(mob/living/user, obj/item/multitool/I)
	if (istype(I) && istype(I.buffer,/obj/machinery/scav_selling))
		to_chat(user, "<span class='notice'>You link [src] with [I.buffer] in [I] buffer.</span>")
		pad = I.buffer
		updateDialog()
		return TRUE

/obj/machinery/computer/scav_selling_control/LateInitialize()
	. = ..()
	if(scav_import_id)
		for(var/obj/machinery/scav_selling/P in GLOB.machines)
			if(P.scav_import_id == scav_import_id)
				pad = P
				return
	else
		pad = locate() in range(4,src)

/obj/machinery/computer/cargo/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, \
											datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "cargo", name, ui_x, ui_y, master_ui, state)
		ui.open()

/obj/machinery/computer/cargo/ui_data()
	var/list/data = list()
	var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_SCA)
	if(D)
		data["points"] = D.account_balance
	data["cart"] = list()
	for(var/datum/supply_order/SO in SSscav.shoppinglist)
		data["cart"] += list(list(
			"object" = SO.pack.name,
			"cost" = SO.pack.cost,
			"id" = SO.id,
			"orderer" = SO.orderer,
			"paid" = !isnull(SO.paying_account) //paid by requester
		))

	return data

/obj/machinery/computer/cargo/ui_static_data(mob/user)
	var/list/data = list()
	data["requestonly"] = requestonly
	data["supplies"] = list()
	for(var/pack in SSscav.scav_packs)
		var/datum/supply_pack/P = SSscav.scav_packs[pack]
		if(!data["supplies"][P.group])
			data["supplies"][P.group] = list(
				"name" = P.group,
				"packs" = list()
			)
		if((P.hidden && !(obj_flags & EMAGGED)) || (P.contraband && !contraband) || (P.special && !P.special_enabled) || P.DropPodOnly)
			continue
		data["supplies"][P.group]["packs"] += list(list(
			"name" = P.name,
			"cost" = P.cost,
			"id" = pack,
			"desc" = P.desc || P.name, // If there is a description, use it. Otherwise use the pack's name.
			"small_item" = P.small_item,
			"access" = P.access
		))
	return data

