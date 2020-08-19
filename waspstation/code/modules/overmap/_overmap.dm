#define MAIN_OVERMAP_OBJECT_ID "main"
/* OVERMAP TURFS */
/turf/open/overmap
	icon = 'waspstation/icons/turf/overmap.dmi'
	icon_state = "overmap0"

/turf/open/overmap/edge
	opacity = 1
	density = 1

//this is completely unnecessary but it looks interesting
/turf/open/overmap/Initialize()
	. = ..()
	name = "[x]-[y]"
	var/list/numbers = list()

	if(x == 1 || x == SSovermap.size)
		numbers += list("[round(y/10)]","[round(y%10)]")
		if(y == 1 || y == SSovermap.size)
			numbers += "-"
	if(y == 1 || y == SSovermap.size)
		numbers += list("[round(x/10)]","[round(x%10)]")

	for(var/i = 1 to numbers.len)
		var/image/I = image('waspstation/icons/effects/numbers.dmi',numbers[i])
		I.pixel_x = 5*i - 2
		I.pixel_y = world.icon_size/2 - 3
		if(y == 1)
			I.pixel_y = 3
			I.pixel_x = 5*i + 4
		if(y == SSovermap.size)
			I.pixel_y = world.icon_size - 9
			I.pixel_x = 5*i + 4
		if(x == 1)
			I.pixel_x = 5*i - 2
		if(x == SSovermap.size)
			I.pixel_x = 5*i + 2
		overlays += I

/* OVERMAP OBJECTS */
/obj/structure/overmap
	name = "overmap object"
	desc = "An unknown celestial object."
	icon = 'waspstation/icons/effects/overmap.dmi'
	icon_state = "object"
	///The main helm currently controlling or viewing the vessel
	var/obj/machinery/computer/helm/helm
	///ID
	var/id
	///If we need to render a map for cameras and helms for this object
	var/render_map = FALSE
	///The range of the view shown to helms and viewscreens (subject to be relegated to something else)
	var/sensor_range = 4
	///Integrity percentage (out of 100, duh)
	var/integrity = 100

	///List of other overmap objects in the same tile
	var/list/close_overmap_objects = list()

	// Stuff needed to render the map
	var/map_name
	var/obj/screen/map_view/cam_screen
	var/obj/screen/plane_master/lighting/cam_plane_master
	var/obj/screen/background/cam_background

/obj/structure/overmap/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/overmap/LateInitialize()
	. = ..()
	SSovermap.objects += src
	START_PROCESSING(SSovermap, src)
	if(id == MAIN_OVERMAP_OBJECT_ID)
		name = station_name()
	if(!id)
		id = "overmap_object_[length(SSovermap.objects)++]"
	if(render_map)	// Initialize map objects
		map_name = "overmap_[id]_map"
		cam_screen = new
		cam_screen.name = "screen"
		cam_screen.assigned_map = map_name
		cam_screen.del_on_map_removal = FALSE
		cam_screen.screen_loc = "[map_name]:1,1"
		cam_plane_master = new
		cam_plane_master.name = "plane_master"
		cam_plane_master.assigned_map = map_name
		cam_plane_master.del_on_map_removal = FALSE
		cam_plane_master.screen_loc = "[map_name]:CENTER"
		cam_background = new
		cam_background.assigned_map = map_name
		cam_background.del_on_map_removal = FALSE

/obj/structure/overmap/Destroy()
	. = ..()
	SSovermap.objects -= src
	STOP_PROCESSING(SSovermap, src)
	if(render_map)
		QDEL_NULL(cam_screen)
		QDEL_NULL(cam_plane_master)
		QDEL_NULL(cam_background)

/obj/structure/overmap/process()
	if(render_map)
		var/list/visible_turfs = list()
		for(var/turf/T in view(sensor_range, src))
			visible_turfs += T

		var/list/bbox = get_bbox_of_atoms(visible_turfs)
		var/size_x = bbox[3] - bbox[1] + 1
		var/size_y = bbox[4] - bbox[2] + 1

		cam_screen.vis_contents = visible_turfs
		cam_background.icon_state = "clear"
		cam_background.fill_rect(1, 1, size_x, size_y)
		return TRUE

/obj/structure/overmap/Crossed(atom/movable/AM, oldloc)
	. = ..()
	if(istype(AM, /obj/structure/overmap))
		var/obj/structure/overmap/other = AM
		if(other == src)
			return
		other.close_overmap_objects += src
		close_overmap_objects += other

/obj/structure/overmap/Uncross(atom/movable/AM, atom/newloc)
	. = ..()
	if(istype(AM, /obj/structure/overmap))
		var/obj/structure/overmap/other = AM
		if(other == src)
			return
		other.close_overmap_objects -= src
		close_overmap_objects -= other

/obj/structure/overmap/proc/get_close_objects()
	close_overmap_objects.Cut()
	for(var/obj/structure/overmap/object in get_turf(src))
		if(src)
			continue
		close_overmap_objects += object

/obj/structure/overmap/station/main //there should only be ONE of these in a given game.
	id = MAIN_OVERMAP_OBJECT_ID
	render_map = TRUE
