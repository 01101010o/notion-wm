-- statusd_timebatt.lua (last modified 2015-07-18)
--
-- Public domain
--
-- battery time for Notion 
-- Tested on Manjaro Linux 3.17.8-1-Manjaro
-- More information: <01101010o@openmailbox.org> 
-- Use: copy this file to ~/.notion
--	add to cfg_statusbar.lua file
--	example: template = "[ %date || Time: %timebatt ]"
if not statusd_timebatt then
	statusd_timebatt = { interval = 10*1000 } --10 seconds
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
--Calculated time of discharge
	local AC = pipeCmd('cat /sys/class/power_supply/AC/online')
	local TIME
	if AC == '1' then
		TIME = 'None'
	else
		local now = pipeCmd('cat /sys/class/power_supply/BAT0/charge_now')
		local current = pipeCmd('cat /sys/class/power_supply/BAT0/current_now')
		local time = now/current
		local hours = math.floor(time)
		local mins = math.floor((time - hours)*60)
		TIME = string.format("%02d:%02d", hours, mins)
	end
	return TIME
end

local function update_timebatt()
	statusd.inform("timebatt", BATTERY())
	timebatt_timer:set(statusd_timebatt.interval, update_timebatt)
end

timebatt_timer = statusd.create_timer()
update_timebatt()
