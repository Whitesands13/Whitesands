//Waspstation Emotes

/datum/emote/speen
	key = "speen"
	key_third_person = "speeeens"
	restraint_check = TRUE
	mob_type_allowed_typecache = list(/mob/living, /mob/dead/observer)
	mob_type_ignore_stat_typecache = list(/mob/dead/observer)

/datum/emote/speen/run_emote(mob/user, params,  type_override, intentional)
	. = ..()
	if(.)
		user.spin(20, 1)
		if(isobserver(user) && prob(90)) //Speening in their grave
			var/turf/turf_source = get_turf(user)
			for(var/P in SSmobs.dead_players_by_zlevel[turf_source.z])
				var/mob/M = P
				if(get_dist(M, turf_source) <= world.view - 1)
					M.playsound_local(turf_source, 'waspstation/sound/voice/speen.ogg', 50, 1)
			return
		playsound(user, 'waspstation/sound/voice/speen.ogg', 50, 1, -1)
		if((iscyborg(user) || isanimal(user)) && user.has_buckled_mobs())
			var/mob/living/L = user
			var/datum/component/riding/riding_datum = L.GetComponent(/datum/component/riding)
			if(riding_datum)
				if(L.a_intent == INTENT_HELP)
					for(var/mob/M in L.buckled_mobs)
						riding_datum.force_dismount(M, TRUE)
				else
					for(var/mob/M in L.buckled_mobs)
						riding_datum.force_dismount(M)
			else
				L.unbuckle_all_mobs()
