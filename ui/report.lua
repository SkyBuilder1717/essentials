local S = essentials.translate
local FORMNAME = "essentials:report"

function essentials.show_report_menu(name)
	local formspec = {
		"formspec_version[6]",
		"size[10.5,10.2]",
		"dropdown[3.1,2.4;6.4,0.6;reporting;", essentials.get_players(), ";1;false]",
		"label[3.9,0.4;", S("Report the player"), "]",
		"label[0.8,2.7;", S("Player:"), "]",
		"textarea[0.8,3.7;8.7,5.3;description;", S("Description to report"), ";]",
		"button[0.8,9.2;8.7,0.8;send;", S("Send report"), "]",
		"field[0.8,1.3;8.7,0.8;broken_rule;", S("Broken rule"), ";]"
	}

	core.show_formspec(name, FORMNAME, table.concat(formspec))
end

core.register_on_player_receive_fields(function(player, formname, fields)
	local name = player:get_player_name()
	if formname ~= FORMNAME then
		return
	end
	
	if fields.send then
		local reporting = fields.reporting
		local broken_rule = essentials.trim(fields.broken_rule, 32)
		local description = essentials.trim(fields.description, 512)

		if reporting == "" or (broken_rule == "" or description == "") then
			essentials.player_sound("error", name)
			return
		end

		if reporting == name then
			essentials.player_sound("error", name)
			core.chat_send_player(name, core.colorize("red", S("Cannot report yourself.")))
			return
		end

		essentials.add_report(broken_rule, name, reporting, description)
		core.chat_send_player(name, S("@1 has been reported!", reporting))
		core.log("action", name.." reported "..reporting..". (broken rule: "..broken_rule..")")
		essentials.player_sound("done", name)
		core.close_formspec(name, FORMNAME)
	end
end)