Set ws = CreateObject("wscript.shell")

wscript.sleep(1800)
ws.sendkeys("%y")

wscript.sleep(500)
ws.sendkeys("{ENTER}")
