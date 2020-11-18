//Bad words should be stored encrypted in the val define
//Expected hash produced by MD5 if the decryption is successfull in the hash define
//And a fallback if decryption does not occurr

#define BAD_WORD_COUNT 		1
//All new entries need to be added to the populate_bad_words proc in game/world.dm
#define BAD_WORD_1_VAL  	1
#define BAD_WORD_1_HASH 	"098f6bcd4621d373cade4e832627b4f6"
#define BAD_WORD_1_FALLBACK "Decryption fail"
//End 1
