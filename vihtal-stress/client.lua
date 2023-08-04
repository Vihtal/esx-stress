ESX = exports["es_extended"]:getSharedObject()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = PlayerPedId()

        TriggerEvent('esx_status:getStatus', 'stress', function(status)
            StressVal = status.val
        end)

        if StressVal == 1000000 then -- max StressVal
            SetTimecycleModifier("WATER_silty") -- a bit blur and vision distance reduce
            SetTimecycleModifierStrength(1)
        else
            ClearExtraTimecycleModifier()
        end

        if StressVal >= 900000 then
            local veh = GetVehiclePedIsUsing(ped)
            if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(veh, -1) == ped then -- if ped "driving" a vehicle
                Citizen.Wait(1000)
                ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.15) --  cam shake
                TaskVehicleTempAction(ped, veh, 7, 250) --  turn left a bit
                Citizen.Wait(500)
                TaskVehicleTempAction(ped, veh, 8, 250) -- turn right a bit
                ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.15)
                Citizen.Wait(500)
                ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.15)
            else
                Citizen.Wait(1500)
                ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.15)
            end
        elseif StressVal >= 800000 then
            local veh = GetVehiclePedIsUsing(ped)
            if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(veh, -1) == ped then
                Citizen.Wait(1000)
                ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.10)
                TaskVehicleTempAction(ped, veh, 7, 150)
                Citizen.Wait(500)
                TaskVehicleTempAction(ped, veh, 8, 150)
                ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.10)
                Citizen.Wait(500)
                ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.10)
            else
                Citizen.Wait(1500)
                ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.10)
            end
        elseif StressVal >= 700000 then
            local veh = GetVehiclePedIsUsing(ped)
            if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(veh, -1) == ped then
                Citizen.Wait(1000)
                ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.07)
                TaskVehicleTempAction(ped, veh, 7, 100)
                Citizen.Wait(500)
                TaskVehicleTempAction(ped, veh, 8, 100)
                ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.07)
                Citizen.Wait(500)
                ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.07)
            else
                Citizen.Wait(2000)
                ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.07)
            end
        elseif StressVal >= 600000 then -- %60  Below ½60 no effect to driving
            Citizen.Wait(2500) --frequency
            ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.07) -- effect
        elseif StressVal >= 500000 then
            Citizen.Wait(3500)
            ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.07)
        elseif StressVal >= 350000 then
            Citizen.Wait(5500)
            ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.05)
        elseif StressVal >= 200000 then
            Citizen.Wait(6500)
            ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.03)
        else
            Citizen.Wait(3000)
        end
    end
end)


Citizen.CreateThread(function() -- While shooting
    while true do
        local ped = PlayerPedId()
        local status = IsPedShooting(ped)
        local silenced = IsPedCurrentWeaponSilenced(ped)

        if status and not silenced then
            TriggerServerEvent("stress:add", 30000)
            Citizen.Wait(2000)
        else
            Citizen.Wait(1)
        end
    end
end)



Citizen.CreateThread(function() -- Aiming with a melee, hitting with a melee or getting hit by a melee
    while true do
        local ped = PlayerPedId()
        local status = IsPedInMeleeCombat(ped)

        if status then
            TriggerServerEvent("stress:add", 5000)
            Citizen.Wait(5000)
        else
            Citizen.Wait(1)
        end
    end
end)




Citizen.CreateThread(function() -- Skydiving with parachute
    while true do
        local ped = PlayerPedId()
        local status = GetPedParachuteState(ped)

        if status == 0 then -- freefall with chute (not falling without it)
            TriggerServerEvent("stress:add", 60000)
            Citizen.Wait(5000)
        elseif status == 1 or status == 2 then -- opened chute
            TriggerServerEvent("stress:add", 5000)
            Citizen.Wait(5000)
        else
            Citizen.Wait(5000) -- refresh rate is low on this one since it's not so common to skydive in RP servers
        end
    end
end)

Citizen.CreateThread(function() -- Stealth mode
    while true do
        local ped = PlayerPedId()
        local status = GetPedStealthMovement(ped)

        if status then
            TriggerServerEvent("stress:add", 10000)
            Citizen.Wait(8000)
        else
            Citizen.Wait(1) -- refresh rate
        end
    end
end)

Citizen.CreateThread(function()--Driving over 100mph
    while true do
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
            local speed = GetEntitySpeed(vehicle) * 2.23694 -- Convert speed from m/s to mph, 3.6 for kmh
            if speed > 100 then
                TriggerServerEvent("stress:add", 5000) -- Adjust the stress amount as needed
                Citizen.Wait(2000)
            end
        end

        Citizen.Wait(1000) -- Check the speed every second to avoid constant stress triggering
    end
end)

local lastVehicleHealth = 1000

Citizen.CreateThread(function()--Crashing Vehicle
    while true do
        Citizen.Wait(1000) -- Check for vehicle damage every second to avoid constant stress triggering

        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
            local vehicleHealth = GetVehicleBodyHealth(vehicle)

            if lastVehicleHealth and vehicleHealth < lastVehicleHealth then
                local damage = lastVehicleHealth - vehicleHealth
                if damage > 5 then -- Tweak this value to set the minimum threshold for a crash
                    local stressAmount = damage * 500 -- Adjust the stress amount based on the damage received
                    TriggerServerEvent("stress:add", stressAmount)
                end
            end

            lastVehicleHealth = vehicleHealth
        end
    end
end)

local sprintDuration = 8000 -- Set the duration (in milliseconds) of sprinting required to trigger stress 8000 = 8 seconds
local sprinting = false
local sprintStartTime = 0

Citizen.CreateThread(function()--Sprinting Too Long
    while true do
        local ped = PlayerPedId()

        if not IsPedInAnyVehicle(ped) then
            if IsControlPressed(0, 21) and IsPedOnFoot(ped) then -- 21 is the sprint control key (Shift by default)
                if not sprinting then
                    sprinting = true
                    sprintStartTime = GetGameTimer()
                end
            else
                if sprinting then
                    local sprintTime = GetGameTimer() - sprintStartTime
                    if sprintTime >= sprintDuration then
                        TriggerServerEvent("stress:add", 10000) -- Adjust the stress amount as needed
                    end
                    sprinting = false
                end
            end
        end

        Citizen.Wait(1000) -- Check for sprinting every second to avoid constant stress triggering
    end
end)

local fistFightStressAmount = 4000 -- Adjust the stress amount when the player is involved in a fistfight

Citizen.CreateThread(function() --Fist Fighting
    while true do
        local ped = PlayerPedId()

        if IsPedInMeleeCombat(ped) then
            local target = GetMeleeTargetForPed(ped)

            if target and IsEntityAPed(target) then
                TriggerServerEvent("stress:add", fistFightStressAmount)
            end
        end

        Citizen.Wait(1000) -- Check for fistfight every second to avoid constant stress triggering
    end
end)



function AddStress(method, value, seconds)
    if method:lower() == "instant" then
        TriggerServerEvent("stress:add", value)
    elseif method:lower() == "slow" then
        local count = 0
        repeat
            TriggerServerEvent("stress:add", value/seconds)
            count = count + 1
            Citizen.Wait(1000)
        until count == seconds
    end
end

function RemoveStress(method, value, seconds)
    if method:lower() == "instant" then
        TriggerServerEvent("stress:remove", value)
    elseif method:lower() == "slow" then
        local count = 0
        repeat
            TriggerServerEvent("stress:remove", value/seconds)
            count = count + 1
            Citizen.Wait(1000)
        until count == seconds
    end
end
