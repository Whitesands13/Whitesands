/obj/effect/spawner/structure/window/shutters
	icon = 'icons/obj/structures_spawners.dmi'
	icon_state = "window_spawner"
	name = "window spawner"
	spawn_list = list(/obj/structure/grille, /obj/structure/window/fulltile, /obj/machinery/door/firedoor/window)
	dir = SOUTH
	FASTDMM_PROP(\
		pipe_astar_cost = 2\
	)

/obj/effect/spawner/structure/window/reinforced/shutters
	name = "reinforced window spawner"
	icon_state = "rwindow_spawner"
	spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/fulltile, /obj/machinery/door/firedoor/window)

/obj/effect/spawner/structure/window/reinforced/tinted/shutters
	name = "tinted reinforced window spawner"
	icon_state = "twindow_spawner"
	spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/tinted/fulltile, /obj/machinery/door/firedoor/window)

/obj/effect/spawner/structure/window/plasma/shutters
	name = "plasma window spawner"
	icon_state = "pwindow_spawner"
	spawn_list = list(/obj/structure/grille, /obj/structure/window/plasma/fulltile, /obj/machinery/door/firedoor/window)
