/datum/reagent/consumable/ethanol/spriters_bane
	name = "Spriter's Bane"
	description = "A drink to fill your very SOUL."
	color = "#800080"
	boozepwr = 30
	quality = DRINK_GOOD
	taste_description = "microsoft paints"
	glass_icon_state = "uglydrink"
	glass_name = "Spriter's Bane"
	glass_desc = "Tastes better than it looks."

/datum/reagent/consumable/ethanol/spriters_bane/on_mob_life(mob/living/carbon/C)
	switch(current_cycle)
		if(5 to 40)
			C.jitteriness += 3
			if(prob(10) && !C.eye_blurry)
				C.blur_eyes(6)
				to_chat(C, "<span class='warning'>That outline is so distracting, it's hard to look at anything else!</span>")
		if(40 to 100)
			C.Dizzy(10)
			if(prob(15))
				new /datum/hallucination/hudscrew(C)
		if(100 to INFINITY)
			if(prob(10) && !C.eye_blind)
				C.blind_eyes(6)
				to_chat(C, "<span class='userdanger'>Your vision fades as your eyes are outlined in black!</span>")
			else
				C.Dizzy(20)
	..()

/datum/reagent/consumable/ethanol/spriters_bane/expose_atom(atom/A, volume)
	A.AddComponent(/datum/component/outline)
	..()

/datum/reagent/consumable/ethanol/beesknees
	name = "Bee's Knees"
	description = "This has way too much honey."
	boozepwr = 35
	quality = 0
	taste_description = "sweeter mead"
	glass_icon_state = "beesknees"
	glass_name = "Bee's Knees"
	glass_desc = "This glass is oozing with honey. A bit too much honey to look appealing for anyone but a certain insect."

/datum/reagent/consumable/ethanol/beesknees/on_mob_metabolize(mob/living/M)
	if(is_species(M, /datum/species/apid))
		to_chat(M, "<span class='notice'>What a good drink! Reminds you of the honey back home.</span>")
		SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "quality_drink", /datum/mood_event/quality_fantastic)
	else
		to_chat(M, "<span class='warning'>That drink was way too sweet! You feel sick.</span>")
		M.adjust_disgust(10)
		SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "quality_drink", /datum/mood_event/quality_bad)
	. = ..()

/datum/reagent/consumable/ethanol/beesknees/on_mob_life(mob/living/carbon/M)
	if(is_species(M, /datum/species/apid))
		M.adjustBruteLoss(-1.5, 0)
		M.adjustFireLoss(-1.5, 0)
		M.adjustToxLoss(-1, 0)
	. = ..()
