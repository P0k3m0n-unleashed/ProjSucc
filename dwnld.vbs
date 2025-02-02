Set ws = CreateObject("wscript.shell")

ws.run("edge browser")
wscript.sleep(1000)

' % = Alt
ws.sendkeys("%d")
ws.sendkeys("github.com")

' {} Denote keys
ws.sendkeys("{ENTER}")
wscript.sleep(5000)

' ^ = ctrl
ws.sendkeys("^t")
ws.sendkeys("^{TAB}")
ws.sendkeys("^w")