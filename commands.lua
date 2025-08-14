local enable_damage = core.settings:get_bool("enable_damage")
local speeds = {}
local S = essentials.translate

local function is_contain(table, value)
	for _, v in ipairs(table) do
		if v == value then
			return true
		end
	end
	return false
end

local function remove_val(table, value)
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
        essentials.player_sound("done", name)
        core.get_player_by_name(name):set_physics_override({
            speed = tonumber(speed)
        })
    else
        if core.get_player_by_name(oname) == nil then
            essentials.player_sound("error", name)
            return false, core.colorize("red", S("Please, specify an online player."))
        end
        core.chat_send_player(name, S("Speed of player @1 now is @2.", oname, speed))
        essentials.player_sound("done", name)
        essentials.player_sound("done", oname)
        if essentials.changed_by then
            core.chat_send_player(oname, S("Now your speed is @1 from player @2.", speed, name))
        end
        core.get_player_by_name(oname):set_physics_override({
            speed = tonumber(speed)
        })
    end
end

local function announcement_cmd(name, param)
    if param == "" then
        return false
    end
    local admin = essentials.get_admin_name()
    if name == admin then
        core.chat_send_all(core.colorize("#0006FF", S("[Announcement]")).." "..core.colorize("#00FFC6", param))
    else
        core.chat_send_all(core.colorize("#0006FF", S("[Announcement]")).." "..core.colorize("#00FFC6", param).." "..core.colorize("#82909D", S("(Announced by @1)", name)))
    end
    essentials.play_sound("broadcast")
end

local function biome_cmd(name, param)
    if not core.has_feature("object_use_texture_alpha") then
        core.log("error", essentials.main.." "..S("Your Engine version is deprecated! Update it for \'/biome\' command."))
        essentials.player_sound("error", name)
        return false, core.colorize("red", S("This version of engine doesn't support that command."))
    end

    local pos = core.get_player_by_name(name):get_pos()
    local biomeinfo = core.get_biome_data(pos)
    local biome = core.get_biome_name(biomeinfo.biome)
    if param == "" then
        core.chat_send_player(name, S("Biome")..": ".. dump(biome))
    else
        if core.check_player_privs(name, {debug=true}) then
            if param == "heat" then
                core.chat_send_player(name, dump(biome) ..": ".. biomeinfo.heat)
            elseif param == "humidity" then
                core.chat_send_player(name, dump(biome) ..": ".. biomeinfo.humidity)
            else
                essentials.player_sound("error", name)
                return false, core.colorize("red", S("Invalid information name!"))
            end
        else
            essentials.player_sound("error", name)
            return false, core.colorize("red", S("You cant check more information without privelege!"))
        end
    end
end

local function getpos_cmd(name, param)
    local player = core.get_player_by_name(param);
    if param == "" then
        essentials.player_sound("error", name)
        return false
    elseif core.get_player_by_name(param) == nil then
        essentials.player_sound("error", name)
        return false, core.colorize("red", S("Player @1 not found!", param))
    end
    local pos = player:get_pos();
    local round_pos = vector.round(pos);
    core.chat_send_player(name, S("Position of player @1 is @2 @3 @4.", param, core.colorize("#ff0000", " X:"..round_pos.x), core.colorize("#00ff00", " Y:"..round_pos.y), core.colorize("#0000ff", " Z:"..round_pos.z)))
    essentials.player_sound("done", name)
end

local function seed_cmd(name, param)
    core.chat_send_player(name, S("Seed is @1", core.colorize("lime", core.get_mapgen_setting("seed"))))
end

local function godmode_cmd(name, param)
    if enable_damage then
        local player
        if param == "" then
            player = core.get_player_by_name(name)
        else
            player = core.get_player_by_name(param)
        end
        if player == nil then
            core.chat_send_player(name, core.colorize("red", S("Player @1 not found.", param)))
            essentials.player_sound("error", name)
            return
        end
        local ag = player:get_armor_groups()
        if not ag["immortal"] then
            ag["immortal"] = 1
            if param == "" then
                core.chat_send_player(name, core.colorize("yellow", S("God mode enabled.")))
                essentials.player_sound("request", name)
            else
                core.chat_send_player(name, S("God mode enabled for @1.", param))
                core.chat_send_player(param, S("For you enabled god mode from @1.", name))
                essentials.player_sound("request", param)
                essentials.player_sound("done", name)
            end
        else
            ag["immortal"] = nil
            if param == "" then
                core.chat_send_player(name, core.colorize("yellow", S("God mode disabled.")))
                essentials.player_sound("disabled", name)
            else
                core.chat_send_player(name, S("God mode disabled for @1.", param))
                core.chat_send_player(param, S("For you god mode has been disabled by @1.", name))
                essentials.player_sound("disabled", param)
                essentials.player_sound("done", name)
            end
        end
        player:set_armor_groups(ag)
    else
        essentials.player_sound("error", name)
        return false, core.colorize("red", S("@1 is disabled!", "\"enable_damage\""))
    end
end

local function kill_cmd(name, param)
    if core.settings:get_bool("enable_damage") then
        if param == "" or param == nil then
            core.get_player_by_name(name):set_hp(0)
        else
            if core.get_player_by_name(param) == nil then
                core.chat_send_player(name, core.colorize("red", S("Player @1 not found!", param)))
                essentials.player_sound("error", name)
                return
            end
            core.get_player_by_name(param):set_hp(0)
            core.chat_send_player(name, S("You killed player @1.", param))
            essentials.player_sound("done", name)
            if essentials.killed_by then
                core.chat_send_player(param, S("You has been killed by player @1.", name))
                essentials.player_sound("error", param)
            end
        end
    else
        local player = core.get_player_by_name(name)
        if param then
            player = core.get_player_by_name(param)
            if core.get_player_by_name(param) == nil then
                essentials.player_sound("error", name)
                return false, core.colorize("red", S("Player @1 not found!", param))
            end
            core.chat_send_player(name, S("You respawned player @1.", param))
            essentials.player_sound("done", name)
            if essentials.killed_by then
                core.chat_send_player(param, S("You has been respawned by player @1.", name))
                essentials.player_sound("error", param)
            end
        end
        for _, callback in pairs(core.registered_on_respawnplayers) do
            if callback(player) then
                return true
            end
        end
        return false, "No static_spawnpoint defined"
    end
end

local function heal_cmd(name, param)
    if param == "" or param == nil then
        core.get_player_by_name(name):set_hp(core.PLAYER_MAX_HP_DEFAULT)
        core.chat_send_player(name, S("You has been healed to the possible max health."))
    else
        if core.get_player_by_name(param) == nil then
            essentials.player_sound("error", name)
            return false, core.colorize("red", S("Player @1 not found!", param))
        end
        core.get_player_by_name(param):set_hp(core.PLAYER_MAX_HP_DEFAULT)
        core.chat_send_player(name, S("Player @1 healed to the @2 health.", param, core.get_player_by_name(param):get_hp()))
        essentials.player_sound("done", name)
        if essentials.changed_by then
            core.chat_send_player(param, S("You has been fully healed by @1.", name))
            essentials.player_sound("done", param)
        end
    end
end

local function check_moderator(name)
    if (not is_contain(essentials.moderators, name)) or (not (name == essentials.get_admin_name())) then
        return true
    else
        return false
    end
end

local function maintenance_cmd(name, param)
    if core.is_singleplayer() then
        essentials.player_sound("error", param)
        return false, core.colorize("red", S("Cannot interact with maintenance mode in singleplayer!"))
    end
    essentials.player_sound("done", param)
    if essentials.maintenance then
        essentials.maintenance = false
        core.chat_send_player(name, core.colorize("lightgrey", S("Maintenance mode has been disabled!")))
    else
        essentials.maintenance = true
        core.chat_send_player(name, core.colorize("grey", S("Maintenance mode has been enabled!")))
    end
end

core.register_globalstep(function(dtime)
    if essentials.maintenance then
        for _, player in ipairs(core.get_connected_players()) do
            local name = player:get_player_name()
            if check_moderator(name) then
                core.kick_player(name, essentials.maintenance_msg)
            end
        end
    end
end)

core.register_on_prejoinplayer(function(name)
    if essentials.maintenance and check_moderator(name) then return essentials.maintenance_msg end
end)

core.register_can_bypass_userlimit(function(name, ip)
    if check_moderator(name) then return true end
end)

local function vanish_cmd(name, param)
    local player
    local other = false
    if param == "" or param == nil then
        player = core.get_player_by_name(name)
    else
        player = core.get_player_by_name(param)
        if player == nil then
            essentials.player_sound("error", name)
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
            essentials.player_sound("done", name)
            if essentials.changed_by then
                core.chat_send_player(param, core.colorize("#E6E6E6", S("Now you are invisible from player @1.", name)))
                essentials.player_sound("done", param)
            end
        else
            core.chat_send_player(name, core.colorize("#E6E6E6", S("Now you are invisible.")))
            essentials.player_sound("done", name)
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
            essentials.player_sound("done", name)
            if essentials.changed_by then
                core.chat_send_player(param, S("Now you visible again from player @1.", name))
                essentials.player_sound("done", param)
            end
        else
            core.chat_send_player(name, S("Now you are visible again."))
            essentials.player_sound("done", name)
        end
    end
    player:set_properties(prop)
end

local function troll_cmd(name, param)
    if core.is_singleplayer() then
        essentials.player_sound("error", name)
        return false, core.colorize("red", S("You cant troll in single mode!"))
    end
    essentials.show_troll_menu(name)
end

local function ip_cmd(name, param)
    if param == "" then
        essentials.show_ip_information(name, name)
        return
    end
    if core.get_player_by_name(param) == nil then
        essentials.player_sound("error", name)
        return false, core.colorize("red", S("Player @1 not found!", param))
    end
    essentials.show_ip_information(name, param)
end

local function inv_cmd(name, param)
    if not core.get_player_by_name(param) then
        essentials.player_sound("error", name)
        return false, core.colorize("red", S("Player @1 not found!", param))
    end
    if param == name then
        essentials.player_sound("error", name)
        return false, core.colorize("red", S("Cannot open inventory of yourself!"))
    end
    essentials.show_player_inventory(name, param)
    return true, S("Opening @1's inventory...", param)
end

local function call_cmd(name, param, status)
    if status == "request" then
        if core.get_player_by_name(param) == nil then
            essentials.player_sound("error", name)
            return false, core.colorize("red", S("Player @1 not found!", param))
        end
        if param == name then
            essentials.player_sound("error", name)
            return false, core.colorize("red", S("Cant send teleport request to yourself!"))
        end
        essentials.teleport_requests[param] = {}
        local player = core.get_player_by_name(param)
        table.insert(essentials.teleport_requests[param], name)
        core.chat_send_player(name, core.colorize("#dbdbdb", S("Calls teleport request to player @1.", param)).." "..core.colorize("red", S("In @1 seconds it will expire.", essentials.teleport_request_expire)))
        core.chat_send_player(param, core.colorize("#C2c2c2", S("Player @1 calls to you a teleportation. Request will expire in @2 seconds.", name, essentials.teleport_request_expire)))
        core.chat_send_player(param, core.colorize("#C2c2c2", S("@1 to accept request. @2 to decline request.", core.colorize("#00ff00", "/tpaccept"), core.colorize("#ff0000", "/tpdecline"))))
        essentials.player_sound("done", name)
        essentials.player_sound("request", param)
        core.after(essentials.teleport_request_expire, function()
            if is_contain(essentials.teleport_requests[param], name) then
                core.chat_send_player(param, core.colorize("#c2c2c2", S("Teleportation request from @1 has been expired.", name)))
                core.chat_send_player(name, core.colorize("#ff0000", S("Teleportation request to player @1 has been expired.", param)))
                essentials.player_sound("disable", param)
                essentials.player_sound("error", name)
                remove_val(essentials.teleport_requests[param], name)
            end
        end)
    else
        if (essentials.teleport_requests[name] == {}) or (essentials.teleport_requests[name] == nil) then
            essentials.player_sound("error", name)
            return false, core.colorize("red", S("You dont have any teleport request."))
        end
        local player = core.get_player_by_name(name)
        local string = ""
        if status == "accept" then
            local pos = player:get_pos()
            for i, plname in ipairs(essentials.teleport_requests[name]) do
                if core.get_player_by_name(plname) == nil then
                    return
                end
                local oplayer = core.get_player_by_name(plname)
                core.chat_send_player(plname, core.colorize("#00ff00", S("Your teleport request to player @1 is accepted!", name)))
                oplayer:set_pos(pos)
                if i == 1 then
                    string = string..plname
                else
                    string = string..", "..plname
                end
                essentials.player_sound("done", plname)
            end
            core.chat_send_player(name, core.colorize("#dbdbdb", S("Requests from player(-s) @1 has been accepted.", string)))
        elseif status == "decline" then
            for i, plname in ipairs(essentials.teleport_requests[name]) do
                if core.get_player_by_name(plname) == nil then
                    return
                end
                local oplayer = core.get_player_by_name(plname)
                core.chat_send_player(plname, core.colorize("00ff00", S("Your teleport request to player @1 has been declined!", name)))
                remove_val(essentials.teleport_requests[name], plname)
                if i == 1 then
                    string = string..plname
                else
                    string = string..", "..plname
                end
                essentials.player_sound("done", plname)
            end
            core.chat_send_player(name, core.colorize("#ff0000", S("Requests from player(-s) @1 has been declined.", string)))
        end
        essentials.player_sound("done", name)
        essentials.teleport_requests[name] = {}
    end
end

if essentials.enable_ip_cmd and not essentials.offline_mode then
    if essentials.add_privs and is_contain(essentials.add_privs_list, "ip") then
        core.register_chatcommand("ip", {
            params = "[<name>]",
            description = S("Show the IP of a player."),
            privs = {server = true},
            func = ip_cmd,
        })
    else
        core.register_chatcommand("ip", {
            params = "[<name>]",
            description = S("Show the IP of a player."),
            privs = {ip = true},
            func = ip_cmd,
        })
    end
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "broadcast") then
    core.register_chatcommand("broadcast", {
        params = "<message>",
        description = S("Send GLOBAL message in chat."),
        privs = {broadcast = true},
        func = announcement_cmd,
    })
else
    core.register_chatcommand("broadcast", {
        params = "<message>",
        description = S("Send GLOBAL message in chat."),
        privs = {bring = true},
        func = announcement_cmd,
    })
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "speed") then
    core.register_chatcommand("speed", {
        params = "<speed> [<player>]",
        description = S("Sets a speed for an any player. (Standart speed is 1)"),
        privs = {speed = true},
        func = speed_cmd,
    })
else
    core.register_chatcommand("speed", {
        params = "<speed> [<player>]",
        description = S("Sets a speed for an any player. (Standart speed is 1)"),
        privs = {rollback = true},
        func = speed_cmd,
    })
end

if essentials.add_privs then
    if essentials.biome then
        core.register_chatcommand("biome", {
            params = "[<info_name>]",
            description = S("Shows the current biome information you are in."),
            func = biome_cmd,
        })
    elseif is_contain(essentials.add_privs_list, "biome") then 
        core.register_chatcommand("biome", {
            params = "[<info_name>]",
            privs = {biome = true},
            description = S("Shows the current biome information you are in."),
            func = biome_cmd,
        })
    end
else
    if essentials.biome then
        core.register_chatcommand("biome", {
            params = "[<info_name>]",
            description = S("Shows the current biome information you are in."),
            func = biome_cmd,
        })
    else
        core.register_chatcommand("biome", {
            params = "[<info_name>]",
            privs = {rollback = true},
            description = S("Shows the current biome information you are in."),
            func = biome_cmd,
        })
    end
end

if essentials.add_privs then
    if essentials.seed then
        core.register_chatcommand("seed", {
            description = S("Shows the seed of mapgen."),
            func = seed_cmd,
        })
    elseif is_contain(essentials.add_privs_list, "seed") then 
        core.register_chatcommand("seed", {
            privs = {seed = true},
            description = S("Shows the seed of mapgen."),
            func = seed_cmd,
        })
    end
else
    if essentials.seed then
        core.register_chatcommand("seed", {
            description = S("Shows the seed of mapgen."),
            func = seed_cmd,
        })
    else
        core.register_chatcommand("seed", {
            privs = {rollback = true},
            description = S("Shows the seed of mapgen."),
            func = seed_cmd,
        })
    end
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "god_mode") then
    core.register_chatcommand("god", {
        params = "[<name>]",
        description = S("Enable/Disabe the god mode."),
        privs = {god_mode = true},
        func = godmode_cmd
    })
else
    core.register_chatcommand("god", {
        params = "[<name>]",
        description = S("Enable/Disabe the god mode."),
        privs = {noclip = true},
        func = godmode_cmd
    })
end

core.register_chatcommand("ban_menu", {
    description = S("Opens a ban menu."),
    privs = {ban = true},
    func = function(name, param)
        if core.is_singleplayer() then
            essentials.player_sound("essentials_error", name)
            return false, core.colorize("red", S("You cannot ban in single mode!"))
        end
        essentials.show_ban_menu(name)
    end
})

core.register_chatcommand("kick_menu", {
    description = S("Opens a kick menu."),
    privs = {kick = true},
    func = function(name, param)
        if core.is_singleplayer() then
            essentials.player_sound("essentials_error", name)
            return false, core.colorize("red", S("You cannot kick in single mode!"))
        end
        essentials.show_kick_menu(name)
    end
})

core.register_chatcommand("mute_menu", {
   description = S("Open the mute menu."),
   privs = {mute = true},
   func = function(name, param)
        if core.is_singleplayer() then
            essentials.player_sound("essentials_error", name)
            return false, core.colorize("red", S("You cannot mute in single mode!"))
        end
        essentials.show_mute_menu(name)
   end
})

if essentials.reports_system then
    core.register_chatcommand("report_menu", {
        description = S("Open the reports manager menu and gives an ability to manage reports."),
        privs = {server = true},
        func = function(name, param)
            if core.is_singleplayer() then
                essentials.player_sound("error", name)
                return false, core.colorize("red", S("You cannot report in single mode!"))
            end
            essentials.show_report_manage(name)
        end
    })
    core.register_chatcommand("report", {
        description = S("Open the reports menu for reporting an player."),
        privs = {shout = true},
        func = function(name, param)
            if core.is_singleplayer() then
                essentials.player_sound("error", name)
                return false, core.colorize("red", S("You cannot report in single mode!"))
            end
            essentials.show_report_menu(name)
        end
    })
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "rename_player") then
    core.register_chatcommand("rename_me", {
        description = S("Shows the rename menu."),
        privs = {rename_player = true},
        func = essentials.show_rename_menu
    })
else
    core.register_chatcommand("rename_me", {
        description = S("Shows the rename menu."),
        privs = {kick = true},
        func = essentials.show_rename_menu
    })
end

if essentials.enable_troll_cmd then
    if essentials.add_privs and is_contain(essentials.add_privs_list, "troll") then
        core.register_chatcommand("troll", {
            description = S("Open the trolls menu."),
            privs = {troll = true},
            func = troll_cmd,
        })
    else
        core.register_chatcommand("troll", {
            description = S("Open the trolls menu."),
            privs = {ban = true},
            func = troll_cmd,
        })
    end
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "get_pos") then
    core.register_chatcommand("getpos", {
        params = "<name>",
        description = S("Gets the position of another player."),
        privs = {get_pos = true},
        func = getpos_cmd,
    })
else
    core.register_chatcommand("getpos", {
        params = "<name>",
        description = S("Gets the position of another player."),
        privs = {teleport = true},
        func = getpos_cmd,
    })
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "rename_item") then
    core.register_chatcommand("rename_item", {
        description = S("Hold item in hand and open this menu for renaming it."),
        privs = {rename_item = true},
        func = essentials.show_renameitem_menu
    })
else
    core.register_chatcommand("rename_item", {
        description = S("Hold item in hand and open this menu for renaming it."),
        privs = {basic_privs = true},
        func = essentials.show_renameitem_menu
    })
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "colored_nickname") then
    core.register_chatcommand("color", {
        description = S("Opens a coloring menu."),
        privs = {colored_nickname = true},
        func = essentials.show_coloring_menu
    })
else
    core.register_chatcommand("color", {
        description = S("Opens a coloring menu."),
        privs = {kick = true},
        func = essentials.show_coloring_menu
    })
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "kill") then
    core.register_chatcommand("kill", {
        params = "[<name>]",
        description = S("Kill anyone with command."),
        privs = {kill = true},
        func = kill_cmd,
    })
else
    core.register_chatcommand("kill", {
        params = "[<name>]",
        description = S("Kill anyone with command."),
        privs = {protection_bypass = true},
        func = kill_cmd,
    })
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "heal") then
    core.register_chatcommand("heal", {
        params = "[<name>]",
        description = S("Heals full health for a player."),
        privs = {heal = true},
        func = heal_cmd,
    })
else
    core.register_chatcommand("heal", {
        params = "[<name>]",
        description = S("Heals full health for a player."),
        privs = {rollback = true},
        func = heal_cmd,
    })
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "maintenance") then
    core.register_chatcommand("maintenance", {
        description = S("Enables and Disables maintenance mode on server."),
        privs = {maintenance = true},
        func = maintenance_cmd,
    })
else
    core.register_chatcommand("maintenance", {
        description = S("Enables and Disables maintenance mode on server."),
        privs = {server = true},
        func = maintenance_cmd,
    })
end

core.register_on_joinplayer(function(ObjectRef, last_login)
    ObjectRef:get_meta():set_int("invisible", 0)
end)

if essentials.add_privs and is_contain(essentials.add_privs_list, "invisible") then
    core.register_chatcommand("v", {
        params = "[<name>]",
        description = S("Makes player invisible."),
        privs = {invisible = true},
        func = vanish_cmd,
    })
else
    core.register_chatcommand("v", {
        params = "[<name>]",
        description = S("Makes player invisible."),
        privs = {server = true},
        func = vanish_cmd,
    })
end

-- Thanks to Bapt-tech for idea!
-- https://i.imgur.com/zVCmNOT.png
core.register_chatcommand("textbox", {
    description = S("Shows to any player a textbox with a text!"),
    privs = {ban = true},
    func = essentials.show_make_textbox
})

if essentials.add_privs and is_contain(essentials.add_privs_list, "call") then
    core.register_chatcommand("call", {
        params = "<name>",
        description = S("Sends request to teleportation for player."),
        privs = {call = true},
        func = function(name, param)
            call_cmd(name, param, "request")
        end
    })
    core.register_chatcommand("tpaccept", {
        description = S("Accepting teleportation requests from players."),
        privs = {call = true},
        func = function(name, param)
            call_cmd(name, param, "accept")
        end
    })
    core.register_chatcommand("tpdecline", {
        description = S("Declining teleportation requests from players."),
        privs = {call = true},
        func = function(name, param)
            call_cmd(name, param, "decline")
        end
    })
elseif core.get_modpath("sethome") then
    core.register_chatcommand("call", {
        params = "<name>",
        description = S("Sends request to teleportation for player."),
        privs = {home = true},
        func = function(name, param)
            call_cmd(name, param, "request")
        end
    })
    core.register_chatcommand("tpaccept", {
        description = S("Accepting teleportation requests from players."),
        privs = {home = true},
        func = function(name, param)
            call_cmd(name, param, "accept")
        end
    })
    core.register_chatcommand("tpdecline", {
        description = S("Declining teleportation requests from players."),
        privs = {home = true},
        func = function(name, param)
            call_cmd(name, param, "decline")
        end
    })
else
    core.log("error", "'/call', '/tpaccept', '/tpdecline' commands have not to be added. Because You don't have 'sethome' mod or 'call' privilege in settings!")
end

if essentials.add_privs and is_contain(essentials.add_privs_list, "inv") then
    core.register_chatcommand("inv", {
        params = "<name>",
        description = S("Opens player's inventory"),
        privs = {server = true},
        func = inv_cmd,
    })
else
    core.register_chatcommand("inv", {
        params = "<name>",
        description = S("Opens player's inventory"),
        privs = {inv = true},
        func = inv_cmd,
    })
end

local function show_about_screen(name)
	local formspec = {
        "formspec_version[6]",
        "size[12,6]",
        "hypertext[0.1,0.1;5.8,5.8;about;", core.hypertext_escape(table.concat({
            "<big><b>About Essentials</b></big>",
            "Essentials — Luanti mod, inspired by EssentialsX plug-in for Minecraft.",
            "Mod was intended to be command overhaul, to make moderation for the admin easier.",
            "",
            "<i>More information coming soon...</i>"
        }, "\n")), "]",
        "image[6.1,0.1;5.8,5.8;essentials_skybuilder_approved.png]"
    }
	core.show_formspec(name, "essentials:about", table.concat(formspec))
end

core.register_chatcommand("essentials", {
    params = "<about | version>",
    func = function(name, param)
        local params = param:gsub("%s+", "")
        if param == "about" then show_about_screen(name)
        elseif param == "version" then return true, S("@1 current: @2", core.colorize("lightgrey", essentials.main_tr), core.colorize(essentials.need_update.value and "red" or "lime", "v"..essentials.version))
        else return false end
    end
})