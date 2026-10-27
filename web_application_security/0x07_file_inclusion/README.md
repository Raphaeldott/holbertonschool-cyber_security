# 0x07. File Inclusion — Cyber - WebSec 0x07

Path traversal / LFI / RFI challenges against the training target `web0x07.hbtn`
(reached over the project OpenVPN). Each task captures a flag.

> Educational use only, inside the authorized Holberton training environment.

## Target

- `http://web0x07.hbtn/` — Flask app (nginx + waitress) listing Task 0–4.

## Tasks

| File | Endpoint | Technique | Status |
|------|----------|-----------|--------|
| `0-flag.txt` | `/task0/download_file` | Path traversal: `path` accepts an absolute dir | ✅ |
| `1-flag.txt` | `/task1/download_file` | Filter bypass: `../` and full path in `filename` → 403; absolute `path` + bare `filename` works | ✅ |
| `2-flag.txt` | `/task2/download_file` | Base64-encoded params + MD5 validation; `path` checked against a whitelist | ⏳ |
| `4-flag.txt` | `/find_your_shell/` | LFI (`include()`): set `$_SESSION['FLAG_SET']` via `shell.php`, then include `flag.php` | ✅ |

## Captured requests

- **Task 0:** `GET /task0/download_file?filename=0-flag.txt&path=/etc`
- **Task 1:** `GET /task1/download_file?filename=1-flag.txt&path=/tmp/secure_storage`
- **Poison the logs (4):**
  1. `GET /find_your_shell/find_your_shell.php?filename=task4_file_hub/shell.php` (sets `$_SESSION['FLAG_SET']`)
  2. `GET /find_your_shell/find_your_shell.php?filename=task4_file_hub/flag.php` → reveals the flag

  The endpoint does `include($_GET['filename'])` (confirmed: including itself recurses).
  `php://filter`, RFI (`http://`) and `data://` are all blocked (`://` filtered), so
  source read and remote include are out; LFI to local paths works (`/etc/passwd` reads fine).

## Notes on the target

- `task0/download_file` serves any existing `.txt`/`.md` file at any path (extension
  filter only — `.py`, extensionless files like `/etc/passwd` → 404/blocked).
- `task1/download_file` is whitelisted to `/tmp/secure_storage` (403 elsewhere).
- `task2/download_file` base64-decodes `filename` and `path`, then validates the
  decoded `path` against a whitelist (any other value → `Access denied: Invalid path`).
