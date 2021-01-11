/obj/effect/temp_visual/dir_setting/space_wind
	icon = 'waspstation/icons/effects/atmospherics.dmi'
	icon_state = "space_wind"
	layer = FLY_LAYER
	duration = 20
	mouse_opacity = 0

/obj/effect/temp_visual/dir_setting/space_wind/Initialize(mapload, set_dir, set_alpha = 255)
	. = ..()
	alpha = set_alpha

/obj/effect/temp_visual/dir_setting/item_swing
	icon = 'waspstation/icons/effects/effects.dmi'
	icon_state = "swing"
	duration = 5

/obj/effect/temp_visual/dir_setting/item_swing/stab
	icon_state = "stab"
