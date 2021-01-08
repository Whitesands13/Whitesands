/datum/dcm_net
	//Hub machine
	var/obj/machinery/deepcore/hub/netHub
	/* List of connected machines

	*/
	var/list/obj/machinery/deepcore/connected = list()
	/* Ores available for system output
	NOT to be considered
	*/
	var/list/ores = list() //Key = item/stack/ore ref | Value = Stack amount


/datum/dcm_net/New(obj/machinery/deepcore/hub/source)
	netHub = source

// ** Machine handling procs **

/datum/dcm_net/Destroy()
	if(connected)
		for (var/obj/machinery/deepcore/M in connected)
			M.network = null
	return ..()

/datum/dcm_net/proc/AddMachine(obj/machinery/deepcore/M)
	if(!(M in connected))
		connected += M
		M.network = src
		return TRUE

/datum/dcm_net/proc/RemoveMachine(obj/machinery/deepcore/M)
	if(M in connected)
		connected -= M
		M.network = null
		//Destroys the network if there's no more machines attached
		if(!length(connected))
			connected = null
			qdel(src)
		return TRUE

/datum/dcm_net/proc/MergeWith(datum/dcm_net/net)
	for (var/obj/machinery/deepcore/M in net.connected)
		AddMachine(M)
	qdel(net)

// ** Ore handling procs **

/datum/dcm_net/proc/Push(container)
	for(var/O in container)
		var/amount = container[O]
		ores[O] += amount
		container -= O

/datum/dcm_net/proc/Pull(container)
	for(var/O in ores)
		var/amount = ores[O]
		container[O] += amount
		ores -= O
