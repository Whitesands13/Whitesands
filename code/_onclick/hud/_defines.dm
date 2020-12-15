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
	if(ui_layout)
		x_off += text2num(ui_layout["ui_hand_x_offset"])
		y_off += text2num(ui_layout["ui_hand_y_offset"])
	return"CENTER+[x_off]:16,SOUTH+[y_off]:5"

/datum/hud/proc/ui_equip_position(mob/M)
	var/x_off = 0
	var/y_off = round((M.held_items.len-1) / 2) //values based on old equip ui position (CENTER: +/-16,SOUTH+1:5)
	if(ui_layout)
		x_off += text2num(ui_layout["ui_hand_x_offset"])
		y_off += text2num(ui_layout["ui_hand_y_offset"])
	return "CENTER+[x_off]:-16,SOUTH+[y_off+1]:5"

/datum/hud/proc/ui_swaphand_position(mob/M, which = 1) //values based on old swaphand ui positions (CENTER: +/-16,SOUTH+1:5)
	var/x_off = which == 1 ? -1 : 0
	var/y_off = round((M.held_items.len-1) / 2)
	if(ui_layout)
		x_off += text2num(ui_layout["ui_hand_x_offset"])
		y_off += text2num(ui_layout["ui_hand_y_offset"])
	return "CENTER+[x_off]:16,SOUTH+[y_off+1]:5"

#define ui_wanted_lvl "NORTH,11"
