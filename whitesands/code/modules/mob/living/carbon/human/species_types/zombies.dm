#define REGENERATION_DELAY 15  // After taking damage, how long it takes for automatic regeneration to begin

/obj/item/organ/zombie_infection/experimental
	name = "strange festering ooze"
	desc = "A black web of pus and viscera, with flecks of plasma floating inside."
	causes_damage = FALSE
	revive_time_min = 100
	revive_time_max = 120

/datum/species/zombie/experimental
	name = "High-Functioning Experimental Zombie"
	id = "memezombies"
	limbs_id = "zombie"
	mutanthands = /obj/item/zombie_hand
	armor = 20
	speedmod = 2
	mutanteyes = /obj/item/organ/eyes/night_vision/zombie
	var/heal_rate = 4
	var/regen_cooldown = 0
	changesource_flags = MIRROR_BADMIN | WABBAJACK | ERT_SPAWN

/datum/reagent/romerol/experimental
	name = "COVID-20 Romerol Derivative"
	description = "A variant of COVID-20, this Romerol synthetic derivative drastically improves the healing \
	capabilities of infected hosts, and provides control mechanisms for Syndicate agents in the field."

/obj/item/organ/zombie_infection/experimental/on_find(mob/living/finder)
	to_chat(finder, "<span class='warning'>Inside the head is a disgusting black \
		web of pus and viscera, bound tightly around the brain like some \
		biological harness. As you look closer, you can see thiny specks \
		of plasma floating in the ooze.</span>")

/obj/item/organ/zombie_infection/experimental/zombify()
	timer_id = null

	if(!converts_living && owner.stat != DEAD)
		return

	var/stand_up = (owner.stat == DEAD) || (owner.stat == UNCONSCIOUS)

	if(!iszombie(owner))
		old_species = owner.dna.species.type
		owner.set_species(/datum/species/zombie/experimental)
		to_chat(owner, "<span class='alertalien'>You are now a zombie! Do not seek to be cured, do not help any non-zombies in any way, do not harm your zombie brethren and spread the disease by killing others. You are a creature of hunger and violence.</span>")
		to_chat(owner, "<span class='alertalien'>You are a special variant of zombie \
			with control nanites embedded within you. Do not harm syndicate operatives, \
			and obey their directives if able.</span>")
		owner.visible_message("<span class='danger'>[owner] suddenly convulses, as [owner.p_they()][stand_up ? " stagger to [owner.p_their()] feet and" : ""] gain a ravenous hunger in [owner.p_their()] eyes!</span>", "<span class='alien'>You HUNGER!</span>")

	//Fully heal the zombie's damage the first time they rise
	owner.setToxLoss(0, 0)
	owner.setOxyLoss(0, 0)
	owner.heal_overall_damage(INFINITY, INFINITY, INFINITY, null, TRUE)

	if(!owner.revive(full_heal = FALSE, admin_revive = FALSE))
		return

	owner.grab_ghost()
	owner.visible_message("<span class='danger'>[owner] suddenly convulses, as [owner.p_they()][stand_up ? " stagger to [owner.p_their()] feet and" : ""] gain a ravenous hunger in [owner.p_their()] eyes!</span>", "<span class='alien'>You HUNGER!</span>")
	playsound(owner.loc, 'sound/hallucinations/far_noise.ogg', 50, TRUE)
	owner.do_jitter_animation(living_transformation_time)
	owner.Stun(living_transformation_time)

/// Zombies do not stabilize body temperature they are the walking dead and are cold blooded
/datum/species/zombie/experimental/natural_bodytemperature_stabilization(datum/gas_mixture/environment, mob/living/carbon/human/H)
	return

/datum/species/zombie/experimental/check_roundstart_eligible()
	return FALSE

/datum/species/zombie/experimental/spec_stun(mob/living/carbon/human/H,amount)
	. = min(20, amount)

/datum/species/zombie/experimental/apply_damage(damage, damagetype = BRUTE, def_zone = null, blocked, mob/living/carbon/human/H, forced = FALSE)
	. = ..()
	if(.)
		regen_cooldown = world.time + REGENERATION_DELAY

/datum/species/zombie/experimental/spec_life(mob/living/carbon/C)
	. = ..()
	C.a_intent = INTENT_HARM // THE SUFFERING MUST FLOW

	//Zombies never actually die, they just fall down until they regenerate enough to rise back up.
	//They must be restrained, beheaded or gibbed to stop being a threat.
	if(regen_cooldown < world.time)
		var/heal_amt = heal_rate
		C.heal_overall_damage(heal_amt,heal_amt)
		C.adjustToxLoss(-heal_amt)
	if(!HAS_TRAIT(C, TRAIT_CRITICAL_CONDITION) && prob(4))
		playsound(C, pick(spooks), 50, TRUE, 10)

//Congrats you somehow died so hard you stopped being a zombie
/datum/species/zombie/experimental/spec_death(gibbed, mob/living/carbon/C)
	. = ..()
	var/obj/item/organ/zombie_infection/experimental/infection
	infection = C.getorganslot(ORGAN_SLOT_ZOMBIE)
	if(infection)
		qdel(infection)

/datum/species/zombie/experimental/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	// Deal with the source of this zombie corruption
	//  Infection organ needs to be handled separately from mutant_organs
	//  because it persists through species transitions
	var/obj/item/organ/zombie_infection/experimental/infection
	infection = C.getorganslot(ORGAN_SLOT_ZOMBIE)
	if(!infection)
		infection = new()
		infection.Insert(C)
	GLOB.huds[ANTAG_HUD_TRAITOR].add_hud_to(C)

/datum/reagent/romerol/experimental/expose_mob(mob/living/carbon/human/H, method=TOUCH, reac_volume)
	// Silently add the zombie infection organ to be activated upon death
	if(!H.getorganslot(ORGAN_SLOT_ZOMBIE))
		var/obj/item/organ/zombie_infection/experimental/ZI = new()
		ZI.Insert(H)
	..()
