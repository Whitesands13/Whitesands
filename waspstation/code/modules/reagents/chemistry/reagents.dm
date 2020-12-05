// Called every time reagent containers process.
/datum/reagent/process()
	if(!holder || holder.flags & REAGENT_NOREACT)
		return FALSE
	return TRUE
