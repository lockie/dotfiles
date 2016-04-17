-- {{{ Grab environment
local type = type
local tonumber = tonumber
local io = { popen = io.popen }
local setmetatable = setmetatable
local helpers = require("vicious.helpers")
local SLAXML = require 'slaxdom' -- also requires slaxml.lua; be sure to copy both files
-- }}}


-- Gmail: provides count of new and subject of last e-mail on Gmail
-- vicious.widgets.gmail
local gmail = {}


-- {{{ Variable definitions
local rss = {
  inbox   = {
    "https://mail.google.com/mail/feed/atom",
    "Gmail %- Inbox"
  },
  unread  = {
    "https://mail.google.com/mail/feed/atom/unread",
    "Gmail %- Label"
  },
  --labelname = {
  --  "https://mail.google.com/mail/feed/atom/labelname",
  --  "Gmail %- Label"
  --},
}

-- Default is just Inbox
local feed = rss.inbox
local mail = {
    ["{count}"]   = 0,
    ["{subject}"] = "N/A"
}
-- }}}


-- {{{ Gmail widget type
local function worker(format, warg)
    -- Get info from the Gmail atom feed
    local f = io.popen("curl --retry 3 --connect-timeout 2 -m 3 -fsn " .. feed[1])

    local cont = f:read('*all')
    if cont == "" then
        return mail
    end
    local doc = SLAXML:dom(cont)
    local count = 0
    local title = nil
    for _, el in ipairs(doc.root.kids) do
        if el.name == "entry" then
            count = count + 1
            if title == nil then
                for _, p in ipairs(el.kids) do
                    if p.name == "title" then
                        if p.kids[1] == nil then
                            title = "(no subject)"
                        else
                            title = p.kids[1].value
                        end
--                        if type(warg) == "table" then
--                            title = helpers.scroll(title, warg[1], warg[2])
--                        else
--                            title = helpers.truncate(title, warg)
--                        end
                    end
                end
            end
        end
    end
    mail["{count}"] = count
    if title ~= nil then
        mail["{subject}"] = helpers.escape(title)
    end

    f:close()

    return mail
end
-- }}}

return setmetatable(gmail, { __call = function(_, ...) return worker(...) end })
