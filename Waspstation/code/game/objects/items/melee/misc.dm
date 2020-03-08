/obj/item/melee/greykingsword
	name = "blade of the grey-king"
	desc = "An incredibly impractical sword that looks like 3 replica katanas nailed together by an ametur smith."
	icon = 'waspstation/icons/obj/items_and_weapons.dmi'
	icon_state = "grey_sword"
	item_state = "swordoff"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BACK
	force = 16
	throwforce = 8
	w_class = WEIGHT_CLASS_NORMAL
	block_chance = 30
	attack_verb = list("struck", "slashed", "mall-ninjad", "tided", "multi-shanked", "shredded")
	custom_materials = list(/datum/material/iron = 1420)
	sharpness = IS_SHARP

/obj/item/melee/greykingsword/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text, final_block_chance, damage, attack_type)
	if(attack_type == PROJECTILE_ATTACK)
		final_block_chance = 1 //Still not like your Japaniese animes though.
	return ..()

/obj/item/melee/greykingsword/suicide_act(mob/user)
	if (istype(user, /mob/living/carbon/human/))
		var/mob/living/carbon/human/H = user
		H.forcesay("Master forgive me, but I will have to go all out... Just this once")
	user.visible_message("<span class='suicide'>[user] is cutting [user.p_them()]self on [user.p_their()] own edge!")
	return (BRUTELOSS) //appropriate
