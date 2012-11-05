local string = { match = string.match, format = string.format }
local table = { insert = table.insert }
local os = { date = os.date }
local capi = { timer = timer,
			   image = image }
local naughty = require("naughty")
local awful = require("awful")

module("weather")

local weatherbase = {}
local weatherFormat = '<span font="Terminus 9">%s</span>'

-- Getting the weather information about the city
function getWeather(city)
	local parse = awful.util.pread("curl connect-timeout 1 -fsm 3 http://pogoda.yandex.ru/"..city.."/")
	weatherbase[city].weather = {
		--["cityname"]	= string.match(parse, "") or "Welcome to City-17. It's safer here.",
		["wthtype"]	= string.match(parse, "big\">(.-)<") or "Тревога!",
		["sunrise"]	= string.match(parse, "Восход: </span>(.-)<"),
		["sunset"]	= string.match(parse, "Заход: </span>(.-)<"),
		["temp"]	= string.match(parse, "thermometer__now\">(.-)<") or '<span color="#ff892c"> ! </span>',
		["rhum"]	= string.match(parse, "Влажность: </span>(.-)<") or "Интернет пропал!",
		["winddir"]	= string.match(parse, "Ветер: </span>(.-) м/с") or "Штиль",
--		["wind"]	= string.match(parse, "([%d].[%d] м/с)") or "ветер молчит..."
		}
end

-- Setting the weather icon according to the weather type and time of day (day/night)
function wthIcon(wthtype, sunrise, sunset)
	local day = false
	local daytime = os.date("%H:%M")
	local confdir = awful.util.getdir("config")

	if sunrise and sunset
	and (daytime >= sunrise)
	and (daytime < sunset)
	then day = true end

	if (wthtype == "ясно") then
		if day then return confdir.."/weather_icons/clear.png"
		else return confdir.."/weather_icons/clear-night.png" end

	elseif (wthtype == "полупрозрачная облачность")
		or (wthtype == "переменная облачность")
		or (wthtype == "облачность с просветами")
		or (wthtype == "облачно с прояснениями")
		or (wthtype == "малооблачно") then
		if day then return confdir.."/weather_icons/clouds.png"
		else return confdir.."/weather_icons/clouds-night.png" end

	elseif (wthtype == "облачно")
		or (wthtype == "пасмурно")
		or (wthtype == "туман") then
		return confdir.."/weather_icons/overcast.png"

	elseif (wthtype == "слабая морось")
		or (wthtype == "слабый дождь") then
		return confdir.."/weather_icons/drizzle.png"

	elseif (wthtype == "небольшой дождь")
		or (wthtype == "переменная облачность, небольшой дождь")
		or (wthtype == "облачно, небольшой дождь") then
		return confdir.."/weather_icons/rain.png"

	elseif (wthtype == "дождь")
		or (wthtype == "переменная облачность, дождь")
		or (wthtype == "облачно, дождь")
		or (wthtype == "ливневый дождь") then
		return confdir.."/weather_icons/shower.png"

	elseif (wthtype == "гроза")
		or (wthtype == "дождь, гроза") then
		return confdir.."/weather_icons/storm.png"

	elseif (wthtype == "небольшой снег")
		or (wthtype == "переменная облачность, небольшой снег")
		or (wthtype == "облачно, небольшой снег") then
		return confdir.."/weather_icons/light-snow.png"

	elseif (wthtype == "снег") then
		return confdir.."/weather_icons/snow.png"

	else
		return confdir.."/weather_icons/severe-alert.png"
	end
end

-- Just formatting the data a little to display it in a notification
function wthText(wthtype, rhum, winddir, wind)
	return wthtype.."\n".. "Влажность:" ..rhum.."\n".. "Ветер:" .. winddir .. " м/с"
end

-- Updating weather data
function updateWeather(city)
	getWeather(city)
	local w = weatherbase[city]

	for i=1, #w.widgets do
		w.widgets[i].text = string.format(weatherFormat, w.weather.temp)
		w.widgets[i].image = capi.image(wthIcon(w.weather.wthtype, w.weather.sunrise, w.weather.sunset))
	end

	if w.wthinfo then
		w.wthinfo.box.widgets[2].text = wthText(w.weather.wthtype, w.weather.rhum, w.weather.winddir )
		w.wthinfo.box.widgets[1].image = capi.image(wthIcon(w.weather.wthtype, w.weather.sunrise, w.weather.sunset))
	end
end

-- Adding a weather monitoring to the widget
function addWeather(widget, city, timeout)
	if not widget or weatherbase[widget] ~= nil then return end
	local city = city or "27612"
	weatherbase[widget] = city

	if not weatherbase[city] then
		weatherbase[city] = {}
		weatherbase[city].widgets = {}
	end

	table.insert(weatherbase[city].widgets, widget)

	updateWeather(city)

	weathertimer = capi.timer { timeout = timeout or 907 }
	weathertimer:add_signal("timeout",	function() updateWeather(city)		end)
	weathertimer:start()

	widget:add_signal("mouse::enter",	function() local w = weatherbase[city]
													w.wthinfo = naughty.notify({
														--title = w.weather.cityname,
														text = wthText(w.weather.wthtype, w.weather.rhum, w.weather.winddir, w.weather.wind),
														icon = wthIcon(w.weather.wthtype, w.weather.sunrise, w.weather.sunset),
														timeout = 0,
														hover_timeout = 0.5,
														})					end)
	widget:add_signal("mouse::leave",	function() naughty.destroy(weatherbase[city].wthinfo)	end)
	widget:buttons(awful.util.table.join(
					awful.button({}, 1, function() updateWeather(city)		end)))
end
