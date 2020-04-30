--[[ Add Command Functions & Events ]]--
function AddChatCommand(command, callback, suggestion, arguments, job)
    if job ~= nil then
        if job.grade ~= nil then
            job.grade = 1
        end
    end

	commands[command] = {}
	commands[command].cmd = callback
    commands[command].arguments = arguments or -1
    commands[command].job = job

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end

		commandSuggestions[command] = suggestion
	end

    RegisterCommand(command, function(source, args, rawCommand)
        local mPlayer = exports['mythic_base']:getPlayerFromId(source)

        if mPlayer ~= nil then
            local cData = mPlayer.getChar().getCharData()
            if commands[command].job ~= nil then
                for k, v in pairs(commands[command].job) do
                    if v['base'] == cData.job.base then
                        if tonumber(v['grade']) <= cData.job.grade then
                            if((#args <= commands[command].arguments and #args == commands[command].arguments) or commands[command].arguments == -1)then
                                callback(source, args, rawCommand)
                                break
                            else
                                TriggerEvent('mythic_chat:server:Server', source, "Invalid Number Of Arguments")
                            end
                        end
                    end
                end
            else
                if((#args <= commands[command].arguments and #args == commands[command].arguments) or commands[command].arguments == -1)then
                    callback(source, args, rawCommand)
                else
                    TriggerEvent('mythic_chat:server:Server', source, "Invalid Number Of Arguments")
                end
            end
        end
    end, false)
end

RegisterServerEvent('mythic_chat:server:AddChatCommand')
AddEventHandler('mythic_chat:server:AddChatCommand', function(command, callback, suggestion, arguments, job)
    AddChatCommand(command, callback, suggestion, arguments, job)
end)

function AddAdminChatCommand(command, callback, suggestion, arguments)
	commands[command] = {}
	commands[command].cmd = callback
    commands[command].arguments = arguments or -1
    commands[command].admin = true

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end

		commandSuggestions[command] = suggestion
	end

    RegisterCommand(command, function(source, args, rawCommand)
        local mPlayer = exports['mythic_base']:getPlayerFromId(source)
        local mData = mPlayer.getPlayerData()
        if mData.perm_group == 'admin' then
            if((#args <= commands[command].arguments and #args == commands[command].arguments) or commands[command].arguments == -1)then
                callback(source, args, rawCommand)
            else
                TriggerEvent('mythic_chat:server:Server', source, "Invalid Number Of Arguments")
            end
        else
            exports['mythic_pwnzor']:PlayerLog('Mythic Chat', mPlayer, 'Player That Isn\'t An Admin Attempted To Use An Admin Command. | Details [ Command: ' .. command .. ' ]')
            exports['mythic_pwnzor']:CheatLog('Mythic Chat', 'Player That Isn\'t An Admin Attempted To Use An Admin Command. | Details [ Command: ' .. command .. ' User ID: '.. mData.userId .. ' ]')
        end
    end, false)
end

RegisterServerEvent('mythic_chat:server:AddAdminChatCommand')
AddEventHandler('mythic_chat:server:AddAdminChatCommand', function(command, callback, suggestion, arguments)
    AddAdminChatCommand(command, callback, suggestion, arguments)
end)

--[[ COMMANDS ]]--

AddChatCommand('clear', function(source, args, rawCommand)
    TriggerClientEvent('mythic_chat:client:ClearChat', source)
end, {
    help = "Clear The Chat"
})

AddChatCommand('ad', function(source, args, rawCommand)
    local mPlayer = exports['mythic_base']:getPlayerFromId(source)
    local cData = mPlayer.getChar().getCharData()
    fal = cData.firstName .. ' ' .. cData.lastName
    local msg = rawCommand:sub(4)
    TriggerEvent('mythic_chat:server:Advert', fal, cData.phone, msg)
end, {
    help = "Post An Ad For A Service You're Offering",
    params = {{
            name = "Message",
            help = "The Message You Want To Send To Ad Channel"
        }
    }
}, -1)

AddChatCommand('311', function(source, args, rawCommand)
    local mPlayer = exports['mythic_base']:getPlayerFromId(source)
    local name = mPlayer.getChar().getName()
    fal = name.first .. " " .. name.last
    local msg = rawCommand:sub(5)
    TriggerClientEvent('mythic_jobs:client:Do311Alert', source, fal, msg)
end, {
    help = "Non-Emergency Line",
    params = {{
            name = "Message",
            help = "The Message You Want To Send To 311 Channel"
        }
    }
}, -1)

AddChatCommand('911', function(source, args, rawCommand)
    local mPlayer = exports['mythic_base']:getPlayerFromId(source)
    local name = mPlayer.getChar().getName()
    fal = name.first .. " " .. name.last
    local msg = rawCommand:sub(5)
    TriggerClientEvent('mythic_jobs:client:Do911Alert', source, fal, msg)
end, {
    help = "Emergency Line",
    params = {{
            name = "Message",
            help = "The Message You Want To Send To 911 Channel"
        }
    }
}, -1)

--[[ ADMIN-RESTRICTED COMMANDS ]]--
AddAdminChatCommand('server', function(source, args, rawCommand)
    TriggerEvent('mythic_chat:server:Server', source, rawCommand:sub(8))
end, {
    help = "Test",
    params = {{
            name = "Message",
            help = "The Message You Want To Send To 911 Channel"
        }
    }
}, -1)

AddAdminChatCommand('system', function(source, args, rawCommand)
    TriggerEvent('mythic_chat:server:System', source, rawCommand:sub(8))
end, {
    help = "Test",
    params = {{
            name = "Message",
            help = "The Message You Want To Send To 911 Channel"
        }
    }
}, -1)