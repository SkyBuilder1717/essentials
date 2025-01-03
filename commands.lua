<<<<<<< HEAD
local http = ...
local enable_damage = core.settings:get_bool("enable_damage")
local speeds = {}
local S = essentials.translate

local FORMNAME = "essentials:ip_command"

local function is_contain(table, value)
	for _, v in ipairs(table) do
		if v == value then
			return true
		end
	end
	return false
end

local function show_ip_error(name)
    local text = S("If you want to use /ip command, you must send a mail to the next address:@1SkyBuilderOFFICAL@yandex.ru@2And your message must have that text:@3@4@5If you will accepted, creator will put you in list of trusted ip users and you will can use /ip command", "\n\n", "\n\n", "\n\n", "\"I want to use a /ip command for Essentials mod in Minetest.\"\n\"Add a nickname \'Player\' in trusted ip users\"", "\n\n")
	--minetest.chat_send_player(name, text)
    local formspec = "formspec_version[6]"
    formspec = formspec..
        "size[10.5,4.5]"..
        "textarea[0.6,0.45;9.2,5.7;;;"..text.."]"

	minetest.show_formspec(name, "essentials:ip_command", formspec)
end

local function delete_value_arr(table, value)
    local tbl = {}
    local j = 1
    for i = 1, #table do
        if table[i] ~= value then
            tbl[j] = table[i]
            j = j+1
        end
    end
    table = tbl
end

local function speed_cmd(name, param)
    local speed = string.match(param, "([^ ]+)") or 1
    local oname = string.match(param, speed.." (.+)")
    if oname == nil then
        core.chat_send_player(name, S("Your speed now is @1.", speed))
        minetest.sound_play("done", name)
        minetest.get_player_by_name(name):set_physics_override({
            speed = tonumber(speed)
        })
    else
        if minetest.get_player_by_name(oname) == nil then
            minetest.sound_play("error", name)
            return false, core.colorize("red", S("Please, specify an online player."))
        end
        core.chat_send_player(name, S("Speed of player @1 now is @2.", oname, speed))
        minetest.sound_play("done", name)
        minetest.sound_play("done", oname)
        if essentials.changed_by then
            minetest.chat_send_player(oname, S("Now your speed is @1 from player @2.", speed, name))
        end
        minetest.get_player_by_name(oname):set_physics_override({
            speed = tonumber(speed)
        })
    end
end

local function announcement_cmd(name, param)
    if param == "" then
        return false
    end
    if minetest.check_player_privs(name, {server=true}) then
        core.chat_send_all(core.colorize("#0006FF", S("[Announcement]")).." "..core.colorize("#00FFC6", param))
    else
        core.chat_send_all(core.colorize("#0006FF", S("[Announcement]")).." "..core.colorize("#00FFC6", param).." "..core.colorize("#82909D", S("(Announced by %s)", name)))
    end
    for _, player in ipairs(minetest.get_connected_players()) do
        minetest.sound_play("broadcast", player:get_player_name())
    end
end

local function biome_cmd(name, param)
    -- Thanks to @mckaygerhard on github for that part of script!
    if not minetest.has_feature("object_use_texture_alpha") then
        minetest.log("error", essentials.main.." Your Minetest Engine is deprecated! Update it for \'/biome\' command.")
        minetest.sound_play("error", name)
        return false, core.colorize("red", S("That version of engine doesnt support that command."))
    end

    local pos = minetest.get_player_by_name(name):get_pos()
    local biomeinfo = minetest.get_biome_data(pos)
    local biome = minetest.get_biome_name(biomeinfo.biome)
    if param == "" then
        core.chat_send_player(name, S("Biome")..": \"".. biome .."\"")
    else
        if minetest.check_player_privs(name, {debug=true}) then
            if param == "heat" then
                core.chat_send_player(name, "\"".. biome .."\": ".. biomeinfo.heat)
            elseif param == "humidity" then
                core.chat_send_player(name, "\"".. biome .."\": ".. biomeinfo.humidity)
            else
                minetest.sound_play("error", name)
                return false, core.colorize("red", S("Invalid information name!"))
            end
        else
            minetest.sound_play("error", name)
            return false, core.colorize("red", S("You cant check more information without privelege!"))
        end
    end
end

local function getpos_cmd(name, param)
    local player = minetest.get_player_by_name(param);
    if param == "" then
        minetest.sound_play("error", name)
        return false
    elseif minetest.get_player_by_name(param) == nil then
        minetest.sound_play("error", name)
        return false, core.colorize("red", S("Player @1 not found!", param))
    end
    local pos = player:get_pos();
    local round_pos = vector.round(pos);
    minetest.chat_send_player(name, S("Position of player @1 is @2 @3 @4.", param, core.colorize("#ff0000", " X:"..round_pos.x), core.colorize("#00ff00", " Y:"..round_pos.y), core.colorize("#0000ff", " Z:"..round_pos.z)))
    minetest.sound_play("done", name)
end

local function seed_cmd(name, param)
    core.chat_send_player(name, S("Seed: [@1]", core.colorize("#00ff00", minetest.get_mapgen_setting("seed"))))
end

local function godmode_cmd(name, param)
    if enable_damage then
        local player
        if param == "" then
            player = minetest.get_player_by_name(name)
        else
            player = minetest.get_player_by_name(param)
        end
        if player == nil then
            core.chat_send_player(name, core.colorize("red", S("Player @1 not found.", param)))
            minetest.sound_play("error", name)
            return
        end
        local ag = player:get_armor_groups()
        if not ag["immortal"] then
            ag["immortal"] = 1
            if param == "" then
                core.chat_send_player(name, core.colorize("yellow", S("God mode enabled.")))
                minetest.sound_play("request", name)
            else
                core.chat_send_player(name, S("God mode enabled for @1.", param))
                core.chat_send_player(param, S("For you enabled god mode from @1.", name))
                minetest.sound_play("request", param)
                minetest.sound_play("done", name)
            end
        else
            ag["immortal"] = nil
            if param == "" then
                core.chat_send_player(name, core.colorize("yellow", S("God mode disabled.")))
                minetest.sound_play("disabled", name)
            else
                core.chat_send_player(name, S("God mode disabled for @1.", param))
                core.chat_send_player(param, S("For you god mode has been disabled by @1.", name))
                minetest.sound_play("disabled", param)
                minetest.sound_play("done", name)
            end
        end
        player:set_armor_groups(ag)
    else
        minetest.sound_play("error", name)
        return false, core.colorize("red", S("@1 is disabled!", "\"enable_damage\""))
    end
end

local function kill_cmd(name, param)
    if minetest.settings:get_bool("enable_damage") then
        if param == "" or param == nil then
            minetest.get_player_by_name(name):set_hp(0)
        else
            if minetest.get_player_by_name(param) == nil then
                core.chat_send_player(name, core.colorize("red", S("Player @1 not found!", param)))
                minetest.sound_play("error", name)
                return
            end
            minetest.get_player_by_name(param):set_hp(0)
            core.chat_send_player(name, S("You killed player @1.", param))
            minetest.sound_play("done", name)
            if essentials.killed_by then
                core.chat_send_player(param, S("You has been killed by player @1.", name))
                minetest.sound_play("error", param)
            end
        end
    else
        local player = minetest.get_player_by_name(name)
        if param then
            player = minetest.get_player_by_name(param)
            if minetest.get_player_by_name(param) == nil then
                minetest.sound_play("error", name)
                return false, core.colorize("red", S("Player @1 not found!", param))
            end
            core.chat_send_player(name, S("You respawned player @1.", param))
            minetest.sound_play("done", name)
            if essentials.killed_by then
                core.chat_send_player(param, S("You has been respawned by player @1.", name))
                minetest.sound_play("error", param)
            end
        end
        for _, callback in pairs(minetest.registered_on_respawnplayers) do
            if callback(player) then
                return true
            end
        end
        return false, "No static_spawnpoint defined"
    end
end

local function heal_cmd(name, param)
    if param == "" or param == nil then
        minetest.get_player_by_name(name):set_hp(minetest.PLAYER_MAX_HP_DEFAULT)
        core.chat_send_player(name, S("You has been healed to the possible max health."))
    else
        if minetest.get_player_by_name(param) == nil then
            minetest.sound_play("error", name)
            return false, core.colorize("red", S("Player @1 not found!", param))
        end
        minetest.get_player_by_name(param):set_hp(minetest.PLAYER_MAX_HP_DEFAULT)
        core.chat_send_player(name, S("Player @1 healed to the @2 health.", param, minetest.get_player_by_name(param):get_hp()))
        minetest.sound_play("done", name)
        if essentials.changed_by then
            core.chat_send_player(param, S("You has been fully healed by @1.", name))
            minetest.sound_play("done", param)
        end
    end
end

local function check_moderator(name)
    if (not is_contain(essentials.moderators, name)) or (not minetest.check_player_privs(name, {server=true})) then
        return true
    else
        return false
    end
end

local function maintenance_cmd(name, param)
    if minetest.is_singleplayer() then
        minetest.sound_play("error", param)
        return false, core.colorize("red", S("Cannot interact with maintenance mode in singleplayer!"))
    end
    minetest.sound_play("done", param)
    if essentials.maintenance then
        essentials.maintenance = false
        minetest.chat_send_player(name, core.colorize("lightgrey", S("Maintenance mode has been disabled!")))
    else
        essentials.maintenance = true
        minetest.chat_send_player(name, core.colorize("grey", S("Maintenance mode has been enabled!")))
    end
end

minetest.register_globalstep(function(dtime)
    if essentials.maintenance then
        for _, player in ipairs(minetest.get_connected_players()) do
            local name = player:get_player_name()
            if check_moderator(name) then
                minetest.kick_player(name, essentials.maintenance_msg)
            end
        end
    end
end)

minetest.register_on_prejoinplayer(function(name)
    if essentials.maintenance and check_moderator(name) then
        return essentials.maintenance_msg
    end
end)

local function vanish_cmd(name, param)
    local player
    local other = false
    if param == "" or param == nil then
        player = minetest.get_player_by_name(name)
    else
        player = minetest.get_player_by_name(param)
        if player == nil then
            minetest.sound_play("error", name)
            return false, core.colorize("red", S("Player @1 not found!", param))
        end
        other = true
    end
    local prop
    local vis = player:get_meta():get_int("invisible")
    if vis == nil or vis == 0 then
        player:get_meta():set_int("invisible", 1)
        prop = {
            visual_size = {x = 0, y = 0, z = 0},
            is_visible = false,
            nametag_color = {r=0,g=0,b=0,a=0},
            pointable = false,
            makes_footstep_sound = false,
            show_on_minimap = false,
        }
        if other then
            core.chat_send_player(name, core.colorize("#00ff00", S("Player @1 now is invisible.", param)))
            minetest.sound_play("done", name)
            if essentials.changed_by then
                core.chat_send_player(param, core.colorize("#E6E6E6", S("Now you are invisible from player @1.", name)))
                minetest.sound_play("done", param)
            end
        else
            core.chat_send_player(name, core.colorize("#E6E6E6", S("Now you are invisible.")))
            minetest.sound_play("done", name)
        end
    else
        player:get_meta():set_int("invisible", 0)
        prop = {
            visual_size = {x = 1, y = 1, z = 1},
            is_visible = true,
            nametag_color = {r=255,g=255,b=255,a=255},
            pointable = true,
            makes_footstep_sound = true,
            show_on_minimap = true,
        }
        if other then
            core.chat_send_player(name, core.colorize("#00ff00s", S("Now player @1 is visible again.", param)))
            minetest.sound_play("done", name)
            if essentials.changed_by then
                core.chat_send_player(param, S("Now you visible again from player @1.", name))
                minetest.sound_play("done", param)
            end
        else
            core.chat_send_player(name, S("Now you are visible again."))
            minetest.sound_play("done", name)
        end
    end
    player:set_properties(prop)
    --core.chat_send_player(name, dump(vis))
end

local function troll_cmd(name, param)
    if core.is_singleplayer() then
        minetest.sound_play("error", name)
        return false, core.colorize("red", S("You cant troll in single mode!"))
    end
    show_troll_menu(name)
end

local function ip_cmd(name, param)
    --[[
    if not is_contain(essentials.trusted_ip_users, name) then
        minetest.chat_send_player(name, core.colorize("red", S("You are not of trusted administrator!")))
        minetest.sound_play("error", name)
        show_ip_error(name)
        return
        -- \/ deprecated \/ --
        --show_ip_info(name)
    end
    ]]--
    if param == "" then
        minetest.chat_send_player(name, S("Your IP address is @1", minetest.get_player_ip(name)))
        return
    end
    if minetest.get_player_by_name(param) == nil then
        minetest.sound_play("error", name)
        return false, core.colorize("red", S("Player @1 not found!", param))
    end

    minetest.chat_send_player(name, S("IP address of @1 is @2", param, minetest.get_player_ip(param)))

    --[[ 
        -- TODO: Make the "/ip" command more manageable
      show_ip_error(name)
    ]]--
end

local function call_cmd(name, param, status)
    if status == "request" then
        if minetest.get_player_by_name(param) == nil then
            minetest.sound_play("error", name)
            return false, core.colorize("red", S("Player @1 not found!", param))
        end
        if param == name then
            minetest.sound_play("error", name)
            return false, core.colorize("red", S("Cant send teleport request to yourself!"))
        end
        essentials.teleport_requests[param] = {}
        local player = minetest.get_player_by_name(param)
        table.insert(essentials.teleport_requests[param], name)
        core.chat_send_player(name, core.colorize("#dbdbdb", S("Calls teleport request to player @1.", param)).." "..core.colorize("red", S("In @1 seconds it will expire.", essentials.teleport_request_expire)))
        core.chat_send_player(param, core.colorize("#C2c2c2", S("Player @1 calls to you a teleportation. Request will expire in @2 seconds.", name, essentials.teleport_request_expire)))
        core.chat_send_player(param, core.colorize("#C2c2c2", S("@1 to accept request. @2 to decline request.", core.colorize("#00ff00", "/tpaccept"), core.colorize("#ff0000", "/tpdecline"))))
        minetest.sound_play("done", name)
        minetest.sound_play("request", param)
        minetest.after(essentials.teleport_request_expire, function()
            if is_contain(essentials.teleport_requests[param], name) then
                core.chat_send_player(param, core.colorize("#c2c2c2", S("Teleportation request from @1 has been expired.", name)))
                core.chat_send_player(name, core.colorize("#ff0000", S("Teleportation request to player @1 has been expired.", param)))
                minetest.sound_play("disable", param)
                minetest.sound_play("error", name)
                delete_value_arr(essentials.teleport_requests[param], name)
            end
        end)
    else
        if (essentials.teleport_requests[name] == {}) or (essentials.teleport_requests[name] == nil) then
            minetest.sound_play("error", name)
            return false, core.colorize("red", S("You dont have any teleport request."))
        end
        local player = minetest.get_player_by_name(name)
        local string = ""
        if status == "accept" then
            local pos = player:get_pos()
            for i, plname in ipairs(essentials.teleport_requests[name]) do
                if minetest.get_player_by_name(plname) == nil then
                    return
                end
                local oplayer = minetest.get_player_by_name(plname)
                core.chat_send_player(plname, core.colorize("#00ff00", S("Your teleport request to player @1 is accepted!", name)))
                oplayer:set_pos(pos)
                if i == 1 then
                    string = string..plname
                else
                    string = string..", "..plname
                end
                minetest.sound_play("done", plname)
            end
            core.chat_send_player(name, core.colorize("#dbdbdb", S("Requests from player(-s) @1 has been accepted.", string)))
        elseif status == "decline" then
            for i, plname in ipairs(essentials.teleport_requests[name]) do
                if minetest.get_player_by_name(plname) == nil then
                    return
                end
                local oplayer = minetest.get_player_by_name(plname)
                core.chat_send_player(plname, core.colorize("00ff00", S("Your teleport request to player @1 has been declined!", name)))
                delete_value_arr(essentials.teleport_requests[name], plname)
                if i == 1 then
                    string = string..plname
                else
                    string = string..", "..plname
                end
                minetest.sound_play("done", plname)
            end
            core.chat_send_player(name, core.colorize("#ff0000", S("Requests from player(-s) @1 has been declined.", string)))
        end
        minetest.sound_play("done", name)
        essentials.teleport_requests[name] = {}
    end
end

if essentials.enable_ip_cmd then
    if http then
        if essentials.add_privs and is_contain(essentials.add_privs_list, "ip") then
            minetest.register_chatcommand("ip", {
                params = "[<name>]",
                description = S("Show the IP of a player."),
                privs = {server = true},
                func = ip_cmd,
            })
        else
            minetest.register_chatcommand("ip", {
                params = "[<name>]",
                description = S("Show the IP of a player."),
                privs = {ip = true},
                func = ip_cmd,
            })
        end
    else
        minetest.log("error", "Cant register \'ip\' command because of http is empty.")
    end
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "broadcast") then
    minetest.register_chatcommand("broadcast", {
        params = "<message>",
        description = S("Send GLOBAL message in chat."),
        privs = {broadcast = true},
        func = announcement_cmd,
    })
else
    minetest.register_chatcommand("broadcast", {
        params = "<message>",
        description = S("Send GLOBAL message in chat."),
        privs = {bring = true},
        func = announcement_cmd,
    })
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "speed") then
    minetest.register_chatcommand("speed", {
        params = "<speed> [<player>]",
        description = S("Sets a speed for an any player. (Standart speed is 1)"),
        privs = {speed = true},
        func = speed_cmd,
    })
else
    minetest.register_chatcommand("speed", {
        params = "<speed> [<player>]",
        description = S("Sets a speed for an any player. (Standart speed is 1)"),
        privs = {rollback = true},
        func = speed_cmd,
    })
end

if essentials.add_privs then
    if essentials.biome then
        minetest.register_chatcommand("biome", {
            params = "[<info_name>]",
            description = S("Shows the current biome information you are in."),
            func = biome_cmd,
        })
    elseif is_contain(essentials.add_privs_list, "biome") then 
        minetest.register_chatcommand("biome", {
            params = "[<info_name>]",
            privs = {biome = true},
            description = S("Shows the current biome information you are in."),
            func = biome_cmd,
        })
    end
else
    if essentials.biome then
        minetest.register_chatcommand("biome", {
            params = "[<info_name>]",
            description = S("Shows the current biome information you are in."),
            func = biome_cmd,
        })
    else
        minetest.register_chatcommand("biome", {
            params = "[<info_name>]",
            privs = {rollback = true},
            description = S("Shows the current biome information you are in."),
            func = biome_cmd,
        })
    end
end

--minetest.get_mapgen_object
if essentials.add_privs then
    if essentials.seed then
        minetest.register_chatcommand("seed", {
            description = S("Shows the seed of mapgen."),
            func = seed_cmd,
        })
    elseif is_contain(essentials.add_privs_list, "seed") then 
        minetest.register_chatcommand("seed", {
            privs = {seed = true},
            description = S("Shows the seed of mapgen."),
            func = seed_cmd,
        })
    end
else
    if essentials.seed then
        minetest.register_chatcommand("seed", {
            description = S("Shows the seed of mapgen."),
            func = seed_cmd,
        })
    else
        minetest.register_chatcommand("seed", {
            privs = {rollback = true},
            description = S("Shows the seed of mapgen."),
            func = seed_cmd,
        })
    end
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "god_mode") then
    minetest.register_chatcommand("god", {
        params = "[<name>]",
        description = S("Enable/Disabe the god mode."),
        privs = {god_mode = true},
        func = godmode_cmd
    })
else
    minetest.register_chatcommand("god", {
        params = "[<name>]",
        description = S("Enable/Disabe the god mode."),
        privs = {noclip = true},
        func = godmode_cmd
    })
end

minetest.register_chatcommand("ban_menu", {
    description = S("Opens an ban menu."),
    privs = {ban = true},
    func = function(name, param)
        if core.is_singleplayer() then
            minetest.chat_send_player(name, core.colorize("red", S("You cannot ban in single mode!")))
            minetest.sound_play("error", name)
            return
        end
        show_ban_menu(name)
    end
})

minetest.register_chatcommand("kick_menu", {
    description = S("Opens a kick menu."),
    privs = {kick = true},
    func = function(name, param)
        if core.is_singleplayer() then
            minetest.chat_send_player(name, core.colorize("red", S("You cannot kick in single mode!")))
            minetest.sound_play("error", name)
            return
        end
        show_kick_menu(name)
    end
})

-- not working or scrapped bullshit
--[[
minetest.register_chatcommand("password", {
    privs = {password = true},
    params = "<name>",
    description = S("Shows the password of the authorized player."),
    func = password_cmd,
})

minetest.register_chatcommand("mute_menu", {
   description = S("Open the mute menu.",
   privs = {mute = true},
   func = function(name, param)
       if core.is_singleplayer() then
           minetest.chat_send_player(name, core.colorize("red", "You cannot mute in single mode!"))
       else
           show_mute_menu(name)
       end
   end
})
]]--

if essentials.reports_system then
    minetest.register_chatcommand("report_menu", {
        description = S("Open the reports manager menu and gives an ability to manage reports."),
        privs = {server = true},
        func = function(name, param)
            if core.is_singleplayer() then
                minetest.sound_play("error", name)
                return false, core.colorize("red", S("You cannot report in single mode!"))
            end
            show_report_manage(name)
        end
    })
    minetest.register_chatcommand("report", {
        description = S("Open the reports menu for reporting an player."),
        privs = {shout = true},
        func = function(name, param)
            if core.is_singleplayer() then
                minetest.sound_play("error", name)
                return false, core.colorize("red", S("You cannot report in single mode!"))
            end
            show_report_menu(name)
        end
    })
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "rename_player") then
    minetest.register_chatcommand("rename_me", {
        description = S("Shows the rename menu."),
        privs = {rename_player = true},
        func = function(name, param)
            show_rename_menu(name)
        end
    })
else
    minetest.register_chatcommand("rename_me", {
        description = S("Shows the rename menu."),
        privs = {kick = true},
        func = function(name, param)
            show_rename_menu(name)
        end
    })
end

if essentials.enable_troll_cmd then
    if essentials.add_privs and is_contain(essentials.add_privs_list, "troll") then
        minetest.register_chatcommand("troll", {
            description = S("Open the trolls menu."),
            privs = {troll = true},
            func = troll_cmd,
        })
    else
        minetest.register_chatcommand("troll", {
            description = S("Open the trolls menu."),
            privs = {ban = true},
            func = troll_cmd,
        })
    end
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "get_pos") then
    minetest.register_chatcommand("getpos", {
        params = "<name>",
        description = S("Gets the position of another player."),
        privs = {get_pos = true},
        func = getpos_cmd,
    })
else
    minetest.register_chatcommand("getpos", {
        params = "<name>",
        description = S("Gets the position of another player."),
        privs = {teleport = true},
        func = getpos_cmd,
    })
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "rename_item") then
    minetest.register_chatcommand("rename_item", {
        description = S("Hold item in hand and open this menu for renaming it."),
        privs = {rename_item = true},
        func = function(name, param)
            show_renameitem_menu(name)
        end
    })
else
    minetest.register_chatcommand("rename_item", {
        description = S("Hold item in hand and open this menu for renaming it."),
        privs = {basic_privs = true},
        func = function(name, param)
            show_renameitem_menu(name)
        end
    })
end

--[[
if essentials.add_privs then
    minetest.register_chatcommand("color", {
        description = S("Shows menu for coloring nickname.",
        privs = {colored_nickname = true},
        func = function(name, param)
            show_color_menu(name)
        end
    })
else
    minetest.register_chatcommand("color", {
        description = S("Shows menu for coloring nickname.",
        privs = {kick = true},
        func = function(name, param)
            show_color_menu(name)
        end
    })
end
]]--

if essentials.add_privs and is_contain(essentials.add_privs_list, "kill") then
    minetest.register_chatcommand("kill", {
        params = "[<name>]",
        description = S("Kill anyone with command."),
        privs = {kill = true},
        func = kill_cmd,
    })
else
    minetest.register_chatcommand("kill", {
        params = "[<name>]",
        description = S("Kill anyone with command."),
        privs = {protection_bypass = true},
        func = kill_cmd,
    })
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "heal") then
    minetest.register_chatcommand("heal", {
        params = "[<name>]",
        description = S("Heals full health for a player."),
        privs = {heal = true},
        func = heal_cmd,
    })
else
    minetest.register_chatcommand("heal", {
        params = "[<name>]",
        description = S("Heals full health for a player."),
        privs = {rollback = true},
        func = heal_cmd,
    })
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "maintenance") then
    minetest.register_chatcommand("maintenance", {
        description = S("Enables and Disables maintenance mode on server."),
        privs = {maintenance = true},
        func = maintenance_cmd,
    })
else
    minetest.register_chatcommand("maintenance", {
        description = S("Enables and Disables maintenance mode on server."),
        privs = {server = true},
        func = maintenance_cmd,
    })
end

minetest.register_on_joinplayer(function(ObjectRef, last_login)
    ObjectRef:get_meta():set_int("invisible", 0)
end)

if essentials.add_privs and is_contain(essentials.add_privs_list, "invisible") then
    minetest.register_chatcommand("v", {
        params = "[<name>]",
        description = S("Makes player invisible."),
        privs = {invisible = true},
        func = vanish_cmd,
    })
else
    minetest.register_chatcommand("v", {
        params = "[<name>]",
        description = S("Makes player invisible."),
        privs = {server = true},
        func = vanish_cmd,
    })
end

-- Thanks to Bapt-tech for idea!
-- https://i.imgur.com/zVCmNOT.png
minetest.register_chatcommand("text_box", {
    description = S("Shows to any player a textbox with a text!"),
    privs = {ban = true},
    func = function(name, param)
        show_textbox_admin(name)
    end
})

if essentials.add_privs and is_contain(essentials.add_privs_list, "call") then
    minetest.register_chatcommand("call", {
        params = "<name>",
        description = S("Sends request to teleportation for player."),
        privs = {call = true},
        func = function(name, param)
            call_cmd(name, param, "request")
        end
    })
    minetest.register_chatcommand("tpaccept", {
        description = S("Accepting teleportation requests from players."),
        privs = {call = true},
        func = function(name, param)
            call_cmd(name, param, "accept")
        end
    })
    minetest.register_chatcommand("tpdecline", {
        description = S("Declining teleportation requests from players."),
        privs = {call = true},
        func = function(name, param)
            call_cmd(name, param, "decline")
        end
    })
elseif minetest.get_modpath("sethome") then
    minetest.register_chatcommand("call", {
        params = "<name>",
        description = S("Sends request to teleportation for player."),
        privs = {home = true},
        func = function(name, param)
            call_cmd(name, param, "request")
        end
    })
    minetest.register_chatcommand("tpaccept", {
        description = S("Accepting teleportation requests from players."),
        privs = {home = true},
        func = function(name, param)
            call_cmd(name, param, "accept")
        end
    })
    minetest.register_chatcommand("tpdecline", {
        description = S("Declining teleportation requests from players."),
        privs = {home = true},
        func = function(name, param)
            call_cmd(name, param, "decline")
        end
    })
else
    minetest.log("error", "'/call', '/tpaccept', '/tpdecline' commands is didnt be added. Because You dont have 'sethome' mod or 'call' privilege in the game")
=======
local http = ...
local enable_damage = core.settings:get_bool("enable_damage")
local speeds = {}
local S = essentials.translate

local FORMNAME = "essentials:ip_command"

local function is_contain(table, value)
	for _, v in ipairs(table) do
		if v == value then
			return true
		end
	end
	return false
end

local function show_ip_error(name)
    local text = S("If you want to use /ip command, you must send a mail to the next address:@1SkyBuilderOFFICAL@yandex.ru@2And your message must have that text:@3@4@5If you will accepted, creator will put you in list of trusted ip users and you will can use /ip command", "\n\n", "\n\n", "\n\n", "\"I want to use a /ip command for Essentials mod in Minetest.\"\n\"Add a nickname \'Player\' in trusted ip users\"", "\n\n")
	--minetest.chat_send_player(name, text)
    local formspec = "formspec_version[6]"
    formspec = formspec..
        "size[10.5,4.5]"..
        "textarea[0.6,0.45;9.2,5.7;;;"..text.."]"

	minetest.show_formspec(name, "essentials:ip_command", formspec)
end

local function delete_value_arr(table, value)
    local tbl = {}
    local j = 1
    for i = 1, #table do
        if table[i] ~= value then
            tbl[j] = table[i]
            j = j+1
        end
    end
    table = tbl
end

local function speed_cmd(name, param)
    local speed = string.match(param, "([^ ]+)") or 1
    local oname = string.match(param, speed.." (.+)")
    if oname == nil then
        core.chat_send_player(name, S("Your speed now is @1.", speed))
        minetest.sound_play("done", name)
        minetest.get_player_by_name(name):set_physics_override({
            speed = tonumber(speed)
        })
    else
        if minetest.get_player_by_name(oname) == nil then
            minetest.sound_play("error", name)
            return false, core.colorize("red", S("Please, specify an online player."))
        end
        core.chat_send_player(name, S("Speed of player @1 now is @2.", oname, speed))
        minetest.sound_play("done", name)
        minetest.sound_play("done", oname)
        if essentials.changed_by then
            minetest.chat_send_player(oname, S("Now your speed is @1 from player @2.", speed, name))
        end
        minetest.get_player_by_name(oname):set_physics_override({
            speed = tonumber(speed)
        })
    end
end

local function announcement_cmd(name, param)
    if param == "" then
        return false
    end
    if minetest.check_player_privs(name, {server=true}) then
        core.chat_send_all(core.colorize("#0006FF", S("[Announcement]")).." "..core.colorize("#00FFC6", param))
    else
        core.chat_send_all(core.colorize("#0006FF", S("[Announcement]")).." "..core.colorize("#00FFC6", param).." "..core.colorize("#82909D", S("(Announced by %s)", name)))
    end
    for _, player in ipairs(minetest.get_connected_players()) do
        minetest.sound_play("broadcast", player:get_player_name())
    end
end

local function biome_cmd(name, param)
    -- Thanks to @mckaygerhard on github for that part of script!
    if not minetest.has_feature("object_use_texture_alpha") then
        minetest.log("error", essentials.main.." Your Minetest Engine is deprecated! Update it for \'/biome\' command.")
        minetest.sound_play("error", name)
        return false, core.colorize("red", S("That version of engine doesnt support that command."))
    end

    local pos = minetest.get_player_by_name(name):get_pos()
    local biomeinfo = minetest.get_biome_data(pos)
    local biome = minetest.get_biome_name(biomeinfo.biome)
    if param == "" then
        core.chat_send_player(name, S("Biome")..": \"".. biome .."\"")
    else
        if minetest.check_player_privs(name, {debug=true}) then
            if param == "heat" then
                core.chat_send_player(name, "\"".. biome .."\": ".. biomeinfo.heat)
            elseif param == "humidity" then
                core.chat_send_player(name, "\"".. biome .."\": ".. biomeinfo.humidity)
            else
                minetest.sound_play("error", name)
                return false, core.colorize("red", S("Invalid information name!"))
            end
        else
            minetest.sound_play("error", name)
            return false, core.colorize("red", S("You cant check more information without privelege!"))
        end
    end
end

local function getpos_cmd(name, param)
    local player = minetest.get_player_by_name(param);
    if param == "" then
        minetest.sound_play("error", name)
        return false
    elseif minetest.get_player_by_name(param) == nil then
        minetest.sound_play("error", name)
        return false, core.colorize("red", S("Player @1 not found!", param))
    end
    local pos = player:get_pos();
    local round_pos = vector.round(pos);
    minetest.chat_send_player(name, S("Position of player @1 is @2 @3 @4.", param, core.colorize("#ff0000", " X:"..round_pos.x), core.colorize("#00ff00", " Y:"..round_pos.y), core.colorize("#0000ff", " Z:"..round_pos.z)))
    minetest.sound_play("done", name)
end

local function seed_cmd(name, param)
    core.chat_send_player(name, S("Seed: [@1]", core.colorize("#00ff00", minetest.get_mapgen_setting("seed"))))
end

local function godmode_cmd(name, param)
    if enable_damage then
        local player
        if param == "" then
            player = minetest.get_player_by_name(name)
        else
            player = minetest.get_player_by_name(param)
        end
        if player == nil then
            core.chat_send_player(name, core.colorize("red", S("Player @1 not found.", param)))
            minetest.sound_play("error", name)
            return
        end
        local ag = player:get_armor_groups()
        if not ag["immortal"] then
            ag["immortal"] = 1
            if param == "" then
                core.chat_send_player(name, core.colorize("yellow", S("God mode enabled.")))
                minetest.sound_play("request", name)
            else
                core.chat_send_player(name, S("God mode enabled for @1.", param))
                core.chat_send_player(param, S("For you enabled god mode from @1.", name))
                minetest.sound_play("request", param)
                minetest.sound_play("done", name)
            end
        else
            ag["immortal"] = nil
            if param == "" then
                core.chat_send_player(name, core.colorize("yellow", S("God mode disabled.")))
                minetest.sound_play("disabled", name)
            else
                core.chat_send_player(name, S("God mode disabled for @1.", param))
                core.chat_send_player(param, S("For you god mode has been disabled by @1.", name))
                minetest.sound_play("disabled", param)
                minetest.sound_play("done", name)
            end
        end
        player:set_armor_groups(ag)
    else
        minetest.sound_play("error", name)
        return false, core.colorize("red", S("@1 is disabled!", "\"enable_damage\""))
    end
end

local function kill_cmd(name, param)
    if minetest.settings:get_bool("enable_damage") then
        if param == "" or param == nil then
            minetest.get_player_by_name(name):set_hp(0)
        else
            if minetest.get_player_by_name(param) == nil then
                core.chat_send_player(name, core.colorize("red", S("Player @1 not found!", param)))
                minetest.sound_play("error", name)
                return
            end
            minetest.get_player_by_name(param):set_hp(0)
            core.chat_send_player(name, S("You killed player @1.", param))
            minetest.sound_play("done", name)
            if essentials.killed_by then
                core.chat_send_player(param, S("You has been killed by player @1.", name))
                minetest.sound_play("error", param)
            end
        end
    else
        local player = minetest.get_player_by_name(name)
        if param then
            player = minetest.get_player_by_name(param)
            if minetest.get_player_by_name(param) == nil then
                minetest.sound_play("error", name)
                return false, core.colorize("red", S("Player @1 not found!", param))
            end
            core.chat_send_player(name, S("You respawned player @1.", param))
            minetest.sound_play("done", name)
            if essentials.killed_by then
                core.chat_send_player(param, S("You has been respawned by player @1.", name))
                minetest.sound_play("error", param)
            end
        end
        for _, callback in pairs(minetest.registered_on_respawnplayers) do
            if callback(player) then
                return true
            end
        end
        return false, "No static_spawnpoint defined"
    end
end

local function heal_cmd(name, param)
    if param == "" or param == nil then
        minetest.get_player_by_name(name):set_hp(minetest.PLAYER_MAX_HP_DEFAULT)
        core.chat_send_player(name, S("You has been healed to the possible max health."))
    else
        if minetest.get_player_by_name(param) == nil then
            minetest.sound_play("error", name)
            return false, core.colorize("red", S("Player @1 not found!", param))
        end
        minetest.get_player_by_name(param):set_hp(minetest.PLAYER_MAX_HP_DEFAULT)
        core.chat_send_player(name, S("Player @1 healed to the @2 health.", param, minetest.get_player_by_name(param):get_hp()))
        minetest.sound_play("done", name)
        if essentials.changed_by then
            core.chat_send_player(param, S("You has been fully healed by @1.", name))
            minetest.sound_play("done", param)
        end
    end
end

local function check_moderator(name)
    if (not is_contain(essentials.moderators, name)) or (not minetest.check_player_privs(name, {server=true})) then
        return true
    else
        return false
    end
end

local function maintenance_cmd(name, param)
    if minetest.is_singleplayer() then
        minetest.sound_play("error", param)
        return false, core.colorize("red", S("Cannot interact with maintenance mode in singleplayer!"))
    end
    minetest.sound_play("done", param)
    if essentials.maintenance then
        essentials.maintenance = false
        minetest.chat_send_player(name, core.colorize("lightgrey", S("Maintenance mode has been disabled!")))
    else
        essentials.maintenance = true
        minetest.chat_send_player(name, core.colorize("grey", S("Maintenance mode has been enabled!")))
    end
end

minetest.register_globalstep(function(dtime)
    if essentials.maintenance then
        for _, player in ipairs(minetest.get_connected_players()) do
            local name = player:get_player_name()
            if check_moderator(name) then
                minetest.kick_player(name, essentials.maintenance_msg)
            end
        end
    end
end)

minetest.register_on_prejoinplayer(function(name)
    if essentials.maintenance and check_moderator(name) then
        return essentials.maintenance_msg
    end
end)

local function vanish_cmd(name, param)
    local player
    local other = false
    if param == "" or param == nil then
        player = minetest.get_player_by_name(name)
    else
        player = minetest.get_player_by_name(param)
        if player == nil then
            minetest.sound_play("error", name)
            return false, core.colorize("red", S("Player @1 not found!", param))
        end
        other = true
    end
    local prop
    local vis = player:get_meta():get_int("invisible")
    if vis == nil or vis == 0 then
        player:get_meta():set_int("invisible", 1)
        prop = {
            visual_size = {x = 0, y = 0, z = 0},
            is_visible = false,
            nametag_color = {r=0,g=0,b=0,a=0},
            pointable = false,
            makes_footstep_sound = false,
            show_on_minimap = false,
        }
        if other then
            core.chat_send_player(name, core.colorize("#00ff00", S("Player @1 now is invisible.", param)))
            minetest.sound_play("done", name)
            if essentials.changed_by then
                core.chat_send_player(param, core.colorize("#E6E6E6", S("Now you are invisible from player @1.", name)))
                minetest.sound_play("done", param)
            end
        else
            core.chat_send_player(name, core.colorize("#E6E6E6", S("Now you are invisible.")))
            minetest.sound_play("done", name)
        end
    else
        player:get_meta():set_int("invisible", 0)
        prop = {
            visual_size = {x = 1, y = 1, z = 1},
            is_visible = true,
            nametag_color = {r=255,g=255,b=255,a=255},
            pointable = true,
            makes_footstep_sound = true,
            show_on_minimap = true,
        }
        if other then
            core.chat_send_player(name, core.colorize("#00ff00s", S("Now player @1 is visible again.", param)))
            minetest.sound_play("done", name)
            if essentials.changed_by then
                core.chat_send_player(param, S("Now you visible again from player @1.", name))
                minetest.sound_play("done", param)
            end
        else
            core.chat_send_player(name, S("Now you are visible again."))
            minetest.sound_play("done", name)
        end
    end
    player:set_properties(prop)
    --core.chat_send_player(name, dump(vis))
end

local function troll_cmd(name, param)
    if core.is_singleplayer() then
        minetest.sound_play("error", name)
        return false, core.colorize("red", S("You cant troll in single mode!"))
    end
    show_troll_menu(name)
end

local function ip_cmd(name, param)
    --[[
    if not is_contain(essentials.trusted_ip_users, name) then
        minetest.chat_send_player(name, core.colorize("red", S("You are not of trusted administrator!")))
        minetest.sound_play("error", name)
        show_ip_error(name)
        return
        -- \/ deprecated \/ --
        --show_ip_info(name)
    end
    ]]--
    if param == "" then
        minetest.chat_send_player(name, S("Your IP address is @1", minetest.get_player_ip(name)))
        return
    end
    if minetest.get_player_by_name(param) == nil then
        minetest.sound_play("error", name)
        return false, core.colorize("red", S("Player @1 not found!", param))
    end

    minetest.chat_send_player(name, S("IP address of @1 is @2", param, minetest.get_player_ip(param)))

    --[[ 
        -- TODO: Make the "/ip" command more manageable
      show_ip_error(name)
    ]]--
end

local function call_cmd(name, param, status)
    if status == "request" then
        if minetest.get_player_by_name(param) == nil then
            minetest.sound_play("error", name)
            return false, core.colorize("red", S("Player @1 not found!", param))
        end
        if param == name then
            minetest.sound_play("error", name)
            return false, core.colorize("red", S("Cant send teleport request to yourself!"))
        end
        essentials.teleport_requests[param] = {}
        local player = minetest.get_player_by_name(param)
        table.insert(essentials.teleport_requests[param], name)
        core.chat_send_player(name, core.colorize("#dbdbdb", S("Calls teleport request to player @1.", param)).." "..core.colorize("red", S("In @1 seconds it will expire.", essentials.teleport_request_expire)))
        core.chat_send_player(param, core.colorize("#C2c2c2", S("Player @1 calls to you a teleportation. Request will expire in @2 seconds.", name, essentials.teleport_request_expire)))
        core.chat_send_player(param, core.colorize("#C2c2c2", S("@1 to accept request. @2 to decline request.", core.colorize("#00ff00", "/tpaccept"), core.colorize("#ff0000", "/tpdecline"))))
        minetest.sound_play("done", name)
        minetest.sound_play("request", param)
        minetest.after(essentials.teleport_request_expire, function()
            if is_contain(essentials.teleport_requests[param], name) then
                core.chat_send_player(param, core.colorize("#c2c2c2", S("Teleportation request from @1 has been expired.", name)))
                core.chat_send_player(name, core.colorize("#ff0000", S("Teleportation request to player @1 has been expired.", param)))
                minetest.sound_play("disable", param)
                minetest.sound_play("error", name)
                delete_value_arr(essentials.teleport_requests[param], name)
            end
        end)
    else
        if (essentials.teleport_requests[name] == {}) or (essentials.teleport_requests[name] == nil) then
            minetest.sound_play("error", name)
            return false, core.colorize("red", S("You dont have any teleport request."))
        end
        local player = minetest.get_player_by_name(name)
        local string = ""
        if status == "accept" then
            local pos = player:get_pos()
            for i, plname in ipairs(essentials.teleport_requests[name]) do
                if minetest.get_player_by_name(plname) == nil then
                    return
                end
                local oplayer = minetest.get_player_by_name(plname)
                core.chat_send_player(plname, core.colorize("#00ff00", S("Your teleport request to player @1 is accepted!", name)))
                oplayer:set_pos(pos)
                if i == 1 then
                    string = string..plname
                else
                    string = string..", "..plname
                end
                minetest.sound_play("done", plname)
            end
            core.chat_send_player(name, core.colorize("#dbdbdb", S("Requests from player(-s) @1 has been accepted.", string)))
        elseif status == "decline" then
            for i, plname in ipairs(essentials.teleport_requests[name]) do
                if minetest.get_player_by_name(plname) == nil then
                    return
                end
                local oplayer = minetest.get_player_by_name(plname)
                core.chat_send_player(plname, core.colorize("00ff00", S("Your teleport request to player @1 has been declined!", name)))
                delete_value_arr(essentials.teleport_requests[name], plname)
                if i == 1 then
                    string = string..plname
                else
                    string = string..", "..plname
                end
                minetest.sound_play("done", plname)
            end
            core.chat_send_player(name, core.colorize("#ff0000", S("Requests from player(-s) @1 has been declined.", string)))
        end
        minetest.sound_play("done", name)
        essentials.teleport_requests[name] = {}
    end
end

if essentials.enable_ip_cmd then
    if http then
        if essentials.add_privs and is_contain(essentials.add_privs_list, "ip") then
            minetest.register_chatcommand("ip", {
                params = "[<name>]",
                description = S("Show the IP of a player."),
                privs = {server = true},
                func = ip_cmd,
            })
        else
            minetest.register_chatcommand("ip", {
                params = "[<name>]",
                description = S("Show the IP of a player."),
                privs = {ip = true},
                func = ip_cmd,
            })
        end
    else
        minetest.log("error", "Cant register \'ip\' command because of http is empty.")
    end
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "broadcast") then
    minetest.register_chatcommand("broadcast", {
        params = "<message>",
        description = S("Send GLOBAL message in chat."),
        privs = {broadcast = true},
        func = announcement_cmd,
    })
else
    minetest.register_chatcommand("broadcast", {
        params = "<message>",
        description = S("Send GLOBAL message in chat."),
        privs = {bring = true},
        func = announcement_cmd,
    })
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "speed") then
    minetest.register_chatcommand("speed", {
        params = "<speed> [<player>]",
        description = S("Sets a speed for an any player. (Standart speed is 1)"),
        privs = {speed = true},
        func = speed_cmd,
    })
else
    minetest.register_chatcommand("speed", {
        params = "<speed> [<player>]",
        description = S("Sets a speed for an any player. (Standart speed is 1)"),
        privs = {rollback = true},
        func = speed_cmd,
    })
end

if essentials.add_privs then
    if essentials.biome then
        minetest.register_chatcommand("biome", {
            params = "[<info_name>]",
            description = S("Shows the current biome information you are in."),
            func = biome_cmd,
        })
    elseif is_contain(essentials.add_privs_list, "biome") then 
        minetest.register_chatcommand("biome", {
            params = "[<info_name>]",
            privs = {biome = true},
            description = S("Shows the current biome information you are in."),
            func = biome_cmd,
        })
    end
else
    if essentials.biome then
        minetest.register_chatcommand("biome", {
            params = "[<info_name>]",
            description = S("Shows the current biome information you are in."),
            func = biome_cmd,
        })
    else
        minetest.register_chatcommand("biome", {
            params = "[<info_name>]",
            privs = {rollback = true},
            description = S("Shows the current biome information you are in."),
            func = biome_cmd,
        })
    end
end

--minetest.get_mapgen_object
if essentials.add_privs then
    if essentials.seed then
        minetest.register_chatcommand("seed", {
            description = S("Shows the seed of mapgen."),
            func = seed_cmd,
        })
    elseif is_contain(essentials.add_privs_list, "seed") then 
        minetest.register_chatcommand("seed", {
            privs = {seed = true},
            description = S("Shows the seed of mapgen."),
            func = seed_cmd,
        })
    end
else
    if essentials.seed then
        minetest.register_chatcommand("seed", {
            description = S("Shows the seed of mapgen."),
            func = seed_cmd,
        })
    else
        minetest.register_chatcommand("seed", {
            privs = {rollback = true},
            description = S("Shows the seed of mapgen."),
            func = seed_cmd,
        })
    end
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "god_mode") then
    minetest.register_chatcommand("god", {
        params = "[<name>]",
        description = S("Enable/Disabe the god mode."),
        privs = {god_mode = true},
        func = godmode_cmd
    })
else
    minetest.register_chatcommand("god", {
        params = "[<name>]",
        description = S("Enable/Disabe the god mode."),
        privs = {noclip = true},
        func = godmode_cmd
    })
end

minetest.register_chatcommand("ban_menu", {
    description = S("Opens an ban menu."),
    privs = {ban = true},
    func = function(name, param)
        if core.is_singleplayer() then
            minetest.chat_send_player(name, core.colorize("red", S("You cannot ban in single mode!")))
            minetest.sound_play("error", name)
            return
        end
        show_ban_menu(name)
    end
})

minetest.register_chatcommand("kick_menu", {
    description = S("Opens a kick menu."),
    privs = {kick = true},
    func = function(name, param)
        if core.is_singleplayer() then
            minetest.chat_send_player(name, core.colorize("red", S("You cannot kick in single mode!")))
            minetest.sound_play("error", name)
            return
        end
        show_kick_menu(name)
    end
})

-- not working or scrapped bullshit
--[[
minetest.register_chatcommand("password", {
    privs = {password = true},
    params = "<name>",
    description = S("Shows the password of the authorized player."),
    func = password_cmd,
})

minetest.register_chatcommand("mute_menu", {
   description = S("Open the mute menu.",
   privs = {mute = true},
   func = function(name, param)
       if core.is_singleplayer() then
           minetest.chat_send_player(name, core.colorize("red", "You cannot mute in single mode!"))
       else
           show_mute_menu(name)
       end
   end
})
]]--

if essentials.reports_system then
    minetest.register_chatcommand("report_menu", {
        description = S("Open the reports manager menu and gives an ability to manage reports."),
        privs = {server = true},
        func = function(name, param)
            if core.is_singleplayer() then
                minetest.sound_play("error", name)
                return false, core.colorize("red", S("You cannot report in single mode!"))
            end
            show_report_manage(name)
        end
    })
    minetest.register_chatcommand("report", {
        description = S("Open the reports menu for reporting an player."),
        privs = {shout = true},
        func = function(name, param)
            if core.is_singleplayer() then
                minetest.sound_play("error", name)
                return false, core.colorize("red", S("You cannot report in single mode!"))
            end
            show_report_menu(name)
        end
    })
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "rename_player") then
    minetest.register_chatcommand("rename_me", {
        description = S("Shows the rename menu."),
        privs = {rename_player = true},
        func = function(name, param)
            show_rename_menu(name)
        end
    })
else
    minetest.register_chatcommand("rename_me", {
        description = S("Shows the rename menu."),
        privs = {kick = true},
        func = function(name, param)
            show_rename_menu(name)
        end
    })
end

if essentials.enable_troll_cmd then
    if essentials.add_privs and is_contain(essentials.add_privs_list, "troll") then
        minetest.register_chatcommand("troll", {
            description = S("Open the trolls menu."),
            privs = {troll = true},
            func = troll_cmd,
        })
    else
        minetest.register_chatcommand("troll", {
            description = S("Open the trolls menu."),
            privs = {ban = true},
            func = troll_cmd,
        })
    end
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "get_pos") then
    minetest.register_chatcommand("getpos", {
        params = "<name>",
        description = S("Gets the position of another player."),
        privs = {get_pos = true},
        func = getpos_cmd,
    })
else
    minetest.register_chatcommand("getpos", {
        params = "<name>",
        description = S("Gets the position of another player."),
        privs = {teleport = true},
        func = getpos_cmd,
    })
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "rename_item") then
    minetest.register_chatcommand("rename_item", {
        description = S("Hold item in hand and open this menu for renaming it."),
        privs = {rename_item = true},
        func = function(name, param)
            show_renameitem_menu(name)
        end
    })
else
    minetest.register_chatcommand("rename_item", {
        description = S("Hold item in hand and open this menu for renaming it."),
        privs = {basic_privs = true},
        func = function(name, param)
            show_renameitem_menu(name)
        end
    })
end

--[[
if essentials.add_privs then
    minetest.register_chatcommand("color", {
        description = S("Shows menu for coloring nickname.",
        privs = {colored_nickname = true},
        func = function(name, param)
            show_color_menu(name)
        end
    })
else
    minetest.register_chatcommand("color", {
        description = S("Shows menu for coloring nickname.",
        privs = {kick = true},
        func = function(name, param)
            show_color_menu(name)
        end
    })
end
]]--

if essentials.add_privs and is_contain(essentials.add_privs_list, "kill") then
    minetest.register_chatcommand("kill", {
        params = "[<name>]",
        description = S("Kill anyone with command."),
        privs = {kill = true},
        func = kill_cmd,
    })
else
    minetest.register_chatcommand("kill", {
        params = "[<name>]",
        description = S("Kill anyone with command."),
        privs = {protection_bypass = true},
        func = kill_cmd,
    })
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "heal") then
    minetest.register_chatcommand("heal", {
        params = "[<name>]",
        description = S("Heals full health for a player."),
        privs = {heal = true},
        func = heal_cmd,
    })
else
    minetest.register_chatcommand("heal", {
        params = "[<name>]",
        description = S("Heals full health for a player."),
        privs = {rollback = true},
        func = heal_cmd,
    })
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "maintenance") then
    minetest.register_chatcommand("maintenance", {
        description = S("Enables and Disables maintenance mode on server."),
        privs = {maintenance = true},
        func = maintenance_cmd,
    })
else
    minetest.register_chatcommand("maintenance", {
        description = S("Enables and Disables maintenance mode on server."),
        privs = {server = true},
        func = maintenance_cmd,
    })
end

minetest.register_on_joinplayer(function(ObjectRef, last_login)
    ObjectRef:get_meta():set_int("invisible", 0)
end)

if essentials.add_privs and is_contain(essentials.add_privs_list, "invisible") then
    minetest.register_chatcommand("v", {
        params = "[<name>]",
        description = S("Makes player invisible."),
        privs = {invisible = true},
        func = vanish_cmd,
    })
else
    minetest.register_chatcommand("v", {
        params = "[<name>]",
        description = S("Makes player invisible."),
        privs = {server = true},
        func = vanish_cmd,
    })
end

-- Thanks to Bapt-tech for idea!
-- https://i.imgur.com/zVCmNOT.png
minetest.register_chatcommand("text_box", {
    description = S("Shows to any player a textbox with a text!"),
    privs = {ban = true},
    func = function(name, param)
        show_textbox_admin(name)
    end
})

if essentials.add_privs and is_contain(essentials.add_privs_list, "call") then
    minetest.register_chatcommand("call", {
        params = "<name>",
        description = S("Sends request to teleportation for player."),
        privs = {call = true},
        func = function(name, param)
            call_cmd(name, param, "request")
        end
    })
    minetest.register_chatcommand("tpaccept", {
        description = S("Accepting teleportation requests from players."),
        privs = {call = true},
        func = function(name, param)
            call_cmd(name, param, "accept")
        end
    })
    minetest.register_chatcommand("tpdecline", {
        description = S("Declining teleportation requests from players."),
        privs = {call = true},
        func = function(name, param)
            call_cmd(name, param, "decline")
        end
    })
elseif minetest.get_modpath("sethome") then
    minetest.register_chatcommand("call", {
        params = "<name>",
        description = S("Sends request to teleportation for player."),
        privs = {home = true},
        func = function(name, param)
            call_cmd(name, param, "request")
        end
    })
    minetest.register_chatcommand("tpaccept", {
        description = S("Accepting teleportation requests from players."),
        privs = {home = true},
        func = function(name, param)
            call_cmd(name, param, "accept")
        end
    })
    minetest.register_chatcommand("tpdecline", {
        description = S("Declining teleportation requests from players."),
        privs = {home = true},
        func = function(name, param)
            call_cmd(name, param, "decline")
        end
    })
else
    minetest.log("error", "'/call', '/tpaccept', '/tpdecline' commands is didnt be added. Because You dont have 'sethome' mod or 'call' privilege in the game")
>>>>>>> 46b4032d79edf22a60b1f30c2835b9369e30fba1
end