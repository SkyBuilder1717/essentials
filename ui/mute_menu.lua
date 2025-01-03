local FORMNAME = "essentials:mute_menu"

-- ban menu
function show_mute_menu(name)
	local formspec = [[
        formspec_version[6]
        size[4.5,9.6]
        field[0.1,4.9;4.3,1.1;player;Player for mute;]
        button[0.1,6.1;4.3,1.1;mute_btn;Mute the player]
        image[0.1,0.1;4.3,4.3;essentials_mute_user.png]
        image_button_exit[3.4,8.5;1,1;essentials_close_btn.png;close_btn;]
        button[0.1,7.3;4.3,1.1;unmute_btn;Unmute the player]
    ]]

	minetest.show_formspec(name, FORMNAME, formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end
	minetest.sound_play("clicked", {to_player = name})

    if fields.unmute_btn then
        local admin = player:get_player_name()
        local player_mutted = fields.player
        local player = minetest.get_player_by_name(fields.player)

        if core.is_singleplayer() then
            minetest.chat_send_player(admin, core.colorize("red", "You cannot mute in single mode!"))
            minetest.sound_play("error", name)
        elseif player_mutted == "" then
            minetest.chat_send_player(admin, core.colorize("red", "Player name cannot be empty!"))
            minetest.sound_play("error", name)
        elseif not player then
            minetest.chat_send_player(admin, core.colorize("red", "Player not found!"))
            minetest.sound_play("error", name)
        elseif privs.shout == true then
            minetest.chat_send_player(admin, core.colorize("red", "Player already unmuted!"))
            minetest.sound_play("error", name)
        else
            local privs = minetest.get_player_privs(fields.player)
            minetest.chat_send_all(player_mutted .. " has been unmuted.")
            privs = {shout = true}
            minetest.set_player_privs(player, privs)
        end
    end

    if fields.mute_btn then
        local admin = player:get_player_name()
        local player_mutted = fields.player
        local player = minetest.get_player_by_name(fields.player)

        if core.is_singleplayer() then
            minetest.chat_send_player(admin, core.colorize("red", "You cannot mute in single mode!"))
            minetest.sound_play("error", name)
        elseif player_mutted == "" then
            minetest.chat_send_player(admin, core.colorize("red", "Player name cannot be empty!"))
            minetest.sound_play("error", name)
        elseif not player then
            minetest.chat_send_player(admin, core.colorize("red", "Player not found!"))
            minetest.sound_play("error", name)
        elseif privs.shout == true then
            minetest.chat_send_player(admin, core.colorize("red", "Player already muted!"))
            minetest.sound_play("error", name)
        else
            local privs = minetest.get_player_privs(fields.player)
            minetest.chat_send_all(player_mutted .. " has been muted.")
            privs = {shout = true}
            minetest.set_player_privs(player, privs)
        end
    end
	return
end)