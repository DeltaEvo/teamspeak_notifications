require("ts3init")

local function onTextMessageEvent(serverConnectionHandlerID, targetMode, toID, fromID, fromName, fromUniqueIdentifier, message, ffIgnored)
        local id, error = ts3.getClientID(serverConnectionHandlerID)
        if error ~= ts3errors.ERROR_ok then
                print("Error getting own client ID: " .. error)
                return
        end
        local channel
        if targetMode == ts3defs.TextMessageTargetMode.TextMessageTarget_CLIENT then channel = fromName
        elseif targetMode == ts3defs.TextMessageTargetMode.TextMessageTarget_SERVER then channel = "Global"
        elseif targetMode == ts3defs.TextMessageTargetMode.TextMessageTarget_MAX then channel = "Max"
        elseif targetMode == ts3defs.TextMessageTargetMode.TextMessageTarget_CHANNEL then
                -- Get which channel we are in
                local channelID, error = ts3.getChannelOfClient(serverConnectionHandlerID, id)
                if error ~= ts3errors.ERROR_ok then
                        print("Error getting own channel: " .. error)
                        return
                end
                -- Get the name of my channel
                local chan, error = ts3.getChannelVariableAsString(serverConnectionHandlerID, channelID, ts3defs.ChannelProperties.CHANNEL$
                if error ~= ts3errors.ERROR_ok then
                        print("Error getting channel name: " .. error)
                        return
                end
                channel = chan

        end
        if fromID ~= id then
                os.execute("notify-send --icon \"/usr/share/pixmaps/teamspeak3.png\" \"Teamspeak: ".. channel .."\" \"" .. message .. "\"")
        end
end

ts3RegisterModule("notify", {
    onTextMessageEvent = onTextMessageEvent
})
