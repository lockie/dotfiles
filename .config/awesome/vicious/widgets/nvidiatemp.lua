
-- {{{ Grab environment
local setmetatable = setmetatable
local io = { popen = io.popen }
-- }}}

-- NvidiaTemp: provides nvidia card temperature
-- vicious.widgets.nvidiatemp
local nvidiatemp = {}

local function worker(format)
	local res = ""
	local f = io.popen("nvidia-settings -q gpucoretemp -t")
	if (f == nil) then return nil end
	for line in f:lines() do
		res = line
	end
	f:close()
	return {res}
end

return setmetatable(nvidiatemp, { __call = function(_, ...) return worker(...) end })
