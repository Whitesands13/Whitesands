/obj/machinery/vending/medical
	name = "\improper NanoMed Plus"
	desc = "Medical drug dispenser."
	icon_state = "med"
	icon_deny = "med-deny"
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?;Ping!"
	req_access = list(ACCESS_MEDICAL)
	products = list(/obj/item/stack/medical/gauze = 8,
					/obj/item/reagent_containers/syringe = 12,
					/obj/item/reagent_containers/dropper = 3,
					/obj/item/healthanalyzer = 4,
					/obj/item/reagent_containers/pill/patch/styptic = 5,
					/obj/item/reagent_containers/pill/patch/silver_sulf = 5,
					/obj/item/reagent_containers/syringe/perfluorodecalin = 2,
					/obj/item/reagent_containers/pill/insulin = 5,
					/obj/item/reagent_containers/glass/bottle/charcoal = 4,
					/obj/item/reagent_containers/glass/bottle/epinephrine = 3,
					/obj/item/reagent_containers/glass/bottle/morphine = 4,
					/obj/item/reagent_containers/glass/bottle/potass_iodide = 1,
					/obj/item/reagent_containers/glass/bottle/salglu_solution = 3,
					/obj/item/reagent_containers/glass/bottle/toxin = 3,
					/obj/item/reagent_containers/syringe/antiviral = 6,
					/obj/item/reagent_containers/medigel/styptic = 2,
					/obj/item/reagent_containers/medigel/silver_sulf = 2,
					/obj/item/reagent_containers/medigel/sterilizine = 1,
					/obj/item/stack/sticky_tape/surgical = 3,
					/obj/item/healthanalyzer/wound = 4,
					/obj/item/stack/medical/ointment = 2,
					/obj/item/stack/medical/suture = 2,
					/obj/item/stack/medical/bone_gel = 4,
					/obj/item/reagent_containers/pill/morphine = 4,
					/obj/item/storage/box/gum/happiness = 3,
					/obj/item/sensor_device = 2,
					/obj/item/pinpointer/crew = 2,
					/obj/item/reagent_containers/glass/bottle/vial/small = 5,
					/obj/item/stack/medical/splint = 10,
					/obj/item/bonesetter = 2,
					/obj/item/gauze_injector = 3)
	contraband = list(/obj/item/reagent_containers/pill/tox = 3,
		              /obj/item/reagent_containers/pill/morphine = 4,
		              /obj/item/reagent_containers/pill/charcoal = 6,
		              /obj/item/storage/box/hug/medical = 1)
	premium = list(/obj/item/reagent_containers/medigel/synthflesh = 2,
		        	/obj/item/storage/pill_bottle/psicodine = 2,
		        	/obj/item/reagent_containers/hypospray/medipen = 3,
					/obj/item/clothing/glasses/hud/health = 2,
					/obj/item/clothing/glasses/hud/health/prescription = 1,
					/obj/item/hypospray/mkii = 1,
		        	/obj/item/storage/belt/medical = 3,
					/obj/item/storage/firstaid/advanced = 2,
					/obj/item/shears = 1,
					/obj/item/plunger/reinforced = 2)
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = FIRE_PROOF
	refill_canister = /obj/item/vending_refill/medical
	default_price = 250
	extra_price = 500
	payment_department = ACCOUNT_MED
	light_mask = "med-light-mask"

/obj/item/vending_refill/medical
	machine_name = "NanoMed Plus"
	icon_state = "refill_medical"

/obj/machinery/vending/medical/syndicate_access
	name = "\improper SyndiMed Plus"
	req_access = list(ACCESS_SYNDICATE)
