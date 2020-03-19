/turf/open/floor/plasteel
	icon = 'waspstation/icons/turf/floors/tiles.dmi'
	color = COLOR_FLOORTILE_GRAY
	icon_state = "tiled"
	floor_tile = /obj/item/stack/tile/plasteel
	broken_states = list("damaged1", "damaged2", "damaged3", "damaged4", "damaged5")
	burnt_states = list("floorscorched1", "floorscorched2")

/turf/open/floor/plasteel/examine(mob/user)
	. = ..()
	. += "<span class='notice'>There's a <b>small crack</b> on the edge of it.</span>"

/turf/open/floor/plasteel/update_icon()
	if(!..())
		return 0
	if(!broken && !burnt)
		icon_state = icon_regular_floor


/turf/open/floor/plasteel/airless
	initial_gas_mix = AIRLESS_ATMOS
/turf/open/floor/plasteel/telecomms
	initial_gas_mix = TCOMMS_ATMOS


/turf/open/floor/plasteel/dark
	color = COLOR_TILE_GRAY
	floor_tile = /obj/item/stack/tile/plasteel/dark
/turf/open/floor/plasteel/dark/airless
	initial_gas_mix = AIRLESS_ATMOS
/turf/open/floor/plasteel/dark/telecomms
	initial_gas_mix = TCOMMS_ATMOS
/turf/open/floor/plasteel/airless/dark
	color = COLOR_TILE_GRAY
/turf/open/floor/plasteel/dark/side
	icon_state = "dark"
/turf/open/floor/plasteel/dark/corner
	icon_state = "darkcorner"
/turf/open/floor/plasteel/checker
	icon_state = "checker"

/turf/open/floor/plasteel/mono
	icon_state = "monotile"
/turf/open/floor/plasteel/mono/dark
	color = COLOR_TILE_GRAY
/turf/open/floor/plasteel/mono/white
	icon_state = "monotile_light"
	color = COLOR_WHITE

/turf/open/floor/plasteel/tech
	icon = 'waspstation/icons/turf/floors/techfloor.dmi'
	icon_state = "techfloor_gray"
	color = null
/turf/open/floor/plasteel/tech/grid
	icon_state = "techfloor_grid"

/turf/open/floor/plasteel/new_tile
	icon_state = "tile_full"
	color = null
/turf/open/floor/plasteel/new_tile/cargo_one
	icon_state = "cargo_one_full"
/turf/open/floor/plasteel/new_tile/kafel
	icon_state = "kafel_full"
/turf/open/floor/plasteel/new_tile/techmaint
	icon_state = "techmaint"
/turf/open/floor/plasteel/new_tile/monofloor
	icon_state = "monofloor"
	color = COLOR_TILE_GRAY
/turf/open/floor/plasteel/new_tile/steel_grid
	icon_state = "grid"
	color = COLOR_TILE_GRAY
/turf/open/floor/plasteel/new_tile/steel_ridged
	icon_state = "ridged"
	color = COLOR_TILE_GRAY

/turf/open/floor/plasteel/white
	color = COLOR_WHITE
	floor_tile = /obj/item/stack/tile/plasteel/white
/turf/open/floor/plasteel/white/side
	icon_state = "whitehall"
/turf/open/floor/plasteel/white/corner
	icon_state = "whitecorner"
/turf/open/floor/plasteel/airless/white
	color = COLOR_WHITE
/turf/open/floor/plasteel/airless/white/side
	icon_state = "whitehall"
/turf/open/floor/plasteel/airless/white/corner
	icon_state = "whitecorner"
/turf/open/floor/plasteel/white/telecomms
	initial_gas_mix = TCOMMS_ATMOS

/turf/open/floor/plasteel/airless/showroomfloor
	icon_state = "showroomfloor"


/turf/open/floor/plasteel/yellowsiding
	icon_state = "yellowsiding"
/turf/open/floor/plasteel/yellowsiding/corner
	icon_state = "yellowcornersiding"


/turf/open/floor/plasteel/recharge_floor
	icon_state = "recharge_floor"
/turf/open/floor/plasteel/recharge_floor/asteroid
	icon_state = "recharge_floor_asteroid"


/turf/open/floor/plasteel/chapel
	icon_state = "chapel"

/turf/open/floor/plasteel/showroomfloor
	icon = 'waspstation/icons/turf/floors.dmi'
	icon_state = "showroomfloor"


/turf/open/floor/plasteel/solarpanel
	icon_state = "solarpanel"
	icon = 'waspstation/icons/turf/decals.dmi'
/turf/open/floor/plasteel/airless/solarpanel
	icon_state = "solarpanel"
	icon = 'waspstation/icons/turf/decals.dmi'

/turf/open/floor/plasteel/freezer
	color = null
	icon = 'waspstation/icons/turf/floors.dmi'
	icon_state = "freezer"

/turf/open/floor/plasteel/freezer/airless
	initial_gas_mix = AIRLESS_ATMOS


/turf/open/floor/plasteel/kitchen_coldroom
	name = "cold room floor"
	initial_gas_mix = KITCHEN_COLDROOM_ATMOS

/turf/open/floor/plasteel/kitchen_coldroom/freezerfloor
	icon_state = "freezer"


/turf/open/floor/plasteel/grimy
	color = null
	icon = 'waspstation/icons/turf/floors.dmi'
	icon_state = "lino"
	tiled_dirt = FALSE

/turf/open/floor/plasteel/cafeteria
	icon_state = "cafeteria"

/turf/open/floor/plasteel/airless/cafeteria
	icon_state = "cafeteria"


/turf/open/floor/plasteel/cult
	icon_state = "cult"
	name = "engraved floor"

/turf/open/floor/plasteel/vaporwave
	icon = 'icons/turf/floors.dmi'
	icon_state = "pinkblack"

/turf/open/floor/plasteel/goonplaque
	icon_state = "plaque"
	name = "commemorative plaque"
	desc = "\"This is a plaque in honour of our comrades on the G4407 Stations. Hopefully TG4407 model can live up to your fame and fortune.\" Scratched in beneath that is a crude image of a meteor and a spaceman. The spaceman is laughing. The meteor is exploding."
	tiled_dirt = FALSE

/turf/open/floor/plasteel/cult/narsie_act()
	return
/turf/open/floor/plasteel/cult/airless
	initial_gas_mix = AIRLESS_ATMOS


/turf/open/floor/plasteel/stairs
	icon_state = "stairs"
	tiled_dirt = FALSE
/turf/open/floor/plasteel/stairs/left
	icon_state = "stairs-l"
/turf/open/floor/plasteel/stairs/medium
	icon_state = "stairs-m"
/turf/open/floor/plasteel/stairs/right
	icon_state = "stairs-r"
/turf/open/floor/plasteel/stairs/old
	icon_state = "stairs-old"


/turf/open/floor/plasteel/rockvault
	icon = 'waspstation/icons/turf/floors/misc.dmi'
	icon_state = "rockvault"
/turf/open/floor/plasteel/rockvault/alien
	icon_state = "alienvault"
/turf/open/floor/plasteel/rockvault/sandstone
	icon_state = "sandstonevault"


/turf/open/floor/plasteel/elevatorshaft
	icon = 'waspstation/icons/turf/floors.dmi'
	icon_state = "elevatorshaft"

/turf/open/floor/plasteel/bluespace
	icon = 'icons/turf/floors.dmi'
	icon_state = "bluespace"

/turf/open/floor/plasteel/sepia
	icon_state = "sepia"
