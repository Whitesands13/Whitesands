/obj/structure/catwalk
	name = "catwalk"
	desc = "A catwalk for easier EVA maneuvering and cable placement."
	icon = 'waspstation/icons/obj/smooth_structures/catwalk.dmi'
	icon_state = "catwalk"
	density = FALSE
	anchored = TRUE
	armor = list("melee" = 50, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 80, "acid" = 50)
	max_integrity = 50
	layer = LATTICE_LAYER //under pipes
	plane = FLOOR_PLANE
	smooth = SMOOTH_TRUE
	obj_flags = CAN_BE_HIT | BLOCK_Z_FALL
	var/number_of_rods = 2
	var/hatch_open = FALSE
	var/obj/item/stack/tile/plasteel/plated_tile

/obj/structure/catwalk/Initialize()
	. = ..()
	update_icon()

/obj/structure/catwalk/over
	layer = CATWALK_LAYER

/obj/structure/catwalk/over/plated_catwalk
	name = "plated catwalk"
	icon_state = "catwalk_platedwhite"
	plated_tile = new /obj/item/stack/tile/plasteel

/obj/structure/catwalk/over/plated_catwalk/dark
	plated_tile = new /obj/item/stack/tile/plasteel/dark

/obj/structure/catwalk/over/plated_catwalk/white
	name = "plated catwalk"
	plated_tile = new /obj/item/stack/tile/plasteel/white

/obj/structure/catwalk/update_icon()
	..()
	cut_overlays()
	icon_state = ""
	var/image/I
	icon_state = hatch_open ? "catwalk" : "open"
	if(!hatch_open)
		icon_state = "catwalk"
	else
		icon_state = "open"
	if(plated_tile)
		smooth = SMOOTH_FALSE
		I = image('waspstation/icons/obj/catwalks.dmi', "plated")
		I.color = plated_tile.color
		overlays += I
	else
		smooth = SMOOTH_TRUE

/obj/structure/catwalk/examine(mob/user)
	. = ..()
	. += deconstruction_hints(user)

/obj/structure/catwalk/proc/deconstruction_hints(mob/user)
	return "<span class='notice'>The supporting rods look like they could be <b>sliced</b>.</span>"

/obj/structure/catwalk/attackby(obj/item/C, mob/user, params)
	if(resistance_flags & INDESTRUCTIBLE)
		return
	if(C.tool_behaviour == TOOL_WELDER)
		to_chat(user, "<span class='notice'>You slice off [src]</span>")
		deconstruct()
	if(C.tool_behaviour == TOOL_CROWBAR && plated_tile)
		hatch_open = !hatch_open
		if(hatch_open)
			playsound(src, 'sound/items/Crowbar.ogg', 100, 2)
			to_chat(user, "<span class='notice'>You pry open \the [src]'s maintenance hatch.</span>")
		else
			playsound(src, 'sound/items/Deconstruct.ogg', 100, 2)
			to_chat(user, "<span class='notice'>You shut \the [src]'s maintenance hatch.</span>")
		update_icon()
		return
	if(istype(C, /obj/item/stack/tile) && !plated_tile)
		var/obj/item/stack/tile/plasteel/ST = C
		to_chat(user, "<span class='notice'>Placing tile...</span>")
		if(do_after(user, 30, target = src))
			to_chat(user, "<span class='notice'>You plate \the [src]</span>")
			name = "plated catwalk"
			src.add_fingerprint(user)
			if(ST.use(1))
				plated_tile = C
				update_icon()


/obj/structure/catwalk/Move()
	var/turf/T = loc
	for(var/obj/structure/cable/C in T)
		C.deconstruct()
	..()

/obj/structure/catwalk/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stack/rods(get_turf(src), number_of_rods)
	qdel(src)
	var/turf/T = loc
	if(!istype(T, /turf/open/floor))
		for(var/obj/structure/cable/C in T)
			C.deconstruct()
	..()
