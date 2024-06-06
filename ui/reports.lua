local FORMNAME = "essentials:report_admin"
local idr = "0000"
local ids = ""
local iss = 1

local function formspec_format(def)
	local formspec = string.format("formspec_version[6]".."size[10.5,11.5]".."dropdown[3.7,1.2;3,0.8;report;%s;1;false]".."label[3.7,1;Report]".."label[0.9,3.4;Reported by %s]".."label[0.9,4;Culprit is %s]".."textarea[0.9,4.8;8.7,5.3;description;Description to report;%s]".."label[3.7,2.3;Broken rule: %s]".."button[5.9,10.4;3.7,0.8;decline;Decline]".."button[0.9,10.4;3.7,0.8;accept;Approve]".."label[6.9,4.6;Selected ID: %s]", ids, def.by_name, def.reported_name, def.about, def.broked_rule)
	return formspec
end

minetest.after(0, function()
	if not essentials_reports == nil then
		for i, def in ipairs(essentials_reports) do
			--if not string.fing(dump(def)) == "log" then
				ids = ids..","..def.id
			--end
		end
	end
end)

function show_report_manage(name)
	minetest.chat_send_player(name, ids)

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

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end
	local name = player:get_player_name()
	minetest.sound_play("clicked", {to_player = name})
    
	local def = {}
	
	if fields.report then
		idr = report
		if not essentials_reports == nil then
			for i, def in ipairs(essentials_reports) do
				if def.id == idr then
					player:set_properties({
						formspec = formspec_format(def)
					})
				end
			end
		end
	end

	if fields.accept then
		essentials.appdec_report(idr, "approve", name)
	end
	if fields.decline then
		essentials.appdec_report(idr, "decline", name)
	end
	return
end)