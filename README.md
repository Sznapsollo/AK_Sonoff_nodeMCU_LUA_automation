# Pairing Sonoff TH01 and TH16 lua scripts for Home Automation

## About

This repository contains lua scripts for your Sonoff TH01 and Sonoff TH16 wifi smart switches. Goal of these scripts is to replace default Sonoff software with different functionality which is controlled by programming in lua scripts. Way to deploy lua scripts to Sonoff devices is described below and also in **<a href="https://github.com/Sznapsollo/AK_Sonoff_nodeMCU_LUA_automation/blob/master/Readme_instruction_sonoff_lua_deployment.pdf" target="_blank">Readme_instruction_sonoff_lua_deployment.pdf</a>** file present in this repository. Also check links to Youtube vids at the bottom of this description. .lua scripts provided here make it very easy to pair Sonoff switches with AKHomeAutomation solution on my other github repository.

These scripts provide the following functionality:
- they register to your wifi network and obtain static ip
- Sonoff device can be toggled ON/OFF with its hardware button
- Sonoff will output content on its webpage depending on the url content
- Operate Sonoff device via GET requests using "ping" argument

### Json output

If url contains **check=1** (example http://sonoff_ip_address/?check=1) webpage will return json indicating current state of Sonoff wifi smart switch. Example: enabled switch will return {"pin1":1} where 1 indicates that its current status is ON. This mode is used to read switch status from remote services/automation systems.

### UI output

If url contains **check=2** (example http://sonoff_ip_address/?check=2) webpage will display ON/OFF buttons which user can use to toggle the switch. Button indicating current state of the device will be marked with green border. This mode is useful when user wants to manually switch status.

### Controlling via GET pin url request attributes

Sonoff device will change its state depending on url **pin** attribute. **pin=ON1** enables the Sonoff switch (example: http://sonoff_ip_address/?pin=ON1). **pin=OFF1** disables the Sonoff switch (example: http://sonoff_ip_address/?pin=OFF1).

Naturally **pin** attribute can be combined with **check** attribute (example: http://sonoff_ip_address/?check=1&pin=ON1) to toggle the switch and read its current state at the same time.

## Deployment

- Choose proper scripts for your Sonoff device (TH01, TH16). Difference between these scripts is that TH16 additionally handles second LED light that TH16 has to indicate wifi connection status. TH01 has only one LED and scripts in this repository use this light to indicate current switch state.
- in **init.lua** script change SSID, APPWD, IPADR, IPROUTER, IPNETMASK to make for Sonoff device connecting to your local network possible.
- follow steps in **<a href="https://github.com/Sznapsollo/AK_Sonoff_nodeMCU_LUA_automation/blob/master/Readme_instruction_sonoff_lua_deployment.pdf" target="_blank">Readme_instruction_sonoff_lua_deployment.pdf</a>** file to flash Sonoff with NodeMCU and upload lua scripts. This file describes how to perform this operation using Raspberry PI however this can also be done from different platforms in which case steps of flashing the device and uploading .lua scripts might be different.

## Links

- **<a href="https://youtu.be/AlX1ZiVodwY" target="_blank">Video describing deployment process of LUA scripts on Sonoff device</a>**
- **<a href="https://www.youtube.com/watch?v=C19ARWDYR3c&list=PLjd2MVjW6mhFygrvXyVcdNoq6pHK8MdUW" target="_blank">AKHomeAUtomation Youtube playlist</a>**

Take care!
Wanna touch base? office@webproject.waw.pl
