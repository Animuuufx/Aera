# NightVaults Mail Server

This directory contains the Windows mail-server setup for `nightvaults.com` using **MailEnable Standard Edition**. Cloudflare remains the DNS provider and IIS remains available for the existing Aera website.

## Stack

- MailEnable Standard Edition 10.59 (FREE)
- SMTP server-to-server delivery: TCP 25
- Authenticated SMTP submission: TCP 465 and/or 587
- IMAP over TLS: TCP 993
- Optional MailEnable Webmail through IIS
- Cloudflare DNS

MailEnable Standard provides SMTP, IMAP, POP3 and web mail services for Windows. The official installer is a normal Windows setup wizard, which is preferable for the first installation on this server.

## Mailboxes

The initial mailbox set is:

- `animu@nightvaults.com`
- `admin@nightvaults.com`
- `support@nightvaults.com`

Passwords are never stored in this repository. Create the accounts in MailEnable's administration console after the installation is complete.

## Installation

1. Run `INSTALL_MAIL_SERVER.bat` as Administrator.
2. The script downloads the official MailEnable Standard 10.59 installer from MailEnable and launches it elevated.
3. In the MailEnable installer, install the SMTP and IMAP services. Install Web Mail if you want webmail on the IIS server.
4. When prompted for the mail domain/post office, use `nightvaults.com`.
5. Configure the server hostname as `mail.nightvaults.com` where MailEnable asks for the public mail host/HELO name.
6. If the installer asks which IIS site should host webmail, select the intended Aera/IIS site rather than replacing the existing Aera site.
7. Finish installation and create the mailboxes listed above in the MailEnable administration tools.
8. Run `setup-mail-firewall.ps1` as Administrator.
9. Add the DNS records from `cloudflare-dns.md` in Cloudflare.
10. Set the public server IP reverse DNS/PTR to `mail.nightvaults.com` through the hosting/VPS provider.

## Client settings

Use these settings after TLS certificates are configured:

- Incoming IMAP: `mail.nightvaults.com`, port `993`, SSL/TLS
- Outgoing SMTP: `mail.nightvaults.com`, port `465`, implicit TLS
- Alternative SMTP submission: port `587`, STARTTLS
- Username: full mailbox address, for example `animu@nightvaults.com`
- Authentication: mailbox password

POP3 is available from MailEnable Standard but is not the recommended client protocol when IMAP is available.

## Cloudflare

Keep `mail.nightvaults.com` **DNS only** (gray cloud). Cloudflare should remain authoritative DNS, but the mail hostname should not be orange-clouded.

Do not enable Cloudflare Email Routing for `nightvaults.com` while MailEnable is the authoritative inbound mail server. The MX record should point directly to `mail.nightvaults.com`.

## DNS records

At minimum, publish:

| Type | Name | Content / Target | Priority | Proxy |
|---|---|---|---:|---|
| A | `mail` | `<PUBLIC_SERVER_IP>` | — | **DNS only** |
| MX | `@` | `mail.nightvaults.com` | `10` | DNS only |
| TXT | `@` | `v=spf1 ip4:<PUBLIC_SERVER_IP> -all` | — | DNS only |
| TXT | `_dmarc` | `v=DMARC1; p=quarantine; rua=mailto:admin@nightvaults.com` | — | DNS only |

MailEnable's DKIM/SPF/DMARC configuration should be completed using the DNS values generated or documented by your selected MailEnable version. Do not commit private DKIM keys or mailbox passwords to GitHub.

## IIS / webmail

MailEnable's Web Mail component uses IIS. Because the Aera website already uses IIS, do not replace or repurpose its existing site bindings. Give webmail its own site/host binding when practical, such as:

`https://mail.nightvaults.com/`

The exact IIS binding and certificate arrangement should be completed after the core SMTP/IMAP services are working.

## Security

- Never commit mailbox passwords, TLS private keys, DKIM private keys, or other secrets.
- Keep authenticated mail submission enabled and do not operate as an open relay.
- Use SPF, DKIM and DMARC for outbound mail authentication.
- Port 25 must be reachable for normal inbound Internet mail delivery.
- Prefer TLS for client SMTP and IMAP connections.

## Resources

Official MailEnable downloads:
https://www.mailenable.com/download.asp

Official MailEnable Standard installation guide:
https://www.mailenable.com/documentation/10.0/Standard/Installation.html

Official MailEnable silent installation documentation:
https://mailenable.com/kb/content/article.asp?ID=ME020471
