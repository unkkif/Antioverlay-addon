local isRecording = {}
local banReason = Locales.OverlayDetected


RegisterServerEvent("madebyunkki::ban")
AddEventHandler("madebyunkki::ban", function(reason)
    local src = source
    if isRecording[src] then return end
    isRecording[src] = true

    if Config.recordplayer then
        exports[Config.FiveguardName]:recordPlayerScreen(src, Config.recordtime, function(success)
            if success then
                print("Screenshot success for player: " .. src)
                exports[Config.FiveguardName]:fg_BanPlayer(src, banReason, true)
            else
                print("Screenshot failed for player: " .. src)
            end
            isRecording[src] = false
        end, Config.Webhook)
    else
        exports[Config.FiveguardName]:fg_BanPlayer(src, banReason, true)
        isRecording[src] = false
    end
end)
