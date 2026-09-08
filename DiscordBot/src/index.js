require('dotenv').config();
const http = require('node:http');
const { Client, GatewayIntentBits, Events } = require('discord.js');
const { pool } = require('./db');
const { env, envNumber } = require('./env');

const discordToken = env('DISCORD_TOKEN');
if (!discordToken) {
  throw new Error('DISCORD_TOKEN is required. Copy .env.example to .env and configure the bot.');
}

const client = new Client({
  intents: [GatewayIntentBits.Guilds]
});

client.once(Events.ClientReady, async ready => {
  console.log(`[Aera Discord] Logged in as ${ready.user.tag}`);
  try {
    await pool.query('SELECT 1');
    console.log('[Aera Discord] MySQL connection OK.');
  } catch (error) {
    console.error('[Aera Discord] MySQL connection failed:', error.message);
  }
});

client.on(Events.InteractionCreate, async interaction => {
  if (!interaction.isChatInputCommand()) return;

  if (interaction.commandName === 'server') {
    try {
      const [rows] = await pool.query('SELECT COUNT(*) AS count FROM users WHERE online = 1');
      const online = Number(rows[0]?.count || 0);
      await interaction.reply(`Aera is online. Players online: **${online}**`);
    } catch (error) {
      console.error('[Aera Discord] Server command failed:', error.message);
      await interaction.reply({
        content: 'The Aera server status is temporarily unavailable.',
        ephemeral: true
      });
    }
  }
});

const statusPort = envNumber('BOT_STATUS_PORT', 5592);
if (statusPort < 0 || statusPort >= 65536 || !Number.isInteger(statusPort)) {
  throw new Error(`BOT_STATUS_PORT must be an integer from 0 to 65535. Received: ${statusPort}`);
}

http.createServer((req, res) => {
  if (req.url !== '/health') {
    res.writeHead(404);
    return res.end('Not Found');
  }

  res.writeHead(200, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({
    ok: true,
    discordReady: client.isReady(),
    timestamp: new Date().toISOString()
  }));
}).listen(statusPort, '127.0.0.1', () => {
  console.log(`[Aera Discord] Health endpoint: 127.0.0.1:${statusPort}/health`);
});

client.login(discordToken);
