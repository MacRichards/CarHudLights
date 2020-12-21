--[[ /////////////////////////////////// ]]
--[[                                     ]]
--[[                Config               ]]
--[[                                     ]]
--[[ /////////////////////////////////// ]]

Config = {}

-- * Config Options for Cars and Boats
Config.Speedometer = true
Config.EngineDamage = true
Config.HeadLights = true
Config.IndiatorLights = true
Config.CruseControl = true
Config.LicensePlate = true
Config.Seatbelt = true

Config.UseKnots = true

-- * Can be either mph or kph
Config.speedUnits = "mph"

-- * For a list of possible keys go to https://docs.fivem.net/docs/game-references/controls/

-- * Set to the same key as your cruse control or speed limiter script.
Config.ccKey = 182 -- L

-- * Key used to toggle your seatbelt
Config.seatBeltKey = 311 -- K

-- * KM/H (must be have decimal value)
Config.Speed = 100.0