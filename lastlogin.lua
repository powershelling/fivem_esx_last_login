ALTER TABLE users DROP COLUMN last_login;
ALTER TABLE users ADD COLUMN last_login DATETIME;


-- On server\main.lua from es_extended

function onPlayerJoined(playerId)
  local identifier = ESX.GetIdentifier(playerId)
  if identifier then
    if ESX.GetPlayerFromIdentifier(identifier) then
      DropPlayer(playerId,
        ('there was an error loading your character!\nError code: identifier-active-ingame\n\nThis error is caused by a player on this server who has the same identifier as you have. Make sure you are not playing on the same Rockstar account.\n\nYour Rockstar identifier: %s'):format(
          identifier))
    else
      local result = MySQL.scalar.await('SELECT 1 FROM users WHERE identifier = ?', {identifier})
      if result then
        loadESXPlayer(identifier, playerId, false)
      else
        createESXPlayer(identifier, playerId)
      end
    end
  else
    DropPlayer(playerId,
      'there was an error loading your character!\nError code: identifier-missing-ingame\n\nThe cause of this error is not known, your identifier could not be found. Please come back later or report this problem to the server administration team.')
  end
end

function loadESXPlayer(identifier, playerId, isNewPlayer)
  -- ...
  -- Your other code here
  -- ...

  -- Get the current date in day-month-year format
  local currentDate = os.date('%d-%m-%Y')

  -- Update the last_login column with the current date
  MySQL.Sync.execute('UPDATE users SET last_login = @last_login WHERE identifier = @identifier', {['@last_login'] = currentDate, ['@identifier'] = identifier})

  -- ...
  -- Your other code here
  -- ...
end



