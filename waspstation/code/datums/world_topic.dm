/datum/world_topic/ooc_relay
	keyword = "ooc_send"
	require_comms_key = TRUE

/datum/world_topic/ooc_relay/Run(list/input)
	if(GLOB.say_disabled || !GLOB.ooc_allowed)	//This is here to try to identify lag problems
		return "OOC is currently disabled."

	for(var/client/C in GLOB.clients)
		if(GLOB.OOC_COLOR)
			to_chat(C, "<font color='[GLOB.OOC_COLOR]'><b><span class='prefix'>OOC:</span> <EM>[input["sender"]]:</EM> <span class='message linkify'>[input["message"]]</span></b></font>")
		else
			to_chat(C, "<span class='ooc'><span class='prefix'>OOC:</span> <EM>[input["sender"]]:</EM> <span class='message linkify'>[input["message"]]</span></span>")

/datum/world_topic/manifest //Ported from SunsetStation
	keyword = "manifest"
	require_comms_key = TRUE //not really needed, but I don't think any bot besides ours would need it

/datum/world_topic/manifest/Run(list/input)
	var/list/heads = list()
	var/list/sec = list()
	var/list/eng = list()
	var/list/med = list()
	var/list/sci = list()
	var/list/sup = list()
	var/list/civ = list()
	var/list/bot = list()
	var/list/misc = list()
	var/list/dat = list()
	var/even = 0
	// sort mobs
	for(var/datum/data/record/t in GLOB.data_core.general)
		var/name = t.fields["name"]
		var/rank = t.fields["rank"]
		var/department = 0
		if(rank in GLOB.command_positions)
			heads[name] = rank
			department = 1
		if(rank in GLOB.security_positions)
			sec[name] = rank
			department = 1
		if(rank in GLOB.engineering_positions)
			eng[name] = rank
			department = 1
		if(rank in GLOB.medical_positions)
			med[name] = rank
			department = 1
		if(rank in GLOB.science_positions)
			sci[name] = rank
			department = 1
		if(rank in GLOB.supply_positions)
			sup[name] = rank
			department = 1
		if(rank in GLOB.civilian_positions)
			civ[name] = rank
			department = 1
		if(rank in GLOB.nonhuman_positions)
			bot[name] = rank
			department = 1
		if(!department && !(name in heads))
			misc[name] = rank
	if(heads.len > 0)
		LAZYINITLIST(dat["Heads"])
		for(var/name in heads)
			LAZYADD(dat["Heads"] , "[name] + [heads[name]]")
			even = !even
	if(sec.len > 0)
		LAZYINITLIST(sec["Security"])
		for(var/name in sec)
			LAZYADD(dat["Security"] , "[name] + [sec[name]]")
			even = !even
	if(eng.len > 0)
		LAZYINITLIST(dat["Engineering"])
		for(var/name in eng)
			LAZYADD(dat["Engineering"] , "[name] + [eng[name]]")
			even = !even
	if(med.len > 0)
		LAZYINITLIST(dat["Medical"])
		for(var/name in med)
			LAZYADD(dat["Medical"] , "[name] + [med[name]]")
			even = !even
	if(sci.len > 0)
		LAZYINITLIST(dat["Science"])
		for(var/name in sci)
			LAZYADD(dat["Science"] , "[name] + [sci[name]]")
			even = !even
	if(sup.len > 0)
		LAZYINITLIST(dat["Supply"])
		for(var/name in sup)
			LAZYADD(dat["Supply"] , "[name] + [sup[name]]")
			even = !even
	if(civ.len > 0)
		LAZYINITLIST(dat["Civilian"])
		for(var/name in civ)
			LAZYADD(dat["Civilian"] , "[name] + [civ[name]]")
			even = !even
	// in case somebody is insane and added them to the manifest, why not
	if(bot.len > 0)
		LAZYINITLIST(dat["Silicon"])
		for(var/name in bot)
			LAZYADD(dat["Silicon"] , "[name] + [bot[name]]")
			even = !even
	// misc guys
	if(misc.len > 0)
		LAZYINITLIST(dat["Miscellaneous"])
		for(var/name in misc)
			LAZYADD(dat["Miscellaneous"] , "[name] + [misc[name]]")
			even = !even
	return json_encode(dat)

/datum/world_topic/reload_admins
	keyword = "reload_admins"
	require_comms_key = TRUE

/datum/world_topic/reload_admins/Run(list/input)
	ReloadAsync()
	log_admin("[input["sender"] reloaded admins via chat command.")
	return "Admins reloaded."

/datum/world_topic/reload_admins/proc/ReloadAsync()
	set waitfor = FALSE
	load_admins()

/datum/world_topic/ircrestart
	keyword = "ircrestart"
	require_comms_key = TRUE

 /datum/world_topic/ircrestart/Run(list/input)
	var/active_admins = FALSE
	for(var/client/C in GLOB.admins)
		if(!C.is_afk() && check_rights_for(C, R_SERVER))
			active_admins = TRUE
			break
	if(!active_admins)
		return world.Reboot(input[keyword], input["reason"])
	else
		return "There are active admins on the server! Ask them to restart."
