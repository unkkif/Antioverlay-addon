Config = {}

-- Fiveguard Setting
Config.FiveguardName = "your-fiveguard-file-name" -- fiveguard resource file name 
Config.RecordPlayer = true -- true or false
Config.WebhookURL = "your-webhook-here" -- The video will be sent to this URL, can be useful for review.
Config.RecordTime = 1500 -- 1500 = 1.5sec




-- Overlay Setting
Config.MaxAttempts = 5
-- Maximum number of allowed mouse movement attempts during the overlay check.
-- If the player moves the mouse too many times, they will be banned.

Config.BaseDuration = 5000
-- The base duration of the overlay protection in milliseconds (5000 ms = 5 seconds).
-- This defines how long the overlay detection remains active before it automatically stops.

Config.AdditionalDuration = 5000
-- Extra time in milliseconds added to the overlay protection duration
-- for each detected mouse movement during the check.
-- This prolongs the overlay detection period whenever mouse activity is detected.

Config.OverlayKey = 121
-- The key code that triggers the overlay check when pressed.
-- 121 corresponds to the INSERT key.
-- You can change this to any other key code as needed.


-- BTW THIS CANT BE DUMPED!



RegisterNetEvent("madebyunkki:requestConfig")
AddEventHandler("madebyunkki:requestConfig", function()
    local src = source
    TriggerClientEvent("madebyunkki:sendConfig", src, {
        OverlayKey = Config.OverlayKey,
        MaxAttempts = Config.MaxAttempts,
        BaseDuration = Config.BaseDuration,
        AdditionalDuration = Config.AdditionalDuration,
    })
end)
