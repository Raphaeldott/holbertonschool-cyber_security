# 0x06. IDOR — CyberBank

Insecure Direct Object Reference (IDOR) exploitation against the **Cyber - WebSec 0x06**
training target (CyberBank). Each task captures a unique flag proving successful
exploitation.

> Educational use only, inside the authorized Holberton training environment.
> These techniques are illegal and unethical against systems you do not own or
> are not authorized to test.

## Target

- Application: CyberBank (`http://web0x06.hbtn/`)
- Entry endpoint: `http://web0x06.hbtn/dashboard`
- Reached over the project OpenVPN.

## Tooling

- Firefox + FoxyProxy
- Burp Suite (Proxy / Repeater / Intruder)

## Tasks

| File | Goal |
|------|------|
| `0-flag.txt` | Uncover another user's ID (IDOR on user info) |
| `1-flag.txt` | Enumerate account numbers and disclose a balance |
| `2-flag.txt` | Abuse the wire-transfer logic to push balance over $10K |
| `3-flag.txt` | Bypass 3D Secure OTP verification on a payment |
| (report) | Written vulnerability report (Google Doc link) |

Each `*-flag.txt` contains the single flag string captured for that task and ends
with a newline.
