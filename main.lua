--[[
    Copyright (C) 2021 MacRichards

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see https://www.gnu.org/licenses/.
]]

local speedBuffer = {}
local velBuffer = {}
local seatBelt = false
local cruseIsOn = false

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(1)

        local ped = PlayerPedId()
        local playerPed = GetPlayerPed(-1)
        local pedVeh = GetVehiclePedIsIn(playerPed, false)
        local menu = IsPauseMenuActive()
        local speed = GetEntitySpeed(pedVeh)
        local damage = GetVehicleEngineHealth(pedVeh)
        local engineState = GetIsVehicleEngineRunning(pedVeh)
        local lights, lightsOn, highbeamsOn = GetVehicleLightsState(pedVeh)

        -- Check if ped is in Vehicle and not cycle or train
        if IsPedInAnyVehicle(playerPed, false) and GetVehicleClass(pedVeh) ~= 13 and GetVehicleClass(pedVeh) ~= 21 then
            -- Check to see if vehicle is a car
            if GetVehicleClass(pedVeh) <= 12 or GetVehicleClass(pedVeh) >= 17 then
                -- Check to see if ped is driver
                if GetPedInVehicleSeat(pedVeh, -1) == playerPed then
                    DrawSpeedometer(speed, pedVeh)
                    DrawEngineDamage(damage, menu)
                    DrawEngineState(engineState)
                    DrawHeadLighrs(lightsOn, highbeamsOn, menu)
                    DrawIndiacatorLights(pedVeh, menu)
		    EnableIndicatorControl(pedVeh)
                    DrawCruseControl(speed)
                    DrawLicensePlate(pedVeh)
                else
                    ClearAllButSeatBelt(menu)
                end
                DrawSeatBelt(pedVeh, ped, menu)
            end

            -- Check to see if vehicle is a boat
            if GetVehicleClass(pedVeh) == 14 then
                if GetPedInVehicleSeat(pedVeh, -1) == playerPed then
                    DrawSpeedometer(speed, pedVeh)
                    DrawEngineDamage(damage, menu)
                    DrawHeadLighrs(lightsOn, highbeamsOn, menu)
                    DrawHeading(pedVeh)
                else
                    ClearAllButSeatBelt(menu)
                end
            end
            -- Check to see if vehicle is a helicopter or plane
            if GetVehicleClass(pedVeh) == 15 or GetVehicleClass(pedVeh) == 16 then
                if GetPedInVehicleSeat(pedVeh, -1) == playerPed or GetPedInVehicleSeat(pedVeh, 0) == playerPed then
                    DrawSpeedometer(speed, pedVeh)
                    DrawEngineDamage(damage, menu)
                    DrawHeadLighrs(lightsOn, highbeamsOn, menu)
                    DrawPitch(pedVeh)
                    DrawHeading(pedVeh)
                    DrawAltitude(pedVeh)
                    DrawRoll(pedVeh)
                    DrawLandingGear(pedVeh)
                else
                    ClearAllButSeatBelt(menu)
                end
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

function DrawSpeedometer(speed, car)
    local newSpeed = 0
    local unit = ""

    if Config.UseKnots and GetVehicleClass(car) >= 14 and GetVehicleClass(car) <= 16 then
        newSpeed = speed * 1.94381308
        unit = "knots"
    else
        if Config.speedUnits == "mph" then
            newSpeed = speed * 2.2369
            unit = "mph"
        else
            newSpeed = speed * 3.6
            unit = "kph"
        end
    end

    if Config.Speedometer then
        DrawRct(0.11, 0.932, 0.046, 0.03, 0, 0, 0, 150)
        DrawTxt(0.61, 1.42, 1.0, 1.0, 0.64, "~w~" .. math.ceil(newSpeed), 255, 255, 255, 255)
        DrawTxt(0.633, 1.432, 1.0, 1.0, 0.4, "~w~" .. unit, 255, 255, 255, 255)
    end
end

function DrawEngineState(engineState)
    if Config.EngineState then
        if engineState then
            DrawTxt(0.516, 1.24, 1.0, 0.5, "~g~Running", 255, 255, 255, 255);
        else
            DrawTxt(0.516, 1.24, 1.0, 0.5, "~r~Off", 255, 255, 255, 255);
        end
    end
end

function DrawEngineDamage(damage, menu)
    if Config.EngineDamage then
        if damage >= 500 then
            SendNUIMessage({type = menu, kind = 1})
        elseif damage < 500 and damage >= 250 then
            SendNUIMessage({type = menu, kind = 2})
        elseif damage < 250 then
            SendNUIMessage({type = menu, kind = 3})
        end
    end
end

function DrawHeadLighrs(lightsOn, highbeamsOn, menu)
    if Config.HeadLights then
        if lightsOn == 1 or highbeamsOn == 1 then
            SendNUIMessage({type = menu, kind = 4})
        else
            SendNUIMessage({type = menu, kind = 5})
        end
    end
end

function DrawIndiacatorLights(pedVeh, menu)
    if Config.IndiatorLights then
        local indicatorLights = GetVehicleIndicatorLights(pedVeh)
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
end

function EnableIndicatorControl(pedVeh)
    if IsControlJustReleased(0, 174) then
        SetVehicleIndicatorLights(pedVeh, 1, true)
        --notify("~y~[Signal Lights]~w~: ~g~Left") --if needs
    end

    if IsControlJustReleased(0, 172) then
        SetVehicleIndicatorLights(pedVeh, 1, false)
    end

    if IsControlJustReleased(0, 175) then
        SetVehicleIndicatorLights(pedVeh, 0, true)
        --notify("~y~[Signal Lights]~w~: ~b~Right")
    end

    if IsControlJustReleased(0, 172) then
        SetVehicleIndicatorLights(pedVeh, 0, false)
    end
end

function DrawCruseControl(speed)
    if Config.CruseControl then
        if IsControlJustReleased(1, Config.ccKey) and math.floor(speed * 2.2369) >= 23 then
            cruseIsOn = not cruseIsOn;
        end

        if cruseIsOn then
            DrawTxt(0.606, 1.267, 1.0, 1.0, 0.5, "~g~ACC", 255, 255, 255, 255)
            if math.floor(speed) < 23 or IsControlJustReleased(1, 8) then
                cruseIsOn = false
            end
        else
            DrawTxt(0.606, 1.267, 1.0, 1.0, 0.5, "ACC", 0, 0, 0, 150)
        end
    end
end

function DrawLicensePlate(pedVeh)
    if Config.LicensePlate then
        local plateText = GetVehicleNumberPlateText(pedVeh)
        DrawTxt(0.516, 1.24, 1.0, 1.0, 0.5, "~w~" .. plateText, 255, 255, 255, 255)
    end
end

function DrawSeatBelt(car, ped, menu)
    if Config.Seatbelt and GetVehicleClass(car) ~= 8 then
        if seatBelt then
            SendNUIMessage({type = menu, kind = 11})
            DisableControlAction(0, 75, true)
            DisableControlAction(27, 75, true)
        else
            SendNUIMessage({type = menu, kind = 10})
        end

        if IsControlJustReleased(1, Config.seatBeltKey) then
            seatBelt = not seatBelt
        end

        speedBuffer[2] = speedBuffer[1]
        speedBuffer[1] = GetEntitySpeed(car)

        if not seatBelt and speedBuffer[2] ~= nil and GetEntitySpeedVector(car, true).y > 1.0 and speedBuffer[1] > (100 / 3.6) and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then
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
end

function DrawLandingGear(pedVeh)
    if Config.LandingGear and GetVehicleHasLandingGear(pedVeh) then
        if GetLandingGearState(pedVeh) == 0 then
            DrawTxt(0.600, 1.267, 1.0, 1.0, 0.5, "~g~Gear", 255, 255, 255, 255)
        elseif GetLandingGearState(pedVeh) ~= 4 then
            DrawTxt(0.600, 1.267, 1.0, 1.0, 0.5, "~o~Gear", 255, 255, 255, 255)
        else
            DrawTxt(0.600, 1.267, 1.0, 1.0, 0.5, "~w~Gear", 255, 255, 255, 255)
        end
    end
end

function DrawAltitude(pedVeh)
    if Config.Altitude then
        local altitude = GetEntityHeightAboveGround(pedVeh)
        DrawText(0.517, 1.300, 1.0, 1.0, 0.35, "~w~Altitude: ~y~" .. altitude, 255, 255, 255, 255);
    end
end

function DrawHeading(pedVeh)
    if Config.Heading then
        local heading = math.ceil(GetEntityHeading(pedVeh))
        DrawTxt(0.517, 1.300, 1.0, 1.0, 0.35, "~w~Heading: ~y~" .. heading, 255, 255, 255, 255)
    end
end

function DrawPitch(pedVeh)
    if Config.Pitch then
        local pitch = math.ceil(GetEntityPitch(pedVeh))
        DrawTxt(0.517, 1.320, 1.0, 1.0, 0.35, "~w~Pitch: ~y~" .. pitch, 255, 255, 255, 255)
    end
end

function DrawRoll(pedVeh)
    if Config.Roll then
        local roll = (GetEntityRotation(pedVeh, 2))
        DrawTxt(0.517, 1.340, 1.0, 1.0, 0.35, "~w~Roll: ~y~" .. math.floor(roll.y), 255, 255, 255, 255)
    end
end

function ClearAllButSeatBelt(menu)
    SendNUIMessage({type = menu, kind = 12})
end

function Fwv(entity)
    local hr = GetEntityHeading(entity) + 90.0
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

function DrawTxt(x, y, width, height, scale, text, r, g, b, a)
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

function DrawRct(x, y, width, height, r, g, b, a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end
