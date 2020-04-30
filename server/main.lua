AddEventHandler('chatMessage', function(source, n, message)
    local mPlayer = exports['mythic_base']:getPlayerFromId(source)
    
    if mPlayer ~= nil then
        local char = mPlayer.getChar()
        if char ~= nil then
            local cData = char.getCharData()

            if(starts_with(message, '/'))then
                local command_args = stringsplit(message, " ")

                command_args[1] = string.gsub(command_args[1], '/', "")

                local commandName = command_args[1]

                if commands[commandName] ~= nil then
                    if commands[commandName].job ~= nil then
                        for k, v in pairs(commands[commandName].job) do
                            if cData.job.base == v.base then
                                local command = commands[commandName]
                            end
                        end
                    else
                        local command = commands[commandName]
                    end

                    if(command)then
                        local Source = source
                        CancelEvent()
                        table.remove(command_args, 1)
                        if (not (command.arguments <= (#command_args - 1)) and command.arguments > -1) then
                            TriggerEvent('mythic_chat:server:Server', source, "Invalid Number Of Arguments")
                        end
                    else
                        TriggerEvent('mythic_chat:server:Server', source, "Invalid Command Handler")
                    end
                else
                    TriggerEvent('mythic_chat:server:Server', source, "Invalid Command")
                end
            else
                local mPlayer = exports['mythic_base']:getPlayerFromId(source)
                local char = mPlayer.getChar()
                local name = char.getName()

                fal = name.first .. " " .. name.last
                TriggerClientEvent('chat:addMessage', -1, {
                    template = '<div class="chat-message"><div class="chat-message-header">[OOC] {0}:</div><div class="chat-message-body">{1}</div></div>',
                    args = { fal, message }
                })
            end
        else
            
        end
        CancelEvent()
    end
end)

RegisterServerEvent('mythic_chat:server:Server')
AddEventHandler('mythic_chat:server:Server', function(source, message)
    TriggerClientEvent('chat:addMessage', source, {
        template = '<div class="chat-message server"><div class="chat-message-header">[SERVER]</div><div class="chat-message-body">{0}</div></div>',
        args = { message }
    })
    CancelEvent()
end)

RegisterServerEvent('mythic_chat:server:ServerToAll')
AddEventHandler('mythic_chat:server:ServerToAll', function(message)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message server"><div class="chat-message-header">[SERVER]</div><div class="chat-message-body">{0}</div></div>',
        args = { message }
    })
    CancelEvent()
end)

RegisterServerEvent('mythic_chat:server:System')
AddEventHandler('mythic_chat:server:System', function(source, message)
    TriggerClientEvent('chat:addMessage', source, {
        template = '<div class="chat-message system"><div class="chat-message-header">[SYSTEM]</div><div class="chat-message-body">{0}</div></div>',
        args = { message }
    })
    CancelEvent()
end)

RegisterServerEvent('mythic_chat:server:SystemToAll')
AddEventHandler('mythic_chat:server:SystemToAll', function(message)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message system"><div class="chat-message-header">[SYSTEM]</div><div class="chat-message-body">{0}</div></div>',
        args = { message }
    })
    CancelEvent()
end)

RegisterServerEvent('mythic_chat:server:Advert')
AddEventHandler('mythic_chat:server:Advert', function(name, phone, message)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message advert"><div class="chat-message-header"><i class="fas fa-ad"></i> Advertisement: {0} | {1}</div><div class="chat-message-body">{2}</div></div>',
        args = { name, phone, message }
    })
    CancelEvent()
end)

RegisterServerEvent('mythic_chat:server:311Alert')
AddEventHandler('mythic_chat:server:311Alert', function(name, location, message)
    local players = exports['mythic_base']:getPlayers()
    for i = 1, #players, 1 do
        local cData = exports['mythic_base']:getPlayerFromId(players[i]).getChar().getCharData()
        if cData.job.base == 'police' or cData.job.base == 'ems' or players[i] == source then
            TriggerClientEvent('chat:addMessage', exports['mythic_base']:getPlayerFromId(players[i]).getSource(), {
                template = '<div class="chat-message nonemergency"><div class="chat-message-header">[311] | Caller : {0} | Location : {1}</div><div class="chat-message-body">{2}</div></div>',
                args = { name, location, message }
            })
        end
    end

    CancelEvent()
end)

RegisterServerEvent('mythic_chat:server:911Alert')
AddEventHandler('mythic_chat:server:911Alert', function(name, location, message)
    local players = exports['mythic_base']:getPlayers()
    for i = 1, #players, 1 do
        local cData = exports['mythic_base']:getPlayerFromId(players[i]).getChar().getCharData()
        if cData.job.base == 'police' or i == source then
            TriggerClientEvent('chat:addMessage', exports['mythic_base']:getPlayerFromId(players[i]).getSource(), {
                template = '<div class="chat-message emergency"><div class="chat-message-header">[911] | Caller : {0} | Location : {1}</div><div class="chat-message-body">{2}</div></div>',
                args = { name, location, message }
            })
        end
    end

    CancelEvent()
end)

RegisterServerEvent('mythic_chat:server:PoliceDispatch')
AddEventHandler('mythic_chat:server:PoliceDispatch', function(code, gender, locale, message)
    local players = exports['mythic_base']:getPlayers()
    for i = 1, #players, 1 do
        local cData = exports['mythic_base']:getPlayerFromId(players[i]).getChar().getCharData()
        if cData.job.base == 'police' then
            TriggerClientEvent('chat:addMessage', exports['mythic_base']:getPlayerFromId(players[i]).getSource(), {
                template = '<div class="chat-message emergency"><div class="chat-message-header">[911 Dispatch] | {0} - {1} | Location : {2}</div><div class="chat-message-body">{3}</div></div>',
                args = { code, gender, locale, message }
            })
        end
    end

    CancelEvent()
end)

RegisterServerEvent('mythic_chat:server:EmergencyDispatch')
AddEventHandler('mythic_chat:server:EmergencyDispatch', function(name, location, message)
    local players = exports['mythic_base']:getPlayers()
    for i = 1, #players, 1 do
        local cData = exports['mythic_base']:getPlayerFromId(players[i]).getChar().getCharData()
        if cData.job.base == 'police' or cData.job.base == 'ems' then
            TriggerClientEvent('chat:addMessage', exports['mythic_base']:getPlayerFromId(players[i]).getSource(), {
                template = '<div class="chat-message nonemergency"><div class="chat-message-header">[311 Dispatch] | Caller : {0} | Location : {1}</div><div class="chat-message-body">{2}</div></div>',
                args = { name, location, message }
            })
        end
    end

    CancelEvent()
end)

RegisterServerEvent('mythic_chat:server:SendMeToNear')
AddEventHandler('mythic_chat:server:SendMeToNear', function(source, message)
    local src = source
    TriggerClientEvent('mythic_chat:client:ReceiveMe', -1, src, message)
end)

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end