--init.lua
SSID    = "YourWifiNetworkName"
APPWD   = "YourWifiNetworkPassword"
STATICIP = true
IPADR = "192.168.0.12" 
IPROUTER = "192.168.0.1" 
IPNETMASK = "255.255.255.0"
CMDFILE = "handler.lua"   -- File that is executed after connection

wifiTrys     = 15     -- Counter of trys to connect to wifi
NUMWIFITRYS  = 200    -- Maximum number of WIFI Testings while waiting for connection
LAUNCHEDFILE = false

ledPin = 7;
gpio.mode(ledPin, gpio.OUTPUT);
gpio.write(ledPin, gpio.HIGH);

wifi.sta.eventMonReg(wifi.STA_IDLE, function() print("STATION_IDLE") end)
wifi.sta.eventMonReg(wifi.STA_CONNECTING, function() print("STATION_CONNECTING") end)
wifi.sta.eventMonReg(wifi.STA_WRONGPWD, function() print("STATION_WRONG_PASSWORD") end)
wifi.sta.eventMonReg(wifi.STA_APNOTFOUND, function() print("STATION_NO_AP_FOUND") end)
wifi.sta.eventMonReg(wifi.STA_FAIL, function() print("STATION_CONNECT_FAIL") end)
wifi.sta.eventMonReg(wifi.STA_GOTIP, function() print("STATION_GOT_IP") end)

function launch()
  print("Connected to WIFI!")
  print("IP Address: " .. wifi.sta.getip())
  
  if(LAUNCHEDFILE) then
	return
  end

  LAUNCHEDFILE = true
  
  gpio.write(ledPin, gpio.LOW);
  -- Call our command file. Note: if you foul this up you'll brick the device!
  dofile(CMDFILE)
  print("Running file.")
end

function checkWIFI() 
  if ( wifiTrys > NUMWIFITRYS ) then
    print("Sorry. Not able to connect")
  else
    ipAddr = wifi.sta.getip()
    if ( ( ipAddr ~= nil ) and  ( ipAddr ~= "0.0.0.0" ) )then
      tmr.alarm( 1 , 500 , 0 , launch )
    else
      -- Reset alarm again
      tmr.alarm( 0 , 2500 , 0 , checkWIFI)
      print("Checking WIFI..." .. wifiTrys)
      wifiTrys = wifiTrys + 1
    end 
  end 
end

wifi.sta.eventMonReg(wifi.STA_CONNECTING, function(previous_State)
    if(previous_State==wifi.STA_GOTIP) then
		gpio.write(ledPin, gpio.HIGH);
        print("Station lost connection with access point\n\tAttempting to reconnect...")
		checkWIFI()
    else
        print("STATION_CONNECTING")
    end
end)

print("-- Starting up! ")

-- Lets see if we are already connected by getting the IP
ipAddr = wifi.sta.getip()
if ( ( ipAddr == nil ) or  ( ipAddr == "0.0.0.0" ) ) then
  -- We aren't connected, so let's connect
  print("Configuring WIFI....")
  wifi.setmode(wifi.STATIONAP)
  if (STATICIP) then
	wifi.sta.setip({ip=IPADR,netmask=IPNETMASK,gateway=IPROUTER})
  end
  wifi.sta.config(SSID,APPWD)
  
  print("Waiting for connection")
  tmr.alarm( 0 , 2500 , 0 , checkWIFI )
else
 -- We are connected, so just run the launch code.
 launch()
end

