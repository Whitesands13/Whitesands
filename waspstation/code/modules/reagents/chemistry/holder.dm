/datum/reagents/proc/set_reacting(react = TRUE)
	if(react)
		flags &= ~(REAGENT_NOREACT)
