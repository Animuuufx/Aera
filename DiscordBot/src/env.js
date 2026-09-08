function env(name, fallback = '') {
  let value = process.env[name];
  if (value === undefined || value === null) return fallback;

  value = String(value).trim();

  // Accept normal dotenv quotes as well as accidentally escaped quotes such as \"5592\".
  if (value.length >= 4 && value.startsWith('\\"') && value.endsWith('\\"')) {
    value = value.slice(2, -2);
  } else if (value.length >= 2 && value.startsWith('"') && value.endsWith('"')) {
    value = value.slice(1, -1);
  }

  return value;
}

function envNumber(name, fallback) {
  const value = Number(env(name, String(fallback)));
  if (!Number.isFinite(value)) {
    throw new Error(`${name} must be a valid number. Received: ${JSON.stringify(env(name))}`);
  }
  return value;
}

module.exports = { env, envNumber };
