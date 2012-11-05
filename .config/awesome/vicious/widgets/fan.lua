
-- {{{ Grab environment
local setmetatable = setmetatable
local io = { open = io.open }
-- }}}

-- Fan: provides cpu/motherboard fan speed
-- vicious.widgets.fan
local fan = {}

local function worker(format, warg)
	if warg == nil then warg = 1 end
	local file = io.open("/sys/devices/platform/it87.656/fan" .. warg .. "_input", "r")
	if (file == nil) then
		return nil
	end
	local fanspeed = file:read("*n")
	file:close()

	return {fanspeed}
end

return setmetatable(fan, { __call = function(_, ...) return worker(...) end })
