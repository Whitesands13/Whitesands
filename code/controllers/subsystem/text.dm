SUBSYSTEM_DEF(text)
	name = "text"
	init_order = 0	//This runs first as other subsystems may depend on the deobfuscation of targets.
	GLOB.bad_word_list = new/list(BAD_WORD_COUNT)
	GLOB.bad_word_list_targets = new/list(BAD_WORD_COUNT)
	GLOB.bad_word_list[1] = decrypt_by_world_IP(BAD_WORD_1_VAL, BAD_WORD_1_HASH, BAD_WORD_1_TARGET)
	GLOB.bad_word_list_targets[1] = BAD_WORD_1_TARGET
