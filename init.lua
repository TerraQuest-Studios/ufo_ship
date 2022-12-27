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
        self.object:set_rotation(vector.new(ufo_ship.deg_to_rad(ufo_ship.level_ship_offset), 0, 0))
    end,
    on_rightclick = function(self, clicker)
        if not clicker or not clicker:is_player() then return end

        --todo: sometimes player is plain stupid and doesnt sit player, figure out why
        if not self.driver then
            clicker:set_attach(self.object, "", vector.new(0,0.5,0.25), vector.new(-ufo_ship.level_ship_offset,180,0))
            clicker:set_properties({visual_size = vector.new(0.075,0.075,0.075)})
            player_api.player_attached[clicker:get_player_name()] = true
            player_api.set_animation(clicker, "sit", 0)
            clicker:set_properties({
                eye_height = 1.25
            })
            clicker:set_eye_offset(vector.new(0,0,-2.5))
            self.driver = clicker:get_player_name()
        elseif self.driver == clicker:get_player_name() then
            clicker:set_detach()
            player_api.player_attached[clicker:get_player_name()] = nil
            clicker:set_eye_offset(vector.new(0,0,0))
            clicker:set_properties({visual_size = vector.new(1,1,1)})
            self.driver = nil
        end
    end,
})