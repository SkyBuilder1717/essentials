<<<<<<< HEAD
local FORMNAME = "essentials:reports_log"

function show_reports_log(name)
	local ids = ""
	if not essentials_reports == nil then
		for i, name in ipairs(essentials_reports.log) do
			if i == 1 then
				ids = id..name
			else
				ids = ids..","..name
			end
		end
	end
	minetest.chat_send_player(name, ids)

	local formspec = "formspec_version[6]"..
	"size[10.5,11]"..
	"label[1.2,0.5;Reports log]"..
	"textlist[0.7,1;9.1,9.3;report_logger;"..ids..";1;false]"
	minetest.show_formspec(name, FORMNAME, formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end
	local name = player:get_player_name()
	minetest.sound_play("clicked", {to_player = name})
    
	--minetest.chat_send_player(name, dump(fields))
	return
=======
local FORMNAME = "essentials:reports_log"

function show_reports_log(name)
	local ids = ""
	if not essentials_reports == nil then
		for i, name in ipairs(essentials_reports.log) do
			if i == 1 then
				ids = id..name
			else
				ids = ids..","..name
			end
		end
	end
	minetest.chat_send_player(name, ids)

	local formspec = "formspec_version[6]"..
	"size[10.5,11]"..
	"label[1.2,0.5;Reports log]"..
	"textlist[0.7,1;9.1,9.3;report_logger;"..ids..";1;false]"
	minetest.show_formspec(name, FORMNAME, formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end
	local name = player:get_player_name()
	minetest.sound_play("clicked", {to_player = name})
    
	--minetest.chat_send_player(name, dump(fields))
	return
>>>>>>> 46b4032d79edf22a60b1f30c2835b9369e30fba1
end)