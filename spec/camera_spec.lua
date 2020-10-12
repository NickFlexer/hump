---
-- camera_spec.lua


describe("Camera", function ()

    local camera = require "camera"

    describe("initialize", function ()
        _G.love = {
            graphics = {
                getWidth = function () return 10 end,
                getHeight = function () return 20 end
            }
        }

        it("with default params", function ()
            mock(_G.love)

            local c = camera.new()
            assert.is.Table(c)
            assert.is.equal(c.x, 5)
            assert.is.equal(c.y, 10)
            assert.is.equal(c.scale, 1)
            assert.is.equal(c.rot, 0)
            assert.is.Function(c.smoother)

            mock.revert(_G.love)
        end)

        it("with custom params", function ()
            local c = camera.new(1, 2, 3, 4, function () end)
            assert.is.Table(c)
            assert.is.equal(c.x, 1)
            assert.is.equal(c.y, 2)
            assert.is.equal(c.scale, 3)
            assert.is.equal(c.rot, 4)
            assert.is.Function(c.smoother)
        end)

        teardown(function()
            _G.love = nil
        end)
    end)

    describe("look at", function ()
        it("set", function ()
            local c = camera(100, 100)
            local nc = c:lookAt(50, 60)
            local x, y = nc:position()
            assert.is.Table(nc)
            assert.is.equal(x, 50)
            assert.is.equal(y, 60)
        end)
    end)

    describe("move", function ()
        it("positive", function ()
            local c = camera.new(10, 10)
            local nc = c:move(2, 3)
            local x, y = nc:position()
            assert.is.Table(nc)
            assert.is.equal(x, 12)
            assert.is.equal(y, 13)
        end)

        it("negative", function ()
            local c = camera.new(10, 10)
            local nc = c:move(-2, -3)
            local x, y = nc:position()
            assert.is.Table(nc)
            assert.is.equal(x, 8)
            assert.is.equal(y, 7)
        end)
    end)

    describe("rotate", function ()
        it("set", function ()
            local c = camera.new(10, 10, 1, 1)
            local nc = c:rotate(1)
            assert.is.Table(nc)
            assert.is.equal(nc.rot, 2)
        end)
    end)

    describe("rotate to", function ()
        it("set", function ()
            local c = camera.new(10, 10, 1, 1)
            local nc = c:rotateTo(-100)
            assert.is.Table(nc)
            assert.is.equal(nc.rot, -100)
        end)
    end)

    describe("zoom", function ()
        it("set", function ()
            local c = camera.new(10, 10, 2)
            local nc = c:zoom(3)
            assert.is.Table(nc)
            assert.is.equal(nc.scale, 6)
        end)
    end)

    describe("zoom to", function ()
        local c = camera.new(10, 10, 2)
            local nc = c:zoomTo(3)
            assert.is.Table(nc)
            assert.is.equal(nc.scale, 3)
    end)

    describe("attach", function ()
        _G.love = {
            graphics = {
                getScissor = function () return 10, 10, 20, 20 end,
                getWidth = function () return 100 end,
                getHeight = function () return 200 end,
                setScissor = function () end,
                push = function () end,
                translate = function () end,
                scale = function () end,
                rotate = function () end
            }
        }

        it("with default params", function ()
            mock(_G.love)

            local c = camera.new(1, 1, 3, 4)
            c:attach()

            assert.stub(love.graphics.setScissor).was_called_with(0, 0, 100, 200)
            assert.stub(love.graphics.translate).was.called(2)
            assert.stub(love.graphics.translate).was_called_with(50, 100)
            assert.stub(love.graphics.translate).was_called_with(-1, -1)
            assert.stub(love.graphics.scale).was_called_with(3)
            assert.stub(love.graphics.rotate).was_called_with(4)

            mock.revert(_G.love)
        end)

        it("with custom params", function ()
            mock(_G.love)

            local c = camera.new(1, 1, 3, 4)
            c:attach(10, 10, 20, 20)

            assert.stub(love.graphics.setScissor).was_called_with(10, 10, 20, 20)
            assert.stub(love.graphics.translate).was.called(2)
            assert.stub(love.graphics.translate).was_called_with(20, 20)
            assert.stub(love.graphics.translate).was_called_with(-1, -1)
            assert.stub(love.graphics.scale).was_called_with(3)
            assert.stub(love.graphics.rotate).was_called_with(4)

            mock.revert(_G.love)
        end)

        teardown(function()
            _G.love = nil
        end)
    end)

    describe("detach", function ()
        _G.love = {
            graphics = {
                getScissor = function () return 10, 20, 30, 40 end,
                getWidth = function () return 100 end,
                getHeight = function () return 200 end,
                push = function () end,
                translate = function () end,
                scale = function () end,
                rotate = function () end,
                pop = function () end,
                setScissor = function () end
            }
        }

        it("after attach() call", function ()
            mock(_G.love)

            local c = camera.new(1, 1)
            c:attach()
            c:detach()

            assert.stub(love.graphics.pop).was.called(1)
            assert.stub(love.graphics.setScissor).was_called_with(10, 20, 30, 40)

            mock.revert(_G.love)
        end)

        it("without attach() call", function ()
            mock(_G.love)

            local c = camera.new(1, 1)
            c:detach()

            assert.stub(love.graphics.pop).was.called(1)
            assert.stub(love.graphics.setScissor).was_called_with(nil, nil, nil, nil)

            mock.revert(_G.love)
        end)

        teardown(function()
            _G.love = nil
        end)
    end)

    describe("draw", function ()
        _G.love = {
            graphics = {
                getScissor = function () return 10, 20, 30, 40 end,
                getWidth = function () return 100 end,
                getHeight = function () return 200 end,
                push = function () end,
                translate = function () end,
                scale = function () end,
                rotate = function () end,
                pop = function () end,
                setScissor = function () end
            }
        }

        it("use draw function", function ()
            mock(_G.love)

            local f = spy.new(function () end)

            local c = camera.new(1, 1)
            c:draw(f)

            assert.spy(f).was.called()
            assert.stub(love.graphics.setScissor).was_called_with(0, 0, 100, 200)

            mock.revert(_G.love)
        end)

        it("use drawable box and draw function", function ()
            mock(_G.love)

            local f = spy.new(function () end)

            local c = camera.new(1, 1)
            c:draw(1, 2, 3, 4, f)

            assert.spy(f).was.called()
            assert.spy(love.graphics.setScissor).was.called(2)
            assert.stub(love.graphics.setScissor).was_called_with(1, 2, 3, 4)

            mock.revert(_G.love)
        end)

        it("use drawable box and noclip arg", function ()
            mock(_G.love)

            local f = spy.new(function () end)

            local c = camera.new(1, 1)
            c:draw(1, 2, 3, 4, true, f)

            assert.spy(f).was.called()
            assert.spy(love.graphics.setScissor).was.called(1)

            mock.revert(_G.love)
        end)

        it("without args", function ()
            local c = camera.new(1, 1)
            assert.has_error(function () c:draw() end, "Invalid arguments to camera:draw()")
        end)

        it("single arg is not function", function ()
            local expected_string = "attempt to call local 'func' (a string value)"

            if _VERSION:match("%d+%.%d+") == "5.3" then
                expected_string = "attempt to call a string value (local 'func')"
            end

            local c = camera.new(1, 1)
            assert.has_error(function () c:draw("aaaa") end, expected_string)
        end)

        teardown(function()
            _G.love = nil
        end)
    end)
end)
