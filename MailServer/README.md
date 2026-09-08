# NightVaults Mail Server

This directory contains the Windows mail-server setup for `nightvaults.com`.

## Stack

- MailEnable Standard 10.59 (stable release)
- SMTP: TCP 25 for server-to-server delivery
- SMTP submission: TCP 587 with STARTTLS
- IMAP over TLS: TCP 993
- Optional POP3 over TLS: TCP 995
- IIS-hosted MailEnable Webmail
- Cloudflare remains the DNS provider

MailEnable Standard provides SMTP, IMAP, POP3 and webmail on Windows and is free for personal/commercial use. Do not put mailbox passwords, Cloudflare API tokens, DKIM private keys, or other secrets in this repository.

## Mailboxes

The initial mailbox set is:

- `animu@nightvaults.com`
- `admin@nightvaults.com`
- `support@nightvaults.com`

`provision-mailboxes.ps1` prompts for passwords interactively and does not save them.

## Installation

1. Download the current stable **MailEnable Standard** installer from the official MailEnable download page. The repository setup targets stable 10.59 rather than the 10.60 beta.
2. Install MailEnable Standard with Webmail enabled. IIS is already used by Aera and is a supported MailEnable webmail host.
3. Run `provision-mailboxes.ps1` from an elevated Windows PowerShell session.
4. Configure MailEnable DKIM for `nightvaults.com` and publish the generated public key in Cloudflare DNS.
5. Create the Cloudflare DNS records in `cloudflare-dns.md`.
6. Configure `mail.nightvaults.com` as the MailEnable webmail host header and issue an HTTPS certificate in IIS.
7. Open the mail ports in Windows Firewall and any upstream firewall/NAT.
8. Make sure the server's public IP has reverse DNS/PTR set to `mail.nightvaults.com`; this is controlled by the IP/hosting provider, not Cloudflare DNS.

## Webmail

The intended URL is:

`https://mail.nightvaults.com/mewebmail`

MailEnable webmail is installed as an IIS application/virtual directory and supports publishing through a host header. This avoids requiring a separate webmail application.

## Client settings

For `animu@nightvaults.com` and the other mailboxes:

- Incoming IMAP: `mail.nightvaults.com`, port `993`, SSL/TLS
- Outgoing SMTP: `mail.nightvaults.com`, port `587`, STARTTLS
- Username: full mailbox address, for example `animu@nightvaults.com`
- Authentication: mailbox password

Do not expose or use unauthenticated SMTP submission. Port 25 is for mail-server delivery; authenticated users should submit mail on 587.

## Cloudflare note

Keep `mail.nightvaults.com` **DNS only** (gray cloud). Cloudflare's normal HTTP proxy does not proxy SMTP/IMAP, so orange-clouding the mail hostname would break normal mail connectivity. The MX record should point to `mail.nightvaults.com`.

See `cloudflare-dns.md` for the exact record template.

## Security

Use TLS certificates for SMTP submission, IMAP and webmail. Enable DKIM and publish SPF and DMARC. Do not create a catch-all mailbox unless it is explicitly needed. Keep relay restricted to authenticated users/local delivery and review MailEnable logs after installation.
