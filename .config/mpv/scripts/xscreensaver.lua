local utils = require 'mp.utils'
mp.add_periodic_timer(30, function()
    utils.subprocess({args={"xfce4-screensaver-command", "--poke"}})
end)
