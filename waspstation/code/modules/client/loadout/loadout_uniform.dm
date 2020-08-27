// Uniform slot
/datum/gear/uniform
	subtype_path = /datum/gear/uniform
	slot = ITEM_SLOT_ICLOTHING
	sort_category = "Uniforms"

//Colored jumpsuits

/datum/gear/uniform/color
	subtype_path = /datum/gear/uniform/color
	cost = 1000

/datum/gear/uniform/color/red
	display_name = "jumpsuit, red"
	path = /obj/item/clothing/under/color/red

/datum/gear/uniform/color/green
	display_name = "jumpsuit, green"
	path = /obj/item/clothing/under/color/green

/datum/gear/uniform/color/blue
	display_name = "jumpsuit, blue"
	path = /obj/item/clothing/under/color/blue

/datum/gear/uniform/color/yellow
	display_name = "jumpsuit, yellow"
	path = /obj/item/clothing/under/color/yellow

/datum/gear/uniform/color/pink
	display_name = "jumpsuit, pink"
	path = /obj/item/clothing/under/color/pink

/datum/gear/uniform/color/black
	display_name = "jumpsuit, black"
	path = /obj/item/clothing/under/color/black

/datum/gear/uniform/color/white
	display_name = "jumpsuit, white"
	path = /obj/item/clothing/under/color/white

/datum/gear/uniform/color/random
	display_name = "jumpsuit, random"
	path = /obj/item/clothing/under/color/random //literally useless if grey assistants is off
	cost = 2500

/datum/gear/uniform/color/rainbow
	display_name = "jumpsuit, rainbow"
	path = /obj/item/clothing/under/color/rainbow
	cost = 5000

//Shorts

/datum/gear/uniform/athshortsred
	display_name = "athletic shorts, red"
	path = /obj/item/clothing/under/shorts/red
	cost = 1000

/datum/gear/uniform/athshortsblack
	display_name = "athletic shorts, black"
	path = /obj/item/clothing/under/shorts/black
	cost = 1000

//JUMPSUIT "SUITS"

/datum/gear/uniform/suit
	subtype_path = /datum/gear/uniform/suit
	cost = 1000

/datum/gear/uniform/suit/amish
	display_name = "suit, amish"
	path = /obj/item/clothing/under/suit/sl

/datum/gear/uniform/suit/white
	display_name = "suit, white"
	path = /obj/item/clothing/under/suit/white

/datum/gear/uniform/suit/tan
	display_name = "suit, tan"
	path = /obj/item/clothing/under/suit/tan

/datum/gear/uniform/suit/black
	display_name = "suit, executive"
	path = /obj/item/clothing/under/suit/black_really

/datum/gear/uniform/suit/black/skirt
	display_name = "suitskirt, executive"
	path = /obj/item/clothing/under/suit/black_really/skirt

/datum/gear/uniform/suit/navy
	display_name = "suit, navy"
	path = /obj/item/clothing/under/suit/navy

/datum/gear/uniform/suit/burgundy
	display_name = "suit, burgundy"
	path = /obj/item/clothing/under/suit/burgundy

/datum/gear/uniform/suit/galaxy
	display_name = "suit, galaxy"
	path = /obj/item/clothing/under/rank/civilian/lawyer/galaxy
	cost = 7500

/datum/gear/uniform/suit/white/skirt
	display_name = "suitskirt, white shirt"
	path = /obj/item/clothing/under/suit/black/skirt

/datum/gear/uniform/suit/white
	display_name = "suit, white shirt"
	path = /obj/item/clothing/under/suit/black
//Premium
/datum/gear/uniform/tacticool
	display_name = "tacticool turtleneck"
	path = /obj/item/clothing/under/syndicate/tacticool
	cost = 10000

//Polychromic stuff
/datum/gear/uniform/polychromic
	subtype_path = /datum/gear/uniform/polychromic
	cost = 5000

/datum/gear/uniform/polychromic/jumpsuit
	display_name = "polychromic tri-tone jumpsuit"
	description = "A fancy jumpsuit made with polychromic threads."
	path = /obj/item/clothing/under/misc/polyjumpsuit

/datum/gear/uniform/polychromic/skirt
	display_name = "polychromic skirt"
	description = "A fancy skirt made with polychromic threads."
	path = /obj/item/clothing/under/dress/skirt/polychromic

/datum/gear/uniform/polychromic/pleated
	display_name = "polychromic pleated skirt"
	description = "A magnificent pleated skirt complements the woolen polychromatic sweater."
	path = /obj/item/clothing/under/misc/polyjumpsuit

/datum/gear/uniform/polychromic/shorts
	display_name = "polychromic athletic shorts"
	description = "95% Polychrome, 5% Spandex!"
	path = /obj/item/clothing/under/shorts/polychromic

/datum/gear/uniform/polychromic/buttonup
	display_name = "polychromic button-up shirt"
	description = "A fancy button-up shirt made with polychromic threads."
	path = /obj/item/clothing/under/misc/poly_shirt

/datum/gear/uniform/polychromic/buttonup
	display_name = "polychromic kilt"
	description = "It's not a skirt!"
	path = /obj/item/clothing/under/costume/kilt/polychromic

//Degenerate
/datum/gear/uniform/polychromic/pantsu
	display_name = "polychromic panties" //This is totally cursed by Mald "totally" signed off on this - BFAT
	description = "Topless striped panties. Now with 120% more polychrome!"
	path = /obj/item/clothing/under/shorts/polychromic/pantsu

/datum/gear/uniform/polychromic/bottomless
	display_name = "polychromic bottomless shirt" //But hey, at least the boys can air out too
	description = "Great for showing off your underwear in dubious style."
	path = /obj/item/clothing/under/misc/poly_bottomless

/datum/gear/uniform/polychromic/tanktop
	display_name = "polychromic tank top" //Honestly, we have such a wide variety of underwear....
	description = "For those lazy summer days."
	path = /obj/item/clothing/under/misc/poly_tanktop

/datum/gear/uniform/polychromic/femtanktop
	display_name = "polychromic feminine tank top" //and the Darkholme outfit exists.
	description = "Great for showing off your chest in style. Not recommended for males."
	path = /obj/item/clothing/under/misc/poly_tanktop/female
