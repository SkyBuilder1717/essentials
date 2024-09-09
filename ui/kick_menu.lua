local FORMNAME = "essentials:kick_menu"
local S = essentials.translate

function show_kick_menu(name)
	local formspec = "formspec_version[6]"
	local ids = ""
	for _, player in ipairs(minetest.get_connected_players()) do
		ids = ids..","..player:get_player_name()
	end

	formspec = formspec..
        "size[12.5,4.5]"..
		"dropdown[4.5,0.3;6.8,1.1;player;"..ids..";1;false]"..
        "field[4.5,2;6.8,1.1;reason;"..S("Reason of kick")..";]"..
        "button[4.5,3.3;6.8,1.1;kick_btn;"..S("Kick the player").."]"..
        "image[0.2,0.2;4.2,4.2;essentials_kick_user.png]"..
        "image_button_exit[11.4,0.1;1,1;essentials_close_btn.png;close_btn;]"

	minetest.show_formspec(name, FORMNAME, formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end
    local name = player:get_player_name()
    minetest.sound_play("clicked", name)

    if (fields.player == nil) or (fields.player == "") then
        return
    end
    if minetest.get_player_by_name(fields.player) == nil then
        return
    end
    local player_ban = minetest.get_player_by_name(fields.player)

    if fields.kick_btn then
        local player_banned = fields.player
        local reason_kick = fields.reason
        if core.is_singleplayer() then
            minetest.chat_send_player(name, core.colorize("red", S("You cannot kick in single mode!")))
            minetest.sound_play("error", name)
        elseif not player_ban then
            minetest.chat_send_player(name, core.colorize("red", S("Player not found!")))
            minetest.sound_play("error", name)
        elseif reason_kick == "" then
            core.kick_player(fields.player)
            core.chat_send_all(S("Kicked @1.", player_banned))
            for _, player in ipairs(minetest.get_connected_players()) do
                minetest.sound_play("kicked", player:get_player_name())
            end
        else
            core.kick_player(fields.player, fields.reason)
            core.chat_send_all(S("Kicked @1 for '@2'.", player_banned, reason_kick))
            for _, player in ipairs(minetest.get_connected_players()) do
                minetest.sound_play("kicked", player:get_player_name())
            end
        end
    end
	return
end)