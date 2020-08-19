PROCESSING_SUBSYSTEM_DEF(overmap)
	name = "Overmap"
	flags = SS_KEEP_TIMING
	wait = 1
	///List of all active ships
	var/list/ships = list()
	///List of all objects and events displayed on the map, this is probably bad
	var/list/objects = list()
	///Width/heighth of the overmap "zlevel"
	var/size = 15

/datum/controller/subsystem/processing/overmap/proc/get_overmap_object_by_id(id)
	for(var/obj/structure/overmap/object in objects)
		if(object.id == id)
			return object
