local S = essentials.translate
local FORMNAME = "essentials:report_admin"
local ids = ""

local idrs = {}
local function rst(n)
	idrs[n] = "0000"
end

core.register_on_joinplayer(function(p)
	local n = p:get_player_name()
	rst(n)
end)

local function load_ids()
	ids = ""
	for id, def in pairs(essentials_reports) do
		ids = ids..","..id
	end
end

local function get_formspec(id)
	local def = essentials_reports[id]
	local selected_id = 1

	local i = 1
	for iden, _ in pairs(essentials_reports) do
		i = i + 1
		if id == tostring(iden) then
			selected_id = i
		end
	end

	essentials.load_reports()
	load_ids()

	local formspec
	if (not essentials_reports[id]) or (id == "0000") then
		formspec = {
			"formspec_version[6]",
			"size[10.5,11.5]",
			"dropdown[3.7,1.2;3,0.8;report;", ids, ";", selected_id, ";false]",
			"label[3.7,1;", S("Report"), "]",
			"label[3.7,2.3;", S("No selected report."), "]"
		}
	else
		formspec = {
			"formspec_version[6]",
			"size[10.5,11.5]",
			"dropdown[3.7,1.2;3,0.8;report;", ids, ";", selected_id, ";false]",
			"label[3.7,1;", S("Report"), "]",
			"label[0.9,3.4;", S("Reported by @1", def.by_name), "]",
			"label[0.9,4;", S("Culprit is @1", def.reported_name), "]",
			"textarea[0.9,4.8;8.7,5.3;description;", S("Description to report"), ";", def.about, "]",
			"label[3.7,2.3;", S("Broken rule: @1", def.broken_rule), "]",
			"button[5.9,10.4;3.7,0.8;decline;", S("Decline"), "]",
			"button[0.9,10.4;3.7,0.8;accept;", S("Approve"), "]",
			"label[6.9,4.6;", S("Selected ID: @1", id), "]"
		}
	end
	
	return table.concat(formspec)
end

function essentials.show_report_manage(name)
	core.show_formspec(name, FORMNAME, get_formspec("0000"))
end

core.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end
	local name = player:get_player_name()
	essentials.player_sound("clicked", name)
    
	local def = {}
	
	if fields.report then
		idrs[name] = fields.report
		local formspec = get_formspec(idrs[name])

		if fields.accept then
			essentials.appdec_report(idrs[name], "approve", name)
			rst(name)
			core.close_formspec(name, FORMNAME)
			return
		elseif fields.decline then
			essentials.appdec_report(idrs[name], "decline", name)
			rst(name)
			core.close_formspec(name, FORMNAME)
			return
		end
		core.show_formspec(name, FORMNAME, formspec)
	end
end)