# 0x05 Upload Vulnerabilities — Task 0: Find the upload subdomain

Target main domain: `http://web0x05.hbtn` (internal lab host — only reachable from inside the Holberton lab VM / VPN).
Goal: identify which **subdomain** hosts a web app with an insecure file-upload feature, and write its hostname to `0-target.txt`.

## 0. Make the lab host resolvable (if needed)

`.hbtn` is not a real TLD, so DNS must point somewhere. Confirm resolution first:

```bash
getent hosts web0x05.hbtn || cat /etc/hosts | grep web0x05
```

If `web0x05.hbtn` resolves to an IP (call it `TARGET_IP`), wildcard subdomains usually resolve to the same IP. You can add candidates to `/etc/hosts` as you discover them, e.g.:

```bash
echo "TARGET_IP up3l0d3r.web0x05.hbtn" | sudo tee -a /etc/hosts
```

## 1. Subdomain enumeration

### Option A — gobuster vhost (works even without per-subdomain DNS; uses Host header)

```bash
gobuster vhost -u http://web0x05.hbtn -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt --append-domain -t 20
```

### Option B — ffuf via Host header fuzzing

```bash
ffuf -u http://web0x05.hbtn/ -H "Host: FUZZ.web0x05.hbtn" \
     -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt \
     -mc 200,301,302,403 -fs 0
```

Tune `-fs` (filter size) to the size of the default/catch-all response so real vhosts stand out.

### Option C — DNS brute force (if subdomains have real DNS records)

```bash
dnsrecon -d web0x05.hbtn -D /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -t brt
# or
gobuster dns -d web0x05.hbtn -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt
```

> The example answer `up3l0d3r.web0x05.hbtn` ("uploader" in leetspeak) hints the target name is upload-themed — watch for hits like `upload`, `uploader`, `up1oad`, `up3l0d3r`, `files`, `media`, `cdn`.

## 2. Inspect each discovered subdomain for an upload feature

For every subdomain found, curl the root and look for upload forms:

```bash
for sub in SUB1 SUB2 SUB3; do
  echo "=== $sub ==="
  curl -s -H "Host: $sub.web0x05.hbtn" http://web0x05.hbtn/ | grep -iE "upload|<form|enctype|type=.?file" 
done
```

A page with `<form ... enctype="multipart/form-data">` and `<input type="file">` is the upload interface.

## 3. Confirm with a benign upload

Upload a plain `.txt` to understand handling (where it lands, whether the name/type is validated):

```bash
echo "hello" > benign.txt
curl -s -F "file=@benign.txt" -H "Host: SUB.web0x05.hbtn" http://web0x05.hbtn/upload
```

Note the response: returned URL/path of the stored file, any filtering, content-type checks. These are the indicators you'll exploit in later tasks.

## 4. Record the answer

Put the confirmed subdomain hostname (just the FQDN, no scheme) in `0-target.txt`, e.g.:

```
up3l0d3r.web0x05.hbtn
```
