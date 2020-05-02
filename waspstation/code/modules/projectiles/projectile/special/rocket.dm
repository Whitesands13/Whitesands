/obj/projectile/bullet/gep
	name ="\improper GEP Rocket"
	desc = "Hold on, i have to drop something. Hehe."
	icon_state= "missile"
	damage = 60
	armour_penetration = 40
	dismemberment = 20

/obj/projectile/bullet/gep/on_hit(atom/target, blocked = FALSE)
	..()
	explosion(target, -1, 1, 2, 1, 0, flame_range = 1)
	return BULLET_ACT_HIT

/obj/projectile/bullet/geprubber
	name ="\improper GEP Rubber Rocket"
	desc = "I have to perform a silent takedown on Manderley."
	icon_state= "missile"
	damage = 20
	armour_penetration = 80
	dismemberment = 0
	stamina = 60 //lets be honest theres no way you can even survive something this size
