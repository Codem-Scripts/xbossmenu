function CheckPlayerBoss(source)
    local Player = GetPlayer(source)
    if Player then
        if Config.Framework == "new-qb" or Config.Framework == "old-qb" then
            return Player.PlayerData.job.isboss
        elseif Config.Framework == "esx" then
            return Player.job.grade_name == 'dono'
        end
    end
end

function GetPlayer(source)
    if not source then return end
    if Config.Framework == "new-qb" or Config.Framework == "old-qb" then
        return frameworkObject.Functions.GetPlayer(source)
    elseif Config.Framework == "esx" then
        return frameworkObject.GetPlayerFromId(source)
    end
end

function CheckAccessable(source, itype)
    local Player = GetPlayer(source)
    local playerJob = {}
    if Config.Framework == "new-qb" or Config.Framework == "old-qb" then
        playerJob = {name = Player.PlayerData.job.name, grade = Player.PlayerData.job.grade.level}
    elseif Config.Framework == "esx" then
        playerJob = {name = Player.job.name, grade = Player.job.grade}
    end
    if CheckPlayerBoss(source) then
        return {access = true, job = playerJob.name}
    else
        return {access = false}
    end
end

function GetPlayerCharacterNameESX(source)
    local Player = GetPlayer(source)
    identifier = Player.identifier
    local result = ExecuteSql("SELECT * FROM users WHERE identifier = '"..identifier.."'")
    if result[1] then 
        return result[1].firstname..' '..result[1].lastname 
    end
end

RegisterServerEvent("cdm-xboss:OpenInventory")
AddEventHandler("cdm-xboss:OpenInventory",function()
    local check = CheckAccessable(source, "Inventory") 
    if check.access then
        Config.OpenInventory(check.job, source)    
    end
end)

RegisterNetEvent("xboss:OpenMenu")
AddEventHandler("xboss:OpenMenu",function()
    local src = source
    local Player = GetPlayer(source)
    local moneyC = 0
    if Player then
        if Config.Framework == "new-qb" or Config.Framework == "old-qb" then
            local playerjob = Player.PlayerData.job.name
            accesable = Config.AccessForMenu[playerjob]
            if accesable then
                playerData = GetPlayerData(src)
                employeeList = {}
                local result = ExecuteSql("SELECT * FROM players")

                if result[1] then
                    for k,v in pairs(result) do
                        local PlayerCitizen = frameworkObject.Functions.GetPlayerByCitizenId(v.citizenid)
                        if PlayerCitizen then
                            if PlayerCitizen.PlayerData.job and PlayerCitizen.PlayerData.job.name == playerjob then
                                table.insert(employeeList,{
                                    citizenid = PlayerCitizen.PlayerData.citizenid,
                                    jobdata = PlayerCitizen.PlayerData.job,
                                    gradeLevel = PlayerCitizen.PlayerData.job.grade.level,
                                    steam = GetPlayerName(PlayerCitizen.PlayerData.source),
                                    charname = PlayerCitizen.PlayerData.charinfo.firstname ..' '..PlayerCitizen.PlayerData.charinfo.lastname,
                                    status = true,
                                    playerid = PlayerCitizen.PlayerData.source
                                })
                            end
                        else
                            local userJobData = json.decode(v.job)
                            local charinfo = json.decode(v.charinfo)
                            if userJobData.name and userJobData.name == playerjob then
                                table.insert(employeeList,{
                                    citizenid = v.citizenid,
                                    jobdata = userJobData,
                                    gradeLevel = userJobData.grade.level,
                                    steam = v.name,
                                    charname = charinfo.firstname..' '..charinfo.lastname,
                                    status = false
                                })
                            end
                        end

                    end
                end
                
                table.sort(employeeList, function(a, b)
                    return tonumber(a.gradeLevel) > tonumber(b.gradeLevel)
                end)
                if companyMoneys[Player.PlayerData.job.name] and Player.PlayerData.job.name then
                    moneyC = companyMoneys[Player.PlayerData.job.name]
                else
                    moneyC = 0
                end
                TriggerClientEvent("xboss-opennui", src, employeeList, moneyC, playerData)
            end
        elseif Config.Framework == "esx" then
            local playerjob = Player.job.name
            accesable = Config.AccessForMenu[playerjob]
            if accesable then
                playerData = GetPlayerData(src)
                employeeList = {}
                local result = ExecuteSql("SELECT * FROM users")
                if result[1] then
                    for k,v in pairs(result) do
                        local PlayerCitizen = frameworkObject.GetPlayerFromIdentifier(v.identifier)
                        if PlayerCitizen  then
                            if PlayerCitizen.job and PlayerCitizen.job.name == playerjob then
                                local jobdata = {
                                    grade = {
                                        name = PlayerCitizen.job.grade_label
                                    }
                                }
                                table.insert(employeeList,{
                                    citizenid = PlayerCitizen.identifier,
                                    jobdata = jobdata,
                                    gradeLevel = PlayerCitizen.job.grade,
                                    steam = GetPlayerName(PlayerCitizen.source),
                                    charname = v.firstname ..' '..v.lastname,
                                    status = true,
                                    playerid = PlayerCitizen.source
                                })
                            end
                        else
                            if v.job and v.job == playerjob then
                                local jobdata = {
                                    grade = {
                                        name = v.job
                                    }
                                }
                                table.insert(employeeList,{
                                    citizenid = v.identifier,
                                    jobdata = jobdata,
                                    gradeLevel = v.job_grade,
                                    steam = v.firstname ..' '..v.lastname,
                                    charname = v.firstname ..' '..v.lastname,
                                    status = false
                                })
                            end
                        end

                    end
                end
                table.sort(employeeList, function(a, b)
                    return tonumber(a.gradeLevel) > tonumber(b.gradeLevel)
                end)
                local ownerIdentifier = Player.job.name
                if companyMoneys[ownerIdentifier] and Player.job.name then
                    moneyC = companyMoneys[ownerIdentifier]
                else
                    moneyC = 0
                end
                TriggerClientEvent("xboss-opennui", src, employeeList, moneyC, playerData)
            end
        end
    end
end)

RegisterServerEvent("cdm-xboss:setjob")
AddEventHandler("cdm-xboss:setjob",function(id)
    local src = source
    local Player = GetPlayer(src)
    local Target = GetPlayer(id)
    local accesable = CheckAccessable(src)
    if Target and accesable then
        if Config.Framework == "new-qb" or Config.Framework == "old-qb" then
            local PlayerJobName = Player.PlayerData.job.name
            local PlayerJob = {PlayerJobName, 0}

            if PlayerJob[1] then
                if PlayerJob[2] > Target.PlayerData.job.grade.level then
                    if Target.Functions.SetJob(PlayerJob[1], PlayerJob[2]) then
                        TriggerClientEvent("cdm-xboss:refresh", id)
                    end
                end
            elseif PlayerJob[1] ~= Target.PlayerData.job.name then
                if Target.Functions.SetJob(PlayerJob[1], PlayerJob[2]) then
                    TriggerClientEvent("cdm-xboss:refresh", id)
                end
            end

        elseif Config.Framework == "esx" then
            local PlayerJobName = Player.job.name
            local PlayerJob = {PlayerJobName, 0}

            if PlayerJob[1] == Target.job.name then
                if PlayerJob[2] > Target.job.grade then
                    Target.setJob(PlayerJob[1], PlayerJob[2])
                end
            elseif PlayerJob[1] ~= Target.job.name then
                Target.setJob(PlayerJob[1], PlayerJob[2])
            end
        end
        Config.ServerNotification(src, Config.NotificationText["PLAYER_JOB_CHANGED"].text, "success", Config.NotificationText["PLAYER_JOB_CHANGED"].timeout)
    else
        Config.ServerNotification(src, Config.NotificationText["PLAYER_NOT_FOUND"].text, "error", Config.NotificationText["PLAYER_NOT_FOUND"].timeout)
    end
end)