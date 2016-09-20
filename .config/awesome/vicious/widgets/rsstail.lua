
local io = { popen = io.popen }
local string = {
    sub = string.sub,
    gfind = string.gfind
}
local table = {
    insert = table.insert
}

local function split(str, delim)
    local result,pat,lastPos = {},"(.-)" .. delim .. "()",1
    for part, pos in string.gfind(str, pat) do
        table.insert(result, part); lastPos = pos
    end
    table.insert(result, string.sub(str, lastPos))
    return result
end

local rsstail = {}

local function worker(format, warg)
    local data = {
        ["{title}"]   = "N/A",
        ["{link}"] = ""
    }

    local f = io.popen("rsstail -z -n 1 -N -1 -l -u " .. warg)

    local cont = f:read('*all')
    if cont == "" then
        return data
    end

    local raw_data = split(cont, "\n")
    if raw_data[1] ~= nil then
        data["{title}"] = awful.util.escape(raw_data[1])
    end
    if raw_data[2] ~= nil then
        data["{link}"] = raw_data[2]
    end

    f:close()

    return data
end

return setmetatable(rsstail, { __call = function(_, ...) return worker(...) end })
