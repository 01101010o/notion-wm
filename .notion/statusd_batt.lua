-- statusd_batt.lua (last modified 2015-07-18)
--
-- Public domain
--
-- battery percentage for Notion 
-- Tested on Manjaro Linux 3.17.8-1-Manjaro
-- More information: <01101010o@openmailbox.org> 
-- Use: copy this file to ~/.notion
--	add to cfg_statusbar.lua file
--	example: template = "[ %date || BATT: %batt ]"
if not statusd_batt then
	statusd_batt = { interval = 10*1000 } --10 seconds
end

local function pipeCmd(cmd)
	local ret
	local command = io.popen(cmd)
	local tmp = command:read('*a')
	io.close(command)
	ret = string.gsub(tmp, "\n", "") -- Remove line break
	return ret
end

local function BATTERY() 
--Calculated percentage
	local PERCENTAGE = pipeCmd('cat /sys/class/power_supply/BAT0/capacity')
	return PERCENTAGE
end

local function update_batt()
	statusd.inform("batt", BATTERY() .. "%")
	if tonumber(BATTERY()) <= 10 then	-- 10%
		statusd.inform("batt_hint", "critical")
	elseif tonumber(BATTERY()) < 100 then	-- < 100%
		statusd.inform("batt_hint", "important")
	else					-- 100%
		statusd.inform("batt_hint", "normal")
	end
	batt_timer:set(statusd_batt.interval, update_batt)
end

batt_timer = statusd.create_timer()
update_batt()
