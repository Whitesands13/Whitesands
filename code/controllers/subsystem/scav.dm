SUBSYSTEM_DEF(scav)
	name		 = "Scav"
	flags		 = SS_BACKGROUND
	init_order	 = INIT_ORDER_DEFAULT

	var/ordernum = 1					//order number given to next order
	var/list/scav_packs = list()
	var/list/shoppinglist = list()
	var/list/orderhistory = list()
