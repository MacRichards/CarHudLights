
Create a new file called config.lua and past this in it.
```lua
Config = {}

-- https://docs.fivem.net/docs/game-references/controls/

-- * Toggle Default Siren Lights
Config.TogDfltSrnLights = 85 -- Q
Config.TogDfltSrnLights2 = 246 -- Y

-- * Toggle Main Siren
Config.TogLxSiren = 19 -- Left Alt
Config.TogLxSiren2 = 82 -- ,

-- * PowerCall
Config.Powercall = 172 -- Arrow Up

-- * Browse Main Siren Tones
Config.BrowseLxSrnTones = 80 -- R
Config.BrowseLxSrnTones2 = 81 -- .

-- * Horn
Config.Horn = 86 -- E

-- * Turn Indicator Left
Config.IndL = 84 -- -

-- * Turn Indicator Right
Config.IndR = 83 -- =

-- * Hazard Lights
Config.IndH = 202 -- Backspace / ESC
```

Edit client.lua to the following:
from line 438 to 521 replace it with this:
```lua
----- CONTROLS -----
if not IsPauseMenuActive() then

    -- TOG DFLT SRN LIGHTS
	if IsDisabledControlJustReleased(0, Config.TogDfltSrnLights) or IsDisabledControlJustReleased(0, Config.TogDfltSrnLights2) then
		if IsVehicleSirenOn(veh) then
			PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
			SetVehicleSiren(veh, false)
		else
			PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
			SetVehicleSiren(veh, true)
			count_bcast_timer = delay_bcast_timer
		end		

    -- TOG LX SIREN
	elseif IsDisabledControlJustReleased(0, Config.TogLxSiren) or IsDisabledControlJustReleased(0, Config.TogLxSiren2) then
		local cstate = state_lxsiren[veh]
		if cstate == 0 then
	    	if IsVehicleSirenOn(veh) then
				PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1) -- on
				SetLxSirenStateForVeh(veh, 1)
				count_bcast_timer = delay_bcast_timer
			end
		else
		    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1) -- off
		    SetLxSirenStateForVeh(veh, 0)
		    count_bcast_timer = delay_bcast_timer
		end

	-- POWERCALL
	elseif IsDisabledControlJustReleased(0, Config.Powercall) then
		if state_pwrcall[veh] == true then
			PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
			TogPowercallStateForVeh(veh, false)
			count_bcast_timer = delay_bcast_timer
		else
			if IsVehicleSirenOn(veh) then
				PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
				TogPowercallStateForVeh(veh, true)
				count_bcast_timer = delay_bcast_timer
			end
		end
								
	end
							
	-- BROWSE LX SRN TONES
	if state_lxsiren[veh] > 0 then
		if IsDisabledControlJustReleased(0, Config.BrowseLxSrnTones) or IsDisabledControlJustReleased(0, Config.BrowseLxSrnTones2) then
			if IsVehicleSirenOn(veh) then
				local cstate = state_lxsiren[veh]
				local nstate = 1
				PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1) -- on
				if cstate == 1 then
				    nstate = 2
				elseif cstate == 2 then
					nstate = 3
				else	
					nstate = 1
				end
				SetLxSirenStateForVeh(veh, nstate)
				count_bcast_timer = delay_bcast_timer
			end
		end
	end

	-- MANU
	if state_lxsiren[veh] < 1 then
		if IsDisabledControlPressed(0, Config.BrowseLxSrnTones) or IsDisabledControlPressed(0, Config.BrowseLxSrnTones2) then
			actv_manu = true
		else
			actv_manu = false
		end
	else
		actv_manu = false
	end

	-- HORN
	if IsDisabledControlPressed(0, Config.Horn) then
		actv_horn = true
	else
		actv_horn = false
	end

end
```

from line 561 to 607 replace it with this:
```lua
-- IND L
if IsDisabledControlJustReleased(0, Config.IndL) then -- INPUT_VEH_PREV_RADIO_TRACK
	local cstate = state_indic[veh]
	if cstate == ind_state_l then
	    state_indic[veh] = ind_state_o
	    actv_ind_timer = false
    	PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	else
		state_indic[veh] = ind_state_l
		actv_ind_timer = true
		PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	end
	TogIndicStateForVeh(veh, state_indic[veh])
	count_ind_timer = 0
	count_bcast_timer = delay_bcast_timer			
	-- IND R
elseif IsDisabledControlJustReleased(0, Config.IndR) then -- INPUT_VEH_NEXT_RADIO_TRACK
	local cstate = state_indic[veh]
	if cstate == ind_state_r then
		state_indic[veh] = ind_state_o
		actv_ind_timer = false
		PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	else
		state_indic[veh] = ind_state_r
		actv_ind_timer = true
		PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	end
	TogIndicStateForVeh(veh, state_indic[veh])
	count_ind_timer = 0
	count_bcast_timer = delay_bcast_timer
-- IND H
elseif IsControlJustReleased(0, Config.IndH) then -- INPUT_FRONTEND_CANCEL / Backspace
	if GetLastInputMethod(0) then -- last input was with kb
	local cstate = state_indic[veh]
		if cstate == ind_state_h then
			state_indic[veh] = ind_state_o
			PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
		else
			state_indic[veh] = ind_state_h
			PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
		end
		TogIndicStateForVeh(veh, state_indic[veh])
		actv_ind_timer = false
		count_ind_timer = 0
		count_bcast_timer = delay_bcast_timer
	end
end
```