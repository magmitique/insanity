-- Commande pour ajouter de l'XP
RegisterCommand("addxp", function(_, args)
    -- TODO : récupérer args[1], convertir en number ou valeur par défaut
    local amount = tonumber(args[1]) or 10
    -- TODO : déclencher l'event serveur "insanity:addXP"
    TriggerServerEvent("insanity:addXP", amount)
end)

RegisterCommand("money", function()
    TriggerServerEvent("insanity:getMONEY")
end)

-- Event pour recevoir l'XP + level depuis le serveur
RegisterNetEvent("insanity:showXP", function(xp, level)
    SetNotificationTextEntry("STRING")
    AddTextComponentString("Level: " .. level .. " | XP: " .. xp)
    DrawNotification(false, false)
end)

-- Event pour recevoir l'XP + level depuis le serveur
RegisterNetEvent("insanity:showLEVELUP", function()
    SetNotificationTextEntry("STRING")
    AddTextComponentString("🎉 Level UP")
    DrawNotification(false, false)
end)

RegisterNetEvent("insanity:showMONEY", function(money)
    SetNotificationTextEntry("STRING")
    AddTextComponentString("💵 Tu as $" .. money)
    DrawNotification(false, false)
end)

RegisterNetEvent("insanity:npcKilledN", function()
    SetNotificationTextEntry("STRING")
    AddTextComponentString("☠ Tu as tué un NPC: +1XP +$1")
    DrawNotification(false, false)
end)

local killedPeds = {} -- table pour stocker les peds déjà comptés

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        local handle, ped = FindFirstPed()
        local finished = false

        repeat
            if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
                local pedCoords = GetEntityCoords(ped)
                if #(playerCoords - pedCoords) < 50.0 then
                    if IsEntityDead(ped) and not killedPeds[ped] then
                        -- donner l'XP une seule fois
                        TriggerServerEvent("insanity:npcKilled")
                        killedPeds[ped] = true
                    end
                end
            end

            finished, ped = FindNextPed(handle)
            for pedRef, _ in pairs(killedPeds) do
                if not DoesEntityExist(pedRef) then
                    killedPeds[pedRef] = nil
                end
            end
        until not finished

        EndFindPed(handle)
    end
end)
