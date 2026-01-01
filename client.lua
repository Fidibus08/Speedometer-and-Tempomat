local cruiseActive = false
local cruiseSpeed = 0.0

local CRUISE_KEY = 36 --https://docs.fivem.net/docs/game-references/controls/

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)

            if IsControlJustPressed(0, CRUISE_KEY) then
                if not cruiseActive then
                    cruiseSpeed = GetEntitySpeed(vehicle)
                    SetVehicleMaxSpeed(vehicle, cruiseSpeed)
                    cruiseActive = true
                else
                    SetVehicleMaxSpeed(
                        vehicle,
                        GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel")
                    )
                    cruiseActive = false
                end
            end
        else
            cruiseActive = false
        end

        DrawSpeedo()
    end
end)

function DrawSpeedo()
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then return end

    local vehicle = GetVehiclePedIsIn(ped, false)
    local speedMPH  = math.floor(GetEntitySpeed(vehicle) * 2.23694)
    local cruiseMPH = math.floor(cruiseSpeed * 2.23694)


    local x = 0.255
    local y = 0.82
    local w = 0.16
    local h = 0.055

    DrawRect(x, y, w, h, 10, 10, 10, 160)

    if cruiseActive then
        DrawRect(x - w / 2 + 0.002, y, 0.004, h, 0, 170, 255, 255)
    else
        DrawRect(x - w / 2 + 0.002, y, 0.004, h, 180, 180, 180, 120)
    end

    DrawText2D("SPEED", x - 0.07, y - 0.015, 0.32, 170)
    DrawText2D(speedMPH .. " MPH", x - 0.07, y + 0.005, 0.45, 255)

    if cruiseActive then
        DrawText2D("CRUISE", x + 0.02, y - 0.015, 0.32, 170)
        DrawText2D(cruiseMPH .. " MPH", x + 0.02, y + 0.005, 0.45, 0, 170, 255)
    else
        DrawText2D("CRUISE", x + 0.02, y - 0.015, 0.32, 170)
        DrawText2D("OFF", x + 0.02, y + 0.005, 0.45, 200, 80, 80)
    end
end

function DrawText2D(text, x, y, scale, r, g, b)
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextColour(r or 255, g or 255, b or 255, 255)
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end
