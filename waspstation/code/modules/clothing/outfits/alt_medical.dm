//Doctor Alts

/datum/outfit/job/doctor/juniordoctor
	name = "Junior Doctor"

	uniform = /obj/item/clothing/under/rank/medical/doctor/junior_doctor
	alt_uniform = null
	shoes = /obj/item/clothing/shoes/sneakers/blue
	suit =  null
	alt_suit = null
	l_hand = null
	suit_store = null

	backpack_contents = list(/obj/item/storage/firstaid/medical=1, /obj/item/flashlight/pen=1)

/datum/outfit/job/doctor/seniordoctor
	name = "Senior Doctor"

	uniform = /obj/item/clothing/under/suit/senior_doctor
	alt_uniform = null
	shoes = /obj/item/clothing/shoes/laceup
	suit = /obj/item/clothing/suit/toggle/lawyer/medical
	alt_suit = /obj/item/clothing/suit/toggle/labcoat
	dcoat = null
	l_hand = null
	suit_store = null
	neck = /obj/item/clothing/neck/tie/blue

	backpack_contents = list(/obj/item/storage/firstaid/medical=1, /obj/item/flashlight/pen=1)

/datum/outfit/job/doctor/psychiatrist
	name = "Psychiatrist"

	uniform = /obj/item/clothing/under/rank/medical/psychiatrist
	alt_uniform = /obj/item/clothing/under/rank/medical/psychiatrist/blue
	shoes = /obj/item/clothing/shoes/laceup
	suit =  null
	alt_suit = null
	l_hand = null
	suit_store = null

	backpack_contents = list(/obj/item/clipboard=1, /obj/item/folder/white=1, /obj/item/taperecorder=1)

//Chemist Alts

/datum/outfit/job/chemist/pharmacist
	name = "Pharmacist"
	jobtype = /datum/job/chemist

	glasses = null

	uniform = /obj/item/clothing/under/rank/medical/chemist/pharmacist
	alt_uniform = null

	backpack_contents = list(/obj/item/clothing/glasses/science=1)

/datum/outfit/job/chemist/pharmacologist
	name = "Pharmacologist"

	glasses = null
	uniform = /obj/item/clothing/under/rank/medical/chemist/pharmacologist
	alt_uniform = null
	suit = /obj/item/clothing/suit/toggle/labcoat/chemist/side

	backpack_contents = list(/obj/item/clothing/glasses/science=1)

/datum/outfit/job/chemist/juniorchemist
	name = "Junior Chemist"

	glasses = null
	uniform = /obj/item/clothing/under/rank/medical/chemist/junior_chemist
	alt_uniform = null
	suit = null
	alt_suit = null

	backpack_contents = list(/obj/item/clothing/glasses/science=1)

/datum/outfit/job/chemist/seniorchemist
	name = "Senior Chemist"

	glasses = null
	uniform = /obj/item/clothing/under/suit/senior_chemist
	alt_uniform = null
	shoes = /obj/item/clothing/shoes/laceup
	suit = /obj/item/clothing/suit/toggle/lawyer/orange
	alt_suit = /obj/item/clothing/suit/toggle/labcoat/chemist
	dcoat = null
	l_hand = null
	suit_store = null
	neck = /obj/item/clothing/neck/tie/blue

	backpack_contents = list(/obj/item/clothing/glasses/science=1)

//Alt EMT

/datum/outfit/job/paramedic/emt
	name = "Emergency Medical Technician"

	uniform = /obj/item/clothing/under/rank/medical/paramedic/emt

//Alt CMO

/datum/outfit/job/cmo/medicaldirector
	name = "Medical Director"

	uniform = /obj/item/clothing/under/suit/cmo
	alt_uniform = null
	shoes = /obj/item/clothing/shoes/laceup
	suit = /obj/item/clothing/suit/toggle/lawyer/cmo
	alt_suit = /obj/item/clothing/suit/toggle/labcoat/cmo
	neck = /obj/item/clothing/neck/tie/blue
	l_hand = null
	suit_store = null
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1, /obj/item/storage/firstaid/medical=1, /obj/item/flashlight/pen=1)

//Virologist

/datum/outfit/job/virologist/pathologist
	name = "Pathologist"

	uniform = /obj/item/clothing/under/suit/pathologist
	alt_uniform = null
	shoes = /obj/item/clothing/shoes/laceup
	neck = /obj/item/clothing/neck/tie/green
