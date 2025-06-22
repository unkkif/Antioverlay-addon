Config = {}

-- Warning System
Config.WarningWebhook = "your-webhook-here"
-- Webhook URL for sending warnings. Only works if SafeBanSystem is enabled.

-- Overlay Settings
Config.UseBan = false
-- Enables banning the player if an overlay is detected.

Config.SafeBanSystem = true
-- Enables a safer ban system that bans the player after 3 detected overlay attempts

Config.MaxAttempts = 5
-- Maximum allowed mouse movements during the overlay check.
-- Too many mouse movements will result in a ban.

Config.BaseDuration = 5000
-- Base duration of the overlay protection in milliseconds (recommended below 5000 ms).
-- Defines how long the overlay detection stays active before automatically stopping.

Config.AdditionalDuration = 5000
-- Additional time (ms) added to the overlay protection duration for each detected mouse movement.
-- Extends the overlay detection period when mouse activity is detected.

Config.OverlayKey = {121, 36}
-- Key codes that trigger the overlay check when pressed.
-- For example, 36 = Right Shift (used in Susano),
-- 121 = INSERT (used in tzx, redengine, eulen, tz).
-- Feel free to add or change keys as needed.


-- Fiveguard Settings
Config.Fiveguardname = "your-fiveguard-file-name"         -- Fiveguard resource file name.
Config.Recordplayer = false               -- Whether to record player footage (may slightly slow down the script).
Config.Webhook = "your-webhook-here"      -- Webhook URL where recorded videos will be sent, useful for review.
Config.Recordtime = 1500                  -- Recording duration in milliseconds (1500 ms = 1.5 seconds).




RegisterNetEvent("madebyunkki:requestConfig")
AddEventHandler("madebyunkki:requestConfig", function()
    local src = source
    TriggerClientEvent("madebyunkki:sendConfig", src, {
        OverlayKey = Config.OverlayKey,
        MaxAttempts = Config.MaxAttempts,
        BaseDuration = Config.BaseDuration,
        AdditionalDuration = Config.AdditionalDuration,
        UseBan = Config.UseBan,
        SafeBanSystem = Config.SafeBanSystem,
    })
end)
