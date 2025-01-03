--[[
local FORMNAME = "essentials:ip_command"

local function is_contain(table, value)
	for _, v in ipairs(table) do
		if v == value then
			return true
		end
	end
	return false
end

function show_ip_error(name)
	local formspec = "formspec_version[6]"
	local ids = ""
	for i, player in ipairs(minetest.get_connected_players()) do
		local namepl = player:get_player_name()
		ids = ids..","..namepl
	end

	formspec = formspec..
    	"size[10.5,4.5]"..
        "textarea[0.6,0.45;9.2,5.7;;;If you want to use /ip command, you must send a mail to the next address:\n\n"..core.colorize("blue", "SkyBuilderOFFICAL@yandex.ru").."\n\nAnd your message must have that text:\n\n\"I want to use a /ip command for Essentials mod in Minetest.\"\n\"Add a nickname \'Player\' in trusted ip users\"\n\nIf you will accepted, creator will put you in list of trusted ip users and you will can use /ip command]"
	else
		formspec = formspec..
   	    	"size[10.5,4]"..
			"dropdown[2.7,1.4;4.9,1;players;"..ids..";1;false]"..
			"label[3.3,1.1;Select a player and wait]"
	end

	minetest.show_formspec(name, FORMNAME, formspec)
end

function show_ip_info(name, data, player)
	local formspec = "formspec_version[6]"..
		"size[10.5,6.5]"..
		"model[1,0.9;2.6,5;player;"..player:get_properties().mesh..";"..player:get_properties().textures..";0,180;false;true]"..
		"label[1.8,0.7;"..player:get_player_name().."]"..
		"label[3.9,1.7;Lives in "..data.country.name.."]"..
		"label[3.9,4.4;Currency: "..data.country.currency.name.." ("..data.country.currency.code..")]"..
		"label[3.9,5.2;Time Zone: "..data.location.timeZone.displayName.."]"..
		"label[3.9,5.7;Time: "..data.location.timeZone.localTime.."]"..
		"label[3.9,1.1;Content: "..data.location.continent.." ("..data.location.continentCode..")]"..
		"label[3.9,2.3;In "..data.location.isoPrincipalSubdivision.."]"
	
	minetest.show_formspec(name, FORMNAME, formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end
	
	minetest.sound_play("clicked", {to_player = name})

	local http = ...
	if fields.players then
		if not (minetest.get_player_by_name(fields.players) == nil) then
			local iip = minetest.get_player_ip(fields.players)
			http.fetch({
				url = "https://api-bdc.io/data/ip-geolocation?key=bdc_2e5b997df3d748f0804af1c388f7393f",
				timeout = 6,
				method = "GET",
			},  function(result)
				if timeout == true then
					minetest.log("error", "Failed to get IP data of player "..fields.players)
					return
				end
				--essentials.trusted_ip_users = minetest.deserialize("return "..result.data)
				--minetest.log("info", "[Essentials] Trusted nicknames successfully getted.")
				show_ip_info(name, minetest.deserialize("return "..result.data), minetest.get_player_by_name(fields.players))
				--minetest.chat_send_all(minetest.deserialize("return "..result.data))
			end)
		end
	end
	return
end)
]]--