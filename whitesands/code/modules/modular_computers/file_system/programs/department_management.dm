/datum/computer_file/program/department_management
	filename = "dept_manage"
	filedesc = "Departmental Finances Manager"
	program_icon_state = "id"
	program_icon = "money"
	extended_desc = "This program allows management of a department's finances, such as changing paychecks."
	transfer_access = ACCESS_HEADS
	required_access = ACCESS_HEADS
	requires_ntnet = TRUE
	size = 4
	tgui_id = "NtosDeptManager"
/**
  * Returns either a head of staff position for finding suboordinates, or a budget card for determining which budget you can control.
  * * user - The user to get the access from.
  * * budget - Whether or not to return budget card accounts according to access.
  */
/datum/computer_file/program/department_management/proc/get_accesses(mob/user, budget = FALSE)
	. = list()
	var/obj/item/card/id/user_id = user.get_idcard(TRUE)
	if(!user_id)
		return
	if(ACCESS_HOP in user_id.access)
		. += budget ? list(ACCOUNT_SRV, ACCOUNT_CAR) : "Head of Personnel"
	if(ACCESS_HOS in user_id.access)
		. += budget ? ACCOUNT_SEC : "Head of Security"
	if(ACCESS_CMO in user_id.access)
		. += budget ? ACCOUNT_MED : "Chief Medical Officer"
	if(ACCESS_RD in user_id.access)
		. += budget ? ACCOUNT_SCI : "Research Director"
	if(ACCESS_CE in user_id.access)
		. += budget ? ACCOUNT_ENG : "Chief Engineer"

/datum/computer_file/program/department_management/ui_data(mob/user)
	var/list/data = get_header_data()
	var/list/department_accesses = get_accesses(user, FALSE)

	var/list/accounts = list()
	for(var/a in SSeconomy.bank_accounts)
		var/datum/bank_account/account = a
		if(account.account_job.department_head in department_accesses)
			accounts += list(list(
				"holder" = account.account_holder,
				"balance" = account.account_balance,
				"job" = account.account_job?.title,
				"paycheck" = account.account_job?.paycheck,
				"paycheck_department" = account.account_job?.paycheck_department,
				"ref" = REF(account)
			))
	data["accounts"] = accounts
	return data

/datum/computer_file/program/department_management/ui_static_data(mob/user)
	var/list/data = list()

	var/list/jobs = list()
	for(var/j in SSjob.occupations)
		var/datum/job/job = j
		jobs += job.title
	data["jobs"] = jobs

	var/list/department_budgets = get_accesses(user, TRUE)
	var/list/budgets = list()
	for(var/b in department_budgets)
		var/datum/bank_account/department/budget = SSeconomy.get_dep_account(b)
		budgets += list(list(
			"id" = budget.account_id,
			"name" = budget.account_holder,
			"balance" = budget.account_balance,
			"frozen" = budget.frozen,
			"ref" = REF(budget)
		))
	return data

/datum/computer_file/program/department_management/ui_act(action, list/params, datum/tgui/ui)
	if(..())
		return
	var/mob/user = usr
	var/datum/bank_account/account_to_change = locate(params["selected_account"])
	switch(action)
		if("PRG_change_holder")
			account_to_change.account_holder = params["new_holder"]
			return TRUE
		if("PRG_change_id")
			account_to_change.account_id = clamp(text2num(params["new_id"]), 111111, 999999)
			return TRUE
		if("PRG_change_paycheck")
			account_to_change.account_job.paycheck = locate(text2num(params["new_paycheck"]))
			return TRUE
		if("PRG_terminate_employment")
			account_to_change.account_job = new /datum/job/assistant //get a (new) job
			return TRUE
		if("PRG_freeze_acct")
			account_to_change.frozen = !account_to_change.frozen
			return TRUE
