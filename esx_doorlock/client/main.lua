ESX = nil
closestDoor, closestV, closestDistance, closestA, playerPed, playerCoords, playerNotActive = nil, nil, nil, false, nil, nil, true

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
	local onScreen,_x,_y = World3dToScreen2d(coords.x,coords.y,coords.z)
	local px,py,pz = table.unpack(GetGameplayCamCoords())
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

function dooranim(entity, state)
    loadAnimDict("anim@heists@keycard@") 
    TaskPlayAnim(playerPed, "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
    Citizen.Wait(550)
    ClearPedTasks(playerPed)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

function round(num, decimal)
	local mult = 10^(decimal)
	return math.floor(num * mult + 0.5) / mult
end

function updateDoors(useDistance)
	for _,doorID in ipairs(Config.DoorList) do
		
			if doorID.doors then
				for k,v in ipairs(doorID.doors) do
					if v.object and DoesEntityExist(v.object) then
						doorID.exists = 1
					else
						doorID.exists = nil
						v.object = GetClosestObjectOfType(v.objCoords, 1.0, v.objHash, false, false, false)
						
						if doorID.delete and DoesEntityExist(v.object) then
							DeleteObject(v.object)
							SetEntityAsNoLongerNeeded(v.object)
						end
						if DoesEntityExist(v.object) then
							doorID.exists = 1
						end
					end
				end
			else
				if doorID.object and DoesEntityExist(doorID.object) then
					doorID.exists = 1
				else
					doorID.exists = nil
					doorID.object = GetClosestObjectOfType(doorID.objCoords, 1.0, doorID.objHash, false, false, false)
					
					if doorID.delete and DoesEntityExist(doorID.object) then
						DeleteObject(doorID.object)
						SetEntityAsNoLongerNeeded(doorID.object)
					end
					if DoesEntityExist(doorID.object) then
						doorID.exists = 1
					end
				end
			end
			-- set text coords
			if not doorID.setText and doorID.doors then
				for k,v in ipairs(doorID.doors) do
					if k == 1 and doorID.exists then
						doorID.textCoords = v.objCoords
					elseif k == 2 and doorID.exists then
						local textDistance = doorID.textCoords - v.objCoords
						doorID.textCoords = (doorID.textCoords - (textDistance / 2))
						doorID.setText = true
					end
				end
			elseif not doorID.setText and not doorID.doors and doorID.exists then
				if not doorID.garage then
					local minDimension, maxDimension = GetModelDimensions(doorID.objHash)
					if doorID.fixText then dimensions = minDimension - maxDimension else dimensions = maxDimension - minDimension end
					local dx, dy = tonumber(string.sub(dimensions.x, 1, 6)), tonumber(string.sub(dimensions.y, 1, 6))
					local h = tonumber(string.sub(doorID.objHeading, 1, 1))
					if h == 9 or h == 8 or h == 2 then dx, dy = dy, dx end
					local maths = vector3(dx/2, dy/2, 0)
					doorID.textCoords = GetEntityCoords(doorID.object) - maths
					doorID.setText = true
				else
					doorID.textCoords = GetEntityCoords(doorID.object)
					doorID.setText = true
				end
				--print(doorID.textCoords)
			end

	end
end

Citizen.CreateThread(function()
	while true do
		if playerNotActive and playerCoords then
			Citizen.Wait(500)
			if not IsPedStill(playerPed) then
				playerNotActive = nil
				lastCoords = playerCoords
				updateDoors()
				Citizen.Wait(500)
				updateDoors()
			end
		elseif not playerNotActive then
			local distance = #(playerCoords - lastCoords)
			if distance > 30 then
				Citizen.Wait(500)
				updateDoors()
				--print(distance)
				lastCoords = playerCoords
			end
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while not playerCoords do Citizen.Wait(0) end
	while true do
		Citizen.Wait(0)
		local letSleep, sleepLen, distance = true, 500, 0
		for k,v in ipairs(Config.DoorList) do
			local isAuthorized = IsAuthorized(v)
			if v.setText then distance = #(v.textCoords - playerCoords) end
			if v.exists and distance < (v.maxDistance * 2) then
				sleepLen = 100
				if v.doors then
					for k2,v2 in ipairs(v.doors) do
						if v.locked then
							if v2.objHeading and round(GetEntityHeading(v2.object), 0) == round(v2.objHeading, 0) then
								FreezeEntityPosition(v2.object, 1)
								SetEntityRotation(v2.object, 0.0, 0.0, round(v2.objHeading, 1), 2, true)
							else letSleep = false end
						else
							if v2.objHeading and round(GetEntityHeading(v2.object), 0) == round(v2.objHeading, 0) then
								FreezeEntityPosition(v2.object, 0)
								letSleep = true
								sleepLen = 50
							else letSleep = false end
						end
					end
				else
					if v.slides and v.locked then
						coords = GetEntityCoords(v.object)
						if round(#(coords - v.objCoords), 1) == 0.0 then
							FreezeEntityPosition(v.object, 1)
						else letSleep = false end
					elseif v.locked and not v.slides then
						if v.objHeading and round(GetEntityHeading(v.object), 0) == round(v.objHeading, 0) then
							FreezeEntityPosition(v.object, 1)
							SetEntityRotation(v.object, 0.0, 0.0, round(v.objHeading, 1), 2, true)
						else letSleep = false end
					else
						local objVelocity = #(GetEntityRotationVelocity(v.object))
						if objVelocity == 0.0 then
							FreezeEntityPosition(v.object, 0)
							letSleep = true
							sleepLen = 50
						else letSleep = false end
					end
				end
			end
			if v.exists and distance < v.maxDistance then
				closestDoor, closestV, closestDistance, closestA = k, v, #(v.textCoords - playerCoords), isAuthorized
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
		playerPed = PlayerPedId()
		playerCoords = GetEntityCoords(playerPed)
		if closestDistance then
			closestDistance = #(closestV.textCoords - playerCoords)
			if closestDistance < closestV.maxDistance and closestV.setText then
				if not closestV.doors then
					if not IsEntityStatic(closestV.object) and closestV.locked then DrawText3D(closestV.textCoords, 'Locking', 1)
					elseif closestV.locked then
						DrawText3D(closestV.textCoords, 'Locked', 1)
					else if Config.ShowUnlockedText then DrawText3D(closestV.textCoords, 'Unlocked', 1) end end
				else
					local door = {}
					for k2,v2 in ipairs(closestV.doors) do
						if not IsEntityStatic(v2.object) and closestV.locked then door[k2] = 'Locking' elseif closestV.locked then door[k2] = 'Locked' elseif not closestV.locked and Config.ShowUnlockedText then door[k2] = 'Unlocked' end
					end
					if door[1] == door[2] and door[1] == 'Locked' then DrawText3D(closestV.textCoords, 'Locked', 1)
					elseif not closestV.locked and Config.ShowUnlockedText then DrawText3D(closestV.textCoords, 'Unlocked', 1)
					elseif closestV.locked then DrawText3D(closestV.textCoords, 'Locking', 1) end
				end
				if closestA and IsControlJustReleased(0, 38) then
					if not IsPedInAnyVehicle(playerPed) then dooranim(closestV.object, closestV.locked) end
					closestV.locked = not closestV.locked
					TriggerServerEvent('esx_doorlock:updateState', closestDoor, closestV.locked) -- Broadcast new state of the door to everyone
				end
			else
				closestDoor, closestV, closestDistance, closestA = nil, nil, nil, false
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
