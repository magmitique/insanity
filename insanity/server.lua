-- Table pour stocker XP et level
local playerXP = {}
local playerLVL = {}
local playerMONEY = {}

-- Event pour ajouter de l'XP
RegisterNetEvent("insanity:addXP", function(amount)
    local src = source
    -- TODO : convertir 'amount' en number et mettre une valeur par défaut
    local amount = tonumber(amount) or 10
    -- TODO : initialiser playerXP[src] si nil
    if playerXP[src] == nil then playerXP[src] = 0 end
    if playerLVL[src] == nil then playerLVL[src] = 0 end
    -- TODO : ajouter l'XP au joueur
    playerXP[src] = playerXP[src] + amount
    -- TODO : gérer les level up multiples (while ?)
    while playerXP[src] >= 100 do
        playerXP[src] = playerXP[src] - 100
        playerLVL[src] = playerLVL[src] + 1
        print(("Joueur %d à monter en niveau!"):format(src))
        TriggerClientEvent("insanity:showLEVELUP", src)
    end
    -- envoyer XP et level au client
    TriggerClientEvent("insanity:showXP", src, playerXP[src], playerLVL[src])
end)

RegisterNetEvent("insanity:getMONEY", function()
    local src = source
    if playerMONEY[src] == nil then playerMONEY[src] = 0 end
    TriggerClientEvent("insanity:showMONEY", src, playerMONEY[src])
end)

-- Nettoyage quand un joueur quitte
AddEventHandler("playerDropped", function()
    local src = source
    -- TODO : supprimer le joueur de playerXP
    playerXP[src] = nil
    playerLVL[src] = nil
    playerMONEY[src] = nil
end)

RegisterNetEvent("insanity:npcKilled", function()
    local src = source
    if playerXP[src] == nil then playerXP[src] = 0 end
    if playerLVL[src] == nil then playerLVL[src] = 0 end
    if playerMONEY[src] == nil then playerMONEY[src] = 0 end

    -- ajouter 1 XP
    playerXP[src] = playerXP[src] + 1
    playerMONEY[src] = playerMONEY[src] + 1
    
    TriggerClientEvent("insanity:npcKilledN", src)

    -- gérer level up
    while playerXP[src] >= 100 do
        playerXP[src] = playerXP[src] - 100
        playerLVL[src] = playerLVL[src] + 1
        TriggerClientEvent("insanity:showLEVELUP", src)
    end

    -- envoyer au joueur son XP et level
    TriggerClientEvent("insanity:showXP", src, playerXP[src], playerLVL[src])
end)
