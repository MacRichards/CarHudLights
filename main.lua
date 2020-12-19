--[[ /////////////////////////////////// ]]
--[[                                     ]]
--[[                Script               ]]
--[[                                     ]]
--[[ /////////////////////////////////// ]]

local speedBuffer = {}
local velBuffer = {}
local seatBelt = false
local cruseIsOn = false

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(1)

        local ped = PlayerPedId()
        local car = GetVehiclePedIsIn(ped)
        local pedVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        local menu = IsPauseMenuActive()

        -- Check if ped is in Vehicle
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) and IsCar(car) then

            local speedMulti = 0
            local unit = ""

            if Config.speedUnits == "mph" then
                speedMulti = 2.2369
                unit = "mph"
            else
                speedMulti = 3.6
                unit = "kph"
            end

            local speed = GetEntitySpeed(pedVeh) * speedMulti
            local damage = GetVehicleEngineHealth(pedVeh)
            local lights, lightsOn, highbeamsOn = GetVehicleLightsState(pedVeh)
            local indicatorLights = GetVehicleIndicatorLights(pedVeh)

            -- Speedometer
            if Config.Speedometer then
                drawRct(0.11, 0.932, 0.046, 0.03, 0, 0, 0, 150)
                drawTxt(0.61, 1.42, 1.0, 1.0, 0.64, "~w~" .. math.ceil(speed), 255, 255, 255, 255)
                drawTxt(0.633, 1.432, 1.0, 1.0, 0.4, "~w~" .. unit, 255, 255, 255, 255)
            end

            -- Engine Damage
            if Config.EngineDamage then
                if damage >= 500 then
                    SendNUIMessage({type = menu, kind = 1})
                elseif damage < 500 and damage >= 250 then
                    SendNUIMessage({type = menu, kind = 2})
                elseif damage < 250 then
                    SendNUIMessage({type = menu, kind = 3})
                end
            end

            -- Head Lights
            if Config.HeadLights then
                if lightsOn == 1 or highbeamsOn == 1 then
                    SendNUIMessage({type = menu, kind = 4})
                else
                    SendNUIMessage({type = menu, kind = 5})
                end
            end

            -- Indiator Lights
            if Config.IndiatorLights then
                if indicatorLights == 1 then
                    SendNUIMessage({type = menu, kind = 7})
                elseif indicatorLights == 2 then
                    SendNUIMessage({type = menu, kind = 6})
                elseif indicatorLights == 3 then
                    SendNUIMessage({type = menu, kind = 8})
                else
                    SendNUIMessage({type = menu, kind = 9})
                end
            end

            -- Cruse Control
            if Config.CruseControl then
                if IsControlJustReleased(1, Config.ccKey) and math.floor(speed) >= 23 then
                    cruseIsOn = not cruseIsOn;
                end

                if cruseIsOn then
                    drawTxt(0.606, 1.267, 1.0, 1.0, 0.5, "~g~ACC", 255, 255, 255, 255)
                    if math.floor(speed) < 23 or IsControlJustReleased(1, 8) then
                        cruseIsOn = false
                    end
                else
                    drawTxt(0.606, 1.267, 1.0, 1.0, 0.5, "ACC", 0, 0, 0, 150)
                end
            end

            -- Seatbelt
            if Config.Seatbelt and GetVehicleClass(car) ~= 8 then
                if seatBelt then
                    SendNUIMessage({type = menu, kind = 11})
                    DisableControlAction(0, 75, true)
                    DisableControlAction(27, 75, true)
                else
                    SendNUIMessage({type = menu, kind = 10})
                end

                if IsControlJustReleased(1, Config.seatBeltKey) then -- ? Will it accept input on pause menu
                    seatBelt = not seatBelt
                end

                speedBuffer[2] = speedBuffer[1]
                speedBuffer[1] = GetEntitySpeed(car)

                if not seatBelt and speedBuffer[2] ~= nil and GetEntitySpeedVector(car, true).y > 1.0 and speedBuffer[1] > (Config.Speed / 3.6) and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then
                    local co = GetEntityCoords(ped)
                    local fw = Fwv(ped)
                    SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
                    SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
                    Citizen.Wait(1)
                    SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
                end
                velBuffer[2] = velBuffer[1]
                velBuffer[1] = GetEntityVelocity(car)
            end

            -- Turns off ui if Ped dies or is in pause menu
            if IsPlayerDead(PlayerId()) or IsPauseMenuActive() then
                SendNUIMessage({type = false, kind = 0})
            end
        else
            SendNUIMessage({type = menu, kind = 0})
            seatBelt = false
            speedBuffer[1], speedBuffer[2] = 0.0, 0.0
        end
    end
end)

function IsCar(veh) -- 8
    local vc = GetVehicleClass(veh)
    return (vc >= 0 and vc <= 12) or (vc >= 17 and vc <= 20)
end

function Fwv(entity)
    local hr = GetEntityHeading(entity) + 90.0
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

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