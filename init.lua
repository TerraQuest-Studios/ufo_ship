ufo_ship = {
    speed = 1,
    max_speed = 10,
    turn_speed = 2,
    slow_factor = 0.99,
    level_ship_offset = -12.5,
    experimental_mode = false, --current for enabling lasers
}

function ufo_ship.deg_to_rad(x)
    return x * math.pi/180
end

dofile(minetest.get_modpath("ufo_ship") .. "/src/functions.lua")
dofile(minetest.get_modpath("ufo_ship") .. "/src/laser_bolt.lua")
dofile(minetest.get_modpath("ufo_ship") .. "/src/ufo.lua")