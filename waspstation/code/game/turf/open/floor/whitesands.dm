/turf/open/floor/plating/asteroid/whitesands
	name = "salted sand"
	baseturfs = /turf/open/floor/plating/asteroid/whitesands
	icon = 'waspstation/icons/turf/floors/whitesands/ws_floors.dmi'
	icon_state = "sand"
	icon_plating = "sand"
	environment_type = WHITESANDS_SAND_ENV
	floor_variance = 12
	digResult = /obj/item/stack/ore/glass
	var/static/datum/gas_mixture/immutable/whitesands_planet/whitesands_gas = new

/turf/open/floor/plating/asteroid/whitesands/Initialize()
	air = whitesands_gas
	update_air_ref()
	..()
	

/turf/open/floor/plating/asteroid/whitesands/dried
	name = "dried sand"
	baseturfs = /turf/open/floor/plating/asteroid/whitesands/dried
	icon_state = "dried_up"
	icon_plating = "dried_up"
	environment_type = WHITESANDS_DRIED_ENV
	floor_variance = 12
	digResult = /obj/item/stack/ore/glass
