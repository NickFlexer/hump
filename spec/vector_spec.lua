---
-- vector_spec.lua


describe("Vector", function ()

    local vector = require "vector"

    describe("create new", function ()
        it("call with new()", function ()
            local v = vector.new(10, 20)

            assert.is.Table(v)
            assert.is.Number(v.x)
            assert.is.Number(v.y)
            assert.are.equal(v.x, 10)
            assert.are.equal(v.y, 20)
        end)

        it("call as function", function ()
            local v = vector(10, 20)

            assert.is.Table(v)
            assert.is.Number(v.x)
            assert.is.Number(v.y)
            assert.are.equal(v.x, 10)
            assert.are.equal(v.y, 20)
        end)

        it("default vector", function ()
            local v = vector()

            assert.is.Table(v)
            assert.is.Number(v.x)
            assert.is.Number(v.y)
            assert.are.equal(v.x, 0)
            assert.are.equal(v.y, 0)
        end)
    end)

    describe("is vector", function ()
        it("valid default vector", function ()
            local v = vector()
            assert.is.True(vector.isvector(v))
        end)

        it("valid custom vector", function ()
            local v = vector(0.88888, 67876768)
            assert.is.True(vector.isvector(v))
        end)

        it("not a vector", function ()
            local v = "vector(0.88888, 67876768)"
            assert.is.False(vector.isvector(v))
        end)

        it("invalid coordinates", function ()
            local v = vector(0.1, "")
            assert.is.False(vector.isvector(v))
        end)

        it("table", function ()
            local v = {}
            assert.is.False(vector.isvector(v))
        end)
    end)
end)