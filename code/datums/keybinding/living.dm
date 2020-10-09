/datum/keybinding/living
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/living/can_use(client/user)
	return isliving(user.mob)

/datum/keybinding/living/resist
	hotkey_keys = list("B")
	name = "resist"
	full_name = "Resist"
	description = "Break free of your current state. Handcuffed? on fire? Resist!"

/datum/keybinding/living/resist/down(client/user)
	var/mob/living/L = user.mob
	L.resist()
	return TRUE

/datum/keybinding/living/look_up
	hotkey_keys = list("L")
	name = "look up"
	full_name = "Look Up"
	description = "Look up at the next z-level.  Only works if directly below open space."

/datum/keybinding/living/look_up/down(client/user)
	var/mob/living/L = user.mob
	L.look_up()
	return TRUE

/datum/keybinding/living/look_up/up(client/user)
	var/mob/living/L = user.mob
	L.stop_look_up()
	return TRUE

/datum/keybinding/living/rest
	hotkey_keys = list("U")
	name = "rest"
	full_name = "Rest"
	description = "Lay down, or get up."

/datum/keybinding/living/rest/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/living_mob = user.mob
	living_mob.toggle_resting()
