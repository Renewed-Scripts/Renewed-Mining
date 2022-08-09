local QBCore = exports['qb-core']:GetCoreObject()

local ores = {}
local PlayerData = {}
local loggedIn = false
local inMine = false

local function SpawnNewShit(onEnter, id)
    if onEnter then
        for k, v in pairs(Config.MineSlots) do
            if not ores[k] and v.isSpawned then
                ores[k] = CreateObject(joaat(v.model), v.coords.x, v.coords.y, v.coords.z-1, false, false, false)
                PlaceObjectOnGroundProperly(ores[k])
                FreezeEntityPosition(ores[k], true)

                exports['qb-target']:AddCircleZone("MineSlot"..k, v.coords, 1.5, {
                    name = "MineSlot"..k,
                    useZ = true,
                    debugPoly = false,
                }, {
                    options = {
                    {
                        type = "client",
                        event = "Renewed-Mining:client:MineRock",
                        icon = 'fa-solid fa-circle',
                        label = 'Mine Rock',
                        item = "pickaxe",
                        canInteract = function() return Config.MineSlots[k].canMine end,
                        id = k
                    }
                    },
                    distance = 2.5,
                })
            end
        end
    elseif id and not ores[id] then
        ores[id] = CreateObject(joaat(Config.MineSlots[id].model), Config.MineSlots[id].coords.x, Config.MineSlots[id].coords.y, Config.MineSlots[id].coords.z-1, false, false, false)
        PlaceObjectOnGroundProperly(ores[id])
        FreezeEntityPosition(ores[id], true)

        exports['qb-target']:AddCircleZone("MineSlot"..id, Config.MineSlots[id].coords, 1.5, {
            name = "MineSlot"..id,
            useZ = true,
            debugPoly = false,
          }, {
            options = {
              {
                type = "client",
                event = "Renewed-Mining:client:MineRock",
                icon = 'fa-solid fa-circle',
                label = 'Mine Rock',
                item = "pickaxe",
                canInteract = function() return Config.MineSlots[id].canMine end,
                id = id
              }
            },
            distance = 2.5,
        })
    end
end

local function DeleteOre(onExit, id)
    if onExit then
        for i = 1, #ores do
            DeleteObject(ores[i])
            exports['qb-target']:RemoveZone("MineSlot"..i)
            ores[i] = nil
        end
    elseif ores[id] then
        DeleteObject(ores[id])
        exports['qb-target']:RemoveZone("MineSlot"..id)
        ores[id] = nil
    end
end

local function SpawnPolyZone()
    while not loggedIn do wait(10) end
    local Mine = PolyZone:Create({
        vector2(2969.0617675781, 2666.5922851562),
        vector2(2904.3061523438, 2773.287109375),
        vector2(2729.8466796875, 2609.0529785156),
        vector2(2873.7316894531, 2515.853515625)
      }, {
        name="MiningtIng",
        debugPoly = false,
        minZ = 30.089981079102,
        maxZ = 51.49687194824
      })

    Mine:onPlayerInOut(function(isPointInside)
        if isPointInside then
            inMine = true
            SpawnNewShit(true)
        else
            inMine = false
            DeleteOre(true)
        end
    end)
end

local function hasItem(item)
    if PlayerData.items then
        for k, v in pairs(PlayerData.items) do
            if v.name == item then
                return true
            end
        end
    end
end

local object
local function SpawnPickAxe()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local pickaxe = "prop_tool_pickaxe"
    RequestModel(pickaxe)
    while not HasModelLoaded(pickaxe) do
        Wait(1)
    end

    object = CreateObject(pickaxe, coords.x, coords.y, coords.z, true, false, false)
    AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, 57005), 0.09, 0.03, -0.02, -78.0, 13.0, 28.0, false, true, true, true, 0, true)
end

local function doAnim(animDict, anim)
    local ped = PlayerPedId()
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(1)
    end
    TaskPlayAnim(ped, animDict, anim, 8.0, 8.0, -1, 1, 0, false, false, false)
end

RegisterNetEvent('Renewed-Mining:client:MineRock', function(data)
    local id = data.id
    local ped = PlayerPedId()
    if Config.MineSlots[id].isSpawned and Config.MineSlots[id].canMine then
        TriggerServerEvent('Renewed-Mining:server:makebusy', id, false)
        SpawnPickAxe()
        doAnim("melee@large_wpn@streamed_core", "ground_attack_on_spot")
        local circle = math.random(3,4)
        local time = math.random(35,45)
        local success = exports['qb-lock']:StartLockPickCircle(circle, time, success)
        if success then
            ClearPedTasks(ped)
            DeleteObject(object)
            TriggerServerEvent('Renewed-Mining:server:MinedOre', id)
        else
            ClearPedTasks(ped)
            DeleteObject(object)
            TriggerServerEvent('Renewed-Mining:server:makebusy', id, true)
        end
    end
end)

local function mechanicAnim()
    local animDict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@'
    local animation = 'machinic_loop_mechandplayer'

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
      Wait(0)
    end

    TaskPlayAnim(PlayerPedId(), animDict, animation, 8.0, -8.0, -1, 0, 0, 0, 0, 0)
end

RegisterNetEvent('Renewed-Mining:client:SmeltOre', function(data)
    if hasItem(Config.SmeltStone.menu[data].item) then
        mechanicAnim()
        QBCore.Functions.Progressbar('MineSmeltBruv', 'Smelting '..QBCore.Shared.Items[Config.SmeltStone.menu[data].item].label, 5000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Play When Done
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent('Renewed-Mining:server:MeltOre', data)
        end, function() -- Play When Cancel
            QBCore.Functions.Notify('Cancelled...', 'error', 7500)
        end)
    end
end)

RegisterNetEvent('Renewed-Mining:client:SmeltMenu', function()
    local menu = {
        {
            isMenuHeader = true,
            icon = "fa-solid fa-circle-info",
            txt = "Smelt down ores to its metallic form",
            header = "Oven from Heaven",
        },
    }

    for k, v in pairs(Config.SmeltStone.menu) do
        if hasItem(v.item) then
            menu[#menu+1] = {
                header = "Smelt "..QBCore.Shared.Items[v.item].label,
                icon = "fa-solid fa-circle-info",
                params = {
                    event = "Renewed-Mining:client:SmeltOre",
                    args = k,
                }
            }
        else
            menu[#menu+1] = {
                header = "Smelt "..QBCore.Shared.Items[v.item].label,
                icon = "fa-solid fa-circle-info",
                disabled = true
            }
        end
    end

    exports['qb-menu']:openMenu(menu)
end)

exports['qb-target']:AddCircleZone("MineSmelting", Config.SmeltStone.Coords, 1.5, {
    name = "MineSmelting",
    useZ = true,
    debugPoly = false,
}, {
    options = {
    {
        type = "client",
        event = "Renewed-Mining:client:SmeltMenu",
        icon = 'fa-solid fa-circle',
        label = 'Use Smeltery',
    }
    },
    distance = 2.5,
})

RegisterNetEvent('Renewed-Mining:client:SyncModels', function(id, model)
    if not id or not loggedIn then return end
    Config.MineSlots[id].model = model
end)

RegisterNetEvent('Renewed-Mining:client:makebusy', function(id, bool)
    if not id or not loggedIn then return end
    Config.MineSlots[id].canMine = bool
end)

RegisterNetEvent('Renewed-Mining:client:SyncSpawns', function(id, bool)
    if not id or not loggedIn then return end
    Config.MineSlots[id].isSpawned = bool

    if inMine then
        if bool then
            SpawnNewShit(false, id)
        else
            DeleteOre(false, id)
        end
    end
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.TriggerCallback('Renewed-Mining:server:RequestMiningConfig', function(result)
        Config.MineSlots = result
        loggedIn = true
        PlayerData = QBCore.Functions.GetPlayerData()
        SpawnPolyZone()
    end)
end)

AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
      Wait(100)
      if LocalPlayer.state['isLoggedIn'] then
        loggedIn = true
        PlayerData = QBCore.Functions.GetPlayerData()
        SpawnPolyZone()
      end
   end
end)

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
    if ores then
        for i = 1, #ores do
            print(json.encode(ores[i]))
            DeleteObject(ores[i])
            exports['qb-target']:RemoveZone("MineSlot"..i)
            ores[i] = nil
        end
    end
   end
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
end)


CreateThread(function()
    local MineBlip = AddBlipForCoord(vector3(2935.67, 2743.73, 43.69))
    SetBlipSprite(MineBlip, 527)
    SetBlipScale(MineBlip, 0.6)
    SetBlipDisplay(MineBlip, 4)
    SetBlipColour(MineBlip, 81)
    SetBlipAsShortRange(MineBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Mine")
    EndTextCommandSetBlipName(MineBlip)
end)