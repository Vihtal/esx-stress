ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent("stress:add")
AddEventHandler("stress:add", function (value)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local playername = xPlayer.name

    if xPlayer.job.name == "police" then
        -- If the player is a police officer, they gain half the stress.
        -- You can add different jobs using the same method here.
        TriggerClientEvent("esx_status:add", _source, "stress", value / 2) -- Use value / 2 instead of value / 10
    else
        TriggerClientEvent("esx_status:add", _source, "stress", value)
    end
end)


RegisterServerEvent("stress:remove") -- remove stress
AddEventHandler("stress:remove", function (value)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local playername = xPlayer.name

	TriggerClientEvent("esx_status:remove", _source, "stress", value)
	if log then
		SaveLog("Stress removed : "..value, playername)
	end
end)
