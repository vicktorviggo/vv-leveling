-- Function to insert new player data
local function insertPlayerData(citizenID, playerLicense, newexperience)
    if Config.DebugPrints then
        print("Attempting to create new data for ID: " .. citizenID)
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
        print("Attempting to update " .. citizenID .. "'s experience")
    end
    local checkQuery = 'SELECT experience FROM leveling WHERE citizenid = ? AND license = ?'
    local checkParams = {citizenID, playerLicense}

    exports.oxmysql:fetch(checkQuery, checkParams, function(result)
        if result and #result > 0 then
            local playerData = result[1]
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
-- RegisterServerEvent('leveling:addPlayerData')
RegisterNetEvent('leveling:addPlayerData', function(citizenID, playerLicense, newexperience)
    local checkQuery = 'SELECT COUNT(*) as count FROM leveling WHERE citizenid = ? AND license = ?'
    local checkParams = {citizenID, playerLicense}

    exports.oxmysql:fetch(checkQuery, checkParams, function(result)
        if result and result[1].count == 0 then
            -- Player does not exist, insert new data
            if Config.DebugPrints then
                print("No data found for " .. citizenID)
            end
            insertPlayerData(citizenID, playerLicense, newexperience)
        else
            -- Player exists, update experience
            if Config.DebugPrints then
                print("Data found for " .. citizenID)
            end
            updatePlayerExperience(citizenID, playerLicense, newexperience)
        end
    end)
end)