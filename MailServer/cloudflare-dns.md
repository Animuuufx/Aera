# Cloudflare DNS — `nightvaults.com`

Replace `<PUBLIC_SERVER_IP>` with the public IPv4 address of the Windows server running MailEnable.

| Type | Name | Target / Content | Priority | Proxy |
|---|---|---|---:|---|
| A | `mail` | `<PUBLIC_SERVER_IP>` | — | **DNS only** |
| MX | `@` | `mail.nightvaults.com` | `10` | DNS only |
| TXT | `@` | `v=spf1 ip4:<PUBLIC_SERVER_IP> -all` | — | DNS only |
| TXT | `_dmarc` | `v=DMARC1; p=quarantine; adkim=s; aspf=s; rua=mailto:admin@nightvaults.com` | — | DNS only |

## DKIM

MailEnable generates the DKIM selector/public key. After enabling DKIM for `nightvaults.com`, add the TXT record it gives you, normally in this form:

```text
<SELECTOR>._domainkey.nightvaults.com
v=DKIM1; k=rsa; p=<GENERATED_PUBLIC_KEY>
```

Do **not** commit the DKIM private key to GitHub.

## Optional MTA-STS

Once HTTPS for `mail.nightvaults.com` is working, MTA-STS can be added with a `_mta-sts` record and policy file. This is optional and should be enabled only after the mail service is stable.

## Important Cloudflare settings

`mail.nightvaults.com` must be **DNS only**. Cloudflare's standard HTTP proxy does not proxy SMTP/IMAP traffic. MX records themselves are DNS-only, but the hostname they point to must resolve directly to the mail server for normal mail delivery.

Do not enable Cloudflare Email Routing for `nightvaults.com` while using MailEnable as the actual inbound mail server, because Cloudflare-managed MX records would conflict with the MailEnable MX setup.

## Reverse DNS / PTR

Set the public server IP's reverse DNS/PTR to:

```text
mail.nightvaults.com
```

Cloudflare DNS does not control reverse DNS for an IP address. The PTR must be configured by the VPS/dedicated-server/ISP provider that owns the IP range.
