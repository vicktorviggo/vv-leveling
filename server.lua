-- Function to insert new player data
local function insertPlayerData(citizenID, playerLicense, newexperience)
    if Config.DebugPrints then
        print("attempting to create new data for ID: " .. citizenID)
    end
    local insertQuery = 'INSERT INTO leveling (license, citizenid, experience) VALUES (?, ?, ?)'
    local insertParams = {playerLicense, citizenID, newexperience}

    exports.oxmysql:insert(insertQuery, insertParams, function()
        if Config.DebugPrints then
            print("Inserted new player data for ID: " .. citizenID)
        end
    end)
end

-- Function to update existing player data
local function updatePlayerExperience(citizenID, playerLicense, newexperience)
    if Config.DebugPrints then
        print("attempting to update " .. citizenID .. "'s experience")
    end
    local checkQuery = 'SELECT experience FROM leveling WHERE citizenid = ? AND license = ?'
    local checkParams = {citizenID, playerLicense}
    print("1")
    exports.oxmysql:fetch(checkQuery, checkParams, function(result)
        print("2")
        if result and #result > 0 then
            print("3")
            local playerData = result[1]
            print("4")
            local updatedExperience = newexperience + playerData.experience
            
            local updateQuery = 'UPDATE leveling SET experience = ? WHERE citizenid = ? AND license = ?'
            local updateParams = {updatedExperience, citizenID, playerLicense}
            
            exports.oxmysql:update(updateQuery, updateParams, function(rowsAffected)
                if Config.DebugPrints then
                    print("Updated player " .. citizenID .. "'s experience. Rows affected: " .. rowsAffected)
                end
            end)
        end
    end)
end

-- Main event handler
RegisterServerEvent('leveling:addPlayerData')
AddEventHandler('leveling:addPlayerData', function(citizenID, playerLicense, newexperience)
    local checkQuery = 'SELECT COUNT(*) as count FROM leveling WHERE citizenid = ? AND license = ?'
    local checkParams = {citizenID, playerLicense}

    exports.oxmysql:fetch(checkQuery, checkParams, function(result)
        if result[1].count == 0 then
            -- Player does not exist, insert new data
            if Config.DebugPrints then
                print("No data foundt for" .. citizenID)
            end
            insertPlayerData(citizenID, playerLicense, newexperience)
        else
            -- Player exists, update experience
            if Config.DebugPrints then
                print("Data foundt for" .. citizenID)
            end
            updatePlayerExperience(citizenID, newexperience)
        end
    end)
end)