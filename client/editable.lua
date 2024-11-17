core = nil
PlayerJob = {}
isboss = false

Citizen.CreateThread(function()
    while core == nil do
        core = GetFrameworkObject()
        Citizen.Wait(1)
    end
    if Config.Framework == "new-qb" or Config.Framework == "old-qb" then
        PlayerJob = core.Functions.GetPlayerData().job
        TriggerServerEvent("cdm-xboss:checkisboss")
    else
        PlayerJob = core.GetPlayerData().job 
        TriggerServerEvent("cdm-xboss:checkisboss")
    end
end)

RegisterNetEvent("cdm-xboss:openinv")
AddEventHandler("cdm-xboss:openinv",function(data)
    if Config.Inventory == "ox-inventory" then
        exports.ox_inventory:openInventory('stash', data.name)
    elseif Config.Inventory == "qb-inventory" then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", data.label)
        TriggerEvent("inventory:client:SetCurrentStash", data.label)
    end
end)

RegisterNetEvent("cdm-xboss:setboss")
AddEventHandler("cdm-xboss:setboss",function(bool)
    isboss = bool
end)

Citizen.CreateThread(function()
    if not Config.Text.target then
        while true do
            while PlayerJob == nil do
                Citizen.Wait(300)
                if Config.Framework == "new-qb" or Config.Framework == "old-qb" then
                    PlayerJob = core.Functions.GetPlayerData().job
                    TriggerServerEvent("cdm-xboss:checkisboss")
                else
                    PlayerJob = core.GetPlayerData().job 
                    TriggerServerEvent("cdm-xboss:checkisboss")
                end
            end
            wait = 600
            if Config.Location[PlayerJob.name] then
                if isboss then
                    local ped = GetEntityCoords(PlayerPedId())
                    local dst = #(ped- Config.Location[PlayerJob.name])
                    if dst <= 5.0 then
                        wait = 2
                        text = Config.Text.text
                        if dst <= 2.0 then
                            text = "E - "..Config.Text.text
                            if IsControlJustPressed(1,38) then
                                TriggerServerEvent("xboss:OpenMenu")
                            end
                        end 
                        DrawText3d(Config.Location[PlayerJob.name].x, Config.Location[PlayerJob.name].y, Config.Location[PlayerJob.name].z, text)
                    end
                end

            end
            Citizen.Wait(wait)
        end
    end
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(PlayerData)
    PlayerJob = PlayerData.job
    TriggerServerEvent("cdm-xboss:checkisboss")
    if Config.Text.target and Config.Target == "ox_target" then
        local parameters = {
            name = 'Boss Menu',
            coords = vector3(Config.location),
            options = {
                {
                    onSelect = function()
                    TriggerServerEvent("xboss:OpenMenu")
                    end,
                    icon = "fas fa-hammer",
                    label = Config.Text["text"],
                },
            }
        }
        exports.ox_target:addBoxZone(parameters)
    end
end)
RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob",function(jobdata)
    PlayerJob = jobdata
    TriggerServerEvent("cdm-xboss:checkisboss")
    if Config.Text.target and Config.Target == "ox_target" then
        local parameters = {
            name = 'Boss Menu',
            coords = vector3(Config.Location[PlayerJob.name]),
            options = {
                {
                    onSelect = function()
                    TriggerServerEvent("xboss:OpenMenu")
                    end,
                    icon = "fas fa-hammer",
                    label = Config.Text["text"],
                },
            }
        }
        exports.ox_target:addBoxZone(parameters)
    end
end)
