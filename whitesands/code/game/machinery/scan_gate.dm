#define SCANGATE_NONE 			"Off"
#define SCANGATE_MINDSHIELD 	"Mindshield"
#define SCANGATE_NANITES 		"Nanites"
#define SCANGATE_DISEASE 		"Disease"
#define SCANGATE_GUNS 			"Guns"
#define SCANGATE_WANTED			"Wanted"
#define SCANGATE_SPECIES		"Species"
#define SCANGATE_NUTRITION		"Nutrition"

/obj/machinery/scanner_gate/sec
	req_access = list(ACCESS_BRIG)
	scangate_mode = SCANGATE_WANTED

/obj/machinery/scanner_gate/hop
	req_access = list(ACCESS_HOP)
	scangate_mode = SCANGATE_GUNS

#undef SCANGATE_NONE
#undef SCANGATE_MINDSHIELD
#undef SCANGATE_NANITES
#undef SCANGATE_DISEASE
#undef SCANGATE_GUNS
#undef SCANGATE_WANTED
#undef SCANGATE_SPECIES
#undef SCANGATE_NUTRITION
