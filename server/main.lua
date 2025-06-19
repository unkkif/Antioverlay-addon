local isRecording = {}
local banReason = Locales.OverlayDetected

RegisterServerEvent("madebyunkki:checkWhitelist", function()
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    local steamIdentifier

    for _, id in pairs(identifiers) do
        if string.sub(id, 1, 6) == "steam:" then
            steamIdentifier = id
            break
        end
    end

    local isWhitelisted = false
    if steamIdentifier then
        for _, v in pairs(Shared.Whitelist) do
            if steamIdentifier == v then
                isWhitelisted = true
                break
            end
        end
    end

    TriggerClientEvent("madebyunkki:setWhitelistStatus", src, isWhitelisted)
end)

RegisterServerEvent("madebyunkki::ban")
AddEventHandler("madebyunkki::ban", function(reason)
    local src = source
    if isRecording[src] then return end
    isRecording[src] = true

    local identifiers = GetPlayerIdentifiers(src)
    local steamIdentifier

    for _, id in pairs(identifiers) do
        if string.sub(id, 1, 6) == "steam:" then
            steamIdentifier = id
            break
        end
    end

    for _, v in pairs(Shared.Whitelist) do
        if steamIdentifier == v then
            isRecording[src] = false
            return
        end
    end

    if Config.Recordplayer then
        exports[Config.Fiveguardname]:recordPlayerScreen(src, Config.Recordtime, function(success)
            if success then
                print("Screenshot success for player: " .. src)
                exports[Config.Fiveguardname]:fg_BanPlayer(src, banReason, true)
            else
                print("Screenshot failed for player: " .. src)
            end
            isRecording[src] = false
        end, Config.Webhook)
    else
        exports[Config.Fiveguardname]:fg_BanPlayer(src, banReason, true)
        isRecording[src] = false
    end
end)
