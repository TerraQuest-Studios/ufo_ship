local tex = "[combine:16x16^[noalpha^[colorize:red^[opacity:150";
minetest.register_entity("ufo_ship:laser_bolt", {
    initial_properties = {
        visual = "cube",
        visual_size = vector.new(1.5, 0.1, 0.1),
        textures = {tex, tex, tex, tex, tex, tex},
        use_texture_alpha = true,
        physical = true,
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
            ufo_ship.tnt.graphics_boom(self.object:get_pos())
            self.object:remove()
        end

        --TODO: use move result and blow up or something
        if moveresult.collides then
            local pos
            if moveresult.collisions[1].type == "node" then
                pos = moveresult.collisions[1].node_pos
            elseif moveresult.collisions[1].type == "object" then
                pos = moveresult.collisions[1].object:get_pos()
            end
            self.object:remove()

            if pos then ufo_ship.tnt.boom(pos) end
        end
    end,
})