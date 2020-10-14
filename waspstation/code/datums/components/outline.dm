/datum/component/outline
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS

	var/duration

/datum/component/outline/Initialize(_strength = 1)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	duration = 1 SECONDS * _strength
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, .proc/OnExamine)

	var/atom/movable/A = parent
	A.add_filter("rad_glow", 2, list("type"="outline", "color"="#000000", "size"=1))
	START_PROCESSING(SSdcs, src)

/datum/component/outline/Destroy()
	STOP_PROCESSING(SSdcs, src)
	var/atom/movable/A = parent
	A.remove_filter("rad_glow")
	return ..()

/datum/component/outline/process()
	if(duration > 0)
		duration -= 1
	else
		qdel(src)
		return PROCESS_KILL

/datum/component/outline/InheritComponent(datum/component/C, i_am_original, _strength)
	if(!i_am_original)
		return
	if(C)
		var/datum/component/outline/other = C
		duration += other.duration
	else
		duration += 1 SECONDS * _strength

/datum/component/outline/proc/OnExamine(datum/source, mob/user, atom/thing)
	to_chat(user, "<span class='warning'>That outline is hedious! What caused that?</span>")
