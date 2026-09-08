-- Aera v30.3 HTTPS + deployed-client normalization.
-- Safe for existing player/account/gameplay data.
UPDATE site_settings SET SettingValue='https://nightvaults.com/' WHERE SettingKey IN ('site.url','game.base_url');
UPDATE site_settings SET SettingValue='https://nightvaults.com/gamefiles/' WHERE SettingKey='gamefiles.base_url';
-- The supplied production client is aClient-04.swf (HTTPS-fixed). Normalize older live DBs without touching player data.
UPDATE settings_login SET value='aClient-04.swf' WHERE name='sFile' AND location='loader' AND value IN ('aClient-03.swf','Game3089.swf','aClient-04.swf');
