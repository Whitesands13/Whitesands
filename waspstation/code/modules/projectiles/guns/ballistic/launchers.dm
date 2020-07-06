/obj/item/gun/ballistic/automatic/bolter
	name = "Mark Vb Godwyn Pattern Bolter"
	desc = "A rifle designed to shoot massive explosive bolts. For the Emperor."
	icon = 'waspstation/icons/obj/guns/projectile.dmi'
	icon_state = "bolter"
	fire_sound = 'sound/weapons/gun/general/grenade_launch.ogg'
	mag_type = /obj/item/ammo_box/magazine/bolter
	burst_size = 1
	fire_delay = 0
	actions_types = list()
	casing_ejector = TRUE
	mag_display = TRUE
	w_class = WEIGHT_CLASS_BULKY
	force = 18 //youch

/obj/item/gun/ballistic/automatic/bolter/storm
	name = "Mark IV Thunderfury Pattern Storm Bolter"
	desc = "A bolter with twin barrels for improved fire-rate. Bless the Emperor."
	icon_state = "stormbolter"
	burst_size = 2
	fire_delay = 2

/obj/item/gun/ballistic/automatic/bolter/boltpistol
	name = "Mark III Pattern Bolt Pistol"
	desc = "A pistol designed to be a smaller bolter. The Emperor protects."
	icon_state = "boltpistol"
	mag_type = /obj/item/ammo_box/magazine/boltpistol
	w_class = WEIGHT_CLASS_NORMAL
	force = 12 //ouch but less

/obj/item/gun/ballistic/automatic/bolter/debug
	name = "Emperor's Own Bolter"
	desc = "FOR THE EMPEROR!"
	burst_size = 30
	fire_delay = 0.25
	actions_types = list()
	casing_ejector = TRUE
	mag_display = TRUE
	w_class = WEIGHT_CLASS_TINY
	force = 41999
