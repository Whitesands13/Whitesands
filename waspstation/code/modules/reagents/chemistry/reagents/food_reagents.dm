/datum/reagent/consumable/pyre_elementum
	name = "Pyre Elementum"
	description = "This is what makes Fireblossoms even hotter."
	color = "#d30639"
	taste_description = "burning heat"
	taste_mult = 2.0
	var/hunger_drain = -1
	var/injested = FALSE

/datum/reagent/consumable/pyre_elementum/expose_mob(mob/living/M, method=TOUCH, reac_volume)
	if(method == INGEST)
		injested = TRUE
		return
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "pyre_elementum", /datum/mood_event/irritate, name)		// Applied if not eaten
	if(method == TOUCH || method == VAPOR)
		M.adjust_fire_stacks(reac_volume / 5)
		return
	..()

/datum/reagent/consumable/pyre_elementum/on_mob_life(mob/living/carbon/M)
	M.adjust_bodytemperature(20 * TEMPERATURE_DAMAGE_COEFFICIENT, 0, M.get_body_temp_normal())		// Doesn't kill you like capsaicin
	if(M.nutrition && (M.nutrition + hunger_drain > 0))
		M.adjust_nutrition(hunger_drain)
	if(!injested)							// Unless you didn't eat it
		M.adjustFireLoss(0.25*REM, 0)

/datum/reagent/consumable/pyre_elementum/on_mob_end_metabolize(mob/living/M)
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "pyre_elementum")
	..()
