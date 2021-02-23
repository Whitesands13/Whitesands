/obj/item/card/id/solgov
	name = "\improper SolGov Officer ID"
	id_type_name = "\improper SolGov ID"
	desc = "A SolGov ID with no proper access to speak of."
	assignment = "SolGov Officer"
	icon_state = "solgov"
	uses_overlays = FALSE

/obj/item/card/id/solgov/commander
	name = "\improper SolGov Commander ID"
	id_type_name = "\improper SolGov ID"
	desc = "A SolGov ID with no proper access to speak of. This one indicates a Commander."

/obj/item/card/id/solgov/elite
	name = "\improper SolGov Elite ID"
	id_type_name = "\improper SolGov ID"
	desc = "A SolGov ID with no proper access to speak of. This one indicates an Elite."

/obj/item/card/id/away/casino
	name = "\improper Casino Cash Card"
	id_type_name = "\improper Casino ID"
	desc = "An ID card for storing your casino earnings."

/obj/item/card/id/away/casino/staff
	name = "\improper Casino Staff ID"
	desc = "A casino ID card given to all regular staff."
	access = list(ACCESS_AWAY_GENERAL)

/obj/item/card/id/away/casino/security
	name = "\improper Casino Security ID"
	desc = "A casino ID card with elevated secure access."
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_SEC)
