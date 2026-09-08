-- Aera v30.6 current client normalization.
-- Safe for existing player/account/gameplay data.
UPDATE site_settings SET SettingValue='https://nightvaults.com/' WHERE SettingKey IN ('site.url','game.base_url');
UPDATE site_settings SET SettingValue='https://nightvaults.com/gamefiles/' WHERE SettingKey='gamefiles.base_url';
UPDATE settings_login SET value='aClient-04.swf' WHERE name='sFile' AND location='loader';
