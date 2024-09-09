local S = essentials.translate
local FORMNAME = "essentials:ban_menu"

function show_ban_menu(name)
	local formspec = "formspec_version[6]"
	local ids = ""
	for _, player in ipairs(minetest.get_connected_players()) do
		ids = ids..","..player:get_player_name()
	end

	formspec = formspec..
        "size[12.5,4.5]"..
		"dropdown[4.5,0.3;6.8,1.1;player;"..ids..";1;false]"..
        "field[4.5,2;6.8,1.1;reason;"..S("Reason of ban")..";]"..
        "button[4.5,3.3;6.8,1.1;ban_btn;"..S("Ban the player").."]"..
        "image[0.2,0.2;4.2,4.2;essentials_ban_user.png]"..
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

    if fields.ban_btn then
        local player_banned = fields.player
        local reason_ban = fields.reason
        if core.is_singleplayer() then
            minetest.chat_send_player(name, core.colorize("red", S("You cannot ban in single mode!")))
            minetest.sound_play("error", name)
        elseif not player_ban then
            minetest.chat_send_player(name, core.colorize("red", S("Player not found!")))
            minetest.sound_play("error", name)
        elseif reason_ban == "" then
            core.ban_player(fields.player)
            core.chat_send_all("Banned "..player_banned..".")
            for _, player in ipairs(minetest.get_connected_players()) do
                minetest.sound_play("error", player:get_player_name())
            end
        else
            core.ban_player(fields.player)
            core.chat_send_all("Banned "..player_banned.." for "..reason_ban..".")
            for _, player in ipairs(minetest.get_connected_players()) do
                minetest.sound_play("error", player:get_player_name())
            end
        end
    end
	return
end)