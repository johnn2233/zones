local playersInZone = {}

RegisterNetEvent("zone:entered")
AddEventHandler("zone:entered", function(job)
    local src = source
    playersInZone[src] = job
    updateZoneBlip()
end)

RegisterNetEvent("zone:exited")
AddEventHandler("zone:exited", function()
    local src = source
    playersInZone[src] = nil
    updateZoneBlip()
end)

AddEventHandler("playerDropped", function(source)
    playersInZone[source] = nil
    updateZoneBlip()
end)

function updateZoneBlip()
    local countGreen = 0
    local countBlue = 0

    for _, job in pairs(playersInZone) do
        if job == "green" then
            countGreen = countGreen + 1
        elseif job == "blue" then
            countBlue = countBlue + 1
        end
    end

    local color = "white"
    if countGreen > countBlue then
        color = "green"
    elseif countBlue > countGreen then
        color = "blue"
    elseif countGreen > 0 and countBlue > 0 and countGreen == countBlue then
        color = "white" -- or set to "purple" if you prefer a tie to be a special color
    end

    TriggerClientEvent("zone:updateBlip", -1, color)
end
