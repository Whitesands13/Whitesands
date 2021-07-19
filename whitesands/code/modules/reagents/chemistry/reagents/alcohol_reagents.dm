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

/datum/reagent/consumable/ethanol/vodka_cola
	name = "Vodka Cola"
	description = "Vodka, mixed with cola"
	color = "#3f2410" // rgb: 62, 27, 0
	boozepwr = 60
	quality = DRINK_NICE
	taste_description = "depression"
	glass_icon_state = "whiskeycolaglass"
	glass_name = "Vodka Cola"
	glass_desc = "You don't like rum ? Fine, there is Whiskey, wha.. You don't like that too ? Man.. Well, Vodka I guess ?"

/datum/reagent/consumable/ethanol/vodka_soda
	name = "Vodka Soda"
	description = "Vodka, mixed with soda. Eww."
	color = "#3f2410" // rgb: 62, 27, 0
	boozepwr = 60
	quality = DRINK_NICE
	taste_description = "vodka soda"
	glass_icon_state = "whiskeysodaglass"
	glass_name = "Vodka Soda"
	glass_desc = "For those little snowflakes who don't like whiskey and cola."

/datum/reagent/consumable/ethanol/black_roulette
	name = "Black Roulette"
	description = "It's like the real one! Be careful"
	color = "#7c550bbe" // rgb: 102, 67, 0
	boozepwr = 40
	taste_description = "organ failure"
	glass_icon_state = "black_roulette"
	glass_name = "Black Roulette"
	glass_desc = "There is a bullet in the gun-looking drink, I don't feel like trying this."

/datum/reagent/consumable/ethanol/black_roulette/on_mob_add(mob/living/L)
	var/datum/disease/D = new /datum/disease/heart_failure
	metabolization_rate = 5
	if(prob(15) && iscarbon(L))
		L.playsound_local(L, 'sound/weapons/revolver357shot.ogg', 100, 80)
		L.ForceContractDisease(D)
		to_chat(L, "<span class='userdanger'>You're pretty sure you just felt your heart stop for a second there..</span>")
		L.playsound_local(L, 'sound/effects/singlebeat.ogg', 100, 0)
	..()

/datum/reagent/consumable/ethanol/triple_coke
	name = "Triple Coke"
	description = "A strange mixes of Rum, Whiskey, Vodka and cola, perfect when you need to get drunk without noticing it"
	color = "#7c550bbe" // rgb: 102, 67, 0
	boozepwr = 80
	quality = DRINK_NICE
	taste_description = "bad idea"
	glass_icon_state = "triple_coke"
	glass_name = "Triple Coke"
	glass_desc = "Is there cocaine in this drink ? That's sussy.."

/datum/reagent/consumable/ethanol/triple_coke/on_mob_life(mob/living/carbon/M)
	metabolization_rate = 0.5
	if(prob(50))
		M.emote("flip")
		if(prob(50))
			M.emote("collapse")
	..()

/datum/reagent/consumable/ethanol/fringe_weaver/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M, TRAIT_ALCOHOL_TOLERANCE) && (prob(10)))
		M.vomit()
	if(prob(5))
		M.emote("collapse")
	if(prob(5))
		M.drop_all_held_items()
	..()

/datum/reagent/consumable/ethanol/death_afternoon
	name = "Death in the afternoon"
	description = "Icy, milky, scary"
	color = "#c4ffa9"
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "bravery and life"
	glass_icon_state = "death_afternoon"
	glass_name = "Death in the afternoon"
	glass_desc = "You gotta drink it fast!"

/datum/reagent/consumable/ethanol/death_afternoon/on_mob_add(mob/living/carbon/M)
	if(!HAS_TRAIT(M, TRAIT_ALCOHOL_TOLERANCE))
		new /datum/hallucination/death(M, TRUE)
	..()

/datum/reagent/consumable/ethanol/mine_dread
	name = "Miner's Dread"
	description = "Only the most experienced miners should drink this mixture."
	color = "#35322f"
	boozepwr = 70
	taste_description = "Bloody powder"
	glass_icon_state = "mine_dread"
	glass_name = "Miner's Dread"
	glass_desc = "This drink is made with a plastic demon feet."

/datum/reagent/consumable/ethanol/mine_dread/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M, TRAIT_ALCOHOL_TOLERANCE)&&prob(20))
		new /datum/hallucination/oh_yeah(M, TRUE)
	..()

/datum/reagent/consumable/ethanol/electro_blaster
	name = "Electro Blaster"
	description = "Said to be use in the creation of tesla coil."
	color = "#6294ff"
	boozepwr = 80
	taste_description = "coil"
	glass_icon_state = "electro_blaster"
	glass_name = "Electro Blaster"
	glass_desc = "A true drink, For a true engineer, surely."

/datum/reagent/consumable/ethanol/electro_blaster/on_mob_add(mob/living/carbon/M)
	if(!HAS_TRAIT(M, TRAIT_ALCOHOL_TOLERANCE))
		new /datum/hallucination/shock(M, TRUE)
		M.Jitter(5)
	if(prob(5))
		new /datum/hallucination/shock(M, TRUE)
	..()
	var/static/list/increased_rad_loss = list("Station Engineer", "Atmospheric Technician", "Chief Engineer")
	if(M.mind && (M.mind.assigned_role in increased_rad_loss)) //Engineers lose radiation poisoning at a even more massive rate. (2 times more effective than screwdriver)
		M.radiation = max(M.radiation - 50, 0)
	return ..()
