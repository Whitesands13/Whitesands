/obj/structure/overmap/event
	name = "generic overmap event"
	integrity = 0
	///Should the affect_ship() proc be called more than once?
	var/affect_multiple_times = FALSE
	///If the
	var/chance_to_affect = 0

/obj/structure/overmap/event/Initialize(mapload, _id)
	. = ..()
	filter = filter("blur", 1)

/obj/structure/overmap/event/process()
	if(affect_multiple_times)
		for(var/obj/structure/overmap/ship/S in close_overmap_objects)
			if(prob(chance_to_affect))
				affect_ship(S)

/obj/structure/overmap/event/proc/affect_ship(obj/structure/overmap/ship/S)
	return

/obj/structure/overmap/event/Crossed(atom/movable/AM, oldloc)
	. = ..()
	if(istype(AM, /obj/structure/overmap))
		affect_ship(AM)

/obj/structure/overmap/event/meteor
	name = "asteroid storm (moderate)"
	icon_state = "meteor1"
	affect_multiple_times = TRUE
	chance_to_affect = 5
	var/max_damage = 15
	var/min_damage = 5

/obj/structure/overmap/event/meteor/Initialize(mapload, _id)
	. = ..()
	icon_state = "meteor[rand(1, 4)]"

/obj/structure/overmap/event/meteor/affect_ship(obj/structure/overmap/ship/S)
	var/area/source_area = pick(S.shuttle.shuttle_areas)
	source_area.set_fire_alarm_effect()
	if(S.integrity <= 0)
		var/source_object = pick(source_area.contents)
		dyn_explosion(source_object, rand(min_damage, max_damage) / 2)
	else
		S.recieve_damage(rand(min_damage, max_damage))
		for(var/MN in GLOB.player_list)
			var/mob/M = MN
			if(S.shuttle.is_in_shuttle_bounds(M))
				var/strength = abs(S.integrity - initial(S.integrity))
				M.playsound_local(S.shuttle, 'sound/effect/explosionfar.ogg', strength)
				shake_camera(M, 10, strength / 10)

/obj/structure/overmap/event/meteor/minor
	name = "asteroid storm (minor)"
	max_damage = 10
	min_damage = 3

/obj/structure/overmap/event/meteor/major
	name = "asteroid storm (major)"
	max_damage = 25
	min_damage = 10

/obj/structure/overmap/event/emp
	name = "ion storm (moderate)"
	icon_state = "ion1"
	var/strength = 3

/obj/structure/overmap/event/emp/Initialize(mapload, _id)
	. = ..()
	icon_state = "ion[rand(1, 4)]"

/obj/structure/overmap/event/emp/affect_ship(obj/structure/overmap/ship/S)
	var/area/source_area = pick(S.shuttle.shuttle_areas)
	var/source_object = pick(source_area.contents)
	S.recieve_damage(strength)
	source_area.set_fire_alarm_effect()
	empulse(get_turf(source_object), round(rand(strength / 2, strength)), rand(strength, strength * 2))

/obj/structure/overmap/event/emp/minor
	name = "ion storm (minor)"
	strength = 1

/obj/structure/overmap/event/emp/major
	name = "ion storm (major)"
	strength = 5

/obj/structure/overmap/event/electric
	name = "electrical storm (moderate)"
	icon_state = "electrical1"

/obj/structure/overmap/event/emp/Initialize(mapload, _id)
	. = ..()
	icon_state = "electrical[rand(1, 4)]"

/obj/structure/overmap/event/electric/affect_ship(obj/structure/overmap/ship/S)
	var/area/source_area = pick(S.shuttle.shuttle_areas)
	source_area.set_fire_alarm_effect()
	if(S.integrity <= 0)
		var/source_object = pick(source_area.contents)
		tesla_zap(source_object)
	else
		S.recieve_damage(rand(min_damage, max_damage))
		for(var/MN in GLOB.player_list)
			var/mob/M = MN
			if(S.shuttle.is_in_shuttle_bounds(M))
				var/strength = abs(S.integrity - initial(S.integrity))
				M.playsound_local(S.shuttle, 'sound/effects/lightningshock.ogg', strength)
				shake_camera(M, 10, strength / 10)
