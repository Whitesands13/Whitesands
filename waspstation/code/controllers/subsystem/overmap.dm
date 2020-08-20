PROCESSING_SUBSYSTEM_DEF(overmap)
	name = "Overmap"
	priority = SS_BACKGROUND
	flags = SS_KEEP_TIMING
	wait = 1
	///List of all active ships
	var/list/ships = list()
	///Width/heighth of the overmap "zlevel"
	var/size = 15

/datum/controller/subsystem/processing/overmap/proc/get_overmap_object_by_id(id)
	for(var/obj/structure/overmap/object in processing)
		if(object.id == id)
			return object

/datum/controller/subsystem/processing/overmap/proc/get_main()
	get_overmap_object_by_id(MAIN_OVERMAP_OBJECT_ID)
