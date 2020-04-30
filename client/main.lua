function Print3DText(coords, text)
	local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)

	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 255)
		SetTextDropShadow(0, 0, 0, 55)
		SetTextEdge(0, 0, 0, 150)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)

		local factor = (string.len(text)) / 370
		DrawRect(_x,_y + 0.0125, 0.015 + factor, 0.03, 255, 0, 0, 68)
	end
end

RegisterNetEvent('mythic_chat:client:ReceiveMe')
AddEventHandler('mythic_chat:client:ReceiveMe', function(sender, message)
  print("Recieved Packet From Server For /me, Checking If Near Sender")
  local me = PlayerId()
  local senderClient = GetPlayerFromServerId(sender)
  if senderClient == me then
    Citizen.CreateThread(function()
      local timer = 1

      while timer <= 500 do
        local senderPos = GetEntityCoords(GetPlayerPed(senderClient))
        Print3DText(senderPos, message)
        timer = timer + 1

        Citizen.Wait(1)
      end
    end)
  elseif #(vector3(senderPos.x, senderPos.y, senderPos.z) - GetEntityCoords(GetPlayerPed(me))) < 20.0 then
    if HasEntityClearLosToEntity(GetPlayerPed(me), GetPlayerPed(senderClient), 17 ) then
      Citizen.CreateThread(function()
        local timer = 1

        while timer <= 500 do
          local senderPos = GetEntityCoords(GetPlayerPed(senderClient))
          Print3DText(senderPos, message)
          timer = timer + 1

          Citizen.Wait(1)
        end
      end)
    end
  end
end)

RegisterNetEvent('sendProximityMessage')
AddEventHandler('sendProximityMessage', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "^4" .. name .. "", {0, 153, 204}, "^7 " .. message)
  elseif #(vector3(GetEntityCoords(GetPlayerPed(myId))) - GetEntityCoords(GetPlayerPed(pid))) < 19.999 then
    TriggerEvent('chatMessage', "^4" .. name .. "", {0, 153, 204}, "^7 " .. message)
  end
end)

RegisterNetEvent('sendProximityMessageMe')
AddEventHandler('sendProximityMessageMe', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 " .. name .." ".."^6 " .. message)
  elseif #(vector3(GetEntityCoords(GetPlayerPed(myId))) - GetEntityCoords(GetPlayerPed(pid))) < 19.999 then
    TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 " .. name .." ".."^6 " .. message)
  end
end)

RegisterNetEvent('sendProximityMessageDo')
AddEventHandler('sendProximityMessageDo', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "", {255, 0, 0}, " ^0* " .. name .."  ".."^0  " .. message)
  elseif #(vector3(GetEntityCoords(GetPlayerPed(myId))) - GetEntityCoords(GetPlayerPed(pid))) < 19.999 then
    TriggerEvent('chatMessage', "", {255, 0, 0}, " ^0* " .. name .."  ".."^0  " .. message)
  end
end)