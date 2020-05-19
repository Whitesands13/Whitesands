GLOBAL_LIST_INIT(spider_first, world.file2list("strings/names/spider_first.txt"))
GLOBAL_LIST_INIT(spider_last, world.file2list("strings/names/spider_last.txt"))

/obj/item/organ/eyes/night_vision/spider
	name = "spider eyes"
	desc = "These eyes seem to have increased sensitivity to bright light, offset by basic night vision."
	flash_protect = FLASH_PROTECTION_SENSITIVE

/obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/spider
	icon_state = "spidermeat"
	desc = "The stringy meat jokes have been done to death, just like this Arachnid."
	list_reagents = list(/datum/reagent/consumable/nutriment = 3)
	filling_color = "#00FFFF"
	tastes = list("meat" = 3, "stringy" = 1)
	foodtype = MEAT | RAW | TOXIC

/datum/species/spider
	name = "Arachnid"
	id = "spider"
	sexes = 0
	say_mod = "chitters"
	default_color = "00FF00"
	species_traits = list(LIPS, NOEYESPRITES)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BUG
	mutant_bodyparts = list("spider_legs", "spider_spinneret")
	default_features = list("spider_legs" = "Plain", "spider_spinneret" = "Plain")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/spider
	liked_food = MEAT | RAW | GROSS
	disliked_food = FRUIT
	toxic_food = VEGETABLES | DAIRY | CLOTH
	mutanteyes = /obj/item/organ/eyes/night_vision/spider
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/spider
	loreblurb = ""

/datum/species/spider/regenerate_organs(mob/living/carbon/C,datum/species/old_species,replace_current=TRUE,list/excluded_zones)
	. = ..()
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		handle_mutant_bodyparts(H)

/proc/random_unique_spider_name(attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		. = capitalize(pick(GLOB.spider_first)) + " " + capitalize(pick(GLOB.spider_last))

		if(!findname(.))
			break

/proc/spider_name()
	return "[pick(GLOB.spider_first)] [pick(GLOB.spider_last)]"

/datum/species/spider/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_spider_name()

	var/randname = spider_name()

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/spider/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	. = ..()
	if(chem.type == /datum/reagent/toxin/pestkiller)
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.type, REAGENTS_METABOLISM)

/datum/species/spider/check_species_weakness(obj/item/weapon, mob/living/attacker)
	if(istype(weapon, /obj/item/melee/flyswatter))
		return 9 //flyswatters deal 10x damage to spiders
	return 0

/datum/species/spider/on_species_gain(mob/living/carbon/human/H, datum/species/old_species)
	. = ..()
	var/datum/action/innate/change_color/S = new
	S.Grant(H)

/datum/species/spider/on_species_loss(mob/living/carbon/human/H)
	. = ..()
	var/datum/action/innate/spin_web/S = locate(/datum/action/innate/spin_web) in H.actions
	S?.Remove(H)

/datum/action/innate/spin_web
    name = "Spin Web"
    check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUN|AB_CHECK_CONSCIOUS
    icon_icon = 'icons/mob/actions.dmi'
    button_icon_state = "spiderweb"

/datum/action/innate/spin_cocoon
	name = "Spin Cocoon"
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUN|AB_CHECK_CONSCIOUS
	icon_icon = 'icons/mob/actions.dmi'
	button_icon_state = "spidercocoon"

/datum/action/innate/spin_web/Activate()
	var/mob/living/carbon/human/species/spider/H = owner
	if(H.stat == "DEAD")
		return
	if(H.web_ready == FALSE)
		to_chat(H, "<span class='warning'>You need to wait awhile to regenerate web fluid.</span>")
		return
	var/turf/T = get_turf(H)
	if(!T)
		to_chat(H, "<span class='warning'>There's no room to spin your web here!</span>")
		return
	var/obj/structure/spider/stickyweb/W = locate() in T
	var/obj/structure/spider_player/W2 = locate() in T
	if(W || W2)
		to_chat(H, "<span class='warning'>There's already a web here!</span>")
		return
	 // Should have some minimum amount of food before trying to activate
	var/nutrition_threshold = NUTRITION_LEVEL_FED
	if (H.nutrition >= nutrition_threshold)
		to_chat(H, "<i>You begin spinning some web...</i>")
		if(!do_after(H, 10 SECONDS, 1, T))
			to_chat(H, "<span class='warning'>Your web spinning was interrupted!</span>")
			return
		if(prob(75))
			H.adjust_nutrition(-H.spinner_rate)
			addtimer(VARSET_CALLBACK(H, web_ready, TRUE), H.web_cooldown)
			to_chat(H, "<i>You use up a fair amount of energy spinning the web.</i>")
		new /obj/structure/spider_player()
		to_chat(H, "<i>You weave a web on the ground with your spinneret!</i>")

	else
		to_chat(H, "<span class='warning'>You're too hungry to spin web right now, eat something first!</span>")
		return
/*
	This took me far too long to figure out so I'm gonna document it here.
	1) Create an innate action for the species
	2) Have that action trigger a RegisterSignal for mob clicking
	3) Trigger the cocoonAtom proc on that signal
	4) Validate the target then start spinning
	5) if you're not interrupted, force move the target to the cocoon created at their location.
*/
/datum/action/innate/spin_cocoon/Activate()
	var/mob/living/carbon/human/species/spider/H = owner
	if(H.stat == "DEAD")
		return
	if(H.web_ready == FALSE)
		to_chat(H, "<span class='warning'>You need to wait awhile to regenerate web fluid.</span>")
		return
	var/nutrition_threshold = NUTRITION_LEVEL_FED
	if (H.nutrition >= nutrition_threshold)
		to_chat(H, "<span class='warning'>You pull out a strand from your spinneret, ready to wrap a target. <BR>\
		 (Press ALT+CLICK or MMB on the target to start wrapping.)</span>")
		H.adjust_nutrition(H.spinner_rate * -3)
		RegisterSignal(H, list(COMSIG_MOB_MIDDLECLICKON, COMSIG_MOB_ALTCLICKON), .proc/cocoonAtom)
		return
	else
		to_chat(H, "<span class='warning'>You're too hungry to spin web right now, eat something first!</span>")
		return

/datum/action/innate/spin_cocoon/proc/cocoonAtom(mob/living/carbon/human/species/spider/H, atom/movable/A)
	UnregisterSignal(H, list(COMSIG_MOB_MIDDLECLICKON, COMSIG_MOB_ALTCLICKON))
	if (!H || !isspiderperson(H))
		return COMSIG_MOB_CANCEL_CLICKON
	else
		if(!do_after(H, 10 SECONDS, 1, A))
			to_chat(H, "<span class='warning'>Your web spinning was interrupted!</span>")
			return
		var/obj/structure/spider_player/cocoon/C = new(A.loc)
		if(isliving(A))
			C.icon_state = pick("cocoon_large1","cocoon_large2","cocoon_large3")
			A.forceMove(C)
			H.visible_message("<span class='danger'>[H] wraps [A] into a large cocoon!</span>")
			return
		else
			A.forceMove(C)
			H.visible_message("<span class='danger'>[H] wraps [A] into a cocoon!</span>")
			return
