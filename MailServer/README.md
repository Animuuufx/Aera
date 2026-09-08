# NightVaults Mail Server

This directory contains the Windows mail-server setup for `nightvaults.com` using **Stalwart Mail Server**. Cloudflare remains the DNS provider and IIS remains available for the existing Aera website.

## Stack

- Stalwart Mail Server (current Windows x86_64 build)
- SMTP server-to-server delivery: TCP 25
- Authenticated SMTP submission: TCP 465 (preferred) or 587
- IMAP over TLS: TCP 993
- Stalwart WebUI / webmail services
- Cloudflare DNS

Stalwart's current Windows distribution is a single executable. The official Windows instructions use NSSM to run it as an automatic Windows service; this repository's installer follows that supported model.

## Mailboxes

The initial mailbox set is:

- `animu@nightvaults.com`
- `admin@nightvaults.com`
- `support@nightvaults.com`

Passwords are never stored in this repository. Create the accounts through Stalwart WebUI or use `provision-mailboxes.ps1` after the server's first-time setup is complete.

## Installation

1. Run `INSTALL_MAIL_SERVER.bat` as Administrator.
2. The installer creates `C:\Program Files\Stalwart\bin`, `etc`, `data`, and `logs`, downloads the current Stalwart Windows release, and prepares the service configuration.
3. Install NSSM when prompted by the installer and use it to create the `Stalwart` Windows service.
4. Start the service and open `http://127.0.0.1:8080/admin` for the first-time setup wizard.
5. In the wizard use:
   - Server hostname: `mail.nightvaults.com`
   - Default email domain: `nightvaults.com`
   - Automatic TLS certificate: enabled once public DNS is ready
   - Generate DKIM keys: enabled
   - DNS management: **Manual** because Cloudflare remains under your control
6. Create the three mailboxes in Account Manager or run `provision-mailboxes.ps1`.
7. Add the DNS records from `cloudflare-dns.md` in Cloudflare.
8. Open the required mail ports in Windows Firewall and your upstream firewall/NAT.
9. Set the server public IP's reverse DNS/PTR to `mail.nightvaults.com` through the provider that controls the IP range.

## Webmail / administration

The first setup uses:

`http://127.0.0.1:8080/admin`

After the public hostname and TLS are working, the intended public administration endpoint is:

`https://mail.nightvaults.com/admin`

Because your existing IIS site already occupies normal HTTP/HTTPS bindings on the server, do not bind Stalwart directly to TCP 80/443 unless you intentionally move web traffic away from IIS. Use an IIS reverse proxy or another dedicated public address/listener for the production HTTPS endpoint.

## Client settings

Use these settings after TLS is configured:

- Incoming IMAP: `mail.nightvaults.com`, port `993`, SSL/TLS
- Outgoing SMTP: `mail.nightvaults.com`, port `465`, implicit TLS
- Alternative SMTP submission: port `587`, STARTTLS
- Username: full mailbox address, for example `animu@nightvaults.com`
- Authentication: mailbox password

## Cloudflare

Keep `mail.nightvaults.com` **DNS only** (gray cloud). Cloudflare should continue to provide authoritative DNS, but its normal HTTP proxy is not used for SMTP/IMAP traffic.

Use manual DNS management in Stalwart and publish the generated MX, SPF, DKIM, DMARC, MTA-STS, TLS-RPT and client-autoconfiguration records in Cloudflare as appropriate.

## Security

- Do not commit mailbox passwords, API keys, recovery credentials, TLS private keys, or DKIM private keys.
- Do not leave `STALWART_RECOVERY_ADMIN` configured permanently.
- Keep authenticated mail submission enabled and do not operate as an open relay.
- Use DKIM, SPF and DMARC for outbound mail authentication.
- Port 25 must be reachable for normal inbound Internet mail delivery.

## Resources

Official Stalwart Windows installation documentation:
https://stalw.art/docs/install/platform/windows/
