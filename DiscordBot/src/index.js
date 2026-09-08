require('dotenv').config();
const http = require('node:http');
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const { Client, GatewayIntentBits, Events, PermissionFlagsBits, EmbedBuilder } = require('discord.js');
const { pool } = require('./db');
const { env, envNumber } = require('./env');

const discordToken = env('DISCORD_TOKEN');
if (!discordToken) throw new Error('DISCORD_TOKEN is required. Copy .env.example to .env and configure the bot.');

const parseRoleIds = name => env(name).split(',').map(value => value.trim()).filter(Boolean);
const moderatorRoleIds = parseRoleIds('DISCORD_MOD_ROLE_IDS');
const administratorRoleIds = parseRoleIds('DISCORD_ADMIN_ROLE_IDS');
const client = new Client({ intents: [GatewayIntentBits.Guilds] });
const botStartedAt = Date.now();

function hasConfiguredRole(interaction, roleIds) {
  return roleIds.length > 0 && interaction.member?.roles?.cache?.some(role => roleIds.includes(role.id));
}
function isModerator(interaction) {
  if (hasConfiguredRole(interaction, moderatorRoleIds) || hasConfiguredRole(interaction, administratorRoleIds)) return true;
  return interaction.memberPermissions?.has(PermissionFlagsBits.ModerateMembers) || false;
}
function isAdministrator(interaction) {
  if (hasConfiguredRole(interaction, administratorRoleIds)) return true;
  return interaction.memberPermissions?.has(PermissionFlagsBits.Administrator) || false;
}
async function requireModerator(interaction) {
  if (isModerator(interaction)) return true;
  await interaction.reply({ content: 'You need the Aera Moderator role to use this command.', ephemeral: true });
  return false;
}
async function requireAdministrator(interaction) {
  if (isAdministrator(interaction)) return true;
  await interaction.reply({ content: 'You need the Aera Administrator role to use this command.', ephemeral: true });
  return false;
}

async function getUserColumns() {
  const [rows] = await pool.query(
    'SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? ORDER BY ORDINAL_POSITION',
    ['users']
  );
  return rows.map(row => row.COLUMN_NAME);
}
function findColumn(columns, candidates) {
  for (const candidate of candidates) {
    const match = columns.find(column => column.toLowerCase() === candidate.toLowerCase());
    if (match) return match;
  }
  return null;
}
async function lookupPlayer(search) {
  const columns = await getUserColumns();
  const nameColumn = findColumn(columns, ['username', 'userName', 'Name', 'name', 'User', 'user', 'login']);
  if (!nameColumn) return null;
  const idColumn = findColumn(columns, ['id', 'ID', 'UserID', 'userId']);
  const levelColumn = findColumn(columns, ['level', 'Level', 'lvl']);
  const onlineColumn = findColumn(columns, ['online', 'Online']);
  const selected = [
    `\`${nameColumn}\` AS player_name`,
    idColumn ? `\`${idColumn}\` AS player_id` : 'NULL AS player_id',
    levelColumn ? `\`${levelColumn}\` AS player_level` : 'NULL AS player_level',
    onlineColumn ? `\`${onlineColumn}\` AS player_online` : 'NULL AS player_online'
  ].join(', ');
  const [rows] = await pool.query(
    `SELECT ${selected} FROM \`users\` WHERE \`${nameColumn}\` LIKE ? LIMIT 1`,
    [`%${search}%`]
  );
  return rows[0] || null;
}
async function getOnlineCount() {
  const [rows] = await pool.query('SELECT COALESCE(SUM(CAST(`count` AS UNSIGNED)), 0) AS count FROM `servers`');
  return Number(rows[0]?.count || 0);
}
async function getServerRows() {
  const [rows] = await pool.query('SELECT * FROM `servers`');
  return rows;
}
function getColumnValue(row, candidates) {
  const key = Object.keys(row).find(column => candidates.some(candidate => column.toLowerCase() === candidate.toLowerCase()));
  return key ? row[key] : null;
}
function formatUptime(ms) {
  let seconds = Math.floor(ms / 1000);
  const days = Math.floor(seconds / 86400); seconds %= 86400;
  const hours = Math.floor(seconds / 3600); seconds %= 3600;
  const minutes = Math.floor(seconds / 60); seconds %= 60;
  const parts = [];
  if (days) parts.push(`${days}d`);
  if (hours) parts.push(`${hours}h`);
  if (minutes) parts.push(`${minutes}m`);
  parts.push(`${seconds}s`);
  return parts.join(' ');
}

client.once(Events.ClientReady, async ready => {
  console.log(`[Aera Discord] Logged in as ${ready.user.tag}`);
  try { await pool.query('SELECT 1'); console.log('[Aera Discord] MySQL connection OK.'); }
  catch (error) { console.error('[Aera Discord] MySQL connection failed:', error.message); }
  console.log(`[Aera Discord] Moderator roles: ${moderatorRoleIds.join(', ') || 'permission fallback'}`);
  console.log(`[Aera Discord] Administrator roles: ${administratorRoleIds.join(', ') || 'permission fallback'}`);
});

client.on(Events.InteractionCreate, async interaction => {
  if (!interaction.isChatInputCommand()) return;
  try {
    switch (interaction.commandName) {
      case 'server': {
        const online = await getOnlineCount();
        await interaction.reply({ embeds: [new EmbedBuilder().setTitle('Aera Server').setDescription('The Aera game server is online.').addFields({ name: 'Players Online', value: `**${online}**`, inline: true }).setTimestamp()] });
        break;
      }
      case 'players': {
        const online = await getOnlineCount();
        await interaction.reply(`There are currently **${online}** players online.`);
        break;
      }
      case 'servers': {
        const rows = await getServerRows();
        if (!rows.length) { await interaction.reply('No server records are currently configured.'); break; }
        const description = rows.map((row, index) => {
          const name = getColumnValue(row, ['name', 'servername', 'server']) || `Server ${index + 1}`;
          const count = getColumnValue(row, ['count', 'players', 'playercount']) ?? 0;
          const status = getColumnValue(row, ['status', 'online']) ?? 'Online';
          return `**${name}** — ${status} — ${count} players`;
        }).join('\n');
        await interaction.reply({ embeds: [new EmbedBuilder().setTitle('Aera Servers').setDescription(description.slice(0, 4000)).setTimestamp()] });
        break;
      }
      case 'serverinfo': {
        const guild = interaction.guild;
        if (!guild) { await interaction.reply({ content: 'This command can only be used inside a Discord server.', ephemeral: true }); break; }
        await interaction.reply({ embeds: [new EmbedBuilder().setTitle(guild.name).addFields(
          { name: 'Owner', value: `<@${guild.ownerId}>`, inline: true },
          { name: 'Members', value: String(guild.memberCount), inline: true },
          { name: 'Channels', value: String(guild.channels.cache.size), inline: true },
          { name: 'Roles', value: String(guild.roles.cache.size), inline: true },
          { name: 'Created', value: `<t:${Math.floor(guild.createdTimestamp / 1000)}:F>`, inline: true },
          { name: 'Server ID', value: guild.id, inline: true }
        ).setTimestamp()] });
        break;
      }
      case 'uptime': {
        await interaction.reply(`Aera Discord bot uptime: **${formatUptime(Date.now() - botStartedAt)}**.`);
        break;
      }
      case 'whoami': {
        const permissions = interaction.memberPermissions?.toArray?.() || [];
        const configuredModerator = hasConfiguredRole(interaction, moderatorRoleIds);
        const configuredAdministrator = hasConfiguredRole(interaction, administratorRoleIds);
        const roles = interaction.member?.roles?.cache?.filter(role => role.id !== interaction.guild?.id).map(role => role.name).join(', ') || 'None';
        await interaction.reply({ embeds: [new EmbedBuilder().setTitle('Your Aera Discord Profile').addFields(
          { name: 'User', value: `${interaction.user.tag}`, inline: true },
          { name: 'User ID', value: interaction.user.id, inline: true },
          { name: 'Roles', value: roles.slice(0, 1000), inline: false },
          { name: 'Aera Moderator', value: configuredModerator || !!interaction.memberPermissions?.has(PermissionFlagsBits.ModerateMembers) ? 'Yes' : 'No', inline: true },
          { name: 'Aera Administrator', value: configuredAdministrator || !!interaction.memberPermissions?.has(PermissionFlagsBits.Administrator) ? 'Yes' : 'No', inline: true },
          { name: 'Discord Permissions', value: permissions.length ? permissions.join(', ').slice(0, 1000) : 'None', inline: false }
        ).setTimestamp()] });
        break;
      }
      case 'player': {
        const search = interaction.options.getString('name', true);
        const player = await lookupPlayer(search);
        if (!player) { await interaction.reply({ content: `No Aera player matching **${search}** was found.`, ephemeral: true }); break; }
        const status = player.player_online === null || player.player_online === undefined ? 'Unknown' : Number(player.player_online) === 1 ? 'Online' : 'Offline';
        const level = player.player_level === null || player.player_level === undefined ? 'Unknown' : String(player.player_level);
        await interaction.reply({ embeds: [new EmbedBuilder().setTitle(`Player: ${player.player_name}`).addFields(
          { name: 'Account ID', value: String(player.player_id ?? 'Unknown'), inline: true },
          { name: 'Level', value: level, inline: true },
          { name: 'Status', value: status, inline: true }
        )] });
        break;
      }
      case 'ping': await interaction.reply(`Pong! **${client.ws.ping}ms**`); break;
      case 'help': {
        await interaction.reply({ embeds: [new EmbedBuilder().setTitle('Aera Bot Commands').setDescription([
          '**Server:** `/server` `/players` `/servers` `/serverinfo`',
          '**Player:** `/player` `/whoami`',
          '**Bot:** `/ping` `/uptime` `/help`',
          '**Moderation:** `/kick` `/ban` `/unban` `/timeout` `/clear`',
          '**Administration:** `/announce` `/botstatus`'
        ].join('\n')).setTimestamp()] });
        break;
      }
      case 'announce': {
        if (!(await requireAdministrator(interaction))) break;
        const message = interaction.options.getString('message', true);
        const embed = new EmbedBuilder().setTitle('Aera Announcement').setDescription(message).setFooter({ text: `Posted by ${interaction.user.tag}` }).setTimestamp();
        await interaction.channel.send({ embeds: [embed] });
        await interaction.reply({ content: 'Announcement posted.', ephemeral: true });
        break;
      }
      case 'kick': {
        if (!(await requireModerator(interaction))) break;
        const member = interaction.options.getMember('user'); const reason = interaction.options.getString('reason') || 'No reason provided.';
        if (!member) { await interaction.reply({ content: 'That user is not a member of this server.', ephemeral: true }); break; }
        if (!member.kickable) { await interaction.reply({ content: 'I cannot kick that member. Check the bot role hierarchy.', ephemeral: true }); break; }
        await member.kick(reason); await interaction.reply(`Kicked **${member.user.tag}**. Reason: ${reason}`); break;
      }
      case 'ban': {
        if (!(await requireModerator(interaction))) break;
        const member = interaction.options.getMember('user'); const reason = interaction.options.getString('reason') || 'No reason provided.';
        if (!member) { await interaction.reply({ content: 'That user is not a member of this server.', ephemeral: true }); break; }
        if (!member.bannable) { await interaction.reply({ content: 'I cannot ban that member. Check the bot role hierarchy.', ephemeral: true }); break; }
        await member.ban({ reason, deleteMessageSeconds: 86400 }); await interaction.reply(`Banned **${member.user.tag}**. Reason: ${reason}`); break;
      }
      case 'unban': {
        if (!(await requireModerator(interaction))) break;
        const userId = interaction.options.getString('user_id', true); const reason = interaction.options.getString('reason') || 'No reason provided.';
        await interaction.guild.members.unban(userId, reason); await interaction.reply(`Unbanned **${userId}**.`); break;
      }
      case 'timeout': {
        if (!(await requireModerator(interaction))) break;
        const member = interaction.options.getMember('user'); const minutes = interaction.options.getInteger('minutes', true); const reason = interaction.options.getString('reason') || 'No reason provided.';
        if (!member) { await interaction.reply({ content: 'That user is not a member of this server.', ephemeral: true }); break; }
        if (!member.moderatable) { await interaction.reply({ content: 'I cannot timeout that member. Check the bot role hierarchy.', ephemeral: true }); break; }
        await member.timeout(minutes * 60 * 1000, reason); await interaction.reply(`Timed out **${member.user.tag}** for **${minutes} minutes**. Reason: ${reason}`); break;
      }
      case 'clear': {
        if (!(await requireModerator(interaction))) break;
        const amount = interaction.options.getInteger('amount', true); const deleted = await interaction.channel.bulkDelete(amount, true);
        await interaction.reply({ content: `Deleted **${deleted.size}** messages.`, ephemeral: true }); break;
      }
      case 'botstatus': {
        if (!(await requireAdministrator(interaction))) break;
        await interaction.reply({ embeds: [new EmbedBuilder().setTitle('Aera Discord Bot').addFields(
          { name: 'Discord', value: client.isReady() ? 'Connected' : 'Disconnected', inline: true },
          { name: 'Latency', value: `${client.ws.ping}ms`, inline: true },
          { name: 'Guilds', value: String(client.guilds.cache.size), inline: true },
          { name: 'Uptime', value: formatUptime(Date.now() - botStartedAt), inline: true }
        ).setTimestamp()] });
        break;
      }
      default: break;
    }
  } catch (error) {
    console.error(`[Aera Discord] Command ${interaction.commandName} failed:`, error);
    const message = error?.code === 'ER_NO_SUCH_TABLE' ? 'The required Aera database table is unavailable.' : 'The command could not be completed.';
    if (interaction.replied || interaction.deferred) await interaction.followUp({ content: message, ephemeral: true }).catch(() => {});
    else await interaction.reply({ content: message, ephemeral: true }).catch(() => {});
  }
});

const statusPort = envNumber('BOT_STATUS_PORT', 5592);
if (statusPort < 0 || statusPort >= 65536 || !Number.isInteger(statusPort)) throw new Error(`BOT_STATUS_PORT must be an integer from 0 to 65535. Received: ${statusPort}`);
const shutdownToken = env('BOT_SHUTDOWN_TOKEN') || crypto.randomBytes(32).toString('hex');
const heartbeatFile = path.join(__dirname, '..', 'discord-bot-health.json');
function writeHeartbeat() { try { fs.writeFileSync(heartbeatFile, JSON.stringify({ pid: process.pid, ok: true, discordReady: client.isReady(), timestamp: new Date().toISOString() }), 'utf8'); } catch (error) { console.error('[Aera Discord] Could not write health heartbeat:', error.message); } }
function removeHeartbeat() { try { if (fs.existsSync(heartbeatFile)) fs.unlinkSync(heartbeatFile); } catch {} }
let shuttingDown = false;
function shutdown() { if (shuttingDown) return; shuttingDown = true; clearInterval(heartbeatTimer); removeHeartbeat(); try { statusServer.close(); } catch {} try { client.destroy(); } catch {} setTimeout(() => process.exit(0), 100).unref(); }
writeHeartbeat(); const heartbeatTimer = setInterval(writeHeartbeat, 2000);
function isLoopback(address) { return address === '127.0.0.1' || address === '::1' || address === '::ffff:127.0.0.1'; }
const statusServer = http.createServer((req, res) => {
  if (!isLoopback(req.socket.remoteAddress)) { res.writeHead(403); return res.end('Forbidden'); }
  if (req.url === '/health' && req.method === 'GET') { const payload = JSON.stringify({ ok: true, discordReady: client.isReady(), pid: process.pid, timestamp: new Date().toISOString() }); res.writeHead(200, { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(payload), 'Connection': 'close' }); return res.end(payload); }
  if (req.url === '/shutdown' && (req.method === 'POST' || req.method === 'GET')) { const auth = req.headers['x-aera-shutdown-token']; if (!auth || auth !== shutdownToken) { res.writeHead(401); return res.end('Unauthorized'); } res.writeHead(202, { 'Content-Type': 'application/json', 'Connection': 'close' }); res.end(JSON.stringify({ ok: true, message: 'Shutdown requested.' })); setTimeout(shutdown, 50).unref(); return; }
  res.writeHead(404); res.end('Not Found');
});
statusServer.listen(statusPort, '127.0.0.1', () => { console.log(`[Aera Discord] Health endpoint: 127.0.0.1:${statusPort}/health`); writeHeartbeat(); });
process.on('SIGINT', shutdown); process.on('SIGTERM', shutdown); process.on('exit', removeHeartbeat);
client.login(discordToken).catch(error => { console.error('[Aera Discord] Discord login failed:', error); removeHeartbeat(); process.exitCode = 1; });
