defbindings("WMPlex.toplevel", {
	---Brillo
	kpress("XF86MonBrightnessDown","ioncore.exec_on(_, 'xbacklight -dec 10%')"),
	kpress("XF86MonBrightnessUp","ioncore.exec_on(_, 'xbacklight -inc 10%')"),
	---moc
	kpress("XF86AudioPrev","ioncore.exec_on(_, 'mocp -r')"),
	kpress("XF86AudioPlay","ioncore.exec_on(_, 'mocp -G')"),
	kpress("XF86AudioNext","ioncore.exec_on(_, 'mocp -f')"),
	---control de volumen
	kpress("XF86AudioRaiseVolume","ioncore.exec_on(_, 'amixer set Master 2%+')"),
	kpress("XF86AudioLowerVolume","ioncore.exec_on(_, 'amixer set Master 2%-')"),
	kpress("XF86AudioMute","ioncore.exec_on(_, 'amixer set Master toggle')"),
	kpress("Print","ioncore.exec_on(_, 'import -window root screan.png')"),
	---Program
	kpress(META.."F","ioncore.exec_on(_, 'firefox')"),
})

