local citizenID = "player_citizen_id"
local playerName = "JohnDoe"
local playerLicense = "your_license_here"
local experience = "100"

-- Step 1: Check if the player already exists
local checkQuery = 'SELECT * FROM leveling WHERE citizenid = ? AND name = ?'
local checkParams = {citizenID, playerName}

exports.oxmysql:fetch(checkQuery, checkParams, function(result)
    if #result == 0 then
        -- Step 2: If the player does not exist, insert the new data
        local insertQuery = 'INSERT INTO leveling (license, citizenid, name, experience) VALUES (?, ?, ?, ?)'
        local insertParams = {playerLicense, citizenID, playerName, experience}

        exports.oxmysql:insert(insertQuery, insertParams, function(insertedId)
            if Config.Debug then
                print("Inserted new player data with ID: " .. insertedId)
            end
        end)
    else
        if Config.Debug then
            print("Player already exists in the database, skipping insertion.")
        end
    end
end)
