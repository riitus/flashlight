ESX = nil

M_7g4614(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local eq = false
local fon = true
DecorRegister(decor_fon,2)
DecorRegister(decor_eq,2)

M_7g4614(function()
	while true do 
		Citizen.Wait(200)
		if GetSelectedPedWeapon(PlayerPedId()) == `weapon_flashlight` and not eq then
			eq = true
			Citizen.Wait(2000)
			ESX.Streaming.RequestAnimDict('amb@incar@male@patrol@torch@base', function()
				TaskPlayAnim(PlayerPedId(), 'amb@incar@male@patrol@torch@base', 'base', 8.0, -8.0, -1, 49, 0.0, false, false, false)
			end)
			DecorSetBool(PlayerPedId(),decor_eq,true)
		elseif GetSelectedPedWeapon(PlayerPedId()) ~= `weapon_flashlight` and eq then
			eq = false
			fon = false
		end
	end
	
end)
M_7g4614(function()
	while true do
		if eq then
			DisableControlAction(0,25,false)
			if IsControlJustPressed(0,68) and not fon then
				fon = true
				DecorSetBool(PlayerPedId(),decor_fon,true)
			elseif IsControlJustPressed(0,68) and fon then
				fon = false
				DecorSetBool(PlayerPedId(),decor_fon,false)
			end
		end
		Citizen.Wait(1)
	end
end)

local letSleep = true
M_7g4614(function()
	while true do
		Citizen.Wait(5)
		for _, player in ipairs(GetActivePlayers()) do
			local ped = GetPlayerPed(player)
			if GetSelectedPedWeapon(ped) == `weapon_flashlight` then
				letSleep = false
				AttachEntityToEntity(GetCurrentPedWeaponEntityIndex(ped), ped, GetPedBoneIndex(ped, 57005), 0.125, 0.07, -0.03, 55.0, -125.0, 0.0, 0, 0, 1, 0, 0, 1)
				if DecorGetBool(ped,decor_fon) then
					local coords = GetEntityCoords(GetCurrentPedWeaponEntityIndex(ped))
					local kierunek = GetEntityRotation(ped)
					local vec = RotAnglesToVec(kierunek)
					DrawSpotLight(coords.x,coords.y,coords.z,vec.x,vec.y,vec.z,255,255,255,100.0,15.0,25.0,15.0,50.0)
				end
			end		
		end
		if letSleep then Citizen.Wait(3000) end
	end
end)

function RotAnglesToVec(rot)
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z)*num, math.cos(z)*num, math.sin(x))
end