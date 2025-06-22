local isRecording = {}
local banReason = Locales.OverlayDetected
local DiscordWebhook = Config.WarningWebhook
local playerWarnings = {}


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

RegisterNetEvent("madebyunkki::sendDiscordWarning", function(playerId, reason)
    local src = playerId
    local name = GetPlayerName(src) or "Unknown"
    local identifiers = GetPlayerIdentifiers(src)
    local steamHex, ipAddress = "N/A", "N/A"

    for _, id in ipairs(identifiers) do
        if id:find("steam:") then steamHex = id end
        if id:find("ip:") then ipAddress = id:sub(4) end
    end

    local steamLink = "https://steamcommunity.com/profiles/" .. steamHex:gsub("steam:", "")
    local ipLink = "https://check-host.net/ip-info?host=" .. ipAddress

    local message = {
        username = "Overlay Warning System",
        embeds = {{
            title = "Overlay Detection Alert!",
            description = "Suspicious overlay activity detected.",
            color = 0xE67E22,
            fields = {
                { name = "Player Name", value = name, inline = true },
                { name = "Player ID", value = tostring(src), inline = true },
                { name = "Steam Hex", value = string.format("[%s](%s)", steamHex, steamLink), inline = true },
                { name = "IP Address", value = string.format("[%s](%s)", ipAddress, ipLink), inline = true },
                { name = "Reason", value = reason }
            },
            footer = { text = "Overlay Warning System" },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    PerformHttpRequest(Config.WarningWebhook, function(err, text, headers) end, 'POST',
        json.encode(message),
        { ['Content-Type'] = 'application/json' }
    )
end)

RegisterNetEvent("madebyunkki::handleOverlayDetection", function(reason)
    local src = source
    local steam = "unknown"

    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if id:find("steam:") then
            steam = id
            break
        end
    end

    playerWarnings[steam] = (playerWarnings[steam] or 0) + 1
    local count = playerWarnings[steam]

    TriggerEvent("madebyunkki::sendDiscordWarning", src, reason .. string.format(" (%d/3 warnings)", count))

    -- Bannaa jos 3 kertaa havaittu
    if count >= 3 then
        exports[Config.Fiveguardname]:fg_BanPlayer(src, banReason, true)
        playerWarnings[steam] = nil
    end
end)
