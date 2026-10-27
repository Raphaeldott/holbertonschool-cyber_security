# 0x06. Nmap Advanced Port Scans

Bash scripts that run advanced Nmap scan types against a target supplied as `$1`.
Each script is exactly two lines, Betty-style, and must be run on Kali Linux.

## Requirements

- Scripts tested on Kali Linux.
- Each file is exactly two lines (`wc -l` prints 2).
- First line is exactly `#!/bin/bash`.
- The IP range / host is substituted for `$1` (used without quotes).
- No backticks, `&&`, `||`, `;`, or `echo`.
- Every script starts with `sudo`.
- All files are executable.

## Tasks

| File | Scan | Target ports | Notes |
|------|------|--------------|-------|
| `0-null_scan.sh` | TCP NULL (`-sN`) | 20-25 | No flags set; stealthy |
| `1-fin_scan.sh` | FIN (`-sF`) | 80-85 | Fragmentation (`-f`), timing `-T2` |
| `2-xmas_scan.sh` | Xmas (`-sX`) | 440-450 | `--open`, `--packet-trace`, `--reason` |
| `3-maimon_scan.sh` | Maimon (`-sM`) | ftp,ssh,telnet,http,https | High verbosity (`-vv`) |
| `4-ask_scan.sh` | ACK (`-sA`) | `$2` | `--reason`, `--host-timeout 1000ms` |
| `5-window_scan.sh` | Window (`-sW`) | `$2` | Excludes range `$3` |
| `6-custom_scan.sh` | Custom all-flags | `$2` | All TCP flags; output to `custom_scan.txt` |

## Usage

```
./0-null_scan.sh <host>
./4-ask_scan.sh <host> 80,22,25
./5-window_scan.sh <host> 20-30 25-28
./6-custom_scan.sh <host> 80-90
```
