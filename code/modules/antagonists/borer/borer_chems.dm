/datum/borer_chem
	var/chem
	var/chemname = "chemical"
	var/chem_desc = "This is a chemical. Also a bug. Yell at a coder."
	var/chemuse = 30
	var/quantity = 10

/datum/borer_chem/epinephrine
	chem = /datum/reagent/medicine/epinephrine
	chemname = "epinephrine"
	chem_desc = "Stabilizes critical condition and slowly restores oxygen damage. If overdosed, it will deal toxin and oxyloss damage."

/datum/borer_chem/leporazine
	chem = /datum/reagent/medicine/leporazine
	chemname = "leporazine"
	chem_desc = "This keeps a patient's body temperature stable. High doses can allow short periods of unprotected EVA."
	chemuse = 75

/datum/borer_chem/mannitol
	chem = /datum/reagent/medicine/mannitol
	chemname = "mannitol"
	chem_desc = "Heals brain damage."

/datum/borer_chem/bicaridine
	chem = /datum/reagent/medicine/bicaridine
	chemname = "bicaridine"
	chem_desc = "Heals brute damage."

/datum/borer_chem/kelotane
	chem = /datum/reagent/medicine/kelotane
	chemname = "kelotane"
	chem_desc = "Heals burn damage."

/datum/borer_chem/dexalin
	chem = /datum/reagent/medicine/dexalin
	chemname = "dexalin"
	chem_desc = "Heals suffocation damage."

/datum/borer_chem/charcoal
	chem = /datum/reagent/medicine/charcoal
	chemname = "charcoal"
	chem_desc = "Slowly heals toxin damage, will also slowly remove any other chemicals."

/datum/borer_chem/methamphetamine
	chem = /datum/reagent/drug/methamphetamine
	chemname = "methamphetamine"
	chem_desc = "Reduces stun times, increases stamina and run speed while dealing brain damage. If overdosed it will deal toxin and brain damage."
	chemuse = 50
	quantity = 9

/datum/borer_chem/spacedrugs
	chem = /datum/reagent/drug/space_drugs
	chemname = "space drugs"
	chem_desc = "Get your host high as a kite."
	chemuse = 75

/datum/borer_chem/creagent
	chem = /datum/reagent/colorful_reagent
	chemname = "colorful reagent"
	chem_desc = "Change the colour of your host."
	chemuse = 100

/datum/borer_chem/ethanol
	chem = /datum/reagent/consumable/ethanol
	chemname = "ethanol"
	chem_desc = "The most potent alcoholic 'beverage', with the fastest toxicity."
	chemuse = 50

/datum/borer_chem/rezadone
	chem = /datum/reagent/medicine/rezadone
	chemname = "rezadone"
	chem_desc = "Heals cellular damage."
