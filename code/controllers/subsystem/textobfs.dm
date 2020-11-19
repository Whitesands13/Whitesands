//Waspstation text obfs subsystem, this serves multiple purposes and can be widely applied for URL specific words.
//Object-Position ownership map:
/*
	POSITION:		OBJECT PATH:
	[0][X]			/obj/item/reagent_containers/food/snacks/meatball
*/
//bad_word_list position map:
/*
	[X][0] = Decrypted bad words for use, upon failure of decryption this spot is filled with [3], this should be initialized to ""
	[X][1] = Actual encrypted value to decrypt, more info in the decrypt_by_world_URL proc
	[X][2] = The MD5 hash of a sucessful decryption, this will be used to tell whether [0] should be filled with [3] or the decrypted value
	[X][3] = The target word to replace, this only applies to /obj/'s. If SHA1 hash of the decrypted word does not match [2] this will be put into [0]
*/
SUBSYSTEM_DEF(textobfs)
	name = "Text"
	init_order = INIT_ORDER_TEXT	//This should run first as other subsystems may depend on the deobfuscation of targets.
	flags = SS_NO_FIRE
	runlevels = RUNLEVEL_INIT | RUNLEVEL_SETUP

	/var/list/bad_word_list	= list{
		list{
			"",
			"test",
			"cb205edee16b24366c871cf55e781346",
			"meatball",
		}
	}

/datum/controller/subsystem/textobfs/Initialize()
	to_chat(world, "\n\ntext init\n\n")	//FOR DEBUG, REMOVE BEFORE DEPLOY
	for(var/x = 0; x < bad_word_list.len; x++)
		bad_word_list[x][0] = decrypt_by_world_URL(bad_word_list[x][1], bad_word_list[x][2], bad_word_list[x][3])
	return ..()

/datum/controller/subsystem/textobfs/proc/decrypt_by_world_URL(var/val = "", var/hash = "", var/fallback = "")
	var/worldkey = world.url
	world.log << "\n\nworld.url returned:" + worldkey	//FOR DEBUG, REMOVE BEFORE DEPLOY
	var/result = worldkey + "a"
	//End decode
	//if(lowertext(md5(result)) != hash)
		//result = fallback
	return result

#undef INIT_ORDER_TEXT
