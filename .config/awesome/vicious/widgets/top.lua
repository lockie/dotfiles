
-- {{{ Grab environment
local setmetatable = setmetatable
local io = { popen = io.popen }
-- }}}

function split(inputstr, sep)
	t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

-- Top : provides most cpu eating process ($1), all procs ($2) and running ones ($3)
-- vicious.widgets.top
local top = {}

local function worker(format)
	local f = io.popen("ps --ppid 2 -p 2 --deselect --sort -%cpu --no-headers -o state,comm")
	if (f == nil) then return nil end
	local i = 0
	local all = 0
	local running = 0
	local most = ""
	for line in f:lines() do
		all = all+1
		c = split(line, " ")
		if (i == 0) then
			most = c[2]
		end
		if (c[1] == "R") then
			running = running+1
		end
		i = 1
	end
	f:close()
	return {most, all, running}
end

return setmetatable(top, { __call = function(_, ...) return worker(...) end })
