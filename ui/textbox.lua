<<<<<<< HEAD
local S = essentials.translate
local FORMNAME = "essentials:textbox"

-- Thanks to Bapt-tech for idea!
-- https://i.imgur.com/zVCmNOT.png

function show_textbox_player(name, label, textbox, owner)
	local formspec = "formspec_version[6]"..
        "size[10.5,8]"..
        "label[1.4,0.7;"..label.." "..S("(by @1)", owner).."]"..
        "image[0.2,0.2;1,1;essentials_warning.png]"..
        "button_exit[3.4,6.6;3.7,1.2;ok_button;OK]"..
        "textarea[0.5,1.5;9.5,4.9;textbox;;"..textbox.."]"

	minetest.show_formspec(name, FORMNAME, formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end
	return
=======
local S = essentials.translate
local FORMNAME = "essentials:textbox"

-- Thanks to Bapt-tech for idea!
-- https://i.imgur.com/zVCmNOT.png

function show_textbox_player(name, label, textbox, owner)
	local formspec = "formspec_version[6]"..
        "size[10.5,8]"..
        "label[1.4,0.7;"..label.." "..S("(by @1)", owner).."]"..
        "image[0.2,0.2;1,1;essentials_warning.png]"..
        "button_exit[3.4,6.6;3.7,1.2;ok_button;OK]"..
        "textarea[0.5,1.5;9.5,4.9;textbox;;"..textbox.."]"

	minetest.show_formspec(name, FORMNAME, formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end
	return
>>>>>>> 46b4032d79edf22a60b1f30c2835b9369e30fba1
end)