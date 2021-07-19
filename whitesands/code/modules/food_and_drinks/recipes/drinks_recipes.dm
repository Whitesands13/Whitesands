////////////////////////////////////// COCKTAILS //////////////////////////////////////

/*  EXAMPLE of a drink recipe ~ Kryyto ~

/datum/chemical_reaction/sarsaparilliansunset
	name = "Sarsaparillian Sunset"
	id = /datum/reagent/consumable/ethanol/sarsaparilliansunset
	results = list(/datum/reagent/consumable/ethanol/sarsaparilliansunset = 5)
	required_reagents = list(/datum/reagent/consumable/ethanol/tequila_sunrise = 5, /datum/reagent/consumable/nuka_cola = 1, /datum/reagent/napalm = 1)         Will be use
	required_catalysts = list(/datum/reagent/consumable/enzyme = 5)                                                                                             Will NOT be use
	required_temp = 320
	mix_message = "The mixture ignites."
	mix_sound = 'sound/items/lighter_on.ogg'                                                                                                                    .ogg or .wav only       (ogg being like an mp3 on Groove)
*/

/datum/chemical_reaction/vodka_cola
	results = list(/datum/reagent/consumable/ethanol/vodka_cola = 15)
	required_reagents = list(/datum/reagent/consumable/ethanol/vodka = 10, /datum/reagent/consumable/space_cola = 5)
	mix_message = "Nothing special."

/datum/chemical_reaction/vodka_soda
	results = list(/datum/reagent/consumable/ethanol/vodka_soda = 15)
	required_reagents = list(/datum/reagent/consumable/ethanol/vodka = 10, /datum/reagent/consumable/sodawater = 5)
	mix_message = "Nothing special."

/datum/chemical_reaction/salty_water
	results = list(/datum/reagent/consumable/salty_water = 5)
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/medicine/salglu_solution = 1)
	mix_message = "Nothing special."

/datum/chemical_reaction/death_afternoon
	results = list(/datum/reagent/consumable/ethanol/death_afternoon = 4)
	required_reagents = list(/datum/reagent/consumable/ethanol/champagne = 3, /datum/reagent/consumable/ethanol/absinthe = 1)
	mix_message = "You felt a pain in your chest, you can't describe it."

/datum/chemical_reaction/triple_coke
	results = list(/datum/reagent/consumable/ethanol/triple_coke = 15)
	required_reagents = list(/datum/reagent/consumable/ethanol/vodka_cola = 5, /datum/reagent/consumable/ethanol/whiskey_cola = 5, /datum/reagent/consumable/ethanol/rum_coke = 5)
	mix_message = "The reaction scream for a moment, then settle down."

/datum/chemical_reaction/black_roulette
	results = list(/datum/reagent/consumable/ethanol/black_roulette = 5)
	required_reagents = list(/datum/reagent/consumable/ethanol/black_russian = 5, /datum/reagent/medicine/strange_reagent = 1)
	mix_message = "You hear a mechanical sound coming from the drink."

/datum/chemical_reaction/mine_dread
	results = list(/datum/reagent/consumable/ethanol/mine_dread = 10)
	required_reagents = list(/datum/reagent/blood = 5, /datum/reagent/ash = 5)
	mix_message = "You can hear the demons from another world."

/datum/chemical_reaction/electro_blaster
	results = list(/datum/reagent/consumable/ethanol/electro_blaster = 10)
	required_reagents = list(/datum/reagent/consumable/ethanol/screwdrivercocktail = 5, /datum/reagent/consumable/ethanol/thirteenloko = 5)
	mix_message = "Electrical sparks come out of the drink."

/datum/chemical_reaction/spriters_bane
	results = list(/datum/reagent/consumable/ethanol/spriters_bane = 3)
	required_reagents = list(/datum/reagent/consumable/ethanol/fernet = 1, /datum/reagent/consumable/ethanol/rum = 1, /datum/reagent/consumable/ethanol/black_russian = 1)
	mix_message = "The solution begins to bubble over and coats the glass in a black outline."
