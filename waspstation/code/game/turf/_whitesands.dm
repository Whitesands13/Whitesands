
#define WHITESANDS_WALL_ENV "rock"
#define WHITESANDS_SAND_ENV "sand"
#define WHITESANDS_DRIED_ENV "dried_up"
#define WHITESANDS_ATMOS "ws_atmos"

#define WS_TEMP_GRAD_COEFF_A 35
// Adjusted period for station time
#define WS_TEMP_GRAD_COEFF_B 864000 / SSticker.station_time_rate_multiplier
#define WS_TEMP_GRAD_COEFF_C 250

/datum/gas_mixture/immutable/whitesands_planet/New()
	if (GLOB.ws_planet_atmos && GLOB.ws_planet_atmos != src)
		return GLOB.ws_planet_atmos
	..()
	ws_moles_amount = CONFIG_GET(number/whitesands_atmos_moles)
	set_temperature(initial_temperature)
	populate()
	mark_immutable()
	create_temperature_gradient(
		WS_TEMP_GRAD_COEFF_A,
		WS_TEMP_GRAD_COEFF_B,
		WS_TEMP_GRAD_COEFF_C
	)
	SSweather.set_temperature_gradient(src)

/datum/gas_mixture/immutable/whitesands_planet/proc/populate_default()
	set_moles(/datum/gas/nitrogen, ws_moles_amount * N2STANDARD)
	set_moles(/datum/gas/oxygen, ws_moles_amount * (O2STANDARD / 2))
	set_moles(/datum/gas/carbon_dioxide, ws_moles_amount *  (O2STANDARD / 2))

/datum/gas_mixture/immutable/whitesands_planet/populate()
	var/list/ws_atmos_conf = CONFIG_GET(keyed_list/whitesands_atmos_mix)
	if (length(ws_atmos_conf) < 1)
		populate_default()
		return

	var/list/gas_types_by_id = list()
	for (var/datum/gas/gas_type in gas_types())
		gas_types_by_id[gas_type.id] = gas_type

	var/list/final_mix = list()
	for(var/gas_key in ws_atmos_conf)
		if (!gas_types_by_id[gas_key])
			var/config_error = "Failed to populate configured gas mix, falling back to default. Undefined gas id: [gas_key]"
			log_game(config_error)
			message_admins(config_error)
			populate_default()
			return
		else
			final_mix += list(gas_types_by_id[gas_key], ws_atmos_conf[gas_key])
	for(var/mix_param in final_mix)
		set_moles(mix_param[0], ws_moles_amount * mix_param[1])
