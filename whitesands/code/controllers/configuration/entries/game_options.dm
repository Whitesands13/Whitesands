/datum/config_entry/keyed_list/no_traitor_head
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG

/datum/config_entry/number/traitor_malf_ai_min_pop
	config_entry_value = 10
	min_val = 1
	max_val = 20

/datum/config_entry/number/max_malf_apc_hack_obj
	min_val = 10
	max_val = 20

/datum/config_entry/keyed_list/box_random_engine
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM
	lowercase = FALSE
	splitter = ","

/datum/config_entry/number/max_overmap_events
	config_entry_value = 40

/datum/config_entry/number/max_overmap_event_clusters
	config_entry_value = 15
	max_val = 30

/datum/config_entry/number/max_overmap_dynamic_events
	config_entry_value = 4

/datum/config_entry/string/overmap_generator_type
	config_entry_value = "random"
