ufo_ship = {
    max_speed = 5,
    level_ship_offset = -12.5
}

function ufo_ship.deg_to_rad(x)
    return x * math.pi/180
end

minetest.register_entity("ufo_ship:ufo", {
    initial_properties = {
        visual = "mesh",
        mesh = "ufo_ship_ship.obj",
        visual_size = vector.new(10, 10, 10),
        textures = {"ufo_ship_ship.png"},
    },
    on_activate = function(self, staticdata, dtime_s)
        self.object:set_rotation(vector.new(ufo_ship.deg_to_rad(ufo_ship.level_ship_offset),0,0))
    end,
})