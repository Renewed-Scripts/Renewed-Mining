local QBCore = exports['qb-core']:GetCoreObject()

local Ores = {
    ["iron"] = {"k4mb1_ironore", "k4mb1_ironore2"},
    ["copper"] = {"k4mb1_copperore", "k4mb1_copperore2"},
    ["gold"] = {"k4mb1_goldore", "k4mb1_goldore2"},
    ["tin"] = {"k4mb1_tinore", "k4mb1_tinore2"},
    ["crystal"] = {"k4mb1_crystalred", "k4mb1_crystalgreen", "k4mb1_crystalblue"}
}


local function GetOre()
    local chance = math.random(1,1000)
    local ore

    if chance <= 320 then
        ore = Ores["iron"][math.random(1,#Ores["iron"])]
    elseif chance > 320 and chance <= 640 then
        ore = Ores["copper"][math.random(1,#Ores["copper"])]
    elseif chance > 640 and chance <= 960 then
        ore = Ores["tin"][math.random(1,#Ores["tin"])]
    elseif chance > 960 and chance <= 995 then
        ore = Ores["gold"][math.random(1,#Ores["gold"])]
    elseif chance > 995 then
        ore = Ores["crystal"][math.random(1,#Ores["crystal"])]
    end

    return ore
end

local function resetOre(id)
    SetTimeout(1 * 20000, function()
        Config.MineSlots[id].model = GetOre()
        Config.MineSlots[id].canMine = true
        Config.MineSlots[id].isSpawned = true
        TriggerClientEvent("Renewed-Mining:client:makebusy", -1, id, true)
        TriggerClientEvent("Renewed-Mining:client:SyncModels", -1, id, Config.MineSlots[id].model)
        TriggerClientEvent('Renewed-Mining:client:SyncSpawns', -1, id, true)
    end)
end

local function returnItem(model)
    local ore
    if model == "k4mb1_ironore" or model == "k4mb1_ironore2" then
        ore = "iron_ore"
    elseif model == "k4mb1_copperore" or model == "k4mb1_copperore2" then
        ore = "copper_ore"
    elseif model == "k4mb1_goldore" or model == "k4mb1_goldore2" then
        ore = "gold_ore"
    elseif model == "k4mb1_tinore" or model == "k4mb1_tinore2" then
        ore = "tin_ore"
    elseif model == "k4mb1_crystalred" then
        ore = "crystal_red"
    elseif model == "k4mb1_crystalgreen" then
        ore = "crystal_green"
    elseif model == "k4mb1_crystalblue" then
        ore = "crystal_blue"
    end

    return ore
end

RegisterNetEvent('Renewed-Mining:server:MinedOre', function(id)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local ped = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(ped)

    if not Config.MineSlots[id] then return end
    if not Config.MineSlots[id].isSpawned then return end
    if Config.MineSlots[id].canMine then return end

    if #(playerCoords - Config.MineSlots[id].coords) > 3.0 then return end

    if not Player.Functions.GetItemByName('pickaxe') then return end

    Config.MineSlots[id].isSpawned = false
    TriggerClientEvent('Renewed-Mining:client:SyncSpawns', -1, id, false)
    resetOre(id)
    local item = returnItem(Config.MineSlots[id].model)
    Player.Functions.AddItem(item, 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
end)

QBCore.Functions.CreateCallback("Renewed-Mining:server:RequestMiningConfig", function(source, cb)
    cb(Config.MineSlots)
end)

CreateThread(function()
    Wait(2500)
    for k, v in pairs(Config.MineSlots) do
        if not v.isSpawned then
            v.model = GetOre()
            v.isSpawned = true

            TriggerClientEvent("Renewed-Mining:client:SyncModels", -1, k, v.model)
            TriggerClientEvent('Renewed-Mining:client:SyncSpawns', -1, k, true)
        end
    end
end)

RegisterNetEvent('Renewed-Mining:server:makebusy', function(id, bool)
    Config.MineSlots[id].canMine = bool
    TriggerClientEvent("Renewed-Mining:client:makebusy", -1, id, bool)
end)

RegisterNetEvent('Renewed-Mining:server:MeltOre', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local ped = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - Config.SmeltStone.Coords) > 3.0 then return end

    if Player.Functions.RemoveItem(Config.SmeltStone.menu[data].item, 1) then
        if Player.Functions.AddItem(Config.SmeltStone.menu[data].recieveitem, math.random(1, 6)) ~= true then
            Player.Functions.AddItem(Config.SmeltStone.menu[data].item, 1)
            TriggerClientEvent('QBCore:Notify', src, 'Could not give item, inventory full!', 'error')
            return
        end
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.SmeltStone.menu[data].recieveitem], "add")
    else
        TriggerClientEvent('QBCore:Notify', src, 'You do not have a '..QBCore.Shared.Items[Config.SmeltStone.menu[data].item].label, 'error')
    end
end)