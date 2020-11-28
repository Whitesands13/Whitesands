/*
	These lists specificy screen locations for different HUD layouts.  For more information, see the byond documentation on the screen_loc var.

	The short version:

	Everything is encoded as strings because apparently that's how Byond rolls.

	"1,1" is the bottom left square of the user's screen.  This aligns perfectly with the turf grid.
	"1:2,3:4" is the square (1,3) with pixel offsets (+2, +4); slightly right and slightly above the turf grid.
	Pixel offsets are used so you don't perfectly hide the turf under them, that would be crappy.

	In addition, the keywords NORTH, SOUTH, EAST, WEST and CENTER can be used to represent their respective
	screen borders. NORTH-1, for example, is the row just below the upper edge. Useful if you want your
	UI to scale with screen size.

	The size of the user's screen is defined by client.view (indirectly by world.view), in our case "15x15".
	Therefore, the top right corner (except during admin shenanigans) is at "15,15"
*/

/datum/hud/proc/ui_hand_position(i) //values based on old hand ui positions (CENTER:-/+16,SOUTH:5)
	var/x_off = -(!(i % 2))
	var/y_off = round((i-1) / 2)
	x_off += ui_layout["ui_hand_x_offset"]
	y_off += ui_layout["ui_hand_y_offset"]
	return"CENTER+[x_off]:16,SOUTH+[y_off]:5"

/datum/hud/proc/ui_equip_position(mob/M)
	var/y_off = round((M.held_items.len-1) / 2) //values based on old equip ui position (CENTER: +/-16,SOUTH+1:5)
	y_off += ui_layout["ui_hand_y_offset"]
	return "CENTER:-16,SOUTH+[y_off+1]:5"

/datum/hud/proc/ui_swaphand_position(mob/M, which = 1) //values based on old swaphand ui positions (CENTER: +/-16,SOUTH+1:5)
	var/x_off = which == 1 ? -1 : 0
	var/y_off = round((M.held_items.len-1) / 2)
	x_off += ui_layout["ui_hand_x_offset"]
	y_off += ui_layout["ui_hand_y_offset"]
	return "CENTER+[x_off]:16,SOUTH+[y_off+1]:5"

GLOBAL_LIST_INIT(ui_layout_default, list(
	//Hand overlay offset
	ui_hand_x_offset = 0,
	ui_hand_x_offset = 0,

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
	ui_above_intent = "EAST-3:24,SOUTH+1:7",
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
	ui_borg_sensor = "CENTER-3:16,SOUTH:5",
	ui_borg_lamp = "CENTER-4:16,SOUTH:5",
	ui_borg_thrusters = "CENTER-5:16,SOUTH:5",
	ui_inv1 = "CENTER-2:16,SOUTH:5",
	ui_inv2 = "CENTER-1  :16,SOUTH:5",
	ui_inv3 = "CENTER  :16,SOUTH:5",
	ui_borg_module = "CENTER+1:16,SOUTH:5",
	ui_borg_store = "CENTER+2:16,SOUTH:5",
	ui_borg_camera = "CENTER+3:21,SOUTH:5",
	ui_borg_album = "CENTER+4:21,SOUTH:5",
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
	ui_pai_view_images = "SOUTH:6,WEST+13"
))

GLOBAL_LIST_INIT(ui_layout_alternate, list(
	//Hand overlay offset
	ui_hand_x_offset = 0,
	ui_hand_x_offset = 0,

	//Lower left, persistent menu
	ui_inventory = "CENTER-5:18,SOUTH:5",

	//Middle left indicators
	ui_lingchemdisplay = "WEST,CENTER-1:15",
	ui_lingstingdisplay = "WEST:6,CENTER-3:11",
	ui_devilsouldisplay = "WEST:6,CENTER-1:15",

	//Lower center, persistent menu
	ui_sstore1 = "CENTER-4:18,SOUTH:5",
	ui_id = "CENTER-2:18,SOUTH+1:5",
	ui_belt = "CENTER-3:18,SOUTH:5",
	ui_back = "CENTER:18,SOUTH:5",
	ui_storage1 = "CENTER-1:18,SOUTH:5",
	ui_storage2 = "CENTER-2:18,SOUTH:5",

	//Lower right, persistent menu
	ui_drop_throw = "CENTER+3:18,SOUTH:5",
	ui_above_movement = "CENTER+7:18,SOUTH:5",
	ui_above_intent = "CENTER+6:18,SOUTH:5",
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
	ui_borg_sensor = "CENTER-3:16,SOUTH:5",
	ui_borg_lamp = "CENTER-4:16,SOUTH:5",
	ui_borg_thrusters = "CENTER-5:16,SOUTH:5",
	ui_inv1 = "CENTER-2:16,SOUTH:5",
	ui_inv2 = "CENTER-1:16,SOUTH:5",
	ui_inv3 = "CENTER:16,SOUTH:5",
	ui_borg_module = "CENTER+1:16,SOUTH:5",
	ui_borg_store = "CENTER+2:16,SOUTH:5",
	ui_borg_camera = "CENTER+3:21,SOUTH:5",
	ui_borg_album = "CENTER+4:21,SOUTH:5",
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
	ui_pai_view_images = "SOUTH:6,WEST+13"
))


/* Ghosts - REPLACED BY WASPSTATION _defines.dm
#define ui_ghost_jumptomob "SOUTH:6,CENTER-2:24"
#define ui_ghost_orbit "SOUTH:6,CENTER-1:24"
#define ui_ghost_reenter_corpse "SOUTH:6,CENTER:24"
#define ui_ghost_teleport "SOUTH:6,CENTER+1:24"
#define ui_ghost_pai "SOUTH: 6, CENTER+2:24"
End Waspstation*/

#define ui_wanted_lvl "NORTH,11"
