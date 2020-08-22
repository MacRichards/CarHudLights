--[[ /////////////////////////////////// ]]
--[[                                     ]]
--[[                Script               ]]
--[[                                     ]]
--[[ /////////////////////////////////// ]]

Citizen.CreateThread(function()

    local ccKey = 246 --Change this value to change CC key

    while true do
        Citizen.Wait(1)

        local pedVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)

        -- Check if ped is in Vehicle
        if (IsPedInAnyVehicle(GetPlayerPed(-1), false)) then

            --[[
                kph factor = 3.6
                mph factor = 2.2369
            ]]
            local speed = GetEntitySpeed(pedVeh)*2.2369
            local damage = GetVehicleEngineHealth(pedVeh)
            local lights, lightsOn, highbeamsOn = GetVehicleLightsState(pedVeh)
            local indicatorLights = GetVehicleIndicatorLights(pedVeh)

            -- Speedometer
            drawRct(0.11, 0.932, 0.046, 0.03, 0, 0, 0, 150)
            drawTxt(0.61, 1.42, 1.0, 1.0, 0.64, "~w~" .. math.ceil(speed), 255, 255, 255, 255)
            drawTxt(0.633, 1.432, 1.0, 1.0, 0.4, "~w~ mph", 255, 255, 255, 255)

            -- Engine Damage
            if (damage >= 500) then
                SendNUIMessage({type = "ui", kind = 1})
            elseif (damage < 500) and (damage >=250) then
                SendNUIMessage({type = "ui", kind = 2})
            elseif (damage < 250) then
                SendNUIMessage({type = "ui", kind = 3})
            end
            
            -- Head Lights
            if (lightsOn == 1) or (highbeamsOn == 1) then
                SendNUIMessage({type = "ui", kind = 4})
            else
                SendNUIMessage({type = "ui", kind = 5})
            end

            --[[ 
                Indiator Lights
                0 = off
                1 = left
                2 = right
                3 = both (hazard)
            ]]
            if (indicatorLights == 1) then
                SendNUIMessage({type = "ui", kind = 6})
            elseif (indicatorLights == 2) then
                SendNUIMessage({type = "ui", kind = 7})
            elseif (indicatorLights == 3) then
                SendNUIMessage({type = "ui", kind = 8})
            else
                SendNUIMessage({type = "ui", kind = 9})
            end

            -- Cruse Control
            if IsControlJustReleased(1, ccKey) and (speed >= 25) then
                if cruseIsOn == true then
                    cruseIsOn = false
                else
                    cruseIsOn = true;
                end
            end

            if (cruseIsOn == true) and (speed < 25) then
                cruseIsOn = false
            end

            if cruseIsOn then
                drawTxt(0.606, 1.267, 1.0, 1.0, 0.5, "~g~ACC", 255, 255, 255, 255)
            else
                drawTxt(0.606, 1.267, 1.0, 1.0, 0.5, "ACC", 0, 0, 0, 150)
            end

        else
            SendNUIMessage({type = "ui", kind = 0})
            cruseIsOn = false;
        end

    end
end)

--[[ /////////////////////////////////// ]]

function drawTxt(x, y, width, height, scale, text, r, g, b, a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function drawRct(x, y, width, height, r, g, b, a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end