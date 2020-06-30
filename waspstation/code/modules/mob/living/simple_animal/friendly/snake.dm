/mob/living/simple_animal/hostile/retaliate/poison/snake
	var/glasses_overlay_file = 'waspstation/icons/mob/pets.dmi'
	var/obj/item/clothing/glasses/glasses = null //snek glasses

/mob/living/simple_animal/hostile/retaliate/poison/snake/update_overlays()
	..()
	overlays.Cut()
	if(glasses && !stat)
		var/mutable_appearance/glasses_overlay = mutable_appearance(glasses_overlay_file, glasses.icon_state)
		add_overlay(glasses_overlay)

/mob/living/simple_animal/hostile/retaliate/poison/snake/show_inv(mob/user)
	user.set_machine(src)

	var/dat = 	"<div align='center'><b>Inventory of [name]</b></div><p>"
	dat += "<br><B>Glasses:</B> <A href='?src=[REF(src)];[glasses ? "remove_inv=glasses'>[glasses]" : "add_inv=glasses'>Nothing"]</A>"

	var/datum/browser/popup = new(usr, "window=mob[REF(src)]", "<div align='center'>Inventory of [name]</div>", 325, 500)
	popup.set_content(dat)
	popup.open(0)

/mob/living/simple_animal/hostile/retaliate/poison/snake/Topic(href, href_list)
	if(!(iscarbon(usr) || iscyborg(usr)) || !usr.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		usr << browse(null, "window=mob[REF(src)]")
		usr.unset_machine()
		return

	//Removing from inventory
	if(href_list["remove_inv"])
		var/remove_from = href_list["remove_inv"]
		switch(remove_from)
			if("glasses")
				if(!glasses)
					to_chat(usr, "<span class='warning'>There is nothing to remove from it!</span>")
					return
				if(!stat)
					say("HISSSS!")
				glasses.forceMove(drop_location())
				glasses = null
				update_overlays()

	//Adding things to inventory
	else if(href_list["add_inv"])
		var/add_to = href_list["add_inv"]
		if(!usr.get_active_held_item())
			to_chat(usr, "<span class='warning'>You have nothing in your hand to put on it!</span>")
			return
		switch(add_to)
			if("glasses")
				if(glasses)
					to_chat(usr, "<span class='warning'>It's already wearing something!</span>")
					return
				else
					var/obj/item/item_to_add = usr.get_active_held_item()
					if(!item_to_add)
						return

					if(!istype(item_to_add, /obj/item/clothing/glasses))
						to_chat(usr, "<span class='warning'>This object won't fit!</span>")
						return

					var/obj/item/clothing/glasses/glasses_to_add = item_to_add

					if(!usr.transferItemToLoc(glasses_to_add, src))
						return
					glasses = glasses_to_add
					to_chat(usr, "<span class='notice'>You fit the glasses onto [src].</span>")
					update_overlays()

#define MAX_BOOKWORM_BOOKS 20

/mob/living/simple_animal/hostile/retaliate/poison/snake/bookworm
	name = "Bookworm"
	icon = 'waspstation/icons/mob/pets.dmi'
	icon_state = "bookworm"
	icon_living = "bookworm"
	icon_dead = "bookworm_dead"
	speak_chance = 10 //a lot less than poly
	speak = list("I can't find anything to read!")

/mob/living/simple_animal/hostile/retaliate/poison/snake/bookworm/Initialize()
	glasses = new /obj/item/clothing/glasses/regular(src)
	grant_all_languages()
	update_overlays()
	speak = get_phrases()
	. = ..()

/mob/living/simple_animal/hostile/retaliate/poison/snake/bookworm/proc/get_phrases() //if someone sees this, be sure to actually literally really kill me
	var/phrase_buffer = list()
	create_random_books(15, src, TRUE)
	for(var/obj/item/book/B in contents)
		var/start = findtext(B.dat, ">")
		var/end = findtext(B.dat, "<", 2)
		phrase_buffer += strip_html(copytext_char(B.dat, start, min(start + 15, end)))
		qdel(B)
	return phrase_buffer //and I mean really actually kill me with a gun or knife or something that can kill people

/mob/living/simple_animal/hostile/retaliate/poison/snake/bookworm/handle_automated_speech(override)
	var/datum/language_holder/LH = get_language_holder()
	LH.selected_language = get_random_spoken_language()
	..()

/mob/living/simple_animal/hostile/retaliate/poison/snake/examine(mob/user)
	. = ..()
	. += "This one [glasses ? "is wearing glasses!" : "seems to be having trouble seeing..."]"

/mob/living/simple_animal/hostile/retaliate/poison/snake/attack_hand(mob/living/carbon/human/M)
	..()
	if(stat != DEAD && M.a_intent == INTENT_HELP)
		handle_automated_speech(1) //assured speak/emote
	return
