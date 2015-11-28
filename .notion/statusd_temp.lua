-- statusd_temp.lua (last modified 2015-07-20)
--
-- Public domain
--
-- More information: <01101010o@openmailbox.org>
-- Use: copy this file to ~/.notion
--	add to cfg_statusbar.lua file
--	example: template = "[ %date || %temp ]"
if not statusd_temp then
	statusd_temp = { interval = 10*1000 } -- 10 seconds
end

local function pipeCmd(cmd)
	local ret
	local command = io.popen(cmd)
	local tmp = command:read('*a')
	io.close(command)
	ret = string.gsub(tmp, "\n", "") -- Remove line break
	return ret
end

local function THERMAL()
	local TEMPK = pipeCmd('cat /sys/class/thermal/thermal_zone0/temp')
	local TEMP = math.floor(TEMPK/1000)
	return TEMP
end

local function update_temp()
	statusd.inform("temp", THERMAL() .. "°C")
	if tonumber(THERMAL()) > 80 then
		statusd.inform("temp_hint", "critical")
	elseif tonumber(THERMAL()) > 60 then
		statusd.inform("temp_hint", "important")
	else
		statusd.inform("temp_hint", "normal")
	end
	temp_timer:set(statusd_temp.interval, update_temp)
end

temp_timer = statusd.create_timer()
update_temp()
