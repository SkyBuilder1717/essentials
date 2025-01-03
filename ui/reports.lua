local S = essentials.translate
local FORMNAME = "essentials:report_admin"
local ids = ""

local function formspec_format(id)
	local def = essentials_reports[id] or {}
	local selected_id = 1

	for i, def2 in ipairs(essentials_reports) do
		minetest.chat_send_all(dump(def).." match with "..dump(def2))
		if def == def2 then
			selected_id = i
		end
	end

	local formspec = string.format("formspec_version[6]"..
		"size[10.5,11.5]"..
		"dropdown[3.7,1.2;3,0.8;report;%s;%s;false]"..
		"label[3.7,1;Report]"..
		"label[0.9,3.4;Reported by %s]"..
		"label[0.9,4;Culprit is %s]"..
		"textarea[0.9,4.8;8.7,5.3;description;Description to report;%s]"..
		"label[3.7,2.3;Broken rule: %s]"..
		"button[5.9,10.4;3.7,0.8;decline;Decline]"..
		"button[0.9,10.4;3.7,0.8;accept;Approve]"..
		"label[6.9,4.6;Selected ID: %s]", 

		ids, selected_id, def.by_name, def.reported_name, def.about, def.broken_rule, id)
	return formspec
end

function show_report_manage(name)
	essentials.load_reports()
	ids = ""
	for id, def in pairs(essentials_reports) do
		ids = ids..","..id
	end

	local formspec = "formspec_version[6]"..
		"size[10.5,11.5]"..
		"dropdown[3.7,1.2;3,0.8;report;"..ids..";1;false]"..
		"label[3.7,1;Report]"..
		"label[0.9,3.4;Reported by -]"..
		"label[0.9,4;Culprit is -]"..
		"textarea[0.9,4.8;8.7,5.3;description;Description to report;]"..
		"label[3.7,2.3;Broken rule: -]"..
		"button[5.9,10.4;3.7,0.8;decline;Decline]"..
		"button[0.9,10.4;3.7,0.8;accept;Approve]"..
		"label[6.9,4.6;Selected ID: 0000]"
	minetest.show_formspec(name, FORMNAME, formspec)
end

local idr = "1000"
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end
	local name = player:get_player_name()
	minetest.sound_play("clicked", {to_player = name})
    
	local def = {}
	
	if fields.report then
		idr = fields.report
		local formspec = formspec_format(idr)

		if fields.accept then
			essentials.appdec_report(idr, "approve")
		end
		if fields.decline then
			essentials.appdec_report(idr, "decline")
		end
		minetest.show_formspec(name, FORMNAME, formspec)
	end
	return
end)