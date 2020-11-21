---
-- gamestate_spec.lua


describe("Gamestate", function ()

    describe("initialize new game satate", function ()
        _G.love = {
            handlers = {}
        }

        it("empty table", function ()
            local gs = require "gamestate"
            local new_gamestate = gs.new()

            assert.is.Table(new_gamestate)
        end)

        teardown(function ()
            _G.love = nil
        end)
    end)

    describe("switch gamestate", function ()
        _G.love = {
            handlers = {}
        }

        teardown(function ()
            _G.love = nil
        end)
    end)
end)