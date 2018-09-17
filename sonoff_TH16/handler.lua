print(wifi.sta.getip()); -- Dynamic IP Address
relayPin = 6;
gpio.mode(relayPin, gpio.OUTPUT);
gpio.write(relayPin, gpio.LOW);


function turn(on, saveState)
	if(on) then
		gpio.write(relayPin, gpio.HIGH);
		if(saveState) then
			saveStatusToFile("1");
		end
	else
		gpio.write(relayPin, gpio.LOW);
		if(saveState) then
			saveStatusToFile("0");
		end
	end
end

function previousStatus()
	statusdata = "0";
	if file.open('status.txt', 'r') then
		statusdata = file.read();
		file.close();
	end
	if(statusdata == "1") then
		turn(true, false);
	end
end

previousStatus();

buttonPin = 3;
buttonDebounce = 250;
gpio.mode(buttonPin, gpio.INPUT, gpio.PULLUP);

srv=net.createServer(net.TCP);

-- Pin to toggle the status
buttondebounced = 0
gpio.trig(buttonPin, "down",function (level)
    if (buttondebounced == 0) then
        buttondebounced = 1;
        tmr.alarm(6, buttonDebounce, 0, function() buttondebounced = 0; end)
      
        --Change the state
        if (isEnabled(relayPin)) then
            turn(false, true);
            print("Manual: Was on, turning off");
        else
            turn(true, true);
            print("Manual: Was off, turning on");
        end
    end
end)

srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
        
        if(_GET.pin == "ON1")then
              turn(true, true);
			  print("Remote: Turning on");
        elseif(_GET.pin == "OFF1")then
              turn(false, true);
			  print("Remote: Turning off");
        end
        
        if(_GET.check == "1") then
			buf = buf.."{\"pin1\":"..gpio.read(relayPin).."}";
        elseif(_GET.check == "2") then
			local button1onstyle = "";
			local button1offstyle = "";
        
			if (isEnabled(relayPin)) then
				  button1onstyle = "style='border:2px solid green'";
			else
				  button1offstyle = "style='border:2px solid green'";
			end
        
			buf = buf.."<p><a href=\"?check=2&pin=ON1\"><button "..button1onstyle..">ON</button></a>&nbsp;<a href=\"?check=2&pin=OFF1\"><button "..button1offstyle..">OFF</button></a></p>";
			
			button1onstyle = nil;
			button1offstyle = nil;
        end
        
        if(buf ~= "") then
			client:send(buf);
		end
		
        buf = nil;
        _GET = nil;
    end)
	
	conn:on("sent", function(client) 
		client:close();
		collectgarbage();
	end)
	
end)

function isEnabled(pin)
	if(gpio.read(pin) == 1) then
		return true;
	else
		return false;
	end
end

function saveStatusToFile(value)
	if file.open('status.txt', 'w') then
		statusdata = file.write(value);
		file.close();
	end	
end


