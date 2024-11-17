UserActivities = {}

RegisterNuiCallback("OpenInventory",function()
    SetNuiFocus(false, false)    
    TriggerServerEvent("cdm-xboss:OpenInventory")
end)

RegisterNuiCallback("OpenOutfit",function()
    SetNuiFocus(false, false)    
    TriggerServerEvent("cdm-xboss:OpenOutfit")
end)

RegisterNuiCallback("CloseUi",function()
    SetNuiFocus(false, false)    
end)

RegisterNetEvent("xboss:setlastactiv")
AddEventHandler("xboss:setlastactiv",function(mtype, amount)
    SendNUIMessage({message = "setlastactiv", type = mtype, amount = amount})
end)

RegisterNetEvent("xboss:refreshmoney")
AddEventHandler("xboss:refreshmoney",function(money)
    SendNUIMessage({message = "refresh", money = money})
end)

RegisterNetEvent("xboss-opennui")
AddEventHandler("xboss-opennui",function(employeeList, companymoney, userdata)
    local src = GetPlayerServerId(PlayerId())
    if Config.Debug then
        print(src, employeeList, companymoney, userdata)
    end
    if isboss then
        SendNUIMessage({message = "open", data = employeeList, localid = src, companymoney = companymoney, userdata = userdata})
        SetNuiFocus(true, true)
    else
        Config.ClientNotification(Config.NotificationText["NOT_BOSS"].text, "error", Config.NotificationText["NOT_BOSS"].timeout)
    end
end)

RegisterNuiCallback("updatejob",function(data)
    TriggerServerEvent("cdm-xboss:updatejob", data.value, data.playerid)
end)

RegisterNuiCallback("deposit",function(data)
    TriggerServerEvent("cdm-xboss:depositcompanymoney", data.amount)
end)

RegisterNuiCallback("withdraw",function(data)
    TriggerServerEvent("cdm-xboss:withdrawcompanymoney", data.amount)
end)

RegisterNuiCallback("setjob",function(data)
    TriggerServerEvent("cdm-xboss:setjob", data.id)
end)

RegisterNetEvent('cdm-xboss:refresh')
AddEventHandler('cdm-xboss:refresh', function()
    TriggerServerEvent("xboss:OpenMenu")
end)