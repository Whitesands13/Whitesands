// == Spawners == \\

/obj/effect/mob_spawn/human/casino
	name = "casino sleeper"
	desc = "A long-term sleeper designed for VIP guests."
	mob_name = "casino guest"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	objectives = "Hit the jackpot, baby!"
	death = FALSE
	roundstart = FALSE
	random = TRUE
	outfit = /datum/outfit/casino
	short_desc = "You are a VIP guest at a top-of-the-line casino!"
	flavour_text = "You are a VIP guest at a top-of-the-line casino! You were waiting in stasis for the value of your account to reach <b>1000 credits</b>, now you just gotta win the jackpot and you'll be rich!"
	assignedrole = "Casino Guest"

/obj/effect/mob_spawn/human/casino/staff
	name = "casino staff sleeper"
	desc = "A long-term sleeper designed for casino staff."
	mob_name = "casino staff"
	objectives = "Cater to visiting guests with your fellow staff. Do not harm potential players, and remember: The house always wins!"
	outfit = /datum/outfit/casino/staff
	short_desc = "You are a staff member on a top-of-the-line space casino!"
	flavour_text = "You are a staff member on a top-of-the-line space casino! Cater to guests and sucker players out of their funds."
	assignedrole = "Casino Staff"

/obj/effect/mob_spawn/human/casino/staff/security
	name = "casino guard sleeper"
	mob_name = "casino guard"
	outfit = /datum/outfit/casino/staff/security
	short_desc = "You are a peacekeeper."
	flavour_text = "You have been assigned to this casino to protect the interests of the company while keeping the peace between \
		guests and staff getting violent after a bust."
	important_info = "Do NOT harm the guests, as that is grounds for contract termination."
	objectives = "Try and keep the peace between staff and guests, non-lethal force is expected."
	assignedrole = "Casino Guard"

// == Outfits ==

/datum/outfit/casino
	name = "Casino Guest"
	shoes = /obj/item/clothing/shoes/laceup
	id = /obj/item/card/id/away/casino

/datum/outfit/casino/pre_equip(mob/living/carbon/human/H, visualsOnly)
	if(uniform == null)
		var/suits = list(
			/obj/item/clothing/under/suit/charcoal,
			/obj/item/clothing/under/suit/navy,
			/obj/item/clothing/under/suit/burgundy,
			/obj/item/clothing/under/suit/tan,
			/obj/item/clothing/under/suit/beige
		)
		if(H.gender == FEMALE)
			suits += list(
				/obj/item/clothing/under/suit/black/female,
				/obj/item/clothing/under/suit/black/skirt,
				/obj/item/clothing/under/suit/black_really/skirt,
				/obj/item/clothing/under/suit/white/skirt,
				/obj/item/clothing/under/rank/civilian/curator/skirt
			)
		else
			suits += list(
				/obj/item/clothing/under/suit/black,
				/obj/item/clothing/under/suit/red,
				/obj/item/clothing/under/suit/checkered,
				/obj/item/clothing/under/suit/blacktwopiece,
				/obj/item/clothing/under/misc/vice_officer
			)
		uniform = pick(suits)
	if(prob(30) && !visualsOnly && glasses == null)
		glasses = /obj/item/clothing/glasses/sunglasses
	. = ..()

/datum/outfit/casino/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	//Set ID cash
	if(!visualsOnly)
		var/datum/bank_account/bank_account = new(H.real_name, null)
		bank_account.adjust_money(1000)
		H.account_id = bank_account.account_id
		var/obj/item/card/id/card = H.get_idcard(FALSE)
		if(card)
			card.registered_account = bank_account
			bank_account.bank_cards += card

/datum/outfit/casino/staff
	name = "Casino Staff"
	uniform = /obj/item/clothing/under/misc/assistantformal
	ears = /obj/item/radio/headset
	back = /obj/item/storage/backpack/satchel
	implants = list(/obj/item/implant/mindshield)
	backpack_contents = list(
		/obj/item/storage/box/survival,
		/obj/item/toy/cards/deck
	)
	l_pocket = /obj/item/lighter/greyscale
	id = /obj/item/card/id/away/casino/staff

/datum/outfit/casino/staff/security
	name = "Casino Guard"
	uniform = /obj/item/clothing/under/misc/bouncer
	belt = /obj/item/storage/belt/security/full
	suit = /obj/item/clothing/suit/armor/vest/blueshirt
	l_pocket = /obj/item/restraints/handcuffs/cable/zipties
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/fingerless
	id = /obj/item/card/id/away/casino/security
