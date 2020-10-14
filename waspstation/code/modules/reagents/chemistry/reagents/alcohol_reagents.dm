/datum/reagent/consumable/ethanol/spriters_bane
	name = "Spriter's Bane"
	description = "A drink to fill your very SOUL."
	color = "#800080"
	boozepwr = 30
	quality = DRINK_GOOD
	taste_description = "a coder made it"
	glass_icon_state = "uglydrink"
	glass_name = "Spriter's Bane"
	glass_desc = "Tastes better than it looks."

/datum/reagent/consumable/ethanol/spriters_bane/on_mob_life(mob/living/carbon/C)
	C.AddComponent(/datum/component/outline, 1)
	switch(current_cycle)
		if(10 to 40)
			C.jitteriness += 3
			if(prob(30) && !C.eye_blurry)
				C.blur_eyes(3)
				to_chat(C, "<span class='warning'>That outline is so distracting, it's hard to look at anything else!</span>")
		if(40 to 100)
			C.Dizzy(10)
			if(prob(30))
				new /datum/hallucination/hudscrew(C)
		if(100 to INFINITY)
			if(prob(20) && !C.eye_blind)
				C.blind_eyes(2)
				to_chat(C, "<span class='userdanger'>Your vision fades as your eyes are outlined in black!</span>")
			else
				C.Dizzy(20)
