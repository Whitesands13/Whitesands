/mob/living/simple_animal/hostile/retaliate/clowndola
	name = "Clowndola"
	real_name = "Clowndola"
	desc = "Clowndola is the noisy walker. Having no hands he embodies the Taoist principle of honk (HonkMother) while his smiling facial expression shows his utter and complete acceptance of the world as it is. Its hide is extremely valuable."
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "kicks"
	icon_state = "clowndola"
	icon_living = "clowndola"
	icon_dead = "clowndola_dead"
	icon = 'icons/mob/gondola.dmi'
	a_intent = INTENT_HARM
	//Gondolas aren't affected by cold.
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	maxHealth = 100
	health = 100
	attack_sound = list('sound/items/airhorn2.ogg', 'sound/items/airhorn.ogg', 'sound/items/carhorn.ogg', 'sound/items/bikehorn.ogg')
	speak_chance = 20
	turns_per_move = 1
	maxHealth = 80
	health = 80
	butcher_results = list(/obj/effect/decal/cleanable/blood/gibs, /obj/item/stack/sheet/animalhide/gondola = 1, /obj/item/reagent_containers/food/snacks/meat/slab/clowndola = 1)
	obj_damage = 0
	melee_damage = 1
	attack_same = 0
	attacktext = "honks at"
	faction = list("clowndola")
	environment_smash = ENVIRONMENT_SMASH_NONE
	mouse_opacity = MOUSE_OPACITY_ICON
	vision_range = 13
	speed = 0
	ventcrawler = VENTCRAWLER_ALWAYS
	robust_searching = 1
	unique_name = 1
	speak_emote = list("honk!", "Honk?", "HONK HONK")
	deathmessage = "honked for the last time..."

	rapid_melee = 3

	var/poison_happy = /datum/reagent/drug/happiness
	var/poison_angry = /datum/reagent/consumable/superlaughter
	var/poison_amount = 0.5
	var/is_angry = FALSE

/mob/living/simple_animal/hostile/retaliate/clowndola/Life()
	if(health <= maxHealth/2)		//If life is inferior as 50%, become angry, otherwise is happy
		is_angry = TRUE
		poison_amount = 1
		speed = -5
		melee_damage = 1
	else
		is_angry = FALSE
		poison_amount = 0.5
		speed = 0
		melee_damage = 0.5

/mob/living/simple_animal/hostile/retaliate/clowndola/AttackingTarget()
	. = ..()
	if(. && isliving(target))
		var/mob/living/T = target
		if(is_angry == FALSE && T.reagents)
			T.reagents.add_reagent(poison_happy, poison_amount)
		else
			T.reagents.add_reagent(poison_angry, poison_amount)


/mob/living/simple_animal/hostile/retaliate/clowndola/examine(mob/user)
	. = ..()
	if(health >= maxHealth)
		. += "<span class='info'>It looks healthy and smile for no apparent reason.</span>"
	else
		. += "<span class='info'>It looks like it's been roughed up.</span>"

/mob/living/simple_animal/hostile/retaliate/clowndola/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	if(!retreat_distance && prob(20))
		retreat_distance = 5
		addtimer(CALLBACK(src, .proc/stop_retreat), 20)
	. = ..()

/mob/living/simple_animal/hostile/retaliate/clowndola/proc/stop_retreat()
	retreat_distance = null
