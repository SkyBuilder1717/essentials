local S = essentials.translate
local FORMNAME = "essentials:report_admin"
local ids = ""

local function load_ids()
	ids = ""
	for id, def in pairs(essentials_reports) do
		ids = ids..","..id
	end
end

local function get_formspec(id)
	local def = essentials_reports[id] or {}
	local selected_id = 1

	for i, d in ipairs(essentials_reports) do
		if def == d then
			selected_id = i
		end
	end

	load_ids()
	essentials.load_reports()

	local formspec = "formspec_version[6]"

	if (not essentials_reports[id]) or (id == "0000") then
		formspec = formspec..string.format("size[10.5,11.5]"..
			"dropdown[3.7,1.2;3,0.8;report;%s;%s;false]"..
			"label[3.7,1;"..S("Report").."]"..
			"label[3.7,2.3;"..S("No selected report.").."]", 
			ids, selected_id)
	else
		formspec = formspec..string.format("size[10.5,11.5]"..
			"dropdown[3.7,1.2;3,0.8;report;%s;%s;false]"..
			"label[3.7,1;"..S("Report").."]"..
			"label[0.9,3.4;"..S("Reported by @1", "%s").."]"..
			"label[0.9,4;"..S("Culprit is @1", "%s").."]"..
			"textarea[0.9,4.8;8.7,5.3;description;"..S("Description to report")..";%s]"..
			"label[3.7,2.3;"..S("Broken rule: @1", "%s").."]"..
			"button[5.9,10.4;3.7,0.8;decline;"..S("Decline").."]"..
			"button[0.9,10.4;3.7,0.8;accept;"..S("Approve").."]"..
			"label[6.9,4.6;Selected ID: %s]", 
			ids, selected_id, def.by_name, def.reported_name, def.about, def.broken_rule, id)
	end
	
	return formspec
end

local idr = "0000"
function essentials.show_report_manage(name)
	local formspec = get_formspec(idr)
	core.show_formspec(name, FORMNAME, formspec)
end

core.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end
	local name = player:get_player_name()
	essentials.player_sound("clicked", name)
    
	local def = {}
	
	if fields.report then
		idr = fields.report
		local formspec = get_formspec(idr)

		if fields.accept then
			essentials.appdec_report(idr, "approve")
		end
		if fields.decline then
			essentials.appdec_report(idr, "decline")
		end
		core.show_formspec(name, FORMNAME, formspec)
	end
end)