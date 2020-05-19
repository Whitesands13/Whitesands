/datum/language/spider
	name = "spider"
	desc = "A language that exploits the multiple limbs of spiders to do subtle dance like movements to communicate without relying on sound.\
	The movements are quick enough to make audible whiffs and thumps however."
	speech_verb = "chitter"
	ask_verb = "chitter"
	exclaim_verb = "chitter"
	key = "m"
	flags = NO_STUTTER | LANGUAGE_HIDE_ICON_IF_NOT_UNDERSTOOD

/datum/language/spider/scramble(input)
	. = prob(65) ? "<i>wiff</i>" : "<i>thump</i>"
	. += (copytext(input, length(input)) == "?") ? "?" : "!"
