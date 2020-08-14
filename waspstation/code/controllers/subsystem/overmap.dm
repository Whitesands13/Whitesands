PROCESSING_SUBSYSTEM_DEF(overmap)
	name = "Overmap"
	flags = SS_KEEP_TIMING
	wait = 1
	///List of all active ships
	var/list/ships = list()
	///Width/heighth of the overmap "zlevel"
	var/size = 30
