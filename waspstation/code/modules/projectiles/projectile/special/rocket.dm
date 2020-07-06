/obj/projectile/bullet/bolter
	name ="explosive bolt"
	icon_state= "bolter"
	damage = 60

/obj/projectile/bullet/bolter/on_hit(atom/target, blocked = FALSE)
	..()
	explosion(target, -0, 0, 2)
	return BULLET_ACT_HIT
