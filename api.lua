function essentials.play_sound(sound)
    if not sound then return end
    for _, p in ipairs(core.get_connected_players()) do
        core.sound_play("essentials_"..sound, p:get_player_name())
    end
end

function essentials.player_sound(sound, name)
    if not name then return end
    if not sound then return end
    core.sound_play("essentials_"..sound, name)
end