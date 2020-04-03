//Please don't roast me too hard
/client/MouseMove(object,location,control,params)
	mouseParams = params
	mouseLocation = location
	mouseObject = object
	mouseControlObject = control
	if(mob && LAZYLEN(mob.mousemove_intercept_objects))
		for(var/datum/D in mob.mousemove_intercept_objects)
			D.onMouseMove(object, location, control, params)
	..()
/datum/proc/onMouseMove(object, location, control, params)
	return
