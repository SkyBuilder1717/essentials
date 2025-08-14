local http = core.request_http_api and core.request_http_api()
local modpath = core.get_modpath(core.get_current_modname())
local st = core.settings
essentials = {
    -- Settings
    seed = st:get_bool("essentials_seed", false),
    biome = st:get_bool("essentials_biome", true),
    trolled_by = st:get_bool("essentials_trolled_by", false),
    killed_by = st:get_bool("essentials_killed_by", false),
    admin_ip_check = st:get_bool("essentials_ip_verified", false),
    check_for_updates = st:get_bool("essentials_check_for_updates", false),
    changed_by = st:get_bool("essentials_changed_by", true),
    add_privs = st:get_bool("essentials_additional_privileges", true),
    enable_ip_cmd = st:get_bool("essentials_ip", false),
    enable_color_cmd = st:get_bool("essentials_colored_nickname", false),
    enable_troll_cmd = st:get_bool("essentials_trolling", false),
    offline_mode = st:get_bool("essentials_offline_mode", false),
    beta_test = st:get_bool("essentials_beta_test", false),
    enable_simple_edit = st:get_bool("essentials_simple_edit", false),
    reports_system = st:get_bool("essentials_report_system", false),
    disposable_eraser = st:get_bool("essentials_disposable_eraser", true),
    teleport_request_expire = (st:get("essentials_teleport_exporation") or 15.0),
    teleport_requests = {},

    -- Unified Inventory detection
    have_unified_inventory = core.get_modpath("unified_inventory") and core.global_exists("unified_inventory"),

    -- Lists of Settings
    add_privs_list = {},
    moderators = {},

    -- Text
    info = "Created by SkyBuilder1717",
    version = "1.1.6",
    translate = core.get_translator("essentials"),
    main_tr = "",
    main = "[Essentials]",

    -- Maintenance mode
    maintenance = false,
    maintenance_msg = "",

    -- approved servers with this mod
    approved_servers = {},

    -- Reports
    reports = {},

    -- All custom privileges in the mod
    privs = {
        "rename_item",
        "rename_player",
        "god_mode",
        "broadcast",
        "speed",
        "heal",
        "kill",
        "get_pos",
        "seed",
        "invisible",
        "troll",
        "ip",
        "biome",
        "call",
        "mute",
        "inv",
        "colored_nickname"
    },
    -- Privileges in text
    privstring = "",

    -- HTTP checking
    is_http = false,
}
local S = essentials.translate
essentials.main_tr = core.colorize("lightgrey", "["..S("Essentials").."]")

if http then
    essentials.is_http = true
else
    if not essentials.offline_mode then
        error("\n"..essentials.main_tr.."\n(If \'essentials\' mod is already in \'secure.http_mods\' parameter, check your internet connection or enable the \'Offline mode\' in mods settings.)\n\nHey!\nIt seems like \'essentials\' mod not in \'secure.http_mods\'!\n\nSo, please add mod in \'secure.http_mods\' option for best experience with Essentials!\nWhy?\nIt required for mod to work perfectly with HTTP requests!\n\nThank you.\n\n\n\n")
    end
end

for i, priv in ipairs(essentials.privs) do
    if i == 1 then
        essentials.privstring = essentials.privstring..priv
    else
        essentials.privstring = essentials.privstring..", "..priv
    end
end
if essentials.beta_test then
    essentials.add_privs_list = string.split((st:get("essentials_all_privs") or essentials.privstring), ", ")
    local moders = st:get("essentials_moderators")
    if moders then
        essentials.moderators = string.split(moders, ", ")
    end
else
    essentials.add_privs_list = string.split(essentials.privstring, ", ")
end
essentials.maintenance_msg = S("@n@1@n@n@nSorry, but server is in maintenance mode right now!@nCome back later!", essentials.main_tr)

if essentials.enable_simple_edit then
    dofile(modpath.."/simple_edit.lua")
end

-- Menus
dofile(modpath.."/ui/ban_menu.lua")
dofile(modpath.."/ui/kick_menu.lua")
dofile(modpath.."/ui/mute_menu.lua")
dofile(modpath.."/ui/rename_me.lua")
dofile(modpath.."/ui/rename_item.lua")
dofile(modpath.."/ui/color_menu.lua")
dofile(modpath.."/ui/troll.lua")
dofile(modpath.."/ui/textbox.lua")
dofile(modpath.."/ui/inventory.lua")
dofile(modpath.."/ui/thanks.lua")

if essentials.reports_system then
    dofile(modpath.."/ui/report.lua")
    dofile(modpath.."/ui/reports.lua")
end

-- Main
dofile(modpath.."/api.lua")
dofile(modpath.."/commands.lua")
dofile(modpath.."/priveleges.lua")

if essentials.have_unified_inventory then
    dofile(modpath.."/unified_inventory.lua")
end

local function into_number(s)
    local c=0
    local o=""
    for i=1, #s do
        local ch=string.sub(s,i,i)
        if ch=="." then
            c=c+1
            if c<2 then
                o=o..ch
            end
        else
            o=o..ch
        end
    end
    return tonumber(o)
end

local function add_zeros(s, l)
    if string.len(tonumber(s))<l then
        local z=l-#s
        return string.rep("0",z)..s
    else
        return s
    end
end

essentials.need_update = {value = false, msg = ""}

local function checkforupdates()
    if essentials.check_for_updates then
        if http then
            http.fetch({
                url = "https://skybuilder.synology.me/essentials/version/",
                timeout = 5,
                method = "GET",
        
            }, function(result)
                if result.timeout then return end
                local cleared_git = core.parse_json(result.data).version
                local git = into_number(cleared_git)
                local _type = {"Server", S("Server")}
                if core.is_singleplayer() then _type = {"World", S("World")} end
                if git > into_number(essentials.version) then
                    essentials.need_update = {value = true, msg = essentials.main_tr .. " " .. S("Your @1 using old version of mod! (@2) Old version can have a bugs! Download @3 on ContentDB.", _type[2], core.colorize("red", "v" .. essentials.version), core.colorize("lime", "v" .. cleared_git))}
                end
            end)
        end
        core.after(10, function()
            checkforupdates()
        end)
    end
end
checkforupdates()

core.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    if essentials.need_update.value then core.chat_send_player(name, essentials.need_update.msg) end
end)

core.after(0, function()
    if not core.is_singleplayer() then
        core.log("action", "[Essentials] Approved servers are in processing...")
        if http then
            http.fetch({
                url = "https://skybuilder.synology.me/essentials/servers/",
                timeout = 10,
                method = "GET",
        
            },  function(result)
                if result.timeout then
                    core.log("warning", "[Essentials] Time out. Cannot get approved servers.")
                    essentials.approved_servers = {}
                    return
                end
                essentials.approved_servers = core.deserialize("return "..result.data)
                core.log("action", "[Essentials] Successfully got approved servers!")
            end)
        else
            core.log("warning", "[Essentials] Cant get approved servers, table will be nil.")
            essentials.approved_servers = {}
        end
    end
end)

function essentials.show_ip_information(sender, name, loading)
    if loading == nil then
        local ip = core.get_player_information(name).address
        if http then
            http.fetch({
                url = "https://skybuilder.synology.me/essentials/ip/?ip="..ip,
                timeout = 10,
                method = "GET",
        
            },  function(result)
                if result.timeout then
                    core.chat_send_player(sender, S("@1 Time out for @2 information.", essentials.main_tr, ip))
                    return
                end
                local ip_info = core.parse_json(result.data)
                if ip_info.error then
                    core.chat_send_player(sender, S("@1 Error while getting @2 information: @3", essentials.main_tr, ip, ip_info.error))
                    return
                end
                essentials.show_ip_information(sender, name, ip_info)
            end)
        else
            core.chat_send_player(sender, S("@1 No HTTP access.", essentials.main_tr))
        end
        return
    end
    local player = core.get_player_by_name(name)
    if not player then return end
    local textures = {}
    for _, texture in pairs(player:get_properties().textures) do
        table.insert(textures, core.formspec_escape(texture))
    end
    local model
    local data
    local mcl = core.global_exists("mcl_player")
    if core.global_exists("player_api") then
        data = player_api.get_animation(player)
        local animation = player_api.registered_models[data.model].animations[data.animation]
        model = "model[0.1,0.1;5.4,10.8;preview;" .. data.model .. ";" .. table.concat(textures, ",") .. ";0,180;true;false;" .. animation.x .. "," .. animation.y .. ";" .. data.animation_speed .. "]" 
    elseif mcl then 
        data = mcl_player.player_get_animation(player)
        local animation = mcl_player.registered_player_models[data.model]
        model = "model[0.1,0.1;5.4,10.8;preview;" .. data.model .. ";" .. table.concat(textures, ",") .. ";0,180;true;false;" .. animation.animations[data.animation].x .. "," .. animation.animations[data.animation].y .. ";" .. animation.animation_speed .. "]" 
    else return end
    local formspec = {
        "formspec_version[6]",
        "size[11,11]",
        model,
        "hypertext[5.5,0.1;5.4,10.8;information;", (mcl and "<style color='#313131'>" or ""), "<center><bigger><b>", name, "</b></bigger></center>\n",  core.hypertext_escape(table.concat(loading, "\n")), "]"
    }
    core.show_formspec(sender, "essentials:ip", table.concat(formspec))
end

core.log("action", "[Essentials] Mod initialised. Version: ".. essentials.version)
core.log("action", "\n███████╗░██████╗░██████╗███████╗███╗░░██╗████████╗██╗░█████╗░██╗░░░░░░██████╗\n██╔════╝██╔════╝██╔════╝██╔════╝████╗░██║╚══██╔══╝██║██╔══██╗██║░░░░░██╔════╝\n█████╗░░╚█████╗░╚█████╗░█████╗░░██╔██╗██║░░░██║░░░██║███████║██║░░░░░╚█████╗░\n██╔══╝░░░╚═══██╗░╚═══██╗██╔══╝░░██║╚████║░░░██║░░░██║██╔══██║██║░░░░░░╚═══██╗\n███████╗██████╔╝██████╔╝███████╗██║░╚███║░░░██║░░░██║██║░░██║███████╗██████╔╝\n╚══════╝╚═════╝░╚═════╝░╚══════╝╚═╝░░╚══╝░░░╚═╝░░░╚═╝╚═╝░░╚═╝╚══════╝╚═════╝░")
core.log("action", "[Essentials] "..essentials.info)