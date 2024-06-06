local FORMNAME = "essentials:report_admin"

function show_report_menu(name)
	local ids = ""
	for i, player in ipairs(minetest.get_connected_players()) do
		local namepl = player:get_player_name()
		--if not namepl == name then
			if i == 1 then
				ids = ids..namepl
			else
				ids = ids..","..namepl
			end
		--end
	end
	minetest.chat_send_player(name, ids)

	local formspec = "formspec_version[6]"..
	"size[10.5,10.2]"..
	"dropdown[3.1,2.4;6.4,0.6;report;"..ids..";1;false]"..
	"label[3.9,0.4;Report the player]"..
	"label[0.8,2.7;Report player:]"..
	"textarea[0.8,3.7;8.7,5.3;description;Description to report;]"..
	"button[0.8,9.2;8.7,0.8;send;Send report]"..
	"field[0.8,1.3;8.7,0.8;broked_rule;Broken rule;]"
	minetest.show_formspec(name, FORMNAME, formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local name = player:get_player_name()
	if formname ~= FORMNAME then
		return
	end
	minetest.sound_play("clicked", {to_player = name})
    
	minetest.chat_send_player(name, dump(fields))

	if fields.send then
		if fields.broked_rule == "" or fields.description == "" then
			minetest.sound_play("error", name)
			return
		end

		if fields.report == name then
			minetest.chat_send_player(name, core.colorize("red", "Cant report yourself."))
			minetest.sound_play("error", name)
			return
		end
		
		essentials.add_report(broked_rule, name, report, description)
	end
	return
end)