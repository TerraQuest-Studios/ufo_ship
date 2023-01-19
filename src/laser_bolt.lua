local tex = "[combine:16x16^[noalpha^[colorize:red^[opacity:150";
minetest.register_entity("ufo_ship:laser_bolt", {
    initial_properties = {
        visual = "cube",
        visual_size = vector.new(1.5, 0.1, 0.1),
        textures = {tex, tex, tex, tex, tex, tex},
        use_texture_alpha = true,
    },
    on_activate = function(self, staticdata, dtime_s)
        self.ttl = self.ttl or 3
    end,
    on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir, damage)
        self.object:remove()
    end,
    on_step = function(self, dtime, moveresult)
        self.ttl = self.ttl - dtime
        if self.ttl < 0 then
            self.object:remove()
        end

        --TODO: use move result and blow up or something
    end,
})