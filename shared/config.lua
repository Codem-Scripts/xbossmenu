Config = {}
Config.Framework = "esx" --esx / new-qb / old-qb
Config.NewESX = true -- ESX 1.2 and above versions (true/false)
Config.Inventory = "ox-inventory" -- ox-inventory / qb-inventory
Config.Database = "oxmysql" -- oxmysql / mysql-async / ghmattimysql
Config.UserImage = "steam" -- discord / steam
Config.Outfit = "illenium" -- illenium / fivem-appearance / qb-default / codem-appearance
Config.Target = "ox_target" -- qb-target / ox_target 
Config.Debug = true -- true / false (If you want to see debug messages in console)
Config.DefaultImage = "https://www.gitbook.com/cdn-cgi/image/width=40,dpr=2,height=40,fit=contain,format=auto/https%3A%2F%2F3253843082-files.gitbook.io%2F~%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252FMRUfpMzIuVWlJ1CkzDbb%252Ficon%252FD3wjQp0cCyS6MkqdCs1C%252Fimage_2022-09-06_182033969.png%3Falt%3Dmedia%26token%3D662e0ec6-bb96-40d2-87e0-3e74d4061566"

Config.Location = {
    ["police"] = vector3(452.63, -973.53, 30.69),
    ["ambulance"] = vector3(311.1818, -599.224, 43.291),
    ["protectev"] = vector3(125.561, -3007.185, 6.837),
}

Config.Text = {
    target = false,
    text = "ADMISTRAÇÃO",
}

Config.AccessForMenu = {
    ["police"] = true,
    ["ambulance"] = true,
    ["protectev"] = true,
}

Config.OpenOutfit = function(source)
    if Config.Outfit == "qb-default" then
        TriggerClientEvent("qb-clothing:client:openMenu",source)
    elseif Config.Outfit == "illenium" then
        TriggerClientEvent("illenium-appearance:client:openJobOutfitsMenu", source, {})
    elseif Config.Outfit == "fivem-appearance" then
        local config = {
            ped = true,
            headBlend = true,
            faceFeatures = true,
            headOverlays = true,
            components = true,
            props = true,
            allowExit = true,
            tattoos = true
        }
        exports['fivem-appearance']:startPlayerCustomization(function(appearance)end, config)
    elseif Config.Outfit == "codem-appearance" then
        TriggerClientEvent("codem-apperance:OpenWardrobe", source)
    end
end

Config.OpenInventory = function(job, source)
    if Config.Inventory == "ox-inventory" then
        Stash = {
            name = job.."cdmt",
            label = job.."cdmt",
        }
        exports.ox_inventory:RegisterStash(Stash.name, Stash.label, 50, 100000, false, false)
        TriggerClientEvent("cdm-xboss:openinv",source,  Stash)
    elseif Config.Inventory == "qb-inventory" then
        Stash = {
            name = job.."cdmt",
            label = job.."cdmt",
        }
        TriggerClientEvent("cdm-xboss:openinv",source,  Stash)
    end
end

DrawText3d = function(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
    ClearDrawOrigin()
end

Config.NotificationText = {
    ["NOT_BOSS"] = {
        text = "Você não é o chefe deste trabalho",
        timeout = 3000,
    },
    ["PLAYER_NOT_FOUND"] = {
        text = "Jogador não encontrado",
        timeout = 3000,
    },
    ["PLAYER_JOB_CHANGED"] = {
        text = "O trabalho do jogador foi alterado",
        timeout = 3000,
    }
}

Config.ClientNotification = function(message, type, length) -- You can change notification event here
    if Config.Framework == "esx" then
        TriggerEvent("esx:showNotification", message)
    else
        TriggerEvent('QBCore:Notify', message, type, length)
    end
end

Config.ServerNotification = function(source, message, type, length) -- You can change notification event here
    if Config.Framework == "esx" then
        TriggerClientEvent("esx:showNotification",source, message)
    else
        TriggerClientEvent('QBCore:Notify', source, message, type, length)
    end
end