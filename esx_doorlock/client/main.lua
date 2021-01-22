ESX = nil
playerCoords = nil
closestK, closestV, closestD, closestA = nil, nil, nil, false
unlockedtext = true

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	ESX.PlayerData = ESX.GetPlayerData()
	-- Update the door list
	ESX.TriggerServerCallback('esx_doorlock:getDoorInfo', function(doorInfo)
		for doorID,state in pairs(doorInfo) do
			Config.DoorList[doorID].locked = state
		end
	end)
end)

function DrawText3D(coords, text, size)
    local onScreen,_x,_y=World3dToScreen2d(coords.x,coords.y,coords.z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextDropShadow()
    SetTextProportional(1.2)
    SetTextColour(255, 255, 255, 150)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
	local factor = (string.len(text)) / 370
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

RegisterNetEvent('dooranim')
AddEventHandler('dooranim', function(entity, turn)
	if turn then
		local coords = GetEntityCoords(entity)
		TaskTurnPedToFaceCoord(playerPed, vector3(coords), -1)
		Citizen.Wait(250)
		while true do
			Citizen.Wait(0)
			local rotation = #(GetEntityRotationVelocity(playerPed))
			if rotation == 0 then break end
		end
	end
    ClearPedSecondaryTask(playerPed)
    loadAnimDict("anim@heists@keycard@") 
    TaskPlayAnim(playerPed, "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
    Citizen.Wait(550)
    ClearPedTasks(playerPed)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

function round(n)
	return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end

function round2(num)
	local mult = 10^(2)
	return math.floor(num * mult + 0.5) / mult
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		playerPed = PlayerPedId()
		local d, distance = 0, 0
		for _,doorID in ipairs(Config.DoorList) do

			if initiated and doorID.textCoords then
				if doorID.textCoords then d = #(doorID.textCoords - playerCoords) end
			end
			if (initiated and d < 30.0) then

				if not doorID.textCoords and DoesEntityExist(doorID.object) and not doorID.doors then
					local minDimension, maxDimension = GetModelDimensions(doorID.objHash)
					if doorID.flip then dimensions = minDimension - maxDimension else dimensions = maxDimension - minDimension end
					local dx, dy = tonumber(string.sub(dimensions.x, 1, 6)), tonumber(string.sub(dimensions.y, 1, 6))
					if doorID.print then print (dx..' '..dy) end
					if doorID.objHeading == 90.0 or doorID.objHeading == 270.0 then dx, dy = dy, dx end
					doorID.textCoords = GetEntityCoords(doorID.object) - vector3(dx/2, dy/2, 0)
				end
				if doorID.doors then
					for k,v in ipairs(doorID.doors) do
						if v.object and DoesEntityExist(v.object) then
							if k == 2 and not doorID.setText then
								distance = doorID.textCoords - v.objCoords
								doorID.textCoords = (doorID.textCoords - (distance / 2))
								doorID.setText = true
							end
							if not doorID.textCoords and k == 1 then
								doorID.textCoords = v.objCoords
							else
								doorID.distanceToPlayer = 1
							end
						else
							doorID.distanceToPlayer = nil
							v.object = GetClosestObjectOfType(v.objCoords, 1.0, v.objHash, false, false, false)
							if doorID.delete and DoesEntityExist(v.object) then
								SetEntityAsMissionEntity(v.object, 1, 1)
								DeleteObject(v.object)
								SetEntityAsNoLongerNeeded(v.object)
							end
						end
					end
				else
					if doorID.object and DoesEntityExist(doorID.object) then
						doorID.distanceToPlayer = 1
					else
						doorID.distanceToPlayer = nil
						doorID.object = GetClosestObjectOfType(doorID.objCoords, 1.0, doorID.objHash, false, false, false)
						if doorID.delete and DoesEntityExist(doorID.object) then
							SetEntityAsMissionEntity(doorID.object, 1, 1)
							DeleteObject(doorID.object)
							SetEntityAsNoLongerNeeded(doorID.object)
						end
					end
				end
			end
		end
		if not initiated then initiated = true else Citizen.Wait(1000) end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local letSleep, sleepLen, distance = true, 500, 0
		for k,v in ipairs(Config.DoorList) do
			local isAuthorized = IsAuthorized(v)
			if v.textCoords then distance = #(v.textCoords - playerCoords) end
			if v.distanceToPlayer and distance < (v.maxDistance * 2) then
				sleepLen = 100
				if v.doors then
					for k2,v2 in ipairs(v.doors) do
						if v.locked then
							if v2.objHeading and tonumber(round(GetEntityHeading(v2.object))..'.0') == v2.objHeading then
								FreezeEntityPosition(v2.object, 1)
								SetEntityRotation(v2.object, 0.0, 0.0, v2.objHeading, 2, true)
							else letSleep = false end
						else
							if v2.objHeading and tonumber(round(GetEntityHeading(v2.object))..'.0') == v2.objHeading then
								FreezeEntityPosition(v2.object, 0)
								letSleep = true
								sleepLen = 50
							else letSleep = false end
						end
					end
				else
					if v.slides and v.locked then
						coords = GetEntityCoords(v.object)
						if round2(v.objCoords.x) == round2(coords.x) and round2(v.objCoords.y) == round2(coords.y) and round2(v.objCoords.z) == round2(coords.z) then
							FreezeEntityPosition(v.object, 1)
						else letSleep = false end
					elseif v.locked and not v.slides then
						if v.objHeading and tonumber(round(GetEntityHeading(v.object))..'.0') == v.objHeading then
							FreezeEntityPosition(v.object, 1)
							SetEntityRotation(v.object, 0.0, 0.0, v.objHeading, 2, true)
						else letSleep = false end
					else
						if v.objHeading and tonumber(round(GetEntityHeading(v.object))..'.0') == v.objHeading then
							FreezeEntityPosition(v.object, 0)
							letSleep = true
							sleepLen = 50
						else letSleep = false end
					end
				end
			end
			if v.distanceToPlayer and distance < v.maxDistance then
				closestK, closestV, closestD, closestA = k, v, #(v.textCoords - playerCoords), isAuthorized
			end
		end
		if letSleep then
			Citizen.Wait(sleepLen)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		playerCoords = GetEntityCoords(playerPed)
		if closestK and closestV and closestD then
			closestD = #(closestV.textCoords - playerCoords)
			if closestD < closestV.maxDistance and not closestV.auto then
				if not closestV.doors then
					if not IsEntityStatic(closestV.object) and closestV.locked then DrawText3D(closestV.textCoords, 'Locking', 1)
					elseif closestV.locked then DrawText3D(closestV.textCoords, 'Locked', 1) else if unlockedtext then DrawText3D(closestV.textCoords, 'Unlocked', 1) end end
				else
					local door = {}
					for k2,v2 in ipairs(closestV.doors) do
						if not IsEntityStatic(v2.object) and closestV.locked then door[k2] = 'Locking' elseif closestV.locked then door[k2] = 'Locked' elseif not closestV.locked and unlockedtext then door[k2] = 'Unlocked' end
					end
					if door[1] == door[2] and door[1] == 'Locked' then DrawText3D(closestV.textCoords, 'Locked', 1)
					elseif not closestV.locked and unlockedtext then DrawText3D(closestV.textCoords, 'Unlocked', 1)
					elseif closestV.locked then DrawText3D(closestV.textCoords, 'Locking', 1) end
				end
				if IsControlJustReleased(0, 38) and closestA then
					if not IsPedInAnyVehicle(playerPed) then TriggerEvent("dooranim", closestV.object, closestV.locked) end
					closestV.locked = not closestV.locked
					TriggerServerEvent('esx_doorlock:updateState', closestK, closestV) -- Broadcast new state of the door to everyone
				end
			else
				closestK, closestV, closestD, closestA = nil, nil, nil, false
			end
		else Citizen.Wait(100) end
	end
end)

function IsAuthorized(doorID)
	if ESX.PlayerData.job == nil then
		return false
	end

	for _,job in pairs(doorID.authorizedJobs) do
		if job == ESX.PlayerData.job.name then
			return true
		end
	end

	return false
end

-- Set state for a door
RegisterNetEvent('esx_doorlock:setState')
AddEventHandler('esx_doorlock:setState', function(doorID, state)
	Config.DoorList[doorID].locked = state
end)
