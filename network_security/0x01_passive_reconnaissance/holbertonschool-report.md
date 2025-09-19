# Passive Reconnaissance Report – Holberton School

**Target Domain:** `holbertonschool.com`  
**Date:** September 2025  
**Analyst:** Raphael DOTT

---

## 1. IP Ranges Associated with `holbertonschool.com`

Based on Shodan results and WHOIS/ASN lookups, the domain resolves to cloud infrastructure hosted in **Amazon Data Services France (eu-west-3 / Paris region)**.

| IP Address     | Hostname                                    | Provider                  | Location | Notes |
|----------------|---------------------------------------------|---------------------------|----------|-------|
| 52.47.143.83   | ec2-52-47-143-83.eu-west-3.compute.amazonaws.com | AWS (eu-west-3)           | Paris, FR | Hosting `yriry2.holbertonschool.com` |
| 35.180.27.154  | ec2-35-180-27-154.eu-west-3.compute.amazonaws.com | AWS (eu-west-3)           | Paris, FR | Redirects to `holbertonschool.com` |

**Observed IP ranges (AWS eu-west-3 Paris region):**
- 52.47.0.0/16  
- 35.180.0.0/16  

Thus, Holberton School infrastructure is primarily hosted within **Amazon AWS eu-west-3 (Paris datacenter)**.

---

## 2. Subdomains & Observed Technologies

From Shodan enumeration:

| Subdomain                    | IP            | Web Server        | TLS / Cert Info     | Technologies / Notes |
|------------------------------|---------------|-------------------|---------------------|----------------------|
| yriry2.holbertonschool.com   | 52.47.143.83  | nginx             | Let's Encrypt (CN: yriry2.holbertonschool.com) | TLS 1.2 / 1.3 supported; forum endpoint |
| holbertonschool.com (root)   | 35.180.27.154 | nginx/1.18.0 (Ubuntu) | Redirect → `http://holbertonschool.com` | Main site, static content + redirects |

### Identified Technologies
- **Web Server:** nginx (versions 1.18.0, 1.21.6)  
- **Hosting:** Amazon Web Services (EC2, eu-west-3 Paris)  
- **TLS Certificates:** Let's Encrypt (auto-renewal)  
- **Protocols:** TLS 1.2, TLS 1.3 (no legacy SSL observed)  
- **Headers:** X-Frame-Options: SAMEORIGIN, X-Content-Type-Options: nosniff  
- **Notes:** Likely reverse-proxy setup; possible backend frameworks (Flask/Django/Node) but not directly disclosed.

---

## 3. Observations & Notes

- Infrastructure is concentrated in AWS France (Paris).  
- Consistent use of **nginx** for serving web applications.  
- Secure TLS configuration with modern protocols.  
- Redirect behavior suggests load balancing or multi-app setup (forum, portal, main site).  
- Some evidence of a **forum platform** (“Level2 Forum” header).  

---

## 4. Recommendations (Recon Only)

- Extend subdomain enumeration using tools like **crt.sh**, **Amass**, or **Sublist3r**.  
- Review AWS public IP ranges for additional instances (`52.16.0.0/14`, `34.240.0.0/13` in eu-west).  
- Use **Wappalyzer** or **BuiltWith** for deeper tech stack fingerprinting.  

---

*End of Report – Passive Reconnaissance Only (No Intrusive Scanning Performed)*

