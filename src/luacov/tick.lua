_G.__SKYNET_LUACOV_COVERAGE_DATA = {}
_G.__SKYNET_LUACOV_COVERAGE_DATA_WRITE_FLAG = false

local skynet = require("skynet")
local stats = require("luacov.stats")

--- Load luacov using this if you want it to periodically
-- save the stats file. This is useful if your script is
-- a daemon (i.e., does not properly terminate).
-- @class module
-- @name luacov.tick
-- @see luacov.defaults.savestepsize
return {
    init = function ()
        local runner = require("luacov.runner")
        runner.tick = true
        runner.init()

        --- overwrite exit
        local old_exit = skynet.exit
        local new_exit = function()
            stats.save(runner.configuration.statsfile, _G.__SKYNET_LUACOV_COVERAGE_DATA)
            old_exit()
        end
        skynet.exit = new_exit

        --- overwrite kill
        local old_kill = skynet.kill
        local new_kill = function()
            stats.save(runner.configuration.statsfile, _G.__SKYNET_LUACOV_COVERAGE_DATA)
            old_kill()
        end
        skynet.kill = new_kill
    end
}
