/proc/deep_list2params(list/deep_list)
	var/list/L = list()
	for(var/i in deep_list)
		var/key = i
		if(isnum(key))
			L += "[key]"
			continue
		if(islist(key))
			key = deep_list2params(key)
		else if(!istext(key))
			key = "[REF(key)]"
		L += "[key]"
		var/value = deep_list[key]
		if(!isnull(value))
			if(islist(value))
				value = deep_list2params(value)
			else if(!(istext(key) || isnum(key)))
				value = "[REF(value)]"
			L["[key]"] = "[value]"
	return list2params(L)
