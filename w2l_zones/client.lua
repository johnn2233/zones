local zoneCenter = vector3(-500.0, -300.0, 34.0)
local zoneRadius = 100.0
local insideZone = false
local playerJob = nil
local blip
ESX = exports["es_extended"]:getSharedObject()

-- Get ESX job updates
RegisterNetEvent('esx:setJob', function(job)
    playerJob = job.name
end)

Citizen.CreateThread(function()
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end
    playerJob = ESX.GetPlayerData().job.name
end)

-- Create the blip
Citizen.CreateThread(function()
    blip = AddBlipForRadius(zoneCenter.x, zoneCenter.y, zoneCenter.z, zoneRadius)
    SetBlipColour(blip, 0) -- white
    SetBlipAlpha(blip, 128)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Multi-Zone")
    EndTextCommandSetBlipName(blip)
end)

-- Zone detection with player alive check
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local ped = PlayerPedId()
        
        -- Skip if player is dead
        if IsPedDeadOrDying(ped, true) then
            insideZone = false
            TriggerServerEvent("zone:exited")
            Citizen.Wait(5000) -- Wait before checking again to reduce unnecessary checks
            
        end
        
        local coords = GetEntityCoords(ped)
        local dist = #(coords - zoneCenter)

        if dist <= zoneRadius and not insideZone then
            insideZone = true
            TriggerServerEvent("zone:entered", playerJob)
        elseif dist > zoneRadius and insideZone then
            insideZone = false
            TriggerServerEvent("zone:exited")
        end
    end
end)

-- Blip update from server
RegisterNetEvent("zone:updateBlip")
AddEventHandler("zone:updateBlip", function(color)
    if not blip then return end

    if color == "green" then
        SetBlipColour(blip, 2) -- green
    elseif color == "blue" then
        SetBlipColour(blip, 3) -- blue
    else
        SetBlipColour(blip, 0) -- white
    end
end)
