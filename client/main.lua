local isWhitelisted = false
local isOverlayBlockActive = false
local mouseMoveAttempts = 0

local Config = {
    OverlayKey = nil,
    MaxAttempts = nil,
    BaseDuration = nil,
    AdditionalDuration = nil,
}

RegisterNetEvent("madebyunkki:sendConfig", function(config)
    Config = config
end)

RegisterNetEvent("madebyunkki:setWhitelistStatus", function(status)
    isWhitelisted = status
end)

CreateThread(function()
    while not NetworkIsSessionStarted() do Wait(0) end
    TriggerServerEvent("madebyunkki:requestConfig")
    TriggerServerEvent("madebyunkki:checkWhitelist")
end)

CreateThread(function()
    while not Config.OverlayKey or not Config.MaxAttempts or not Config.BaseDuration or not Config.AdditionalDuration do
        Wait(100)
    end

    while true do
        Wait(0)
        if isWhitelisted then goto continue end

        if IsPedStill(PlayerPedId()) and IsControlJustPressed(0, Config.OverlayKey) then
            TriggerEvent("madebyunkki::startOverlayChecking")
        end

        ::continue::
    end
end)

RegisterNetEvent('madebyunkki::startOverlayChecking', function()
    if isOverlayBlockActive then return end
    isOverlayBlockActive = true
    mouseMoveAttempts = 0

    local targetX, targetY = 0.01, 0.01
    local startTime = GetGameTimer()
    local endTime = startTime + Config.BaseDuration

    CreateThread(function()
        while isOverlayBlockActive do
            Wait(300)

            local currentTime = GetGameTimer()
            local mouseX, mouseY = GetNuiCursorPosition()

            if mouseX > 100 or mouseY > 100 then
                mouseMoveAttempts = mouseMoveAttempts + 1
                endTime = endTime + Config.AdditionalDuration

                if mouseMoveAttempts >= Config.MaxAttempts then
                    TriggerServerEvent("madebyunkki::ban", Locales.OverlayDetected)
                    isOverlayBlockActive = false
                    return
                end
            end

            SetCursorLocation(targetX, targetY)

            if currentTime > endTime then
                isOverlayBlockActive = false
                break
            end
        end
    end)
end)
