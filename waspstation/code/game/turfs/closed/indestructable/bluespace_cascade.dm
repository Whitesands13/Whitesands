// QUALITY COPYPASTA
/turf/closed/indestructable/bluespace_cascade
	name = "Bluespace Cascade Foam"
	desc = "The unimaginable consequences of tampering with Bluespace. The Universe will never be the same."
	icon='waspstation/icons/turf/walls/bs_cascade.dmi'
	icon_state = "bluespacecrystal1"
	light_range = 5
	light_power = 2
	light_color="#0066FF"
	plane = CAMERA_STATIC_PLANE

	var/list/avail_dirs = list(NORTH,SOUTH,EAST,WEST)
	var/spread_process_timer

/turf/closed/indestructable/bluespace_cascade/New()
	spread_process_timer = addtimer(CALLBACK(src, .process), 30, TIMER_STOPPABLE)
	return ..()

/turf/closed/indestructable/bluespace_cascade/Destroy()
	deltimer(spread_process_timer)
	return ..()

/turf/closed/indestructable/bluespace_cascade/process()
	CHECK_TICK
	// No more available directions? Shut down process().
	if(!length(avail_dirs))
		return
	var/datum/game_mode/cataclysm/C = SSticker.mode
	if (!istype(C))
		return src.Destroy()
	if(C.check_finished())
		return
	// Choose a direction.
	var/pdir = pick(avail_dirs)
	avail_dirs -= pdir
	var/turf/T=get_step(src,pdir)
	CHECK_TICK
	if(istype(T, /turf/closed/indestructable/bluespace_cascade))
		avail_dirs -= pdir
		return process()

	// EXPAND DONG
	if(isturf(T))
		// Nom.
		CHECK_TICK
		T.singularity_act()
		T.ChangeTurf(/turf/closed/indestructable/bluespace_cascade)
		for(var/atom/A in T.contents)
			A.Destroy()
	spread_process_timer = addtimer(CALLBACK(src, .process), 30, TIMER_STOPPABLE)

/turf/closed/indestructable/bluespace_cascade/attack_paw(mob/user as mob)
	return attack_hand(user)

/turf/closed/indestructable/bluespace_cascade/attack_robot(mob/user as mob)
	if(Adjacent(user))
		return attack_hand(user)
	else
		to_chat(user, "<span class = \"warning\">What the fuck are you doing?</span>")
	return

// /vg/: Don't let ghosts fuck with this.
/turf/closed/indestructable/bluespace_cascade/attack_ghost(mob/user as mob)
	user.examine(src)

/turf/closed/indestructable/bluespace_cascade/attack_ai(mob/user as mob)
	return user.examine(src)

/turf/closed/indestructable/bluespace_cascade/attack_hand(mob/user as mob)
	user.visible_message("<span class=\"warning\">\The [user] reaches out and touches \the [src]... And then blinks out of existance.</span>",\
		"<span class=\"danger\">You reach out and touch \the [src]. Everything immediately goes quiet. Your last thought is \"That was not a wise decision.\"</span>",\
		"<span class=\"warning\">You hear an unearthly noise.</span>")

	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)

	Consume(user)

/turf/closed/indestructable/bluespace_cascade/attackby(obj/item/W, mob/living/user as mob)
	user.visible_message("<span class=\"warning\">\The [user] touches \a [W] to \the [src] as a silence fills the room...</span>",\
		"<span class=\"danger\">You touch \the [W] to \the [src] when everything suddenly goes silent.\"</span>\n<span class=\"notice\">\The [W] flashes into dust as you flinch away from \the [src].</span>",\
		"<span class=\"warning\">Everything suddenly goes silent.</span>")

	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)

	user.dropItemToGround(W)
	Consume(W)


/turf/closed/indestructable/bluespace_cascade/Bumped(atom/AM)
	if(istype(AM, /mob/living))
		AM.visible_message("<span class=\"warning\">\The [AM] slams into \the [src] inducing a resonance... \his body starts to glow and catch flame before flashing into ash.</span>",\
		"<span class=\"danger\">You slam into \the [src] as your ears are filled with unearthly ringing. Your last thought is \"Oh, fuck.\"</span>",\
		"<span class=\"warning\">You hear an unearthly noise as a wave of heat washes over you.</span>")
	else
		AM.visible_message("<span class=\"warning\">\The [AM] smacks into \the [src] and rapidly flashes to ash.</span>",\
		"<span class=\"warning\">You hear a loud crack as you are washed with a wave of heat.</span>")

	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)

	Consume(AM)


/turf/closed/indestructable/bluespace_cascade/proc/Consume(atom/AM)
	if(istype(AM, /mob/dead/observer))
		return
	return AM.singularity_act(src)

/turf/closed/indestructable/bluespace_cascade/singularity_act()
	return

/turf/closed/indestructable/bluespace_cascade/no_spread
	avail_dirs = list()
