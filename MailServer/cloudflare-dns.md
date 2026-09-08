# Cloudflare DNS — `nightvaults.com` for MailEnable

Replace `<PUBLIC_SERVER_IP>` with the public IPv4 address of the Windows server running MailEnable.

| Type | Name | Content / Target | Priority | Proxy |
|---|---|---|---:|---|
| A | `mail` | `<PUBLIC_SERVER_IP>` | — | **DNS only** |
| MX | `@` | `mail.nightvaults.com` | `10` | DNS only |
| TXT | `@` | `v=spf1 ip4:<PUBLIC_SERVER_IP> -all` | — | DNS only |
| TXT | `_dmarc` | `v=DMARC1; p=quarantine; rua=mailto:admin@nightvaults.com` | — | DNS only |

## DKIM

Configure DKIM in MailEnable after the installation and publish the public DKIM TXT record it provides for `nightvaults.com`.

Do **not** put a DKIM private key in GitHub.

## Mail hostname / TLS

Keep `mail.nightvaults.com` **DNS only** (gray cloud). Do not orange-cloud the mail hostname. SMTP and IMAP traffic should connect directly to the mail server.

Configure a public TLS certificate for `mail.nightvaults.com` before requiring TLS-only client connections. The exact certificate deployment depends on whether MailEnable or IIS terminates TLS for the relevant service.

## Client autoconfiguration / MTA-STS / TLS-RPT

These records can be added after the basic mail flow works. Keep any HTTPS endpoints on IIS and do not move the existing Aera website off its current bindings just to host mail services.

## Reverse DNS / PTR

Set the public server IP's reverse DNS/PTR to:

```text
mail.nightvaults.com
```

Cloudflare does not control PTR records for your server IP. The PTR must be configured through the hosting/VPS/ISP provider that owns the IP range.

## Important Cloudflare note

Do not enable Cloudflare Email Routing for `nightvaults.com` while MailEnable is the authoritative inbound mail server. The MX record must point directly to `mail.nightvaults.com`.
