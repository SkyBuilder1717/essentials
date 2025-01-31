local FORMNAME = "essentials:troll_menu"
local nodes = {
	{"Glass", "default:glass"},
	{"Obsidian", "default:obsidian"},
	{"Bedrock", "nextgen_bedrock:bedrock"},
}
local S = essentials.translate

local msgr = "["..core.colorize("red", S("TROLL"))..core.colorize("#00ffff", "v"..essentials.version).."] "

local function to_number(s)
    local c = 0
    local r = ""
    for i = 1, #s do
        local ch = string.sub(s, i, i)
        if ch == "." then
            c = c + 1
            if c < 2 then
                r = r..ch
            end
        else
            r = r..ch
        end
    end
    return tonumber(r)
end

function essentials.show_troll_menu(name, custom)
	local formspec = "formspec_version[6]"
	local ids = ""
	for i, player in ipairs(core.get_connected_players()) do
		ids = ids..","..player:get_player_name()
	end

	local traps = ""
	if core.get_modpath("default") then
		traps = traps..","..S("In").." "..S("Glass")..","..S("In").." "..S("Obsidian")
		if core.get_modpath("nextgen_bedrock") then
			traps = traps..","..S("In").." "..S("Bedrock")
		end
	elseif core.get_modpath("mcl_core") then
		traps = traps..","..S("In").." "..S("Glass")..","..S("In").." "..S("Obsidian")..","..S("In").." "..S("Bedrock")
		nodes = {
			{"Glass", "mcl_core:glass"},
			{"Obsidian", "mcl_core:obsidian"},
			{"Bedrock", "mcl_core:bedrock"},
		}
	end

	formspec = formspec..
		"size[10.5,7.7]"..
		"image[4.1,0.5;2.2,2.2;essentials_troll.png]"..
		"label[4.4,0.3;"..S("Troll").." "..S("Menu").."]"..
		"button[0.2,5.2;3,0.8;punch;"..S("Punch player").."]"..
		"button[3.4,5.2;3.7,0.8;launch;"..S("Launch player").."]"..
		"button[3.4,6.2;3.7,0.8;trap;"..S("Trap player in...").."]"..
		"dropdown[3.4,3.6;3.7,0.7;player;"..ids..";1;false]"..
		"label[3.5,3.4;"..S("Select player for trolling").."]"..
		"dropdown[3.4,7;3.7,0.5;trap_in;"..traps..";1;true]"..
		"label[0.1,0.3;"..S("Version: @1", essentials.version).."]"

	if core.features.sound_params_start_time then
		formspec = formspec..
			"button[7.3,6.2;3,0.8;freeze;"..S("Freeze player").."]"..
			"field[7.3,5.2;3,0.8;freeze_seconds;"..S("Freeze for...")..";10]"
	end

	formspec = formspec..
		"tooltip[punch;"..S("Punches selected player to opposite side of hes look").."]"..
		"tooltip[freeze;"..S("Freezes movement of the selected player for specified seconds under").."\n("..S("Also if you press this button for already freezed player, its unfreeze player")..")]"..
		"tooltip[freeze_seconds;"..S("Seconds for freeezing selected player").."]"..
		"tooltip[trap;"..S("Traps selected player in selected blocks under").."]"..
		"tooltip[trap_in;"..S("Blocks for trap the selected player").."]"..
		"tooltip[launch;"..S("Launch player in space").."]"..
		"tooltip[player;"..S("Selected player for trolling").."]"

	core.show_formspec(name, FORMNAME, formspec)
end

local function punch_time(player, puch)
	for i = 1, 30 do
		local dir = player:get_look_dir()
		local vel = {}
		for name, value in pairs(dir) do
			vel[name] = (-value) * 2
		end
		core.after(puch * i, function()
			player:add_velocity(vel)
		end)
	end
end

local function trap_in(player, block)
	local pos = player:get_pos()
	pos = {x = math.round(pos.x), y = math.round(pos.y), z = math.round(pos.z)}
	player:set_pos(pos)
	core.set_node({x = pos.x+1, y = pos.y, z = pos.z}, {name=block})
	core.set_node({x = pos.x-1, y = pos.y, z = pos.z}, {name=block})
	core.set_node({x = pos.x, y = pos.y, z = pos.z+1}, {name=block})
	core.set_node({x = pos.x, y = pos.y, z = pos.z-1}, {name=block})
	core.set_node({x = pos.x, y = pos.y-1, z = pos.z}, {name=block})
	core.set_node({x = pos.x, y = pos.y+2, z = pos.z}, {name=block})
end

local function freeze_it(fields, bool, name)
	local player = core.get_player_by_name(name)
	local look = {
		ver = player:get_look_vertical(),
		hor = player:get_look_horizontal(),
	}
	local meta = player:get_meta()
	local pos = player:get_pos()
	local seconds = tonumber(fields.freeze_seconds)
	if not bool then
		player:set_physics_override({
			speed = 1,
			speed_walk = 1,
			speed_climb = 1,
			speed_crouch = 1,
			speed_fast = 1,
			jump = 1,
			gravity = 1,
			liquid_fluidity = 1,
			liquid_fluidity_smooth = 1,
			liquid_sink = 1,
			acceleration_default = 1,
			acceleration_air = 1,
			acceleration_fast = 1,
			sneak = true,
			sneak_glitch = false,
			new_move = true,
		})
		meta:set_string("_essentials__troll__is_freezed_troll", "")
		core.chat_send_player(name, msgr..S("Player @1 has been unfreezed.", fields.player))
		return
	end
	--core.chat_send_all(dump(look))
	meta:set_string("_essentials__troll__looky", core.serialize(look))
	meta:set_string("_essentials__troll__position_troll", core.serialize(pos))
	meta:set_string("_essentials__troll__is_freezed_troll", "true")
	player:set_physics_override({
		speed = 0,
		speed_walk = 0,
		speed_climb = 0,
		speed_crouch = 0,
		speed_fast = 0,
		jump = 0,
		gravity = 0,
		liquid_fluidity = 0,
		liquid_fluidity_smooth = 0,
		liquid_sink = 0,
		acceleration_default = 0,
		acceleration_air = 0,
		acceleration_fast = 0,
		sneak = false,
		sneak_glitch = true,
		new_move = false,
	})
	player:set_pos(pos)
	core.chat_send_player(name, msgr..S("Player @1 has freezed for @2 second(-s).", fields.player, seconds))
	core.after(seconds, function()
		if meta:get_string("_essentials__troll__is_freezed_troll") == "" then
			return
		end
		player:set_physics_override({
			speed = 1,
			speed_walk = 1,
			speed_climb = 1,
			speed_crouch = 1,
			speed_fast = 1,
			jump = 1,
			gravity = 1,
			liquid_fluidity = 1,
			liquid_fluidity_smooth = 1,
			liquid_sink = 1,
			acceleration_default = 1,
			acceleration_air = 1,
			acceleration_fast = 1,
			sneak = true,
			sneak_glitch = false,
			new_move = true,
		})
		meta:set_string("_essentials__troll__is_freezed_troll", "")
	end)
end

local function troll_message(fields, name)
	if essentials.trolled_by then
		core.chat_send_player(fields.player, S("You have been trolled by @1.", name))
	end
end

core.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end
	local name = player:get_player_name()
	essentials.player_sound("clicked", name)

    if (fields.player == nil) or (fields.player == "") then
        return
    end
    if core.get_player_by_name(fields.player) == nil then
        return
    end
	local player = core.get_player_by_name(fields.player)
	local pos = player:get_pos()
	if fields.punch then
		punch_time(player, 0.01)
		core.chat_send_player(name, msgr..S("Player @1 punched.", fields.player))
	end
	if fields.launch then
		player:add_velocity({x=1,y=75,z=0})
		core.chat_send_player(name, msgr..S("Player @1 launched in space.", fields.player))
	end
	if fields.freeze then
		if player:get_meta():get_string("_essentials__troll__is_freezed_troll") ~= "" then
			freeze_it(fields, nil, name)
			return
		end
		freeze_it(fields, true, name)
	end
	if fields.trap then
		if tonumber(fields.trap_in) == 1 then
			return
		end
		local def = nodes[tonumber(fields.trap_in)-1]
		trap_in(player, def[2])
		core.chat_send_player(name, msgr..S("Player @1 trapped in @2.", fields.player, S(def[1])))
		troll_message()
	end
end)

core.register_globalstep(function(dtime)
	for _, player in ipairs(core.get_connected_players()) do
		local meta = player:get_meta()
		local look = core.deserialize(meta:get_string("_essentials__troll__looky"))
		local ppos = core.deserialize(meta:get_string("_essentials__troll__position_troll"))
		if meta:get_string("_essentials__troll__is_freezed_troll") ~= "" then
			player:set_look_vertical(look.ver)
			player:set_look_horizontal(look.hor)
			player:set_pos(ppos)
			player:set_velocity({x=0,y=0,z=0})
		end
	end
end)