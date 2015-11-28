-- statusd_moc.lua (last modified 2015-07-02)
--
-- Public domain
--
-- moc minimalist status, artist/song for Notion 
-- Test on Manjaro Linux 3.17.8-1-Manjaro
-- More information: <01101010o@openmailbox.org>
-- Use: copy this file to ~/.notion
--	add to cfg_statusbar.lua file
--	example: template = "[ %date || Listen: %moc ]"
if not statusd_moc then
	statusd_moc = { interval = 1000 } -- 1 seconds
end

local function pipeCmd(cmd)
	local ret
	local command = io.popen(cmd)
	local tmp = command:read('*a')
	io.close(command)
	ret = string.gsub(tmp, "\n", "") -- Remove line break
	return ret
end
	
local function listen()
	local artist
	local song
	local listen
	local state
	local f=io.open(".moc/pid")
	if f then
		f:close()
		artist = pipeCmd("mocp -Q %artist")
		song = pipeCmd("mocp -Q %song")
		state = pipeCmd("mocp -Q %state")
		listen = artist.." - " ..song
		if state == "PLAY" then
			return "► "..listen
		else
			return "▮▮ "..listen
		end
	else return "■"
	end
end

local function update_moc()
	statusd.inform("moc", listen())
	moc_timer:set(statusd_moc.interval, update_moc)
end

moc_timer = statusd.create_timer()
update_moc()
