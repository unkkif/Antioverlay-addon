local isRecording = {}
local banReason = Locales.OverlayDetected


RegisterServerEvent("madebyunkki::ban")
AddEventHandler("madebyunkki::ban", function(reason)
    local src = source
    if isRecording[src] then return end
    isRecording[src] = true

    if Config.RecordPlayer then
        exports[Config.FiveguardName]:recordPlayerScreen(src, Config.RecordTime, function(success)
            if success then
                print("Screenshot success for player: " .. src)
                exports[Config.FiveguardName]:fg_BanPlayer(src, banReason, true)
            else
                print("Screenshot failed for player: " .. src)
            end
            isRecording[src] = false
        end, Config.WebhookURL)
    else
        exports[Config.FiveguardName]:fg_BanPlayer(src, banReason, true)
        isRecording[src] = false
    end
end)
