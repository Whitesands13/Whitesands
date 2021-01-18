GLOBAL_LIST_INIT(ui_layout_default, list(
	//Hand overlay offset
	ui_hand_x_offset = "0",
	ui_hand_y_offset = "0",

	//Storage overlay offset
	storage_offset_x = "0",
	storage_offset_y = "0",

	//Lower left, persistent menu
	ui_inventory = "WEST:6,SOUTH:5",

	//Middle left indicators
	ui_lingchemdisplay = "WEST,CENTER-1:15",
	ui_lingstingdisplay = "WEST:6,CENTER-3:11",
	ui_devilsouldisplay = "WEST:6,CENTER-1:15",

	//Lower center, persistent menu
	ui_sstore1 = "CENTER-5:10,SOUTH:5",
	ui_id = "CENTER-4:12,SOUTH:5",
	ui_belt = "CENTER-3:14,SOUTH:5",
	ui_back = "CENTER-2:14,SOUTH:5",
	ui_storage1 = "CENTER+1:18,SOUTH:5",
	ui_storage2 = "CENTER+2:20,SOUTH:5",

	//Lower right, persistent menu
	ui_drop_throw = "EAST-1:28,SOUTH+1:7",
	ui_above_movement = "EAST-2:26,SOUTH+1:7",
	ui_pull_resist = "EAST-3:24,SOUTH+1:7",
	ui_movi = "EAST-2:26,SOUTH:5",
	ui_acti = "EAST-3:24,SOUTH:5",
	ui_zonesel = "EAST-1:28,SOUTH:5",
	ui_acti_alt = "EAST-1:28,SOUTH:5",
	ui_crafting = "EAST-4:22,SOUTH:5",
	ui_building = "EAST-4:22,SOUTH:21",
	ui_language_menu = "EAST-4:6,SOUTH:21",
	ui_skill_menu = "EAST-4:22,SOUTH:5",

	//Upper-middle right (alerts)
	ui_alert1 = "EAST-1:28,CENTER+5:27",
	ui_alert2 = "EAST-1:28,CENTER+4:25",
	ui_alert3 = "EAST-1:28,CENTER+3:23",
	ui_alert4 = "EAST-1:28,CENTER+2:21",
	ui_alert5 = "EAST-1:28,CENTER+1:19",

	//Middle right (status indicators)
	ui_healthdoll = "EAST-1:28,CENTER-2:13",
	ui_health = "EAST-1:28,CENTER-1:15",
	ui_internal = "EAST-1:28,CENTER:17",
	ui_mood = "EAST-1:28,CENTER-3:10",

	//Pop-up inventory
	ui_shoes = "WEST+1:8,SOUTH:5",
	ui_iclothing = "WEST:6,SOUTH+1:7",
	ui_oclothing = "WEST+1:8,SOUTH+1:7",
	ui_gloves = "WEST+2:10,SOUTH+1:7",
	ui_glasses = "WEST:6,SOUTH+3:11",
	ui_mask = "WEST+1:8,SOUTH+2:9",
	ui_ears = "WEST+2:10,SOUTH+2:9",
	ui_neck = "WEST:6,SOUTH+2:9",
	ui_head = "WEST+1:8,SOUTH+3:11",

	//Generic living
	ui_living_pull = "EAST-1:28,CENTER-3:15",
	ui_living_healthdoll = "EAST-1:28,CENTER-1:15",

	//Monkeys
	ui_monkey_head = "CENTER-5:13,SOUTH:5",
	ui_monkey_mask = "CENTER-4:14,SOUTH:5",
	ui_monkey_neck = "CENTER-3:15,SOUTH:5",
	ui_monkey_back = "CENTER-2:16,SOUTH:5",

	//Drones
	ui_drone_drop = "CENTER+1:18,SOUTH:5",
	ui_drone_pull = "CENTER+2:2,SOUTH:5",
	ui_drone_storage = "CENTER-2:14,SOUTH:5",
	ui_drone_head = "CENTER-3:14,SOUTH:5",

	//Cyborgs
	ui_borg_health = "EAST-1:28,CENTER-1:15",
	ui_borg_pull = "EAST-2:26,SOUTH+1:7",
	ui_borg_radio = "EAST-1:28,SOUTH+1:7",
	ui_borg_intents = "EAST-2:26,SOUTH:5",
	ui_borg_lamp = "CENTER-4:16,SOUTH:5",
	ui_borg_thrusters = "CENTER-5:16,SOUTH:5",
	ui_borg_tablet = "CENTER-4:16, SOUTH:5",
	ui_inv1 = "CENTER-2:16,SOUTH:5",
	ui_inv2 = "CENTER-1:16,SOUTH:5",
	ui_inv3 = "CENTER:16,SOUTH:5",
	ui_borg_module = "CENTER+1:16,SOUTH:5",
	ui_borg_store = "CENTER+2:16,SOUTH:5",
	ui_borg_camera = "CENTER+3:21,SOUTH:5",
	ui_borg_alerts = "CENTER+4:21,SOUTH:5",
	ui_borg_language_menu = "CENTER+4:21,SOUTH+1:5",

	//Aliens
	ui_alien_health = "EAST,CENTER-1:15",
	ui_alienplasmadisplay = "EAST,CENTER-2:15",
	ui_alien_queen_finder = "EAST,CENTER-3:15",
	ui_alien_storage_r = "CENTER+1:18,SOUTH:5",
	ui_alien_language_menu = "EAST-3:26,SOUTH:5",

	//Constructs
	ui_construct_pull = "EAST,CENTER-2:15",
	ui_construct_health = "EAST,CENTER:15",

	// AI
	ui_ai_core = "SOUTH:6,WEST",
	ui_ai_camera_list = "SOUTH:6,WEST+1",
	ui_ai_track_with_camera = "SOUTH:6,WEST+2",
	ui_ai_camera_light = "SOUTH:6,WEST+3",
	ui_ai_crew_monitor = "SOUTH:6,WEST+4",
	ui_ai_crew_manifest = "SOUTH:6,WEST+5",
	ui_ai_alerts = "SOUTH:6,WEST+6",
	ui_ai_announcement = "SOUTH:6,WEST+7",
	ui_ai_shuttle = "SOUTH:6,WEST+8",
	ui_ai_state_laws = "SOUTH:6,WEST+9",
	ui_ai_pda_send = "SOUTH:6,WEST+10",
	ui_ai_pda_log = "SOUTH:6,WEST+11",
	ui_ai_take_picture = "SOUTH:6,WEST+12",
	ui_ai_view_images = "SOUTH:6,WEST+13",
	ui_ai_sensor = "SOUTH:6,WEST+14",
	ui_ai_multicam = "SOUTH+1:6,WEST+13",
	ui_ai_add_multicam = "SOUTH+1:6,WEST+14",

	// pAI
	ui_pai_software = "SOUTH:6,WEST",
	ui_pai_shell = "SOUTH:6,WEST+1",
	ui_pai_chassis = "SOUTH:6,WEST+2",
	ui_pai_rest = "SOUTH:6,WEST+3",
	ui_pai_light = "SOUTH:6,WEST+4",
	ui_pai_newscaster = "SOUTH:6,WEST+5",
	ui_pai_host_monitor = "SOUTH:6,WEST+6",
	ui_pai_crew_manifest = "SOUTH:6,WEST+7",
	ui_pai_state_laws = "SOUTH:6,WEST+8",
	ui_pai_pda_send = "SOUTH:6,WEST+9",
	ui_pai_pda_log = "SOUTH:6,WEST+10",
	ui_pai_take_picture = "SOUTH:6,WEST+12",
	ui_pai_view_images = "SOUTH:6,WEST+13",

	ui_ghost_jumptomob = "SOUTH:6,CENTER-3:24",
	ui_ghost_orbit = "SOUTH:6,CENTER-2:24",
	ui_ghost_reenter_corpse = "SOUTH:6,CENTER-1:24",
	ui_ghost_teleport = "SOUTH:6,CENTER:24",
	ui_ghost_pai = "SOUTH: 6,CENTER+1:24",
	ui_ghost_spawner_menu = "SOUTH:6,CENTER+2:24"
))

GLOBAL_LIST_INIT(ui_layout_alternate, list(
	//Hand overlay offset
	ui_hand_x_offset = "2",
	ui_hand_y_offset = "0",

	//Storage overlay offset
	storage_offset_x = "2",
	storage_offset_y = "1",

	//Lower left, persistent menu
	ui_inventory = "CENTER-5:18,SOUTH:5",

	//Middle left indicators
	ui_lingchemdisplay = "WEST,CENTER-1:15",
	ui_lingstingdisplay = "WEST:6,CENTER-3:11",
	ui_devilsouldisplay = "WEST:6,CENTER-1:15",

	//Lower center, persistent menu
	ui_sstore1 = "CENTER-4:18,SOUTH:5",
	ui_id = "CENTER-2:18,SOUTH+1:7",
	ui_belt = "CENTER-3:18,SOUTH:5",
	ui_back = "CENTER:18,SOUTH:5",
	ui_storage1 = "CENTER-1:18,SOUTH:5",
	ui_storage2 = "CENTER-2:18,SOUTH:5",

	//Lower right, persistent menu
	ui_drop_throw = "CENTER+3:18,SOUTH:5",
	ui_above_movement = "CENTER+7:18,SOUTH:5",
	ui_pull_resist = "CENTER+6:18,SOUTH:5",
	ui_movi = "CENTER+6:18,SOUTH:5",
	ui_acti = "CENTER+5:18,SOUTH:5",
	ui_zonesel = "CENTER+4:18,SOUTH:5",
	ui_acti_alt = "CENTER+3:18,SOUTH:5",
	ui_crafting = "CENTER+8:22,SOUTH:5",
	ui_building = "CENTER+8:22,SOUTH:21",
	ui_language_menu = "CENTER+8:6,SOUTH:21",
	ui_skill_menu = "CENTER+8:22,SOUTH:5",

	//Upper-middle right (alerts)
	ui_alert1 = "EAST-1:28,CENTER+5:27",
	ui_alert2 = "EAST-1:28,CENTER+4:25",
	ui_alert3 = "EAST-1:28,CENTER+3:23",
	ui_alert4 = "EAST-1:28,CENTER+2:21",
	ui_alert5 = "EAST-1:28,CENTER+1:19",

	//Middle right (status indicators)
	ui_healthdoll = "EAST-1:28,CENTER-2:13",
	ui_health = "EAST-1:28,CENTER-1:15",
	ui_internal = "EAST-1:28,CENTER:17",
	ui_mood = "EAST-1:28,CENTER-3:10",

	//Pop-up inventory
	ui_shoes = "CENTER-4:18,SOUTH+1:7",
	ui_iclothing = "CENTER-1:18,SOUTH+1:7",
	ui_oclothing = "CENTER:18,SOUTH+1:7",
	ui_gloves = "CENTER-3:18,SOUTH+1:7",
	ui_glasses = "CENTER+1:18,SOUTH+1:7",
	ui_mask = "CENTER+3:18,SOUTH+1:7",
	ui_ears = "CENTER+2:18,SOUTH+1:7",
	ui_neck = "CENTER-5:18,SOUTH+1:7",
	ui_head = "CENTER+4:18,SOUTH+1:7",

	//Generic living
	ui_living_pull = "CENTER+7:18,CENTER-3:15",
	ui_living_healthdoll = "EAST-1:28,CENTER-1:15",

	//Monkeys
	ui_monkey_head = "CENTER-5:13,SOUTH:5",
	ui_monkey_mask = "CENTER-4:14,SOUTH:5",
	ui_monkey_neck = "CENTER-3:15,SOUTH:5",
	ui_monkey_back = "CENTER-2:16,SOUTH:5",

	//Drones
	ui_drone_drop = "CENTER+1:18,SOUTH:5",
	ui_drone_pull = "CENTER+2:2,SOUTH:5",
	ui_drone_storage = "CENTER-2:14,SOUTH:5",
	ui_drone_head = "CENTER-3:14,SOUTH:5",

	//Cyborgs
	ui_borg_health = "EAST-1:28,CENTER-1:15",
	ui_borg_pull = "EAST-2:26,SOUTH+1:7",
	ui_borg_radio = "EAST-1:28,SOUTH+1:7",
	ui_borg_intents = "EAST-2:26,SOUTH:5",
	ui_borg_lamp = "CENTER-4:16,SOUTH:5",
	ui_borg_thrusters = "CENTER-5:16,SOUTH:5",
	ui_borg_tablet = "CENTER-4:16, SOUTH:5",
	ui_inv1 = "CENTER-2:16,SOUTH:5",
	ui_inv2 = "CENTER-1:16,SOUTH:5",
	ui_inv3 = "CENTER:16,SOUTH:5",
	ui_borg_module = "CENTER+1:16,SOUTH:5",
	ui_borg_store = "CENTER+2:16,SOUTH:5",
	ui_borg_camera = "CENTER+3:21,SOUTH:5",
	ui_borg_alerts = "CENTER+4:21,SOUTH:5",
	ui_borg_language_menu = "CENTER+4:21,SOUTH+1:5",

	//Aliens
	ui_alien_health = "EAST,CENTER-1:15",
	ui_alienplasmadisplay = "EAST,CENTER-2:15",
	ui_alien_queen_finder = "EAST,CENTER-3:15",
	ui_alien_storage_r = "CENTER+1:18,SOUTH:5",
	ui_alien_language_menu = "EAST-3:26,SOUTH:5",

	//Constructs
	ui_construct_pull = "EAST,CENTER-2:15",
	ui_construct_health = "EAST,CENTER:15",

	// AI
	ui_ai_core = "SOUTH:6,WEST",
	ui_ai_camera_list = "SOUTH:6,WEST+1",
	ui_ai_track_with_camera = "SOUTH:6,WEST+2",
	ui_ai_camera_light = "SOUTH:6,WEST+3",
	ui_ai_crew_monitor = "SOUTH:6,WEST+4",
	ui_ai_crew_manifest = "SOUTH:6,WEST+5",
	ui_ai_alerts = "SOUTH:6,WEST+6",
	ui_ai_announcement = "SOUTH:6,WEST+7",
	ui_ai_shuttle = "SOUTH:6,WEST+8",
	ui_ai_state_laws = "SOUTH:6,WEST+9",
	ui_ai_pda_send = "SOUTH:6,WEST+10",
	ui_ai_pda_log = "SOUTH:6,WEST+11",
	ui_ai_take_picture = "SOUTH:6,WEST+12",
	ui_ai_view_images = "SOUTH:6,WEST+13",
	ui_ai_sensor = "SOUTH:6,WEST+14",
	ui_ai_multicam = "SOUTH+1:6,WEST+13",
	ui_ai_add_multicam = "SOUTH+1:6,WEST+14",

	// pAI
	ui_pai_software = "SOUTH:6,WEST",
	ui_pai_shell = "SOUTH:6,WEST+1",
	ui_pai_chassis = "SOUTH:6,WEST+2",
	ui_pai_rest = "SOUTH:6,WEST+3",
	ui_pai_light = "SOUTH:6,WEST+4",
	ui_pai_newscaster = "SOUTH:6,WEST+5",
	ui_pai_host_monitor = "SOUTH:6,WEST+6",
	ui_pai_crew_manifest = "SOUTH:6,WEST+7",
	ui_pai_state_laws = "SOUTH:6,WEST+8",
	ui_pai_pda_send = "SOUTH:6,WEST+9",
	ui_pai_pda_log = "SOUTH:6,WEST+10",
	ui_pai_take_picture = "SOUTH:6,WEST+12",
	ui_pai_view_images = "SOUTH:6,WEST+13",

	ui_ghost_jumptomob = "SOUTH:6,CENTER-3:24",
	ui_ghost_orbit = "SOUTH:6,CENTER-2:24",
	ui_ghost_reenter_corpse = "SOUTH:6,CENTER-1:24",
	ui_ghost_teleport = "SOUTH:6,CENTER:24",
	ui_ghost_pai = "SOUTH: 6,CENTER+1:24",
	ui_ghost_spawner_menu = "SOUTH:6,CENTER+2:24"
))
