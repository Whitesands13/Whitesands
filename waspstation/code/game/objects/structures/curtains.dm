/obj/structure/curtain/obscuring //In other words, curtains that obscure vision when you close them
	name = "curtains"
	desc = "A sleek set of curtains which will keep prying eyes away from whatever you're doing inside..."
	alpha = 255

/obj/structure/curtain/obscuring/black
	name = "black curtains"
	desc = "A sleek, black set of curtains which will keep prying eyes away from whatever you're doing inside..."
	color = "#000000"

/obj/structure/curtain/obscuring/grey
	name = "grey curtains"
	desc = "A sleek, dark grey set of curtains which will keep prying eyes away from whatever you're doing inside..."
	color = "#696969"

/obj/structure/curtain/obscuring/bounty
	icon_type = "bounty"
	icon_state = "bounty-open"
	color = null

/obj/structure/curtain/obscuring/toggle() //obscure vision when you close them.
	open = !open
	switch(open)
		if(TRUE)
			opacity = FALSE
		if(FALSE)
			opacity = TRUE
	update_icon()
