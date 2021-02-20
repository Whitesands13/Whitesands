/area/awaymission/casino
	name = "Casino"
	icon_state = "awaycontent1"
	requires_power = FALSE

/area/awaymission/casino/lounge
	name = "Casino Lounge"
	icon_state = "awaycontent2"

/area/awaymission/casino/announcer
	name = "Casino Announcer"
	icon_state = "awaycontent4"

/area/awaymission/casino/maintenance
	name = "Casino Maintenance"
	icon_state = "awaycontent5"

/area/awaymission/casino/security
	name = "Casino Security"
	icon_state = "awaycontent3"

/area/awaymission/casino/pit
	name = "Casino Pits"
	icon_state = "awaycontent6"

/obj/item/toy/cards/deck/tournament
	icon = 'whitesands/icons/obj/toys.dmi'
	deckstyle = "tournament"
	desc = "A tournament-grade deck of cards, with a gold weave trim to prevent cheating."

/obj/item/toy/cards/singlecard/tournament
	name = "card"
	deckstyle = "tournament"
	desc = "A tournament-grade playing card with a gold weave trim to prevent cheating."
	icon = 'whitesands/icons/obj/toys.dmi'
	icon_state = "singlecard_down_tournament"
	w_class = WEIGHT_CLASS_TINY

/obj/item/toy/cards/cardhand/tournament
	name = "hand of cards"
	desc = "A number of cards not in a deck, customarily held in ones hand."
	icon = 'whitesands/icons/obj/toys.dmi'
	icon_state = "none"
	w_class = WEIGHT_CLASS_TINY
	currenthand = list()
	choice = null

/obj/item/toy/cards/deck/tournament/draw_card(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return
	var/choice = null
	if(cards.len == 0)
		to_chat(user, "<span class='warning'>There are no more cards to draw!</span>")
		return
	var/obj/item/toy/cards/singlecard/tournament/H = new/obj/item/toy/cards/singlecard/tournament(user.loc)
	if(holo)
		holo.spawned += H // track them leaving the holodeck
	choice = cards[1]
	H.cardname = choice
	H.parentdeck = src
	var/O = src
	H.apply_card_vars(H,O)
	src.cards -= choice
	H.pickup(user)
	user.put_in_hands(H)
	user.visible_message("<span class='notice'>[user] draws a card from the deck.</span>", "<span class='notice'>You draw a card from the deck.</span>")
	update_icon()
	return H

/obj/item/toy/cards/singlecard/tournament/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/toy/cards/singlecard/tournament))
		var/obj/item/toy/cards/singlecard/tournament/C = I
		if(C.parentdeck == src.parentdeck)
			var/obj/item/toy/cards/cardhand/tournament/H = new/obj/item/toy/cards/cardhand/tournament(user.loc)
			H.currenthand += C.cardname
			H.currenthand += src.cardname
			H.parentdeck = C.parentdeck
			H.apply_card_vars(H,C)
			to_chat(user, "<span class='notice'>You combine the [C.cardname] and the [src.cardname] into a hand.</span>")
			qdel(C)
			qdel(src)
			H.update_sprite()
			H.pickup(user)
			user.put_in_active_hand(H)
		else
			to_chat(user, "<span class='warning'>You can't mix cards from other decks!</span>")

	if(istype(I, /obj/item/toy/cards/cardhand/tournament))
		var/obj/item/toy/cards/cardhand/tournament/H = I
		if(H.parentdeck == parentdeck)
			H.currenthand += cardname
			user.visible_message("<span class='notice'>[user] adds a card to [user.p_their()] hand.</span>", "<span class='notice'>You add the [cardname] to your hand.</span>")
			qdel(src)
			H.interact(user)
			H.update_sprite()
		else
			to_chat(user, "<span class='warning'>You can't mix cards from other decks!</span>")

/obj/item/card/id/poker_tournament_card
	name = "Casino Account Card"
	desc = "A card used to store currency for redeeming Casino chips. Keep this safe!"
	id_type_name = "tournament card"
	var/metacoin_balance

/obj/item/card/id/poker_tournament_card/examine(mob/user)
	. = ..()
	. += "The Casino card reports a balance of [metacoin_balance] points. Spend them at a Casino Chip Vendor"
/obj/item/card/id/poker_tournament_card/preloaded/thousand
	metacoin_balance = 1000

/obj/item/card/id/poker_tournament_card/preloaded/five_thousand
	metacoin_balance = 5000

/obj/item/coin/poker_chip
	name = "poker chip"
	icon = 'whitesands/icons/obj/economy.dmi'
	icon_state = "coin"
	sideslist = list()
	value = 1
	w_class = WEIGHT_CLASS_TINY

/obj/item/coin/poker_chip/Initialize()
	. = ..()
	pixel_x = rand(0,16)-8
	pixel_y = rand(0,8)-8
	desc = "A poker chip used in tournaments. This one is worth [src.value] points."

/obj/item/coin/poker_chip/attack_self(mob/user)
	to_chat(user, "<span class='notice'>This probably won't flip well, given it's so pricey.</span>")
	return FALSE

/obj/item/coin/poker_chip/set_custom_materials(var/list/materials, multiplier = 1)
	. = ..()
	value = initial(src.value) // Keep their preset values

/obj/item/coin/poker_chip/ten
	value = 10
/obj/item/coin/poker_chip/twenty_five
	value = 25
	custom_materials = list(/datum/material/silver = 400)
/obj/item/coin/poker_chip/fifty
	value = 50
	custom_materials = list(/datum/material/gold = 400)
/obj/item/coin/poker_chip/hundred
	value = 100
	custom_materials = list(/datum/material/titanium = 400)
/obj/item/coin/poker_chip/five_hundred
	value = 500
	custom_materials = list(/datum/material/plasma = 400)
/obj/item/coin/poker_chip/thousand
	value = 1000
	custom_materials = list(/datum/material/diamond = 400)

/obj/item/storage/box/poker_chips
	name = "Poker Chip box"
	desc = "A box containing poker chips, used for Casino games."

/obj/item/storage/box/poker_chips/PopulateContents()
	. = ..()
/obj/item/storage/box/poker_chips/hundred
	name = "Poker Chip box (100)"
	desc = "A box containing poker chips totaling 100 points. Used for Casino games."

/obj/item/storage/box/poker_chips/hundred/PopulateContents()
	. = ..()
	for(var/i = 0, i < 5, i++)
		new /obj/item/coin/poker_chip/ten(src)
	new /obj/item/coin/poker_chip/twenty_five(src)
	new /obj/item/coin/poker_chip/fifty(src)

/obj/item/storage/box/poker_chips/thousand
	name = "Poker Chip box (1,000)"
	desc = "A box containing poker chips totaling 1000 points. Used for Casino games."

/obj/item/storage/box/poker_chips/thousand/PopulateContents()
	. = ..()
	// 10*10 = 100
	for(var/i = 0, i < 10, i++)
		new /obj/item/coin/poker_chip/ten(src)
	// 25*8 = 200, 300
	for(var/i = 0, i < 8, i++)
		new /obj/item/coin/poker_chip/twenty_five(src)
	// 50 * 4 = 200, 500
	for(var/i = 0, i < 4, i++)
		new /obj/item/coin/poker_chip/fifty(src)
	for (var/i = 0, i < 5, i++)
		new /obj/item/coin/poker_chip/hundred(src)
/obj/item/storage/box/poker_chips/five_thousand
	name = "Poker Chip box (5,000)"
	desc = "A box containing poker chips totaling 5000 points. Used for Casino games."

/obj/item/storage/box/poker_chips/five_thousand/PopulateContents()
	. = ..()
	// 10*40 = 400
	for(var/i = 0, i < 20, i++)
		new /obj/item/coin/poker_chip/ten(src)
	// 25*24 = 600, 1000
	for(var/i = 0, i < 8, i++)
		new /obj/item/coin/poker_chip/twenty_five(src)
	// 50 * 10 = 1000, 2000
	for(var/i = 0, i < 4, i++)
		new /obj/item/coin/poker_chip/fifty(src)
	// 100 * 10 = 1000, 3000
	for (var/i = 0, i < 10, i++)
		new /obj/item/coin/poker_chip/hundred(src)
	// 500 * 4 = 2000, 5000
	for (var/i = 0, i < 4, i++)
		new /obj/item/coin/poker_chip/five_hundred(src)

/obj/machinery/mineral/equipment_vendor/casino_chip_vendor
	name = "Casino Chip Vendor"
	desc = "Used to get chips for Casino games. Uses a special ID card."
	icon = 'whitesands/icons/obj/machines/away_missions.dmi'
	icon_state = "chips"
	prize_list = list(
		new /datum/data/mining_equipment("5000pt Chips", /obj/item/storage/box/poker_chips/five_thousand, 5000),
		new /datum/data/mining_equipment("1000pt Chips", /obj/item/storage/box/poker_chips/thousand, 1000),
		new /datum/data/mining_equipment("100pt Chips", /obj/item/storage/box/poker_chips/hundred, 100)
	)

/obj/machinery/mineral/equipment_vendor/casino_chip_vendor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CasinoVendor", name)
		ui.open()

/obj/machinery/mineral/equipment_vendor/casino_chip_vendor/ui_data(mob/user)
	. = list()
	var/mob/living/carbon/human/H
	var/obj/item/card/id/poker_tournament_card/C
	if(ishuman(user))
		H = user
		C = H.get_idcard(TRUE)
		if(C && istype(C))
			.["user"] = list()
			.["user"]["points"] = C.metacoin_balance
			if(C.registered_account)
				.["user"]["name"] = C.registered_account.account_holder
				if(C.registered_account.account_job)
					.["user"]["job"] = C.registered_account.account_job.title
				else
					.["user"]["job"] = "No Job"

/obj/machinery/mineral/equipment_vendor/casino_chip_vendor/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("purchase")
			var/mob/M = usr
			var/obj/item/card/id/poker_tournament_card/I = M.get_idcard(TRUE)
			if(!istype(I))
				to_chat(usr, "<span class='alert'>Error: An Poker Tournament ID is required!</span>")
				flick(icon_deny, src)
				return
			var/datum/data/mining_equipment/prize = locate(params["ref"]) in prize_list
			if(!prize || !(prize in prize_list))
				to_chat(usr, "<span class='alert'>Error: Invalid choice!</span>")
				flick(icon_deny, src)
				return
			if(prize.cost > I.metacoin_balance)
				to_chat(usr, "<span class='alert'>Error: Insufficient points for [prize.equipment_name] on [I]!</span>")
				flick(icon_deny, src)
				return
			I.metacoin_balance -= prize.cost
			to_chat(usr, "<span class='notice'>[src] clanks to life briefly before vending [prize.equipment_name]!</span>")
			new prize.equipment_path(loc)
			SSblackbox.record_feedback("nested tally", "mining_equipment_bought", 1, list("[type]", "[prize.equipment_path]"))
			. = TRUE
