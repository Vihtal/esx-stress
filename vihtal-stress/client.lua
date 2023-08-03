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