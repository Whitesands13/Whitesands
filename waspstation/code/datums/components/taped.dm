/datum/component/taped
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS

	var/taped_integrity = 0
	var/mutable_appearance/taped_icon
	var/obj/item/stack/tape/tape_used


/datum/component/taped/Initialize(obj/item/stack/tape/tape_used)
	if(!isatom(parent) || !tape_used)
		return COMPONENT_INCOMPATIBLE
	src.tape_used = tape_used
	set_tape()

/datum/component/taped/InheritComponent(datum/component/taped/C, i_am_original, obj/item/stack/tape/tape_used)
	var/obj/I = parent
	if(C)
		src.tape_used = C.tape_used
	else
		src.tape_used = tape_used
	I.cut_overlay(taped_icon)
	set_tape()

/datum/component/taped/RegisterWithParent()
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, .proc/tape_rip)
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, .proc/examine_tape)

/datum/component/taped/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_PARENT_ATTACKBY, COMSIG_PARENT_EXAMINE))

/datum/component/taped/proc/set_tape()
	var/obj/I = parent

	I.obj_integrity = min((I.obj_integrity + tape_used.nonorganic_heal), I.max_integrity)
	taped_integrity += tape_used.nonorganic_heal

	var/icon/tape_marks = icon(initial(I.icon), initial(I.icon_state))
	tape_marks.Blend("#fff", ICON_ADD)
	tape_marks.Blend(icon('waspstation/icons/obj/tapes.dmi', "[tape_used.icon_state]_mask"), ICON_MULTIPLY)
	taped_icon = new(tape_marks)
	I.add_overlay(taped_icon)
	I.update_icon()

/datum/component/taped/proc/tape_rip(datum/source, obj/item/attacker, mob/user)
	var/obj/item/I = attacker
	if(!I.tool_behaviour == TOOL_WIRECUTTER || !I.sharpness >= IS_SHARP)
		return
	playsound(parent, 'sound/items/poster_ripped.ogg', 30, TRUE, -2)
	user.visible_message("<span class='notice'>[user] cuts and tears [tape_used] off \the [parent].", "<span class='notice'>You finish peeling away all the [tape_used] from \the [parent].</span>")
	remove_tape()

/datum/component/taped/proc/examine_tape(datum/source, mob/user, list/examine_list)
	examine_list += "<span class='warning'>A bunch of [tape_used] is holding this thing together!</span>"

/datum/component/taped/proc/remove_tape()
	var/obj/item/I = parent
	I.obj_integrity -= taped_integrity
	I.cut_overlay(taped_icon)
	qdel(src)
