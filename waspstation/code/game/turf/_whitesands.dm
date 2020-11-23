
#define WHITESANDS_WALL_ENV "rock"
#define WHITESANDS_SAND_ENV "sand"
#define WHITESANDS_DRIED_ENV "dried_up"
#define WHITESANDS_ATMOS "ws_atmos"

#define WS_TEMP_GRAD_COEFF_A 35
// Adjusted period for station time
#define WS_TEMP_GRAD_COEFF_B 864000 / SSticker.station_time_rate_multiplier
#define WS_TEMP_GRAD_COEFF_C 250
// Temperature variance creates weird pressures, so we use a nonstandard mole ratio
#define WS_CELL_STANDARD_MOLES 0.7728
/datum/gas_mixture/immutable/whitesands_planet
	initial_temperature = T20C

/datum/gas_mixture/immutable/whitesands_planet/New()
	if (GLOB.whitesands_planet && GLOB.whitesands_planet != src)
		return GLOB.whitesands_planet
	..()
	set_temperature(initial_temperature)
	populate()
	mark_immutable()
	create_temperature_gradient(
		WS_TEMP_GRAD_COEFF_A,
		WS_TEMP_GRAD_COEFF_B,
		WS_TEMP_GRAD_COEFF_C
	)

/datum/gas_mixture/immutable/whitesands_planet/populate()
	set_moles(/datum/gas/nitrogen, WS_CELL_STANDARD_MOLES * N2STANDARD)
	set_moles(/datum/gas/oxygen, WS_CELL_STANDARD_MOLES * (O2STANDARD / 2))
	set_moles(/datum/gas/carbon_dioxide, WS_CELL_STANDARD_MOLES *  (O2STANDARD / 2))

GLOBAL_DATUM_INIT(ws_planet_atmos, /datum/gas_mixture/immutable/whitesands_planet, new)
