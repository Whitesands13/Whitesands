/obj/item/reagent_containers/food/drinks/bottle/sarsaparilla
	name = "SandBlast Sarsaparilla"
	desc = "Sealed for a guaranteed fresh taste in every bottle."
	icon_state = "sandbottle"
	volume = 50
	list_reagents = list(/datum/reagent/medicine/molten_bubbles/sand = 50)
	reagent_flags = null //Cap's on

/obj/item/reagent_containers/food/drinks/bottle/sarsaparilla/attack_self(mob/user)
	if(reagents.flags == null) // Uses the reagents.flags cause reagent_flags is only the init value
		playsound(src, 'waspstation/sound/items/openbottle.ogg', 30, 1)
		user.visible_message("<span class='notice'>[user] takes the cap off [src].</span>", "<span class='notice'>You take the cap off [src].</span>")
		reagents.flags = OPENCONTAINER //Cap's off
		if(prob(1)) //Lucky you
			var/S = new /obj/item/sandstar(src)
			user.put_in_hands(S)
			to_chat(user, "<span class='notice'>You found a SandBlast Star!</span>")
	else
		. = ..()

/obj/item/reagent_containers/food/drinks/bottle/sarsaparilla/examine(mob/user)
	. = ..()
	if(reagent.flags == null)
		. += "<span class='info'>The cap is still sealed.</span>"

/obj/item/sandstar
	name = "SandBlast Sarsaparilla star"
	desc = "Legend says something amazing happens when you collect enough of these."
	custom_price = 100
	custom_premium_price = 110
	icon = 'waspstation/icons/obj/items_and_weapons.dmi'
	icon_state = "sandstar"
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/gold = 200)

