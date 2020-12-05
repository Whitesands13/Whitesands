// Pomegranate
/obj/item/seeds/pomegranate
	name = "pack of pomegranate seeds"
	desc = "These seeds grow into a pomegranate tree."
	icon_state = "seed-pomegranate"
	species = "pomegranate"
	plantname = "Pomegranate Tree"
	product = /obj/item/reagent_containers/food/snacks/grown/pomegranate
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.30, /datum/reagent/consumable/nutriment = 0.16, /datum/reagent/medicine/folate = 0.16, /datum/reagent/potassium= 0.16)
	// No rarity: technically it's a beneficial mutant, but it's not exactly "new"...
	mutatelist = list()

/obj/item/reagent_containers/food/snacks/grown/pomegranate
	seed = /obj/item/seeds/pomegranate
	name = "pomegranate"
	desc = "A highly nutritious fruit notable for its high vitamin content and for its seeds each being individual berries te size of one's pinky nail, arranged in clusters that are separated by a thin membrane."
	icon_state = "pomegranate"
	filling_color = "#FF6347"
	tastes = list("pomegranate" = 1)
	distill_reagent = /datum/reagent/consumable/grenadine
