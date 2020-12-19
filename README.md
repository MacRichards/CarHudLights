# CarHudLights
![GitHub](https://img.shields.io/github/license/MacRichards/CarHudLights) ![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/MacRichards/CarHudLights?include_prereleases)

### Includes
- A Speedometer
- Engine Damage Indicator
- Head Lights Indicator
- Turn Lights Indicator
- Cruse Control Indicator
- Seatbelt Indicator

![in-game preview](https://forum.cfx.re/uploads/default/original/4X/1/b/3/1b37f15d9db61c6d5e74a2a46feab0264e7bc8c3.jpeg)

### Dependencies
- [pv-cruisecontrol](https://forum.cfx.re/t/release-cfx-fx-cruisecontrol/38840) (or another cruse control script)
- [LegacyFuel](https://github.com/InZidiuZ/LegacyFuel) (optional. adds fuel to the game)

## Installation
Download the latest release from the [releases tab](https://github.com/MacRichards/CarHudLights/releases). Navigate to your FXServer/server-data/resources folder. Place folder CarHudLights folder here. Navigate to your FXServer/server-data folder. Edit your server.cfg file to add the following line:
```cfg
start CarHudLights
```
That's it. Launch your server.

## Suggested Config Edits to Other Plugins
These are edits to other plugins' config files to complete the look of your server's hud.
#### [StreetLabel](https://google.com/)
Edit config.lua to
```lua
x = 1.000
y = 0.980
```
#### [nearest-postal](https://google.com/)
Edit config.lua to
```lua
text = {
	format = 'Nearest Postal: %s (~g~%.2fm~w~)',
	posX = 0.173,
	posY = 0.961,
},
```
#### [LegacyFuel](https://google.com/)
Edit fuel_client.lua in the last Citizen.CreateThread(function() found on line 374 to
```lua
if displayHud then
	--DrawAdvancedText(0.130 - x, 0.77 - y, 0.005, 0.0028, 0.6, mph, 255, 255, 255, 255, 6, 1)
	--DrawAdvancedText(0.174 - x, 0.77 - y, 0.005, 0.0028, 0.6, kmh, 255, 255, 255, 255, 6, 1)
	DrawAdvancedText(0.233 - x, 0.7915 - y, 0.005, 0.0028, 0.5, fuel .. "  Fuel", 255, 255, 255, 255, 6, 1)
	--DrawAdvancedText(0.148 - x, 0.7765 - y, 0.005, 0.0028, 0.5, "Fuel", 255, 255, 255, 255, 6, 1)
else
```
#### [lux_vehcontrol](https://google.com/)
The easy option would be to take a look at the Custom_Lux_Config.md file for information on how to create a config file for lux_vehcontrol. But if you aren't into that you can look at the client.lua file starting on line 438 to change the controls.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)

## Credits
Inspiration for this project came from the [Discontinued Advanced Car Hud System](https://forum.cfx.re/t/discontinued-advanced-car-hud-system-9-14-2017-v2/5179) and the [Seatbelt with blinking warning indicator](https://forum.cfx.re/t/release-seatbelt-with-blinking-warning-indicator/165354). Additional thanks to the [Jeva YouTube Channel](https://www.youtube.com/channel/UCI7x329xu2rLbtVvFPVIhiQ) for their tutorials on Lua programming for FiveM.
