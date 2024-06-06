local FORMNAME = "essentials:rename_item"
local S = essentials.translate

function show_renameitem_menu(name)
    local player = minetest.get_player_by_name(name)
    local formspec = "formspec_version[6]"
    if player:get_wielded_item():get_name() == "" then
        minetest.chat_send_player(name, core.colorize("red", S("Cant rename an empty item.")))
        minetest.sound_play("error")
        return
    end

    local metaformat = player:get_meta():get_string("essentials_item_renamer_formatting")

	formspec = formspec..
        "size[9.6,9.6]"..
        "field[2.7,6.2;4.3,1.1;new_name;"..S("New name")..";]"..
        "button[0.1,8.3;9.4,1.2;rename;"..S("Rename").."]"..
        "image_button_exit[8.5,0.1;1,1;essentials_close_btn.png;close_btn;]"..
        "label[3.2,0.9;"..S("Hold item in hand then@1press @2 button.", "\n", "\""..S("Rename").."\"").."]"..
        "label[1.8,1.9;("..S("Empty name for reset name of the item")..")]"..
        "checkbox[3.7,4;format;"..S("Formatting")..";"..metaformat.."]"..
        "label[2.8,0.3;--="..S("How to rename item?").."=--]"..
        "tooltip[format;"..S("Allows you to use @1 code for make text more cooler!", "\"Minetest Lua\"").."]"

	minetest.show_formspec(name, FORMNAME, formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, field)
	if formname ~= FORMNAME then
		return
	end
    local itemstack = player:get_wielded_item()
	local meta = itemstack:get_meta()
    --local color = field.color
    minetest.sound_play("clicked", {to_player = name})

    if field.format ~= nil then
		local pmeta = player:get_meta()
		pmeta:set_string("essentials_item_renamer_formatting", field.format)
		return
	end

    if field.close_btn then
        minetest.sound_play("clicked")
		return
    end

    if not field.rename then return end

	local format = player:get_meta()
		:get_string("essentials_item_renamer_formatting")

	if format == "true" then
        local parsed = loadstring("return " .. field.new_name)
        meta:set_string("description", parsed())
    else
        meta:set_string("description", field.new_name)
    end

	--meta:set_string("color", field.color)
	player:set_wielded_item(itemstack)
    minetest.close_formspec(player:get_player_name(), formname)
end)