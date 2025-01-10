local S = essentials.translate
local FORMNAME = "essentials:report"

function essentials.show_report_menu(name)
	local ids = ""
	for i, player in ipairs(core.get_connected_players()) do
		local n = player:get_player_name()
		ids = ids..","..n
	end

		local formspec = "formspec_version[6]"..
		"size[10.5,10.2]"..
		"dropdown[3.1,2.4;6.4,0.6;reporting;"..ids..";1;false]"..
		"label[3.9,0.4;"..S("Report the player").."]"..
		"label[0.8,2.7;"..S("Player:").."]"..
		"textarea[0.8,3.7;8.7,5.3;description;"..S("Description to report")..";]"..
		"button[0.8,9.2;8.7,0.8;send;"..S("Send report").."]"..
		"field[0.8,1.3;8.7,0.8;broked_rule;"..S("Broken rule")..";]"

	core.show_formspec(name, FORMNAME, formspec)
end

core.register_on_player_receive_fields(function(player, formname, fields)
	local name = player:get_player_name()
	if formname ~= FORMNAME then
		return
	end
	essentials.player_sound("clicked", name)

	if fields.send then
		local reporting = fields.reporting
		local broked_rule = fields.broked_rule
		local description = fields.description

		if reporting == "" or (broked_rule == "" or description == "") then
			essentials.player_sound("error", name)
			return
		end

		if reporting == name then
			essentials.player_sound("error", name)
			core.chat_send_player(name, core.colorize("red", S("Cannot report yourself.")))
			return
		end

		essentials.add_report(broked_rule, name, reporting, description)
		core.chat_send_player(name, S("@1 has been reported!", reporting))
		essentials.player_sound("done", name)
		core.close_formspec(name, FORMNAME)
	end
end)