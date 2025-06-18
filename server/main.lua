local isRecording = {}
local banReason = Locales.OverlayDetected


RegisterServerEvent("madebyunkki::ban")
AddEventHandler("madebyunkki::ban", function(reason)
    local src = source
    if isRecording[src] then return end
    isRecording[src] = true

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
