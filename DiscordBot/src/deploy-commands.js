require('dotenv').config();
const { REST, Routes, SlashCommandBuilder } = require('discord.js');
const { env } = require('./env');

const token = env('DISCORD_TOKEN');
const clientId = env('DISCORD_CLIENT_ID');
const guildId = env('DISCORD_GUILD_ID');

if (!token || !clientId) {
  throw new Error('DISCORD_TOKEN and DISCORD_CLIENT_ID are required.');
}

const commands = [
  new SlashCommandBuilder().setName('server').setDescription('Show Aera server status and online players.'),
  new SlashCommandBuilder().setName('players').setDescription('Show the number of players currently online.'),
  new SlashCommandBuilder().setName('servers').setDescription('List configured Aera game servers.'),
  new SlashCommandBuilder().setName('serverinfo').setDescription('Show information about this Discord server.'),
  new SlashCommandBuilder().setName('uptime').setDescription('Show how long the Aera Discord bot has been running.'),
  new SlashCommandBuilder().setName('whoami').setDescription('Show your Discord account and permission information.'),
  new SlashCommandBuilder().setName('player').setDescription('Look up an Aera player account.')
    .addStringOption(option => option.setName('name').setDescription('Player username or name to search for.').setRequired(true)),
  new SlashCommandBuilder().setName('ping').setDescription('Check the Discord bot latency.'),
  new SlashCommandBuilder().setName('help').setDescription('Show available Aera bot commands.'),
  new SlashCommandBuilder().setName('announce').setDescription('Post an Aera announcement in the current channel.')
    .addStringOption(option => option.setName('message').setDescription('Announcement text.').setRequired(true)),
  new SlashCommandBuilder().setName('kick').setDescription('Kick a member from the Discord server.')
    .addUserOption(option => option.setName('user').setDescription('Member to kick.').setRequired(true))
    .addStringOption(option => option.setName('reason').setDescription('Reason for the kick.').setMaxLength(512)),
  new SlashCommandBuilder().setName('ban').setDescription('Ban a member from the Discord server.')
    .addUserOption(option => option.setName('user').setDescription('Member to ban.').setRequired(true))
    .addStringOption(option => option.setName('reason').setDescription('Reason for the ban.').setMaxLength(512)),
  new SlashCommandBuilder().setName('unban').setDescription('Unban a Discord user by ID.')
    .addStringOption(option => option.setName('user_id').setDescription('Discord user ID.').setRequired(true))
    .addStringOption(option => option.setName('reason').setDescription('Reason for the unban.').setMaxLength(512)),
  new SlashCommandBuilder().setName('timeout').setDescription('Temporarily timeout a Discord member.')
    .addUserOption(option => option.setName('user').setDescription('Member to timeout.').setRequired(true))
    .addIntegerOption(option => option.setName('minutes').setDescription('Timeout duration in minutes.').setMinValue(1).setMaxValue(40320).setRequired(true))
    .addStringOption(option => option.setName('reason').setDescription('Reason for the timeout.').setMaxLength(512)),
  new SlashCommandBuilder().setName('clear').setDescription('Delete recent messages in the current channel.')
    .addIntegerOption(option => option.setName('amount').setDescription('Number of messages to delete (1-100).').setMinValue(1).setMaxValue(100).setRequired(true)),
  new SlashCommandBuilder().setName('botstatus').setDescription('Show detailed Discord bot status.')
].map(command => command.toJSON());

const rest = new REST({ version: '10' }).setToken(token);

(async () => {
  const route = guildId ? Routes.applicationGuildCommands(clientId, guildId) : Routes.applicationCommands(clientId);
  await rest.put(route, { body: commands });
  console.log(`Aera Discord commands deployed (${commands.length} commands).`);
})().catch(error => {
  console.error('Failed to deploy Aera Discord commands:', error);
  process.exitCode = 1;
});
