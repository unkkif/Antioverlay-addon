Config = {}

-- Fiveguard Setting
Config.Fiveguardname = "your-fiveguard-file-name" -- fiveguard resource file name 
Config.Recordplayer = true -- true or false (This may slightly slow down the script)
Config.Webhook = "your-webhook-here" -- The video will be sent to this URL, can be useful for review.
Config.Recordtime = 1500 -- 1500 = 1.5sec

-- Overlay Setting
Config.MaxAttempts = 5

-- Maximum number of allowed mouse movement attempts during the overlay check.
-- If the player moves the mouse too many times, they will be banned.

Config.BaseDuration = 4000 

-- A value set too high can result in false bans. I recommend keeping it below 5000ms.
-- The base duration of the overlay protection in milliseconds (5000 ms = 5 seconds).
-- This defines how long the overlay detection remains active before it automatically stops.

Config.AdditionalDuration = 5000

-- Extra time in milliseconds added to the overlay protection duration
-- for each detected mouse movement during the check.
-- This prolongs the overlay detection period whenever mouse activity is detected.

Config.OverlayKey = {121}
  
-- You can add multiple keys here, e.g. {36, 121}
-- 36 is Right Shift (used on Susano)
-- 121 is the INSERT key (used on tzx, redengine, eulen and tz)
-- This config defines which key(s) trigger the overlay check when pressed.
-- Feel free to change or add key codes as needed.


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
