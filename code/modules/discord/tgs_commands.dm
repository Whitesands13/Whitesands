// Notify
/datum/tgs_chat_command/notify
	name = "notify"
	help_text = "Pings the invoker when the round ends"

/datum/tgs_chat_command/notify/Run(datum/tgs_chat_user/sender, params)
	for(var/member in SSdiscord.notify_members) // If they are in the list, take them out
		if(member == "[sender.mention]")
			SSdiscord.notify_members -= "[SSdiscord.id_clean(sender.mention)]" // The list uses strings because BYOND cannot handle a 17 digit integer
			return "You will no longer be notified when the server restarts"

	// If we got here, they arent in the list. Chuck 'em in!
	SSdiscord.notify_members += "[SSdiscord.id_clean(sender.mention)]" // The list uses strings because BYOND cannot handle a 17 digit integer
	return "You will now be notified when the server restarts"
