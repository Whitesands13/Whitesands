/obj/item/clothing/gloves/color/yellow/sprayon/tape
	name = "taped-on insulated gloves"
	desc = "This is a totally safe idea."
	icon = 'waspstation/icons/obj/clothing/gloves.dmi'
	icon_state = "yellowtape"
	item_state = "ygloves"
	shocks_remaining = 3

/obj/item/clothing/gloves/color/yellow/sprayon/Shocked()
	if(prob(50)) //Fear the unpredictable
		shocks_remaining--
	if(shocks_remaining <= 0)
		qdel(src)
