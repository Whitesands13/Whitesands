//Secret bad words, Wasp defines
//Encrypted bad words should be stored in the val define
//Expected hash produced by MD5 if the decryption is successfull in the hash define
//And the target name to change
#define BAD_WORD_COUNT		1
//All new entries need to be added to the populate_bad_words proc in game/world.dm
#define BAD_WORD_1_VAL  	"test"
#define BAD_WORD_1_HASH 	"0391a1e58f324b3a0c79d32dd09436bd45bfc773"
#define BAD_WORD_1_TARGET	"meatball"

//Object-Position ownership map
/*
	POSITION:		OBJECT PATH:
	1				/obj/item/reagent_containers/food/snacks/meatball
*/

SUBSYSTEM_DEF(text)
	name = "Text"
	init_order = INIT_ORDER_TEXT	//This runs first as other subsystems may depend on the deobfuscation of targets.
	flags = SS_NO_FIRE

/datum/controller/subsystem/text/Initialize()
	//Begin attempting decryption
	GLOB.bad_word_list = new/list(BAD_WORD_COUNT)
	GLOB.bad_word_list_targets = new/list(BAD_WORD_COUNT)

	GLOB.bad_word_list[1] = decrypt_by_world_URL(BAD_WORD_1_VAL, BAD_WORD_1_HASH, BAD_WORD_1_TARGET)
	GLOB.bad_word_list_targets[1] = BAD_WORD_1_TARGET


#undef BAD_WORD_COUNT
#undef BAD_WORD_1_VAL
#undef BAD_WORD_1_HASH
#undef BAD_WORD_1_TARGET
