
/obj/machinery/holopad/emergency
	name = "advanced holopad"
	icon_state = "holopad3"
	///The linked Emergency Hologram
	var/mob/living/simple_animal/hologram/em
	///The type of emergency hologram to spawn
	var/mob/living/simple_animal/hologram/em_spawn_type = /mob/living/simple_animal/hologram
	///If the emergency hologram is active
	var/em_active = FALSE
	///If the holopad has been activated and will allow a ghost to
	var/em_starting = FALSE
	///If the holopad is recharging before allowing you to use the emergency hologram again
	var/em_cooldown = FALSE
	///Name displayed on the holopad, done because I don't know how else to do it
	var/em_name = "emergency hologram"

/obj/machinery/holopad/emergency/Destroy()
	. = ..()
	QDEL_NULL(em)

/obj/machinery/holopad/emergency/update_icon_state()
	var/total_users = LAZYLEN(masters) + LAZYLEN(holo_calls)
	if(ringing)
		icon_state = "holopad_ringing"
	else if(total_users || replay_mode)
		icon_state = "holopad1"
	else
		icon_state = "holopad3"

/obj/machinery/holopad/emergency/attack_ghost(mob/user)
	if(!SSticker.HasRoundStarted() || !loc || !em_starting || em)
		return ..()
	if(is_banned_from(user.key, ROLE_POSIBRAIN))
		to_chat(user, "<span class='warning'>You are banned from becoming a hologram!</span>")
		return
	if(QDELETED(src) || QDELETED(user))
		return
	var/ghost_role = alert("Become a hologram? (Warning, You can no longer be revived!)", "Become Hologram", "Yes", "No")
	if(ghost_role == "No" || !loc)
		return
	if(!em)
		em = new em_spawn_type(src, _holopad=src)
	em.ckey = user.ckey
	em.forceMove(get_turf(src))
	em.say("Please state the nature of the [em_name] emergency.")
	calling = FALSE
	em_starting = FALSE
	SetLightsAndPower()

/obj/machinery/holopad/emergency/attack_hand(mob/living/user)
	. = ..()
	if(em)
		em.apply_damage(rand(5,10), BRUTE)

/obj/machinery/holopad/emergency/emp_act(severity)
	. = ..()
	if(em)
		em.apply_damage(5*severity)


/obj/machinery/holopad/emergency/proc/stop_starting()
	if(em?.ckey)
		return
	SetLightsAndPower()
	calling = FALSE
	em_starting = FALSE
	say("Failed to initiate hologram personality matrices. Please try again later.")

/obj/machinery/holopad/emergency/ui_data(mob/user)
	var/list/data = ..()
	data["em_hologram"] = em_name
	data["em_cooldown"] = em_cooldown
	data["em_active"] = em_active
	return data

/obj/machinery/holopad/emergency/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("em_action")
			if(!em_active)
				var/area/A = get_area(src)
				notify_ghosts("An emergency hologram is being requested in \the [A.name].", source = src, action=NOTIFY_ATTACK, flashwindow = FALSE, ignore_key = POLL_IGNORE_DRONE, notify_suiciders = FALSE)
				em_starting = TRUE
				icon_state = "holopad_ringing"
				calling = TRUE
				addtimer(CALLBACK(src, .proc/stop_starting), 300)
			else
				qdel(em)
				em_cooldown = TRUE
				say("Recharging holoemitters...")
				addtimer(VARSET_CALLBACK(src, em_cooldown, FALSE), 600)
			em_active = !em_active
			return TRUE


/obj/machinery/holopad/emergency/medical
	name = "advanced medical holopad"
	em_name = "medical"
	em_spawn_type = /mob/living/simple_animal/hologram/medical

/obj/machinery/holopad/emergency/bar
	name = "advanced bar holopad"
	em_name = "bartending"
	em_spawn_type = /mob/living/simple_animal/hologram/bar

/obj/machinery/holopad/emergency/science
	name = "advanced science holopad"
	em_name = "scientific"
	em_spawn_type = /mob/living/simple_animal/hologram/science

/obj/machinery/holopad/emergency/engineering
	name = "advanced engineering holopad"
	em_name = "engineering"
	em_spawn_type = /mob/living/simple_animal/hologram/engineering

/obj/machinery/holopad/emergency/command
	name = "advanced command holopad"
	em_name = "command"
	em_spawn_type = /mob/living/simple_animal/hologram/command
