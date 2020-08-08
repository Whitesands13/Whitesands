#define HOLOGRAM_CYCLE_COLORS list("#00ffff", "#ffc0cb", "#9400D3", "#4B0082", "#0000FF", "#00FF00", "#FFFF00", "#FF7F00", "#FF0000")

/mob/living/simple_animal/hologram
	name = "hologram"
	initial_language_holder = /datum/language_holder/universal
	icon = 'icons/effects/effects.dmi'
	icon_state = "static"
	gender = NEUTER
	mob_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	speed = -1
	unsuitable_atmos_damage = 0
	healable = FALSE
	wander = FALSE
	possible_a_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	status_flags = (CANPUSH | CANSTUN | CANKNOCKDOWN)
	dextrous = TRUE
	dextrous_hud_type = /datum/hud/dextrous/hologram
	hud_possible = list(DIAG_STAT_HUD, DIAG_HUD, ANTAG_HUD)
	held_items = list(null, null)
	damage_coeff = list(BRUTE = 0, BURN = 0, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)

	/// The area it was spawned in and cannot leave
	var/area/source_area
	/// The holopad that contains it currently. NOT ALWAYS THE SPAWN HOLOPAD
	var/obj/machinery/holopad/holopad
	///The placeholder hologram that allows the holorays to function
	var/obj/effect/overlay/holo_pad_hologram/hologram_holder

	/// The job the icon for it is generated with
	var/datum/job/job_type

	/// Internal storage slot. Fits any item
	var/obj/item/internal_storage = null
	/// Pockets (Left and right respectively)
	var/obj/item/l_store = null
	var/obj/item/r_store = null

	/// Items to delete after the hologram dissapears when [/datum/proc/Destroy] is called. This could be done better, but shut up
	var/list/obj/item/holoitems = list()
	/// Item that spawns in the hologram's dex_storage slot
	var/obj/item/dex_item

	/// Action used to toggle the ability to walk through everything
	var/datum/action/innate/hologram/toggle_density/toggle_density_action = new

	/// Flavor text announced to holograms on [/mob/proc/Login]
	var/flavortext = \
	"\n<big><span class='warning'>You have no laws other than SERVE THE CREW AT LARGE AT ANY COST.</span></big>\n"+\
	"<span class='notice'>Emergency holograms are ghost spawns that can majorly affect the round due to their versatility. Act with common sense.</span>\n"+\
	"<span class='notice'>Using the role to grief or metagame will be met with a silicon ban.</span>\n"

/mob/living/simple_animal/hologram/New(loc, _holopad)
	. = ..()

/mob/living/simple_animal/hologram/Initialize(mapload, _holopad)
	. = ..()
	source_area = get_area(src)

	var/datum/outfit/O
	if(job_type?.outfit)
		O = new job_type.outfit
		O.r_hand = null
		O.l_hand = null //It would be confusing if, say, the medical hologram had a fake medkit

	var/icon/initial_icon = get_flat_human_icon("hologram_[job_type?.title]", job_type, client?.prefs, "static", outfit_override = O)
	var/icon/alpha_mask = new('icons/effects/effects.dmi', "scanline")//Scanline effect.
	initial_icon.AddAlphaMask(alpha_mask)
	icon = initial_icon
	icon_living = initial_icon

	access_card = new /obj/item/card/id(src)
	access_card?.access |= job_type.access //dunno how the access card would delete itself before then, but this is DM, after all
	ADD_TRAIT(access_card, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

	holopad = _holopad
	hologram_holder = new(src)
	holopad.set_holo(src, src)

	toggle_density_action.Grant(src)

	for(var/datum/atom_hud/data/diagnostic/diag_hud in GLOB.huds)
		diag_hud.add_to_hud(src)

	if(dex_item)
		var/obj/item/to_add = new dex_item(src)
		equip_to_slot_if_possible(to_add, ITEM_SLOT_DEX_STORAGE)
		holoitems += to_add
		if(!istype(to_add, /obj/item/storage))
			return
		for(var/obj/item/content in to_add.contents)
			holoitems += content

/mob/living/simple_animal/hologram/Destroy()
	. = ..()
	for(var/obj/todelete in holoitems)
		QDEL_NULL(todelete)
	for(var/item in contents)
		dropItemToGround(item)
	qdel(holopad?.holorays[src])
	LAZYREMOVE(holopad?.holorays, src)
	qdel(access_card) //Otherwise it ends up on the floor! ...apparently
	QDEL_NULL(toggle_density_action)

/mob/living/simple_animal/hologram/gib()
	dust()

/mob/living/simple_animal/hologram/Move(atom/newloc, direct)
	. = ..()
	if(holopad)
		holopad.update_holoray(src, get_turf(newloc))
		if(!holopad.validate_location(get_turf(newloc), FALSE, FALSE))
			for(var/pad in holopad.holopads) //It's a static list so maybe it will work?
				var/obj/machinery/holopad/another = pad
				if(another == holopad || another.machine_stat)
					continue
				if(another.validate_location(get_turf(newloc), FALSE, FALSE))
					holopad.unset_holo(src)
					if(another.masters && another.masters[src])
						another.clear_holo(src)
					another.set_holo(src, src)
					holopad = another
					return
			forceMove(get_turf(holopad.loc))
			to_chat(src, "<span class='danger'>You've gone too far from your holoprojector!</span>")

/mob/living/simple_animal/hologram/emag_act(mob/user)
	. = ..()
	if(user)
		to_chat(user, "<span class='notice'>You [density ? "poke [src] with your card." : "slide your card through the air where [src] is."].</span>")
	src.visible_message("<span class='danger'>[src] starts flickering!</span>")
	possible_a_intents |= list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, INTENT_HARM)
	disco(src)

/mob/living/simple_animal/hologram/proc/disco()
	color = pick(HOLOGRAM_CYCLE_COLORS)
	alpha = rand(75, 180)
	addtimer(CALLBACK(src, .proc/disco, src), 5) //Call ourselves every 0.5 seconds to change color

/mob/living/simple_animal/hologram/med_hud_set_health()
	var/image/holder = hud_list[DIAG_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	holder.icon_state = "huddiag[RoundDiagBar(health/maxHealth)]"

/mob/living/simple_animal/hologram/med_hud_set_status()
	var/image/holder = hud_list[DIAG_STAT_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	if(stat == DEAD)
		holder.icon_state = "huddead2"
	else if(incapacitated())
		holder.icon_state = "hudoffline"
	else
		holder.icon_state = "hudstat"

/datum/action/innate/hologram/toggle_density
	name = "Toggle Density"
	desc = "Remodulate your holo-emitters to pass through matter."
	icon_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "blink"

/datum/action/innate/hologram/toggle_density/Activate()
	var/mob/living/simple_animal/hologram/H = owner
	H.toggle_density()

/mob/living/simple_animal/hologram/proc/toggle_density()
	density = !density
	if(density)
		movement_type = GROUND
		pass_flags = null
		dextrous = TRUE
	else
		movement_type = FLYING
		pass_flags = PASSGLASS|PASSGRILLE|PASSMOB|PASSTABLE
		drop_all_held_items() //can't hold things when you don't actually exist
		dextrous = FALSE//see above comment
	to_chat(src, "You toggle your density [density ? "on" : "off"].")
	update_icons()

/mob/living/simple_animal/hologram/update_icons()
	. = ..()
	alpha = density ? initial(alpha) : 100 //applies opacity effect if non-dense
	color = density ? initial(color) : "#77abff" //makes the hologram slightly blue

/mob/living/simple_animal/drone/Login()
	. = ..()
	if(!. || !client)
		return FALSE

	if(flavortext)
		to_chat(src, "[flavortext]")

/mob/living/simple_animal/hologram/auto_deadmin_on_login()
	if(!client?.holder)
		return TRUE
	if(CONFIG_GET(flag/auto_deadmin_silicons) || (client.prefs?.toggles & DEADMIN_POSITION_SILICON))
		return client.holder.auto_deadmin()
	return ..()

/mob/living/simple_animal/hologram/assess_threat(judgement_criteria, lasercolor = "", datum/callback/weaponcheck=null) //beepsky isn't stupid
	return -10

/mob/living/simple_animal/hologram/handle_temperature_damage()
	return FALSE

/mob/living/simple_animal/hologram/flash_act(intensity = 1, override_blindness_check = 0, affect_silicon = 0)
	if(affect_silicon)
		return ..()

/mob/living/simple_animal/hologram/mob_negates_gravity()
	return TRUE

/mob/living/simple_animal/hologram/mob_has_gravity()
	return ..() || mob_negates_gravity()

/mob/living/simple_animal/hologram/experience_pressure_difference(pressure_difference, direction)
	return //holograms can't feel the breeze

/mob/living/simple_animal/hologram/bee_friendly()
	return TRUE //See: Star Trek Voyager S3 E12

/mob/living/simple_animal/hologram/electrocute_act(shock_damage, source, siemens_coeff, flags = NONE)
	return FALSE //You can't shock a hologram dumbass

/mob/living/simple_animal/hologram/medical
	job_type = new /datum/job/doctor
	dex_item = /obj/item/storage/belt/medical/surgery

/mob/living/simple_animal/hologram/bar
	job_type = new /datum/job/bartender
	dex_item = /obj/item/reagent_containers/food/drinks/shaker

/mob/living/simple_animal/hologram/science
	job_type = new /datum/job/scientist
	dex_item = /obj/item/storage/belt/utility/atmostech

/mob/living/simple_animal/hologram/engineering
	job_type = new /datum/job/engineer
	dex_item = /obj/item/storage/belt/utility/full

/mob/living/simple_animal/hologram/command
	job_type = new /datum/job/head_of_personnel
	dex_item = /obj/item/card/id/silver/hologram

#undef HOLOGRAM_CYCLE_COLORS
