//A slow but strong beast that tries to stun using its tentacles
/mob/living/simple_animal/hostile/asteroid/gruboid
	name = "gruboid"
	desc = "A massive beast that uses long tentacles to ensnare its prey, threatening them is not advised under any conditions."
	icon = 'whitesands/icons/mob/whitesands/monsters.dmi'
	icon_state = "gruboid2"
	icon_living = "gruboid2"
	icon_aggro = "gruboid"
	icon_dead = "gruboid_dead"
	icon_gib = "syndicate_gib"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	mouse_opacity = MOUSE_OPACITY_ICON
	move_to_delay = 40
	ranged = 1
	ranged_cooldown_time = 120
	friendly_verb_continuous = "wails at"
	friendly_verb_simple = "wail at"
	speak_emote = list("bellows")
	speed = 3
	throw_deflection = 10
	maxHealth = 300
	health = 300
	armor = list("melee" = 10, "bullet" = 15, "laser" = 10, "energy" = 10, "bomb" = 10, "bio" = 10, "rad" = 10, "fire" = 10, "acid" = 10)
	harm_intent_damage = 0
	obj_damage = 100
	melee_damage_lower = 12
	melee_damage_upper = 20
	attack_verb_continuous = "pulverizes"
	attack_verb_simple = "pulverize"
	attack_sound = 'sound/weapons/punch1.ogg'
	throw_message = "does nothing to the rocky hide of the"
	vision_range = 5
	aggro_vision_range = 9
	move_force = MOVE_FORCE_VERY_STRONG
	move_resist = MOVE_FORCE_VERY_STRONG
	pull_force = MOVE_FORCE_VERY_STRONG
	gender = MALE //Shouldn't it be asexual? It reproduces by severing the tongues it attacks with
	var/pre_attack = 0
	var/pre_attack_icon = "gruboid2"
	loot = list(/obj/item/stack/sheet/animalhide/goliath_hide)
	food_type = list(/obj/item/reagent_containers/food/snacks/meat)		// Omnivorous
	tame_chance = 0
	bonus_tame_chance = 10
	search_objects = 1
	wanted_objects = list(/obj/structure/flora/ash)

	footstep_type = FOOTSTEP_MOB_HEAVY

/mob/living/simple_animal/hostile/asteroid/gruboid/Life()
	. = ..()
	handle_preattack()

/mob/living/simple_animal/hostile/asteroid/gruboid/proc/handle_preattack()
	if(ranged_cooldown <= world.time + ranged_cooldown_time*0.25 && !pre_attack)
		pre_attack++
	if(!pre_attack || stat || AIStatus == AI_IDLE)
		return
	icon_state = pre_attack_icon

/mob/living/simple_animal/hostile/asteroid/gruboid/revive(full_heal = FALSE, admin_revive = FALSE)//who the fuck anchors mobs
	if(..())
		move_force = MOVE_FORCE_VERY_STRONG
		move_resist = MOVE_FORCE_VERY_STRONG
		pull_force = MOVE_FORCE_VERY_STRONG
		. = 1

/mob/living/simple_animal/hostile/asteroid/gruboid/death(gibbed)
	move_force = MOVE_FORCE_DEFAULT
	move_resist = MOVE_RESIST_DEFAULT
	pull_force = PULL_FORCE_DEFAULT
	..(gibbed)

/mob/living/simple_animal/hostile/asteroid/gruboid/OpenFire()
	var/tturf = get_turf(target)
	if(!isturf(tturf))
		return
	if(get_dist(src, target) <= 7)//Screen range check, so you can't get tentacle'd offscreen
		visible_message("<span class='warning'>[src] digs its tentacles under [target]!</span>")
		new /obj/effect/temp_visual/gruboid_tentacle/original(tturf, src)
		ranged_cooldown = world.time + ranged_cooldown_time
		icon_state = icon_aggro
		pre_attack = 0

/mob/living/simple_animal/hostile/asteroid/gruboid/Found(atom/A)
	if(istype(A, /obj/structure/flora/ash))
		var/obj/structure/flora/ash/edible = A
		if(!edible.harvested)
			return TRUE
	return FALSE

/mob/living/simple_animal/hostile/asteroid/gruboid/AttackingTarget()
	if(istype(target, /obj/structure/flora/ash))
		var/obj/structure/flora/ash/edible = target
		visible_message("<span class='notice'>[src] eats the [edible].</span>")
		edible.consume()
		target = null		// Don't gnaw on the same plant forever
	else
		. = ..()

/mob/living/simple_animal/hostile/asteroid/gruboid/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	ranged_cooldown -= 10
	handle_preattack()
	. = ..()

/mob/living/simple_animal/hostile/asteroid/gruboid/Aggro()
	vision_range = aggro_vision_range
	handle_preattack()
	if(icon_state != icon_aggro)
		icon_state = icon_aggro

/mob/living/simple_animal/hostile/asteroid/gruboid/pup
	name = "gruboid pup"
	desc = "A small gruboid pup. It's tendrils have not yet fully grown."
	icon = 'whitesands/icons/mob/whitesands/monsters.dmi'
	icon_state = "gruboid_baby"
	icon_living = "gruboid_baby"
	icon_aggro = "gruboid_baby"
	icon_dead = "gruboid_baby_dead"
	throw_message = "does nothing to the tough hide of the"
	pre_attack_icon = "gruboid_baby"
	maxHealth = 60
	health = 60
	armor = list("melee" = 0, "bullet" = 5, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	harm_intent_damage = 0
	obj_damage = 100
	melee_damage_lower = 2
	melee_damage_upper = 5
	tame_chance = 5
	bonus_tame_chance = 15


//Lavaland Gruboid
/mob/living/simple_animal/hostile/asteroid/gruboid/beast
	name = "gruboid"
	desc = "A hulking, armor-plated beast with long tendrils arching from its back."
	icon = 'whitesands/icons/mob/whitesands/monsters.dmi'
	icon_state = "gruboid2"
	icon_living = "gruboid2"
	icon_aggro = "gruboid"
	icon_dead = "gruboid_dead"
	throw_message = "does nothing to the tough hide of the"
	pre_attack_icon = "gruboid2"
	crusher_loot = /obj/item/crusher_trophy/goliath_tentacle
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab/goliath = 2, /obj/item/stack/sheet/bone = 2, /obj/item/stack/sheet/sinew = 2, /obj/item/stack/ore/silver = 10)
	guaranteed_butcher_results = list(/obj/item/stack/sheet/animalhide/goliath_hide = 1)
	loot = list()
	stat_attack = UNCONSCIOUS
	robust_searching = 1
	var/saddled = FALSE
	var/charging = FALSE
	var/revving_charge = FALSE
	var/charge_range = 7
	var/tent_range = 3

/mob/living/simple_animal/hostile/asteroid/gruboid/beast/proc/charge(atom/chargeat = target, delay = 10, chargepast = 2)
	if(!chargeat)
		return
	var/chargeturf = get_turf(chargeat)
	if(!chargeturf)
		return
	var/dir = get_dir(src, chargeturf)
	var/turf/T = get_ranged_target_turf(chargeturf, dir, chargepast)
	if(!T)
		return
	charging = TRUE
	revving_charge = TRUE
	walk(src, 0)
	setDir(dir)
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(loc,src)
	animate(D, alpha = 0, color = "#FF0000", transform = matrix()*2, time = 3)
	SLEEP_CHECK_DEATH(delay)
	revving_charge = FALSE
	var/movespeed = 0.7
	walk_towards(src, T, movespeed)
	SLEEP_CHECK_DEATH(get_dist(src, T) * movespeed)
	walk(src, 0) // cancel the movement
	charging = FALSE

/mob/living/simple_animal/hostile/asteroid/gruboid/beast/Bump(atom/A)
	. = ..()
	if(charging && isclosedturf(A))				// We slammed into a wall while charging
		wall_slam(A)

/mob/living/simple_animal/hostile/asteroid/gruboid/beast/proc/wall_slam(atom/A)
	charging = FALSE
	Stun(100, TRUE, TRUE)
	walk(src, 0)		// Cancel the movement
	if(ismineralturf(A))
		var/turf/closed/mineral/M = A
		if(M.mineralAmt < 7)
			M.mineralAmt++

/mob/living/simple_animal/hostile/asteroid/gruboid/beast/OpenFire()
	var/tturf = get_turf(target)
	var/dist = get_dist(src, target)
	if(!isturf(tturf) || !isliving(target))
		return
	if(dist <= tent_range)
		visible_message("<span class='warning'>[src] digs its tentacles under [target]!</span>")
		new /obj/effect/temp_visual/gruboid_tentacle/original(tturf, src)
		ranged_cooldown = world.time + ranged_cooldown_time
		icon_state = icon_aggro
		pre_attack = 0
	else if(dist <= charge_range)		//Screen range check, so you can't get charged offscreen
		charge()

/mob/living/simple_animal/hostile/asteroid/gruboid/beast/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/saddle) && !saddled)
		if(tame && do_after(user,55,target=src))
			user.visible_message("<span class='notice'>You manage to put [O] on [src], you can now ride [p_them()].</span>")
			qdel(O)
			saddled = TRUE
			can_buckle = TRUE
			buckle_lying = FALSE
			add_overlay("gruboid_saddled")
			var/datum/component/riding/D = LoadComponent(/datum/component/riding)
			D.set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(0, 8), TEXT_SOUTH = list(0, 8), TEXT_EAST = list(-2, 8), TEXT_WEST = list(2, 8)))
			D.set_vehicle_dir_layer(SOUTH, ABOVE_MOB_LAYER)
			D.set_vehicle_dir_layer(NORTH, OBJ_LAYER)
			D.set_vehicle_dir_layer(EAST, OBJ_LAYER)
			D.set_vehicle_dir_layer(WEST, OBJ_LAYER)
			D.keytype = /obj/item/key/lasso
			D.drive_verb = "ride"
		else
			user.visible_message("<span class='warning'>[src] is rocking around! You can't put the saddle on!</span>")
		return
	..()

/mob/living/simple_animal/hostile/asteroid/gruboid/beast/random/Initialize()
	. = ..()
	if(prob(1))
		new /mob/living/simple_animal/hostile/asteroid/gruboid/beast/ancient(loc)
		return INITIALIZE_HINT_QDEL

/mob/living/simple_animal/hostile/asteroid/gruboid/beast/ancient
	name = "ancient gruboid"
	desc = "Gruboids are biologically immortal, and rare specimens have survived for centuries. This one is clearly ancient, and its tentacles constantly churn the earth around it."
	icon_state = "gruboid2"
	icon_living = "gruboid2"
	icon_aggro = "gruboid"
	icon_dead = "gruboid_dead"
	maxHealth = 400
	health = 400
	speed = 4
	pre_attack_icon = "gruboid2"
	throw_message = "does nothing to the rocky hide of the"
	guaranteed_butcher_results = list()
	crusher_drop_mod = 30
	wander = FALSE
	tame_chance = 0
	bonus_tame_chance = 5
	var/list/cached_tentacle_turfs
	var/turf/last_location
	var/tentacle_recheck_cooldown = 100

/mob/living/simple_animal/hostile/asteroid/gruboid/beast/ancient/Life()
	. = ..()
	if(!.) // dead
		return
	if(isturf(loc))
		if(!LAZYLEN(cached_tentacle_turfs) || loc != last_location || tentacle_recheck_cooldown <= world.time)
			LAZYCLEARLIST(cached_tentacle_turfs)
			last_location = loc
			tentacle_recheck_cooldown = world.time + initial(tentacle_recheck_cooldown)
			for(var/turf/open/T in orange(4, loc))
				LAZYADD(cached_tentacle_turfs, T)
		for(var/t in cached_tentacle_turfs)
			if(isopenturf(t))
				if(prob(10))
					new /obj/effect/temp_visual/gruboid_tentacle(t, src)
			else
				cached_tentacle_turfs -= t

/mob/living/simple_animal/hostile/asteroid/gruboid/beast/tendril
	fromtendril = TRUE

//tentacles
/obj/effect/temp_visual/gruboid_tentacle
	name = "gruboid tentacle"
	icon = 'whitesands/icons/mob/whitesands/monsters.dmi'
	icon_state = "Gruboid_tentacle_spawn"
	layer = BELOW_MOB_LAYER
	var/mob/living/spawner

/obj/effect/temp_visual/gruboid_tentacle/Initialize(mapload, mob/living/new_spawner)
	. = ..()
	for(var/obj/effect/temp_visual/gruboid_tentacle/T in loc)
		if(T != src)
			return INITIALIZE_HINT_QDEL
	if(!QDELETED(new_spawner))
		spawner = new_spawner
	if(ismineralturf(loc))
		var/turf/closed/mineral/M = loc
		M.gets_drilled()
	deltimer(timerid)
	timerid = addtimer(CALLBACK(src, .proc/tripanim), 7, TIMER_STOPPABLE)

/obj/effect/temp_visual/gruboid_tentacle/original/Initialize(mapload, new_spawner)
	. = ..()
	var/list/directions = GLOB.cardinals.Copy()
	for(var/i in 1 to 3)
		var/spawndir = pick_n_take(directions)
		var/turf/T = get_step(src, spawndir)
		if(T)
			new /obj/effect/temp_visual/gruboid_tentacle(T, spawner)

/obj/effect/temp_visual/gruboid_tentacle/proc/tripanim()
	icon_state = "Gruboid_tentacle_wiggle"
	deltimer(timerid)
	timerid = addtimer(CALLBACK(src, .proc/trip), 3, TIMER_STOPPABLE)

/obj/effect/temp_visual/gruboid_tentacle/proc/trip()
	var/latched = FALSE
	for(var/mob/living/L in loc)
		if((!QDELETED(spawner) && spawner.faction_check_mob(L)) || L.stat == DEAD)
			continue
		visible_message("<span class='danger'>[src] grabs hold of [L]!</span>")
		L.Stun(100)
		L.adjustBruteLoss(rand(1,3))
		latched = TRUE
	if(!latched)
		retract()
	else
		deltimer(timerid)
		timerid = addtimer(CALLBACK(src, .proc/retract), 10, TIMER_STOPPABLE)

/obj/effect/temp_visual/gruboid_tentacle/proc/retract()
	icon_state = "Gruboid_tentacle_retract"
	deltimer(timerid)
	timerid = QDEL_IN(src, 7)

/obj/item/saddle
	name = "saddle"
	desc = "This saddle will solve all your problems with being killed by lava beasts!"
	icon = 'icons/obj/mining.dmi'
	icon_state = "goliath_saddle"
