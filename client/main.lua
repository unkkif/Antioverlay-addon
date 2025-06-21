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

local function IsAnyOverlayKeyPressed()
    if type(Config.OverlayKey) == "table" then
        for _, key in ipairs(Config.OverlayKey) do
            if IsControlJustPressed(0, key) then
                return true
            end
        end
        return false
    else
        return IsControlJustPressed(0, Config.OverlayKey)
    end
end

CreateThread(function()
    while type(Config.OverlayKey) ~= "number" and type(Config.OverlayKey) ~= "table" or
          type(Config.MaxAttempts) ~= "number" or
          type(Config.BaseDuration) ~= "number" or
          type(Config.AdditionalDuration) ~= "number" do
        Wait(100)
    end

    while true do
        Wait(0)
        if isWhitelisted then goto continue end

        if IsPedStill(PlayerPedId()) and IsAnyOverlayKeyPressed() then
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

    SetCursorLocation(targetX, targetY)

    CreateThread(function()
        while isOverlayBlockActive do
            Wait(300)

            local currentTime = GetGameTimer()
            local mouseX, mouseY = GetNuiCursorPosition()

            if mouseX > 0.1 or mouseY > 0.1 then
                mouseMoveAttempts = mouseMoveAttempts + 1
                endTime = endTime + Config.AdditionalDuration

                if mouseMoveAttempts >= Config.MaxAttempts then
                    TriggerServerEvent("madebyunkki::ban", "Overlay detected")
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
